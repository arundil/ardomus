
// Librerias Necesarias
#include <stdio.h>		// Necesarias para trabajar con c
#include <errno.h>

#include "GuardarBaseDato.h"
#include "GuardarFichero.h"

//Constantes		
#define FICHERO "alarmas.log"	// Fichero donde se guardara el log

int main (int argc, char *argv[]){ // Entrada: Direccion Nodo, Motivo Alarma, fecha, hora

	char insertar[200]="";	// Variable para cuando vayamos a insertar en alarmas
	char update[200]="";	//Variable para cuando vayamos a actualizar algun valor en la tabla de sensores activos
	
	char log[200]=""; 	//creamos para el log
	
	int idMedicion=0;	// Identificación de la medicion defectuosa
	int motivoAlarma=0;	// Motivo de la alarma
	char zona[4]="null";	// Zona de la casa
	char mota[4]= "null";	// Mota que corresponde a dicha zona
	char fecha[15]="null";	// Fecha del envio
	char hora[10]="null";	// Hora del envio	

	char motivo[500]="";	// Variable guardar el motivo

	if(argc!=7){ 
		perror("Error debe haber, seis entradas.\nEjemplo: alarmas idMedicion MotivoAlarma Zona Mota fecha hora.");
		exit(EXIT_FAILURE);
	}

	// Inicializamos los parametros de entradas

	idMedicion=atoi(argv[1]);	
	motivoAlarma=atoi(argv[2]);
	sprintf(zona, "%s", argv[3]);
	sprintf(mota, "%s", argv[4]);
	sprintf(fecha, "%s", argv[5]);
	sprintf(hora, "%s", argv[6]);
	

	//Descripción del motivo
	switch(motivoAlarma){

		case (1):
			sprintf(motivo, "No recivo confirmación por parte de la mota. Enviando informacion recibida. ");
			break;

		case (2):{
			printf("MOTA: %s\n",mota);
			sprintf(motivo, "Incoherencia con el Sensor de Luminosidad. Sensor de Luminosidad desactivado\n.");
			sprintf(update, "UPDATE ardomus_sensoresactivos SET luz = 0 WHERE zona_id='%s' AND mota_id='%s';",zona,mota);
			guardarBD(update);
			break;
			}
		case (3):
			sprintf(motivo, "Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n");
			sprintf(update, "UPDATE ardomus_sensoresactivos SET humedad = 0 WHERE zona_id='%s' AND mota_id='%s';", zona,mota);
			guardarBD(update);				
			break;

		case (4):
			sprintf(motivo, "Incoherencia con el sensor de Temperatura. Sensor de Temperatura desactivado\n");
			sprintf(update, "UPDATE ardomus_sensoresactivos SET temperatura = 0 WHERE zona_id='%s' AND mota_id='%s';", zona,mota);
			guardarBD(update);
			break;
		
		case (5):
			sprintf(motivo, "Incoherencia con el sensor de Movimiento. Sensor de Movimiento desactivado\n");
			sprintf(update, "UPDATE ardomus_sensoresactivos SET movimiento = 0 WHERE zona_id='%s' AND mota_id='%s';", zona,mota);
			guardarBD(update);
			break;

	}

// Creamos la consulta a realizar para insertar
	sprintf(insertar, "INSERT INTO ardomus_alarmas (medicion_id, idmotivo, motivo) VALUES ( '%d', '%d', '%s');", idMedicion, motivoAlarma,motivo);
// Almacenamos en la base de dato
	guardarBD(insertar);

	// Creamos el log a guardar
	sprintf(log, "Alarma: ZONA: %s, MOTA: %s, idMedicion %d ha producido una alarma por motivo:\n--> %s, con Fecha/Hora %s/%s\n\n", zona,mota, idMedicion, motivo, fecha, hora);

	// Se guarda en alarm.log
	guardamosLog(FICHERO, log);

	// Se avisa a los administradores.
	printf("\nAlarma: ZONA: %s, MOTA: %s, idMedicion %d ha producido una alarma por motivo:\n--> %s, con Fecha/Hora %s/%s\n\n", zona,mota, idMedicion, motivo, fecha, hora);

	return 0;

}

