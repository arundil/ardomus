from django.db import models
from django.contrib.auth.models import User

# Unidad de control, elemento principal de la red
class UC(models.Model):
    identificador = models.CharField(max_length=50)
#    password = models.CharField(max_length=50)
#    ip = models.IPAddressField()
    
    def __unicode__(self):
        return self.identificador

class Zonas(models.Model):
    nombre = models.CharField(max_length=50)
    uc = models.ForeignKey(UC)
    
    def __unicode__(self):
        return self.nombre

# Nodos de la red   
class Motas(models.Model):
    nombre = models.CharField(max_length=50)
    zona = models.ForeignKey(Zonas)
    
    def __unicode__(self):
        return self.nombre

# Los tipo de actuadores con los que trabajamos
class TipoActuadores(models.Model):
    nombre = models.CharField(max_length=50)
    
    def __unicode__(self):
        return self.nombre

# Los tipo de sensores con los que trabajamos
class TipoSensores(models.Model):
    nombre = models.CharField(max_length=50)
    
    def __unicode__(self):
        return self.nombre
    
# Aparato electronico fisico, se encarga de hacer una accion del usuario
class Actuadores(models.Model):
    identificador = models.CharField(max_length=50)
    tipo = models.ForeignKey(TipoActuadores)
    mota = models.ForeignKey(Motas)
    
    def __unicode__(self):
        return self.tipo.nombre
    
# Aparato electronico fisico, se encarga de recopilar informacion del entorno
class Sensores(models.Model):
    identificador = models.CharField(max_length=50)
    tipo = models.ForeignKey(TipoSensores)
    mota = models.ForeignKey(Motas)
    
    def __unicode__(self):
        return self.tipo.nombre
    
# Asociacion que representa los permisos de los usuarios por zonas
class UserZona(models.Model):
    user = models.ForeignKey(User)
    zona = models.ForeignKey(Zonas)

# Informacion recogida por los sensores. Si el sensor no existe en la mota la
# medicion da 0
class Mediciones(models.Model):
    zona = models.ForeignKey(Zonas)
    mota = models.ForeignKey(Motas)
    hum = models.CharField(max_length=50, blank= True, null=True)
    temp = models.CharField(max_length=50, blank= True, null=True)
    lum = models.CharField(max_length=50, blank= True, null=True)
    movimiento = models.CharField(max_length=50, blank= True, null=True)    
    date = models.CharField(max_length=50)
    time = models.CharField(max_length=50)
    
    def __unicode__(self):
        return u'%s, %s' % (self.zona, self.mota)    

# Esta tabla se encarga de darle las ordenes a los arduinos, la unidad de control
# borrara las ordenes una vez enviadas.
class Arduinos(models.Model):
    zona = models.ForeignKey(Zonas)
    mota = models.ForeignKey(Motas)
    luz = models.IntegerField()
    ac = models.IntegerField()
    persianas =  models.IntegerField()
    riego =  models.IntegerField()
    
    
# Esta tabla es para recordar como estan los actuadores. 0 = Apagado, 
# 1 = encendido, 99 = no existe ese actuador en esa mota
class ArduinoActuales(models.Model):
    zona = models.ForeignKey(Zonas)
    mota = models.ForeignKey(Motas)
    luz = models.IntegerField()
    ac = models.IntegerField()
#   1 = persiana arriba, 0 = persiana abajo 
    persianas = models.IntegerField()
    riego = models.IntegerField()  

# Nos informa del estado en que estan los sensores. 1 = activo, 
# 0 = inactivo (error) 99 = no existe ese sensor en esa mota
class SensoresActivos(models.Model):
    zona = models.ForeignKey(Zonas)
    mota = models.ForeignKey(Motas)
    motaActiva = models.IntegerField() 
    luz = models.IntegerField()
    temperatura = models.IntegerField()
    humedad = models.IntegerField()
    movimiento = models.IntegerField()

# Tabla que avisa si alguna medicion es anomala
class Alarmas(models.Model):
    medicion = models.ForeignKey(Mediciones)
    idmotivo = models.IntegerField()
    motivo = models.CharField(max_length=500)
    
# Tabla que por cada usuario introduce un reproductor flash sacado de la pagina
# www.mixpod.com
class Sonido(models.Model):
    user = models.ForeignKey(User)
    mixpod = models.TextField(blank= True, null=True)
    
# Tabla que por cada camara de seguridad introduce un 
# reproductor flash sacado de la pagina
# www.ustream.com
class Video(models.Model):
    nombre =models.CharField(max_length=50)
    ustream = models.TextField(blank= True, null=True)

# Tabla para representar los rango de valores por la cual se activan o se 
# desactivan diferentes actuadores.
# Solo hay un plan de ahorro energetico activo a la vez.
# Si hay un plan de ahorro activo los usuarios tienen capados algunos actuadores.
class AhorroEnergetico(models.Model):
    activado = models.IntegerField()
    descripcion = models.CharField(max_length=50)
    luzh = models.IntegerField()
    luzl = models.IntegerField()
    temperaturah = models.IntegerField()
    temperatural = models.IntegerField()
    humedadh = models.IntegerField()
    humedadl = models.IntegerField()