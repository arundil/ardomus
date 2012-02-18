from django.shortcuts import render_to_response
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib import auth
from ardomus.models import *
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.core.mail import send_mail
from datetime import datetime, timedelta 
from django.template.loader import render_to_string
from django.core.mail import EmailMultiAlternatives

import settings

# Funcion principal de todo informatico, devuelve "Hola Mundo"
def hola(request):
    return HttpResponse("Hola Mundo")

# Funcion para entrar en la aplicacion
def loginviews(request):
    username = request.POST.get('username',())
    password = request.POST.get('password',())
    user = auth.authenticate(username=username, password=password)
    if user is not None and user.is_active:
        auth.login(request, user)
        return HttpResponseRedirect("/account/loggedin/")
    else:
        return HttpResponseRedirect("/account/invalid/")

# Funcion para salir de la aplicacion
@login_required
def logoutviews(request):
    auth.logout(request)
    return HttpResponseRedirect("/zonas/")

# Funcion que manda un email generico a un usuario.
# Se usa para recordar los passwords a los usuarios.
def send_mail(asunto, mensaje, email_origen, email_destinatario):
    try:
        html_content = render_to_string('email_generico.html', {'asunto': asunto,
                                                                'mensaje': mensaje})
        
        # preparamos el objeto email con la plantilla rellenada con los datos del usuario
        receptor = [email_destinatario] # destinatario
        msg = EmailMultiAlternatives(asunto, None, settings.DEFAULT_FROM_EMAIL, receptor)
        msg.attach_alternative(html_content, "text/html")
        ret = msg.send()
        
    except Exception, e:
        print e, type(e)
        ret = False
    return ret

# Funcion que cambia el password de un usuario a uno aleatorio y se lo manda
# por via email
def recordar(request):
    if request.method == "POST":
        try:
            nuser =request.POST['user']
            usu = User.objects.get(username = nuser)
            pwd = User.objects.make_random_password(length=7, allowed_chars='abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789')
            usu.set_password(pwd)
            mensaje = "%s,\n\nTu nueva clave es: %s\n\nPara cambiarla pongase en contacto con el administrador de su red"%(usu.username, pwd)
            send_mail("Ardomus: Nuevo password", mensaje, 
                      settings.DEFAULT_FROM_EMAIL, usu.email)
            usu.save()
            mensaje = "Se le ha enviado una nueva clave, comprueba tu correo tras unos minutos."
        except:
            mensaje="Error al recordar el password"
        
        form = AuthenticationForm()
        return render_to_response('login.html',{'form': form,
                                                'mensaje': mensaje})
        
    return render_to_response('recordar.html',{})


# -------------------------------- USUARIOS -------------------------------------

# Funcion que muestra las zonas que tiene permisos el usuario, se usa como
# pagina principal de la aplicacion 
@login_required
def zonas(request):
    user = request.user
    mensaje =""
    if(user.is_superuser):
        zonalist = Zonas.objects.all()
    else:
        zonalist = UserZona.objects.filter(user = user)
    if user.is_staff:
        alarmas = Alarmas.objects.all()
        if alarmas.count()>0:
            mensaje = "Hay alarmas que revisar"
    return render_to_response('zonas.html',{'zonas': zonalist,
                                            'user': user,
                                            'mensaje': mensaje})

#  Funcion que muestra los diferentes actuadores dentro de una zona
# Si hay activado un plan de ahorro energetico, los usuarios solo pueden
# modificar la luz de la zona
@login_required    
def buscarMotas(request):
    user = request.user
    if 'zona' in request.GET:
        nombreZona = request.GET['zona']
        zona = Zonas.objects.get(nombre = nombreZona)
        motas = Motas.objects.filter(zona = zona)
        ae = AhorroEnergetico.objects.filter(activado = 1)
        if ae.count() > 0:
            mensaje = "Hay activado un plan de ahorro energetico"
            tipo = TipoActuadores.objects.get(nombre="Luz")
            actuadores = Actuadores.objects.filter(tipo = tipo)
        else:
            mensaje = ""
            actuadores = Actuadores.objects.all()
        return render_to_response('actuadores.html',{'user': user,
                                                     'motas': motas,
                                                     'actuadores':actuadores, 
                                                     'zona': zona,
                                                     'mensaje': mensaje})
            
    mensaje = "No se ha seleccionado ninguna zona disponible"
    return render_to_response('error.html', {'user': user,
                                             'mensaje': mensaje})
    
# Funcion que redirige a la pagina de accion del actuador seleccionado por el usuario
# Si hace algun cambio se registra en la tabla ArduinosActuales
@login_required
def accion(request):
    user = request.user
    if request.method == 'POST':
        nombrezona = request.POST['zona']
        nombremota = request.POST['mota']
        actuador = request.POST['actuador']
        
        zona = Zonas.objects.get(nombre = nombrezona)
        mota = Motas.objects.get(nombre = nombremota)
        arduinoActual = ArduinoActuales.objects.get(zona = zona, mota = mota)
        
        if(actuador == "Luz"):
            return render_to_response('luz.html', {'user':user,
                                                   'zona': zona,
                                                   'mota': mota,
                                                   'arduinoActual': arduinoActual,
                                                   'actuador': actuador})
        elif(actuador == "Persianas"):
            return render_to_response('persianas.html', {'user':user,
                                                         'zona': zona,
                                                         'mota': mota,
                                                         'arduinoActual': arduinoActual,
                                                         'actuador': actuador})
        
        elif(actuador=="AireAcondicionado"):
            medicion = {}
            mediciones = Mediciones.objects.filter(zona = zona)
            contador = mediciones.count()

