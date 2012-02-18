from django.conf.urls.defaults import patterns, include
from django.contrib import admin
from django.contrib.auth.views import logout
from django.conf import settings
import os 
admin.autodiscover()

from PFC.ardomus.views import * 
site_media = os.path.join(os.path.dirname(__file__),  'site_media') 

urlpatterns = patterns('',
    (r'^site_media/(?P<path>.*)$', 'django.views.static.serve',{'document_root': site_media}),
    (r'^accion/config.txt$', 'django.views.static.serve',{'document_root': site_media}),
    (r'^accion/mp3.txt$', 'django.views.static.serve',{'document_root': site_media}),  
    # Examples:
    # url(r'^$', 'PFC.views.home', name='home'),
    # url(r'^PFC/', include('PFC.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),
    
    (r'^hola/$', hola),
    (r'^accounts/login/$','django.contrib.auth.views.login',{'template_name': 'login.html'}),
    (r'^accounts/logout/$',logout),
    (r'^logout/$', logoutviews),
    (r'^recordar/$', recordar),
    
    (r'^$', zonas),
    (r'^zonas/$', zonas),
    (r'^buscarmotas/$', buscarMotas),
    (r'^accion/$', accion),
    (r'^actuador/$', actuador),
    (r'^sonido/$', sonido),
    (r'^setReproductor/$', setReproductor),
    
    (r'^administrador/$', administrador),
    (r'^usuarios/$', usuarios),
    (r'^addusuario/$', register),
    (r'^modificarpermisos/$', modificarpermisos),
    (r'^eliminaruser/$', eliminaruser),
    (r'^permisos/$', permisos),
    (r'^modpermisos/$', modpermisos),
    (r'^informes/$', informes),
    (r'^filtroInformes/$', filtroInformes),
    (r'^video/$', video),
    (r'^estado/$', estado),
    (r'^password/$', password),
    (r'^setPassword/$', setPassword),
    (r'^ahorro/$', ahorro),
    (r'^addAhorro/$', addAhorro),
    (r'^eliminarAE/$', eliminarAE),
    (r'^modAE/$', modAE),
    (r'^contactar/$', contactar),
    
    (r'^tecnico/$', tecnico),
    (r'^newArdomus/$', newArdomus),
    (r'^validarUC/$', validarUC),
    (r'^addZonas/$', addZonas),
    (r'^validarZonas/$', validarZonas),
    (r'^addMotas/$', addMotas),
    (r'^validarMotas/$', validarMotas),
    (r'^addActSen/$', addActSen),
    (r'^validarActSen/$', validarActSen),
    (r'^addAdministrador/$', addAdministrador),
    (r'^modAdministrador/$', modAdministrador),
    (r'^eliminarAdministrador/$', eliminarAdministrador),
    (r'^finish/$', finish),
    (r'^listElementos/$', listElementos),
    (r'^eliminarElementos/$', eliminarElementos),
    (r'^setAtributo/$', setAtributo),
    (r'^alarmas/$', alarmas),
    (r'^addVideo/$', addVideo),
    (r'^modVideo/$', modVideo),
    
    
)

if settings.DEBUG and settings.STATIC_ROOT:
    urlpatterns += patterns('',
        (r'%s(?P<path>.*)$' % settings.STATIC_URL.lstrip('/'), 
            'django.views.static.serve',
            {'document_root' : settings.STATIC_ROOT }),)