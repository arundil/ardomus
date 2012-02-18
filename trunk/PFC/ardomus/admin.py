from django.contrib import admin
from ardomus.models import *
    
class SenActAdmin(admin.ModelAdmin):
    list_display = ('tipo','mota')
    
class MotaAdmin(admin.ModelAdmin):
    list_display = ('zona', 'nombre')   

class UserZonaAdmin(admin.ModelAdmin):
    list_display = ('user', 'zona')
    
class MedicionesAdmin(admin.ModelAdmin):
    list_display = ('mota', 'temp')      


admin.site.register(UC)
admin.site.register(Zonas)
admin.site.register(Actuadores, SenActAdmin)
admin.site.register(Sensores, SenActAdmin)
admin.site.register(Motas, MotaAdmin)
admin.site.register(TipoActuadores)
admin.site.register(TipoSensores)
admin.site.register(UserZona, UserZonaAdmin)
admin.site.register(Mediciones, MedicionesAdmin)
admin.site.register(Arduinos)
admin.site.register(ArduinoActuales)