#           Optimizar para coger el ultimo elemento de mediciones y que sean del dia
            for med in mediciones:
                medicion = med
                
            return render_to_response('ac.html', {'user':user,
                                                  'zona': zona,
                                                  'mota': mota,
                                                  'arduinoActual': arduinoActual,
                                                  'actuador': actuador,
                                                  'count': contador,
                                                  'medicion': medicion})
        
        elif(actuador=="RiegoCesped"):
            return render_to_response('riego.html', {'user':user,
                                                     'zona': zona,
                                                     'mota': mota,
                                                     'arduinoActual': arduinoActual,
                                                     'actuador': actuador})
        
    mensaje = "Error al intentar la accion "
    return render_to_response('error.html', {'user':user,
                                             'mensaje': mensaje})

# Funcion que manda una orden a la unidad de control (arduinos)
# dependiendo de la accion del usuario que se registra en ArduinosActuales    
@login_required
def actuador(request):
    user = request.user
    zonalist = UserZona.objects.filter(user = user)
    
    if request.method == 'POST':
        nombrezona = request.POST['zona']
        nombremota = request.POST['mota']
        accion = request.POST['accion']
        actuador = request.POST['actuador']
        zona = Zonas.objects.get(nombre = nombrezona)
        mota = Motas.objects.get(nombre = nombremota)
        arduinoActual = ArduinoActuales.objects.get(zona = zona, mota = mota)

#        Valores por defecto
        valorL = arduinoActual.luz
        valorAC = arduinoActual.ac
        persianas = arduinoActual.persianas
        riego = arduinoActual.riego
        mensaje ="No ha hecho nada"

#       Valores de la accion 
        if (actuador == 'Luz'): 
            if (accion=="encender"):
                valorL = 1
                mensaje = "Luz encendida en la zona "+zona.nombre
            else:
                valorL = 0
                mensaje = "Luz apagada en la zona "+zona.nombre
        
        elif (actuador == 'Aire Acondicionado'):
            if (accion=="encender"):
                valorAC = 1
                mensaje = "Aire acondicionado puesto en la zona "+zona.nombre
            else:
                valorAC = 0
                mensaje = "Aire acondicionado apagado en la zona "+zona.nombre
        
        elif (actuador == 'Persianas'):
            if (accion=="subir"):
                persianas = 1
                mensaje = "Persiana subiendo en la zona "+zona.nombre
            else:
                persianas = 0
                mensaje = "Persiana bajando en la zona "+zona.nombre
        
        elif (actuador == 'Riego Cesped'):
            if (accion=="encender"):
                riego = 1
                mensaje = "Riego en la zona "+zona.nombre
            else:
                riego = 0
                mensaje = "Riego quitado en la zona "+zona.nombre
        
#       Orden que se le va a dar al arduino 
        Arduinos.objects.create(zona = zona, mota = mota, luz = valorL, ac = valorAC, 
                                persianas = persianas, riego = riego)
        
#       Valores actualizados 
        arduinoActual.luz = valorL
        arduinoActual.ac = valorAC
        arduinoActual.persianas = persianas
        arduinoActual.riego = riego
        arduinoActual.save()
        
#       Volvemnos al principio 
        if (user.is_superuser):
            zonalist = Zonas.objects.all()
            
        return render_to_response('zonas.html', {'user':user,
                                                 'mensaje': mensaje,
                                                 'zonas': zonalist})
        
    mensaje = "Error al intentar la accion "
    return render_to_response('error.html', {'user':user,
                                             'mensaje': mensaje})


# Se muestra la aplicacion de sonido y guarda un reproductor al usuario
@login_required
def sonido(request):
    user = request.user
    sonido = Sonido.objects.get(user = user)
    if request.method == 'POST':
        mixpod = request.POST['mixpod']
        sonido.mixpod = mixpod
        sonido.save()
               
    return render_to_response('sonido.html', {'user':user,
                                              'sonido': sonido})

# Borra el reproductor que tenia el usuario.
@login_required
def setReproductor(request):
    user = request.user
    sonido = Sonido.objects.get(user = user)
    if request.method == 'POST':
        sonido.mixpod = ""
        sonido.save()
    
    sonido = Sonido.objects.get(user = user)
    return render_to_response('sonido.html', {'user':user,
                                              'sonido': sonido})
    
# ------------------------------------ ADMINISTRADOR  -------------------------------

# Funcion principal del administrador
@login_required    
def administrador(request):
    user = request.user
    if(user.is_staff):
        return render_to_response('administrador.html', {'user':user})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Lista de los usuarios de la red domotica, quitando los superusuarios (tecnicos)
@login_required
def usuarios(request):
    user = request.user
    users = User.objects.filter(is_superuser = False)
    if(user.is_staff):
        return render_to_response('usuarios.html',{'user': user, 
                                                   'users': users})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que registra un nuevo usuario en la red domotica.
