// Librerias Necesarias
#include <stdlib.h>
#include <stdio.h>		// Necesarias para trabajar con c
#include <mysql/mysql.h>	// Necesarias para trabajar con la bd

#include "LlamarProcesos.h"
#include "ahorroenergetico.h"

#define PROCESO "alarmas"		// Proceso Siguiente

#define SERVER "127.0.0.1" 	// Servidor donde se encuentra la BD
#define USER "root"		// Usuario de la base de datos
#define PASSWORD ""		// Password de este usuario
#define DATABASE "ardomus"	// Base de datos a utilizar
#define PUERTO 3306		// Puerto para acceder a la BD


int main (int argc, char *argv[]){ //Parametros Entrada(direccionNodo, fecha, hora, temperatura, tumedad, luminosidad, coordenadas)

	MYSQL *conn;		// Conexion
	MYSQL_RES *res;		// Resultador Obtenido de la consulta
	MYSQL_ROW row;		// Variable que guarda cada fila de la consulta
	
	char consulta1[200]="";		// Para realizar la consulta a la base de dato
	char consulta2[200]="";		// Para realizar la consulta a la base de dato
	
	char zona[20]="null";		// Zona
	char mota[5]="null";		// Mota
	char fecha[15]="null";		// Fecha del envio
	char hora[10]="null";		// Hora del envio
	float temperatura=-100;		// Temperatura medida
	float humedad=-1;		// Humedad medida
	float luminosidad=-1;		// Luminosidad medida
	char idMedicion[15]="null";	// Id de la Medicion

	int activadaMota=0;		// Para saber si el nodo esta activo
	int activadoTemperatura=0;	// Para saber si el sensor Temperatura esta activo
	int activadoHumedad=0;		// Para saber si el sensor Humedad esta activo
	int activadoLuminosidad=0;	// Para saber si el sensor Luminosidad esta activo

	char motivoAlarma[10][2];	// Array con los motivos de las alarma

	int i=-1;			// Para recorrer el array anterior

	// Tiene que haber seis mas el nombre del ejecutable
	if(argc!=8){ 
		perror("Error debe haber, siete entradas.\nEjemplo: ComprobarDatos Zona Mota Fecha Hora Temperatura Humedad Luminosidad.");
		exit(EXIT_FAILURE);//salimos si se produce
	}


	// Inicializamos los parametros de entradas
	sprintf(zona, "%s", argv[1]);
	sprintf(mota, "%s", argv[2]);
	sprintf(fecha,"%s", argv[3]);
	sprintf(hora, "%s", argv[4]);
	temperatura=atof(argv[5]);
	humedad=atof(argv[6]);
	luminosidad=atof(argv[7]);

	//Comprobamos que la direccion del nodo sea correcto o la fecha y la hora tb
	if((strcmp(zona,"null") == 0) || (strcmp(mota,"null") == 0)){ 
		printf("Error DIRECCION del NODO o/y de la RED son NULAS\n");
		exit(EXIT_FAILURE);
	}

	// Creamos la consulta a realizar
	sprintf(consulta1, "SELECT * FROM ardomus_sensoresactivos WHERE zona_id='%s' AND mota_id='%s';", zona, mota);
	
	conn = mysql_init(NULL);

	// Abrimos Conexion con la BD		
	if (!mysql_real_connect(conn, SERVER, USER, PASSWORD, DATABASE, PUERTO, NULL, 0)) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}
			
	// Buscar Nodo y mirar info sobre sensores activados.
	if (mysql_query(conn, consulta1)) {	
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}

	res = mysql_use_result(conn);

	// Guardamos los datos de la alarma en variables.	
	while ((row = mysql_fetch_row(res)) != NULL){

		activadaMota=atoi(row[3]); 
		activadoTemperatura=atoi(row[5]); 
		activadoHumedad=atoi(row[6]);
		activadoLuminosidad=atoi(row[4]);
	}
	
		
	// Cerramos Conexion con la BD 

	mysql_free_result(res);
	mysql_close(conn);

	// Comprobar que los datos recibidos estan dentro de los rangos que no hay incoherencia entre sensor activado y dato nulo o al reves.

	// El nodo debe estar activo
	if(activadaMota){

		if((activadoTemperatura==1 && (temperatura<0 || temperatura>60))){ //comprobamos que la temperatura este activo y dentro del rango(-20,150), y si no esta activo k no de datos
			i++;
			sprintf(motivoAlarma[i], "4"); // Motivo Alarma --> 4 = Incoherencia con el Sensor de Temperatura
		}

		if((activadoHumedad==1 && (humedad<0 || humedad>100)) ){ //comprobamos que la humedad este activo y dentro del rango(00,100), y si no esta activo k no de datos
			i++;
			sprintf(motivoAlarma[i], "3"); // Motivo Alarma --> 3 = Incoherencia con el Sensor de Humedad
		}

		if((activadoLuminosidad==1 && (luminosidad<0 || luminosidad>100))){ //comprobamos que la temperatura este activo y dentro del rango(0,100), y si no esta activo k no de datos
			i++;
			sprintf(motivoAlarma[i], "2"); // Motivo Alarma --> 2 = Incoherencia con el Sensor de Luminosidad
		}

	}else{
		i++;
		sprintf(motivoAlarma[i], "1"); // Motivo Alarma --> 1 = Nodo Inactivo pero enviando informacion
	}


	// Se llama a alarm.c
	if(i>=0){
	
		sprintf(consulta2, "SELECT id FROM ardomus_mediciones WHERE zona_id = '%s' AND mota_id = '%s' AND date = '%s' AND time = '%s';", zona, mota, fecha, hora);

		conn = mysql_init(NULL);

		// Abrimos Conexion con la BD		
		if (!mysql_real_connect(conn, SERVER, USER, PASSWORD, DATABASE, PUERTO, NULL, 0)) {
			fprintf(stderr, "%s\n", mysql_error(conn));
			exit(1);
		}
			
		// Buscar Nodo y mirar info sobre sensores activados.	
		if (mysql_query(conn, consulta2)) {	
			fprintf(stderr, "%s\n", mysql_error(conn));
			exit(1);
		}

		res = mysql_use_result(conn);
		
		// Guardamos los datos de la alarma en variables.	
		while ((row = mysql_fetch_row(res)) != NULL){

			sprintf(idMedicion, "%s", row[0]);
			
		}
		
		// Cerramos Conexion con la BD 	
		mysql_free_result(res);
		mysql_close(conn);
		

	}else{
	  //Sabemos que los datos son correctos, por lo que llamamos a ahorro energético para ver si está conectado.
	  ahorroenergetico();	  
	}

	while(i>=0){	

		char *argumentos[]={PROCESO, idMedicion, motivoAlarma[i], zona, mota, fecha, hora, NULL};

		printf("Enviando: %s, %s, %s, %s, %s, %s,%s.\n", argumentos[0], argumentos[1], argumentos[2], argumentos[3], argumentos[4], argumentos[5],argumentos[6]);
		
		llamamosProceso(PROCESO, argumentos);

		i--;
	}

	return 0;

}
