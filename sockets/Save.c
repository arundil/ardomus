// Librerias Necesarias
#include <stdio.h>		// Necesarias para trabajar con c
#include <errno.h>
#include "GuardarFichero.h"
#include "GuardarBaseDato.h"
#include "LlamarProcesos.h"

//Constantes
#define tp '%'				// Constante para escribir en los string %

#define PROCESO "comprobarDatos"	// Proceso Siguiente
#define FICHERO "save.log"		// Fichero donde se guardara el log

int main (int argc, char *argv[]){ //Parametros Entrada(direccionNodo, fecha, hora, temperatura, tumedad, luminosidad, coordenadas)

	char insertar[300];		// Variable para cuando vayamos a insertar en mediciones
	int i=0;

	char log[500]=""; 		//creamos para el log

	char mota[5]="null";		// Mota sobre la que se recogen mediciones
	char zona[5]="null";		// Zona en la que se encuentra la mota
	char fecha[15]="null";		// Fecha del envio
	char hora[10]="null";		// Hora del envio
	char temperatura[10]="null";	// Temperatura medida
	char humedad[10]="null";	// Humedad medida
	char luminosidad[10]="null";	// Luminosidad medida
	char movimiento[5]="null";	// Sensor de movimiento
	
	// Tiene que haber siete mas el nombre del ejecutable(Save DirNodo, Fecha, Hora, Temperatura, Luminosidad, Coordenadas)
	if(argc!=9){
		perror("Error debe haber, ocho entradas.\nEjemplo: Save Zona Mota Humedad Temperatura Luminosidad Movimiento, Fecha, Hora.");
		exit(EXIT_FAILURE);//salimos si se produce
	}

	// Inicializamos los parametros de entradas
	sprintf(zona, "%s", argv[1]);
	sprintf(mota, "%s", argv[2]);
	sprintf(temperatura,"%s",argv[3]);
	sprintf(humedad,"%s", argv[4]);
	sprintf(luminosidad,"%s",argv[5]);
	sprintf(movimiento,"%s", argv[6]);
	sprintf(fecha,"%s", argv[7]);
	sprintf(hora, "%s", argv[8]);

	//Comprobamos que la direccion del nodo sea correcto o la fecha y la hora tb
	if((strcmp(mota,"null") == 0) || (strcmp(zona,"null") == 0)){
		printf("Error: El identificador de Mota o la Zona no pueden ser nulas.Error en la comunicacion\n");
		exit(EXIT_FAILURE);
	}

	// Creamos la consulta para insertar y actualizar a realizar
	sprintf(insertar, "INSERT INTO ardomus_mediciones (zona_id, mota_id, hum, temp, lum, movimiento, date, time) VALUES ('%s','%s','%s','%s','%s','%s','%s','%s');", zona, mota, humedad,temperatura, luminosidad, movimiento ,fecha,hora);
	

	// Almacenamos en la base de dato
	guardarBD(insertar);
	
	// Creamos el log a guardar
	sprintf(log, "Almacenado: La Zona con ID: %s y la Mota %s, tiene Humedad %s, Temperatura %s, Luminosidad %s y Movimiento %s con Fecha/Hora %s/%s\n\n", zona, mota, humedad, temperatura, luminosidad, movimiento, fecha, hora);

	// Se guarda en el log
	guardamosLog(FICHERO, log);

	// Llamamos a Check.c.

	char *argumentos[]={PROCESO, zona, mota, fecha, hora, temperatura, humedad, luminosidad, NULL};

	printf("Enviando: %s, %s, %s, %s, %s, %s, %s, %s.\n", argumentos[0], argumentos[1], argumentos[2], argumentos[3], argumentos[4], argumentos[5], argumentos[6], argumentos[7]);

	llamamosProceso(PROCESO, argumentos);

	return 0;
}