# Al registrar un usuario introducimos una entrada a la tabla sonido
# Despues de registrar un usuario redirecciona a modificarle los permisos
# zonas = lista de zonas donde no tiene permisos el nuevo usuario (todas)
# zonasp = lista de zonas donde tiene permisos el nuevo usuario (ninguna)
@login_required
def register(request):
    user = request.user
    zonas = Zonas.objects.all()
    if(user.is_staff):
        if request.method == 'POST':
#           Formulario de registro de un usuario mas email con validacion 
            form = UserCreationForm(request.POST)
            if form.is_valid():
                if 'email' in request.POST:
                    email = request.POST['email']
                    if (email.__contains__('@') and email.__contains__('.')):
                        new_user = form.save()
                        new_user.email = email
                        new_user.save() 
                        Sonido.objects.create(user = new_user)
                    else:
                        mensaje = "Email no valido "
                        form = UserCreationForm()
                        return render_to_response('addusuario.html', 
                                                  {'user':user,
                                                   'form': form,
                                                   'mensaje': mensaje})
                        
                
                mensaje = "Permite al menos un permiso al usuario "
                zonasp = {}
                return render_to_response('modpermisos.html',{'zonasp': zonasp, 
                                                              'user': user,
                                                              'userp': new_user,
                                                              'zonas': zonas,
                                                              'mensage': mensaje})
        else:
            form = UserCreationForm()
            
        return render_to_response("addusuario.html",{'user': user, 
                                                     'form': form})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que elimina un usuario de la red domotica
# Se eliminan automaticamente de las tablas UserZona y Sonido
@login_required
def eliminaruser(request):
    user = request.user
    if(user.is_staff):
        if 'userp' in request.POST:
            nombreuserp = request.POST['userp']
            userp = User.objects.get(username = nombreuserp)
            userp.delete()
            
        users = User.objects.filter(is_superuser = False)
        return render_to_response('usuarios.html', {'user':user, 'users': users})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra los diferentes permisos de los usuarios
@login_required
def permisos(request):
    user = request.user
    userzona = UserZona.objects.all()
    users = User.objects.filter(is_superuser = False)
    if(user.is_staff):
        return render_to_response('permisos.html',{'UZ': userzona, 
                                                   'user': user, 
                                                   'users':users})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra los permisos de un usuario (userp) 
# diciendo donde tiene permisos (zonasp) y donde no (setzonax) usando la
# tabla UserZona
@login_required
def modpermisos(request):
    user = request.user
    zonas = Zonas.objects.all()
        
    if(user.is_staff):
        nombreuserp = request.GET['userp']
        userp = User.objects.get(username = nombreuserp)
        zonasp = set(UserZona.objects.filter(user = userp))
        setzonax = set(zonas)
        
        for zonap in zonasp:
            aux = Zonas.objects.get(nombre = zonap.zona)
            setzonax.discard(aux)

        return render_to_response('modpermisos.html',{'zonasp': zonasp, 
                                                      'user': user,
                                                      'userp': userp,
                                                      'zonas': setzonax})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion para cambiar un permiso a un usuario p en una zona. El cambio
# se registra en la tabla UserZona
@login_required
def modificarpermisos(request):
    user = request.user
    zonas = Zonas.objects.all()
    if(user.is_staff):
        nombrezona = request.POST['zona']
        nombreuserp = request.POST['userp']
        valor = request.POST['valor']
            
        zona = Zonas.objects.get(nombre = nombrezona)
        userp = User.objects.get(username = nombreuserp)
        
        if (valor):
            aux = UserZona.objects.create(user=userp, zona= zona)
            mensaje = "Permiso aceptado"
        else:
            aux = UserZona.objects.get(user=userp, zona= zona)
            aux.delete()
            mensaje = "Permiso eliminado"
        
        zonasp = set(UserZona.objects.filter(user = userp))
        setzonax = set(zonas)
        
        for zonap in zonasp:
            aux = Zonas.objects.get(nombre = zonap.zona)
            setzonax.discard(aux)

        return render_to_response('modpermisos.html',{'zonasp': zonasp, 
                                                      'user': user,
                                                      'userp': userp,
                                                      'zonas': setzonax,
                                                      'mensaje': mensaje})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

        
# Funcion que muestra diferentes los informes de las mediciones recogidas por los sensores    
@login_required
def informes(request):
    user = request.user
    informes = Mediciones.objects.all()
    if(user.is_staff):
        mensaje =""
        if (informes.count() == 0):
            mensaje = "No hay informes en la base de datos"
        
        return render_to_response('informes.html',{'user': user,
                                                   'mensaje': mensaje,
                                                   'informes': informes})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que filtra las mediciones de los sensores por dias (filtro)
@login_required
def filtroInformes(request):
    user = request.user
    informes = Mediciones.objects.all()
    mensaje = ""
    if(user.is_staff or informes.count() != 0):
        filtro = request.GET['filtro']
        filtro = float(filtro)
        now = datetime.now()
        last = timedelta(days = filtro)
        setInformes = set(informes)
        
        for informe in informes:
            fecha = informe.date
            fecha = fecha.split("-")
            hora = informe.time
            hora = hora.split(":")
            
            year = int(fecha[0])
            mes = int(fecha[1])
            dia = int(fecha[2])
            h = int(hora[0])
            m = int(hora[1])
            s = int(hora[2])
            
            dat = datetime(year, mes, dia, h, m, s)
            
            if (now - dat > last):
                infor = Mediciones.objects.get(id = informe.id)
                setInformes.discard(infor)
        
#        if (setInformes.count() == 0):
#            mensaje = "No hay mediciones para este filtro"
            
        return render_to_response('informes.html',{'user': user,
                                                   'mensaje': mensaje,
                                                   'informes': setInformes})
        
    else:
        mensaje = "El usuario no tiene permisos de administrador o no hay informes"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Se muestran las diferentes imagenes cogidas por las camaras de seguridad
@login_required
def video(request):
    user = request.user
    if(user.is_staff):
        videos = Video.objects.all()
        return render_to_response('video.html', {'user':user,
                                                 'videos': videos})
    else:
        return render_to_response('error.html', {'user':user})
    
# Muestra el estado actual general de la red domotica 
# diciendo como se encuentran los actuadores
@login_required
def estado(request):
    user = request.user
    if(user.is_staff):
        arduinos = ArduinoActuales.objects.all()
        sensores = SensoresActivos.objects.all()
        return render_to_response('estado.html', {'user':user,
                                                  'arduinos': arduinos,
                                                  'sensores': sensores})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})    

# Funcion para mostrar la herramienta para cambiar un atributo a un usuario.
@login_required
def password(request):
    user = request.user
    if(user.is_staff):
        if (user.is_superuser):
            users = User.objects.filter(is_superuser = False)
        else:
            users = User.objects.filter(is_staff = False)
        return render_to_response('password.html', {'user':user,
                                                    'users': users})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que cambia el password de un usuario p por el administrador        
@login_required
def setPassword(request):
    user = request.user
    if(user.is_staff):
        if ('userp' in request.GET and 'newPass' in request.GET and 
            'confPass' in request.GET):
            id = int(request.GET['userp'])
            userp = User.objects.get(id = id)
            newPass = request.GET['newPass']
            confPass = request.GET['confPass']

        else:
            mensaje = "Error en el envio de los datos"
            return render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
        if 'oldPass' in request.GET:
            oldPass = request.GET['oldPass']
            if (not userp.check_password(oldPass)) :
                mensaje = "Error, no coincide el password antiguo"
                return render_to_response('password.html', {'user':user,
                                                            'mensaje': mensaje})
        else:
            mensaje = "Error en el password antiguo"
            return render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
            
        
        
        if newPass != confPass :
            mensaje = "Error, no coincide los passwords nuevos"
            return render_to_response('password.html', {'user':user,
                                                        'mensaje': mensaje})
            
        userp.set_password(newPass)
        userp.save()
        mensaje = "Se ha modificado el password del usuario %s"%(userp)
        return render_to_response('zonas.html', {'user':user,
                                                 'mensaje': mensaje})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
                
# Funcion que cambia un atributo de un usuario p
@login_required
def setAtributo(request):
    user = request.user
    if(user.is_staff):
        if ('userp' in request.GET and 'mod' in request.GET and 
            'tipo' in request.GET):
            id = int(request.GET['userp'])
            userp = User.objects.get(id = id)
            mod = request.GET['mod']
            x = request.GET['tipo']
            tipo = int(x)
            
            if tipo == 1 :
                if (len(mod) == 0 or User.objects.filter(username = mod).count() > 0):
                    mensaje = "Nombre vacio o no disponible"
                    return render_to_response('error.html', {'user':user,
                                                             'mensaje': mensaje})
                atributo = "nombre"
                userp.username = mod
            else:
                if (mod.__contains__('@') and mod.__contains__('.')):
                    atributo = "email"
                    userp.email = mod
                else:
                    mensaje = "Email no valido "
                    render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
        else:
            mensaje = "Error en el envio de los datos"
            return render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
            
        userp.save()
        mensaje = "Se ha cambiado el atributo %s del usuario %s"%(atributo, userp)
        return render_to_response('zonas.html', {'user':user,
                                                 'mensaje': mensaje})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})  

# Funcion que muestra los planes de ahorro energetico.
# Cambia el estado activado/desactivado de un plan de ahorro poniendo
# los demas planes a 0. Solo puede haber uno activado a la vez
@login_required
def ahorro(request):
    user = request.user
    if(user.is_staff):
        mensaje = ""
        ahorros = AhorroEnergetico.objects.all()
        if request.method == 'POST':
            idahorro = request.POST['id']
            id = int(idahorro)
            ahorro = AhorroEnergetico.objects.get(id = id)
            xahorro = AhorroEnergetico.objects.filter(activado = 1)
            
            ahorro.activado = (not ahorro.activado)
            ahorro.save()
            
            for ah in xahorro:
                if ahorro.id != ah.id:
                    ah.activado = 0
                    ah.save()
                
            if ahorro.activado:
                mensaje = "Ahorro energetico activado"
            else:
                mensaje = "Ahorro energetico desactivado"
                
        return render_to_response('ahorro.html', {'user':user,
                                                  'ahorros': ahorros,
                                                  'mensaje': mensaje})
    else:
        ahorros = AhorroEnergetico.objects.filter(activado = 1)
        if (ahorros.count() == 0):
            mensaje = "No hay ningun plan de ahorro energetico activado"
        else:
            mensaje = ""
        return render_to_response('ahorro.html', {'user':user,
                                                  'ahorros': ahorros,
                                                  'mensaje': mensaje})
  
# Introduce un nuevo plan de ahorro energetico con los valores introducidos
# o con valores por defecto
@login_required
def addAhorro(request):
    user = request.user
    if(user.is_staff):
        if request.method == 'POST':
            ae = AhorroEnergetico.objects.get(id = 1)
            desc = request.POST['desc']
            if len(desc) == 0:
                desc = "NO NAME"
               
            luzh = request.POST['luzh']
            
            if (len(luzh) != 0 and len(luzh) <3):
                luzh = int(luzh)
            else:
                luzh = ae.luzh
                               
            luzl = request.POST['luzl']
            if (len(luzl) != 0 and len(luzl) <3):
                luzl = int(luzl)
            else:
                luzl = ae.luzl
                               
            temph = request.POST['temph']
            if len(temph) != 0 and len(temph) <3:
                temph = int(temph)
            else:
                temph = ae.temperaturah
                       
            templ = request.POST['templ']
            if len(templ) != 0 and len(templ) <3:
                templ = int(templ)
            else:
                templ = ae.temperatural
                           
            humh = request.POST['humh']
            if len(humh) != 0 and len(humh) <3:
                humh = int(humh)
            else: 
                humh = ae.humedadh
                  
            huml = request.POST['huml']
            if len(huml) != 0 and len(huml) <3:
                huml = int(huml)
            else:
                huml = ae.humedadl              
                
            if 'id' in request.POST:
                id = int(request.POST['id'])
                ae = AhorroEnergetico.objects.get(id = id)
                ae.descripcion = desc
                ae.luzh = luzh
                ae.luzl = luzl
                ae.temperaturah = temph
                ae.temperatural = templ
                ae.humedadh = humh
                ae.humedadl = huml
                ae.save()
                mensaje = "Se ha modificado el ahorro energetico "+ desc
            else:                    
                AhorroEnergetico.objects.create(activado = 0, descripcion = desc,
                                                luzh = luzh, luzl = luzl,
                                                temperaturah = temph, temperatural = templ,
                                                humedadh = humh, humedadl = huml)
        
                mensaje = "Se ha creado el ahorro energetico "+desc
            
            ahorros = AhorroEnergetico.objects.all()
            return render_to_response('ahorro.html', {'user':user,
                                                      'ahorros': ahorros,
                                                      'mensaje': mensaje})
        
        return render_to_response('addAhorro.html', {'user': user}) 
            
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Muestra la herramienta donde se pueden modificar los parametros de un plan
# de ahorro energetico
@login_required
def modAE(request):
    user = request.user
    if(user.is_staff and request.method == "POST"):
        id = int(request.POST['id'])
        ae = AhorroEnergetico.objects.get(id = id)
        
        return render_to_response('modAE.html', {'user':user,
                                                 'ahorro': ae})
    
    else:
        mensaje = "El usuario no tiene permisos de administrador o error en el envio de datos"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})


# Elimina un plan de ahorro energetico. El plan DEFAULT no puede ser borrado
@login_required
def eliminarAE(request):
    user = request.user
    if(user.is_staff and request.method == "POST"):
        id = int(request.POST['id'])
        ae = AhorroEnergetico.objects.get(id = id)
        descripcion = ae.descripcion
        ae.delete()
        ahorros = AhorroEnergetico.objects.all()
        mensaje = "Se ha eliminado el ahorro energetico "+ descripcion
        return render_to_response('ahorro.html', {'user':user,
                                                  'ahorros': ahorros,
                                                  'mensaje': mensaje})
    
    else:
        mensaje = "El usuario no tiene permisos de administrador o error en el envio de datos"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra las alarmas activas.
@login_required    
def alarmas(request):
    user = request.user
    if(user.is_staff):
        if request.method == "POST":
            id = int(request.POST['id'])
            Alarmas.objects.get(id = id).delete()
            
        alarmas = Alarmas.objects.all()
        mensaje = ""
        
        if(alarmas.count() == 0):
            mensaje = "No hay alarmas"
        
        return render_to_response('alarmas.html', {'user':user,
                                                   'mensaje': mensaje,
                                                   'alarmas': alarmas})
    else:
        mensaje = "El usuario no tiene permisos de administrador"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
        

def contactar(request):
    user = request.user
    if request.method == "POST":
        mensaj = request.POST['mensaje']
        asunto = request.POST['asunto']
          
        tecnicos = User.objects.filter(is_superuser = 1)
        
        for tecnico in tecnicos:
            send_mail(asunto, mensaj, 
                  settings.DEFAULT_FROM_EMAIL, tecnico.email)
            
        mensaje = "Email enviado"
        return render_to_response('contactar.html', {'user':user,
                                                         'mensaje': mensaje})
    else:    
        return render_to_response('contactar.html', {'user':user})
# --------------------------------- TECNICO -------------------------------------

# Muestra la pagina principal del tecnico
@login_required
def tecnico(request):
    user = request.user
    uc = UC.objects.count()
    if(user.is_superuser):
        
        return render_to_response('tecnicoPrincipal.html', {'user':user,
                                                            'uc': uc})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Creacion de una nueva red domotica
@login_required
def newArdomus(request):
    user = request.user
    
# SOLO PUEDE HABER UNA UNIDAD DE CONTROL POR RED DOMOTICA
    if UC.objects.count() > 1 :
        mensaje = "Solo puede haber una unidad de control por red domotica"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
         
    if(user.is_superuser):
#        Metemos en la BD los tipos de sensores, los tipos de actuadores y el 
#        ahorro energetico DEFAULT.

        if(TipoActuadores.objects.count() == 0):
            TipoActuadores.objects.create(nombre = "Luz")
            TipoActuadores.objects.create(nombre = "AireAcondicionado")
            TipoActuadores.objects.create(nombre = "Persianas")
            TipoActuadores.objects.create(nombre = "RiegoCesped")
        
        if(TipoSensores.objects.count() == 0):
            TipoSensores.objects.create(nombre = "Luminosidad")
            TipoSensores.objects.create(nombre = "Temperatura")
            TipoSensores.objects.create(nombre = "Humedad")
            TipoSensores.objects.create(nombre = "Movimiento")
            TipoSensores.objects.create(nombre = "CO2")

        if(AhorroEnergetico.objects.count() == 0):
            AhorroEnergetico.objects.create(activado = 0, descripcion = "DEFAULT",
                                            luzh = 50, luzl = 20,
                                            humedadh = 75, humedadl = 30,
                                            temperaturah = 28, temperatural = 24)
            
        return render_to_response('newArdomus.html', {'user':user})
    
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
        
# Validacion de la unidad de control.
# Para el caso de una empresa que gestiona mas de una red descomentar 
# los atributos password e ip. Hacerlo tambien en models.py 
def validarUC(request):
    user = request.user
    if(user.is_superuser):
        if (request.POST.get('uc','')): 
#            and request.POST.get('password',''))
                                    
            iduc = request.POST['uc']
#            password = request.POST['password']
            uc = UC(identificador= iduc
#                    , password = password
                                        )
            ucs= UC.objects.all()
            
            if (ucs.count() == 0):
                uc.save()
            else:
                error = "El identificador no puede estar vacio";
                return render_to_response('newArdomus.html', {'user':user,
                                                          'error': error})
                
            return addZonas(request)
        else:
            mensaje = "El identificador no puede estar vacio"
            return render_to_response('newArdomus.html', {'user':user,
                                                          'mensaje': mensaje})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
        
# Funcion que muestra la herramienta para la creacion de nuevas zonas
@login_required
def addZonas(request):
    user = request.user
    if(user.is_superuser):
            return render_to_response('addZonas.html', {'user':user})
            
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
    
# Validacion de las zonas, estan relacionadas con la unidad de control.
# z = numero de zonas nuevas
def validarZonas(request):
    user = request.user
    if(user.is_superuser):
        uc = UC.objects.get(id = 1)
    
        if request.method != 'POST':
            mensaje = "Error al enviar los datos"
            return render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
    
    
        if 'z' in request.POST:
            z = request.POST['z']
        else:
            z = 0
          
        x = int(z)
        i=1
        
        while i <= x :
            i2 = str(i)
            nz = request.POST[i2]
            count = Zonas.objects.filter(nombre = nz)
            if (count.count() == 0 and len(nz) != 0):
                z = Zonas.objects.create(nombre = nz, uc = uc)
            else:
                mensaje = "Error en la creacion de la zona %s, nombre ya existente o vacio '%s'"%(i, nz) 
                return render_to_response('addZonas.html', {'user':user,
                                                            'mensaje': mensaje})
            i = i +1 
            
        return addMotas(request)
    
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra la herramienta para la creacion de nuevas motas.
# Para crear una mota se requiere que exista su zona
@login_required
def addMotas(request):
    user = request.user
    if(user.is_superuser):     
        zonas = Zonas.objects.all()
        return render_to_response('addMotas.html', {'user':user,
                                                    'zonas': zonas})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje}) 

# Funcion que valida las nuevas motas
# m = numero de motas nuevas a introducir
# rzona = nombre de la mota nueva en request
# rmota = nombre de la zona en request
@login_required
def validarMotas(request):
    user = request.user      
    zonas = Zonas.objects.all()  
    if(user.is_superuser):              
        if 'm' in request.POST:
            m = request.POST['m']
        else:
            m = 0
          
        x = int(m)
        i=1
    
        while i <= x :
            rzona = str(i + 100)
            rmota = str (i)
            nz = request.POST[rzona]
            nm = request.POST[rmota]
            zona = Zonas.objects.get(nombre = nz)
            motas = Motas.objects.filter(nombre = nm).count()
           
            if (len(nm) == 0 or motas > 0):
                mensaje = "Error en la creacion de la mota '%d', motas con el mismo nombre o con nombre vacio"%(i)
                return render_to_response('addMotas.html', {'user':user,
                                                            'mensaje': mensaje,
                                                            'zonas': zonas})
                 
            mota = Motas.objects.create(nombre = nm, zona = zona)
                
#           El 99 indica que aun no hay un actuador de ese tipo en esta mota
            ArduinoActuales.objects.create(zona = zona, mota = mota, luz = 99, ac = 99,
                                           persianas = 99, riego = 99)
#           El 99 indica que aun no hay un sensor de ese tipo en esta mota            
            SensoresActivos.objects.create(zona = zona, mota = mota, luz = 99, 
                                           motaActiva = 1, 
                                           temperatura = 99, humedad = 99, 
                                           movimiento = 99)          
            
            i = i +1
        
        return addActSen(request)
    
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra la herramienta para la introduccion de nuevos 
# actuadores y sensores en la red domotica. Se requiere que exista la mota asociada.
@login_required
def addActSen(request):
    user = request.user
    motas = Motas.objects.all()
    tipoAct = TipoActuadores.objects.all()
    tipoSen = TipoSensores.objects.all()
    return render_to_response('addActSen.html', {'user':user,
                                                 'motas': motas,
                                                 'tipoAct': tipoAct,
                                                 'tipoSen': tipoSen}) 

# Validacion de los nuevos actuadores y sensores.
# Al introducir un nuevo actuador se registra en la tabla ArduinosActuales
# Al introducir un nuevo sensor se registra en la tabla SensoresActivos
# a = numero de actuadores nuevos
# motaA = nombre de la mota del actuador en request
# tipoA = nombre del tipo del actuador en request
# s = numero de sensores nuevos
# motaS = nombre de la mota del sensor en request
# tipoS = nombre del tipo del sensor en request
@login_required
def validarActSen(request):
    user = request.user

    if(user.is_superuser):
#       Numero de actuadores 
        if 'a' in request.POST:
            a = request.POST['a']
        else:
            a = 0
#       Numero de sensores 
        if 's' in request.POST:
            s = request.POST['s']
        else:
            s = 0  
        
        x = int(a)
        y = int(s)
    
        i=1 
        j = 51
    
            
        while i <= x :
            actuador = str(i)
            motaA = str (i + 100)
            tipoA = str (i + 200)
            
            nactuador = request.POST[actuador]
            idmota = int(request.POST[motaA])
            ntipo = request.POST[tipoA]
            mota = Motas.objects.get(id = idmota)
            tipo = TipoActuadores.objects.get(nombre = ntipo)
            
            if len(nactuador) == 0:
                nactuador = "NO ID"
            
            a = Actuadores.objects.create(identificador = nactuador, 
                                              tipo = tipo, mota = mota)
            
            arduino = ArduinoActuales.objects.get(zona = mota.zona, mota = mota)
            if (ntipo == "Luz"):
                arduino.luz = 0
            elif (ntipo == "AireAcondicionado"):
                arduino.ac = 0
            elif (ntipo == "Persianas"):
                arduino.persianas = 0
            elif (ntipo == "RiegoCesped"):
                arduino.riego = 0
            
            arduino.save()        
            i = i +1
        
        
        while j <= y :
            sensor = str(j)
            motaS = str (j + 100)
            tipoS = str (j + 200)
            
            nsensor = request.POST[sensor]
            idmota = int(request.POST[motaS])
            ntipo = request.POST[tipoS]
            mota = Motas.objects.get(id = idmota)
            tipo = TipoSensores.objects.get(nombre = ntipo)
            
            if len(nsensor)== 0:
                nsensor = "NO ID"
                
            s = Sensores.objects.create(identificador = nsensor, 
                                        tipo = tipo, mota = mota)
            
            s = SensoresActivos.objects.get(zona = mota.zona, mota = mota)
            
            if (ntipo == "Luminosidad"):
                s.luz = 1
            elif (ntipo == "Movimiento"):
                s.movimiento = 1
            elif (ntipo == "Temperatura"):
                s.temperatura = 1
            elif (ntipo == "Humedad"):
                s.humedad = 1
                
            s.save()
            
            j = j +1
            
        return tecnico(request) 
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra la herramienta para introducir un administrador en la red
@login_required
def addAdministrador(request):
    user = request.user
    if(user.is_superuser):
        form = UserCreationForm()
        return render_to_response('addAdministrador.html', {'user':user,
                                                            'form': form})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})   

# Funcion que introduce el administrador en la red y redirecciona a los permisos
# AL igual que un usuario introducimos una entrada en la tabla Sonido
@login_required
def modAdministrador(request):
    user = request.user
    zonas = Zonas.objects.all()
    
    if(user.is_superuser):
        form = UserCreationForm(request.POST)
        if form.is_valid():
            new_user = form.save()
            new_user.is_staff = 1
            new_user.save()
            Sonido.objects.create(user = new_user)
            
            zonasp = {}
            return render_to_response('modpermisos.html',{'zonasp': zonasp, 
                                                          'user': user,
                                                          'userp': new_user,
                                                          'zonas': zonas})            
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que elimina un administrador de la red
@login_required
def eliminarAdministrador(request):
    user = request.user
    if (user.is_superuser):
        if request.method == "POST":
            id = int(request.POST['id'])
            adm = User.objects.get(id = id)
            mensaje = "Se a eliminado el administrador "
            adm.delete()
            return render_to_response('zonas.html', {'user':user,
                                                     'mensaje': mensaje})
        else:
            adms = User.objects.filter(is_staff = 1, is_superuser = 0)
            return render_to_response('eliminarAdms.html', {'user':user,
                                                            'adms': adms})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
    
# Funcion que da un resumen de ayuda al tecnico para el montaje de la red fisica
@login_required
def finish(request):
    user = request.user
    uc = UC.objects.get(id = 1)
    zonas = Zonas.objects.all()
    motas = Motas.objects.all()
    actuadores = Actuadores.objects.all()
    sensores = Sensores.objects.all()
        
    if(user.is_superuser):        
        return render_to_response('finish.html', {'user':user,
                                                  'uc': uc,
                                                  'zonas': zonas,
                                                  'motas': motas,
                                                  'actuadores': actuadores,
                                                  'sensores': sensores})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})

# Funcion que muestra la herramienta para eliminar o crear elementos de la red
@login_required
def listElementos(request):
    user = request.user
    uc = UC.objects.get(id = 1)
    zonas = Zonas.objects.all()
    motas = Motas.objects.all()
    actuadores = Actuadores.objects.all()
    sensores = Sensores.objects.all()
    
    if(user.is_superuser):
        
        return render_to_response('listElementos.html', {'user':user,
                                                         'uc': uc,
                                                         'zonas': zonas,
                                                         'motas': motas,
                                                         'actuadores': actuadores,
                                                         'sensores': sensores})
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
 
# Funcion que elimina elementos de la red domotica
# Se actualizan los valores de AruinosActuales y SensoresActivos 
def eliminarElementos(request):
    user = request.user
    uc = UC.objects.get(id = 1)
    zonas = Zonas.objects.all()
    motas = Motas.objects.all()
    actuadores = Actuadores.objects.all()
    sensores = Sensores.objects.all()
    
    if(user.is_superuser):
        if 'tipo' in request.POST:
            tipo = request.POST['tipo']
        else:
            tipo = "error"
            
        if 'id' in request.POST:
            nid = request.POST['id']
            id = int(nid)
        else:
            id = -1
        
        if (id == -1 or tipo == "error"):
            mensaje = "el id o el tipo a sido incorrecto"
            return render_to_response('error.html', {'user':user,
                                                     'mensaje': mensaje})
        
        elif(tipo == "Actuador"):
            actuador = Actuadores.objects.get(id = id)
            arduino = ArduinoActuales.objects.get(zona = actuador.mota.zona,
                                                  mota = actuador.mota)
            tipo = actuador.tipo.nombre
            if (tipo == "Luz"):
                arduino.luz = 99
            elif (tipo == "AireAcondicionado"):
                arduino.ac = 99
            elif (tipo == "Persianas"):
                arduino.ac = 99
            elif (tipo == "RiegoCesped"):
                arduino.ac = 99   
                
            arduino.save()
            actuador.delete()
            
        elif(tipo == "Sensor"):
            sensor = Sensores.objects.get(id = id)
            sensorActivo = SensoresActivos.objects.get(zona = sensor.mota.zona,
                                                       mota = sensor.mota)
            tipo = sensor.tipo.nombre
            if(tipo == "Luminosidad"):
                sensorActivo.luz = 99
            elif(tipo == "Temperatura"):
                sensorActivo.temperatura = 99
            elif(tipo == "Humedad"):
                sensorActivo.humedad = 99
            elif(tipo == "Movimiento"):
                sensorActivo.movimiento = 99
            
            sensorActivo.save()
            sensor.delete()
        
        elif(tipo == "Mota"):
            Motas.objects.get(id = id).delete()
        
        elif(tipo == "Zona"):
            Zonas.objects.get(id = id).delete()
        
        zonas = Zonas.objects.all()
        motas = Motas.objects.all()
        actuadores = Actuadores.objects.all()
        sensores = Sensores.objects.all()
        return render_to_response('listElementos.html', {'user':user,
                                                         'uc': uc,
                                                         'zonas': zonas,
                                                         'motas': motas,
                                                         'actuadores': actuadores,
                                                         'sensores': sensores})
        
    else:
        mensaje = "El usuario no tiene permisos de tecnico"
        return render_to_response('error.html', {'user':user,
                                                 'mensaje': mensaje})
        
@login_required
def addVideo(request):
    user = request.user
    if request.method == 'POST':
        nombre = request.POST['nombre']
        ustream = request.POST['ustream']
        if 'id' in request.POST:
            id = int(request.POST['id'])
            video = Video.objects.get(id = id)
            video.nombre = nombre
            video.ustream = ustream
            video.save()
            mensaje = "Se ha modificado la camara '%s'"%(nombre)
        else:
            mensaje = "Se ha introducido una nueva camara de seguridad '%s'"%(nombre)
            Video.objects.create(nombre = nombre, ustream = ustream)
        
        videos = Video.objects.all()
        
        return render_to_response('video.html', {'user':user,
                                                 'mensaje': mensaje,
                                                 'videos': videos})
         
    return render_to_response('addVideo.html', {'user':user})

@login_required
def modVideo(request):
    user = request.user
    if request.method == 'POST':
        id = int(request.POST['id'])
        eliminar = int(request.POST['eliminar'])
        video = Video.objects.get(id = id)
        
        if(eliminar == 1):
            mensaje = "Se ha eliminado la camara %s"%(video.nombre)
            video.delete()
            videos = Video.objects.all()
            return render_to_response('video.html', {'user':user,
                                                     'mensaje': mensaje,
                                                     'videos': videos})
        else:
            mensaje = "Cambia los valores de la camara %s"%(video.nombre)
            videos = Video.objects.all()
            return render_to_response('addVideo.html', {'user':user,
                                                        'video': video,
                                                        'mensaje': mensaje})
