/*
 ============================================================================
 Name        : servidor.c
 Author      : Marc Bayon y Fj. Espinaco
 Version     : 0.1
 Copyright   : Ardomus(c)
 Description : Servidor que recibe los datos de la placa Ethernet Arduino y
 	 	 	   tambien recibe las peticiones de la página web.
 ============================================================================
 */

// Librerias Necesarias
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>

//#include "GuardarFichero.h"
#include "LlamarProcesos.h"
#include "Consultabd.h"

#define MYPORT 3490    // Puerto al que conectarán los usuarios

#define BACKLOG 10     // Cuántas conexiones pendientes se mantienen en cola

#define MAXDATASIZE 150 // máximo número de bytes que se pueden leer de una vez

#define PROCESO "Save"		// Proceso Siguiente
#define OK "HTTP/1.0 200 OK"	// Para mensaje de recibido correctamente
#define NOOK "HTTP/1.0 400 NK"	// Para mensaje de recibido incorrectamente
#define CABECERA "POST /comma-separated-value HTTP/1.0 Host: localhost\n" // Cabecera que debemos de recibir
#define FICHERO "get.log"	// Fichero donde se guardara el log

#define TAMBUF 10

void sigchld_handler(int s) // manejador para procesos muertos
{
	while(wait(NULL) > 0);
}

int main(void){

	int sockfd, new_fd;  		// Escuchar sobre sock_fd, nuevas conexiones sobre new_fd
	struct sockaddr_in my_addr;    	// Información sobre mi dirección (SERVIDOR)
	struct sockaddr_in their_addr; 	// Información sobre la dirección del cliente
	int sin_size;			// Tamaño de la estructura del socket	
	struct sigaction sa;		// Estructura del socket
	int yes=1;			// Bandera del puerto a escuchar
	char buf[MAXDATASIZE]="";	// Buffer de tratamiento de datos
	char *datosRecibidos;		// Buffer de recogida de datos
	char idDatos[20][3];		// Auxiliar que recoge el identificador de los datos
	int i=-1;			// Bucles i
	int j=0;			// Bucles j
	int ok =0;			// Bandera de datos correctos
	char cabecera[60]="";		// Cadena que guarda la cabecera a recibir
	char mota[10]="";		// Cadena que guarda el id. de mota
	char zona[10]="";		// Cadena que guarda el id. de zona
	char tempE[10]="";		// Cadena que guarda la parte entera de la temperatura
	char tempD[10]="";		// Cadena de guarda la parte decimal de la temperatura
	char temperatura[30]="";	// Cadena usada para formar el dato temperatura
	char humE[10]="";		// Cadena que guarda la parte entera de la humedad
	char humD[10]="";		// Cadena que guarda la parte decimal de la humedad
	char humedad[30]="";		// Cadena usada para forma el dato humedad
	char luminosidad[10]="";		// Cadena que guarda el dato luminosidad de la vivienda
	char movimiento[10]="";		// Cadena que guarda el dato del sensor PIR de la vivienda.
	char fecha[15]="null";		// Fecha del envio
	char hora[10]="null";		// Hora del envio
	time_t tiempo;			// Valor del tiempo local
	struct tm * localtiempo;	// Estructura para tener el tiempo local

				//Variables para preparar el envio		
	char menAux[100]= "";		// Variable auxiliar de mensaje
	char mensaje[1000]="";		// Mensaje a mandar a las motas para ejecutar una acción concreta en los actuadores.

	int contador=0;
	//Iniciamos el descritor de fichero socket

	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	if (sockfd == -1) {
		perror("socket");
		exit(EXIT_FAILURE);
	}

	//Liberamos el puerto a escuchar si no esta libre

	if (setsockopt(sockfd,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(int)) == -1) {
		perror("setsockopt");
		exit(EXIT_FAILURE);
	}

	//Campos de la estructura relativos a mi(SERVIDOR)

	my_addr.sin_family = AF_INET;         // Ordenación de bytes de la máquina
	my_addr.sin_port = htons(MYPORT);     // short, Ordenación de bytes de la red
	my_addr.sin_addr.s_addr = INADDR_ANY; // Rellenar con mi dirección IP
	memset(&(my_addr.sin_zero), '\0', 8); // Poner a cero el resto de la estructura

	//asignamos nuestro socket a un puerto físico de comnucación

	if (bind(sockfd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr))
			== -1) {
		perror("bind");
		exit(EXIT_FAILURE);
	}

	/* Realizamos la escucha y dimensionamos una cola para las peticiones:*/
	if (listen(sockfd, BACKLOG) == -1) {
		perror("listen");
		exit(EXIT_FAILURE);
	}

	// Eliminar procesos muertos

	sa.sa_handler = sigchld_handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART;
	if (sigaction(SIGCHLD, &sa, NULL) == -1) {
		perror("sigaction");
		exit(EXIT_FAILURE);
	}

	while(1) {  // main accept() loop
		//aceptamos conexion entrante si existe
		sin_size = sizeof(struct sockaddr_in);
		if ((new_fd = accept(sockfd, (struct sockaddr *)&their_addr,
				&sin_size)) == -1) {
			perror("accept");
			continue;
		}
		//Quien llama?
		printf("Servidor: Establecida conexión con %s\n\n",
				inet_ntoa(their_addr.sin_addr));

		printf("Mostrando peticion del cliente\n");
		//recibimos peticion del cliente
		if ((recv(new_fd, buf, MAXDATASIZE, 0)) == -1)// buf = tipo de funcion a realizar
		{
			perror("recv");
			exit(EXIT_FAILURE);
		}
		printf("Recibiendo: %s\n",buf);


		//=======================================================
		//Interpretacion de datos

		datosRecibidos = strtok(buf, ";");
		i=-1;
		while (datosRecibidos != NULL)
		{
			sprintf(idDatos[++i], "%c%c%c", datosRecibidos[0], datosRecibidos[1], datosRecibidos[2]);
			if(strcmp(idDatos[i], "POS")==0){
				sprintf(cabecera, "%s", datosRecibidos);
			}
			else if(strcmp(idDatos[i], "ZON")==0){
				sprintf(zona, "%s", datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "MOT")==0){
				sprintf(mota, "%s", datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "TEE")==0){
				sprintf(tempE, "%s",datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "TED")==0){
				sprintf(tempD, "%s",datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "HUE")==0){
				sprintf(humE, "%s",datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "HUD")==0){
				sprintf(humD, "%s",datosRecibidos+3);
			}	
			else if(strcmp(idDatos[i], "LUM")==0){
				sprintf(luminosidad, "%s",datosRecibidos+3);
			}
			else if(strcmp(idDatos[i], "MOV")==0){
				sprintf(movimiento, "%s",datosRecibidos+3);
			}

			datosRecibidos = strtok(NULL, ";");
		}
		printf("cabecera: %s\nMota: %s, Zona: %s\n",cabecera,mota,zona);
		strcpy(temperatura,tempE);
		strcat(temperatura,".");
		strcat(temperatura,tempD);
		strcpy(humedad,humE);
		strcat(humedad,".");
		strcat(humedad,humD);
		
		//========================================================

		tiempo=time(NULL);
		localtiempo = localtime(&tiempo);

		sprintf(fecha, "%04d-%02d-%02d", localtiempo -> tm_year + 1900, localtiempo -> tm_mon + 1, localtiempo -> tm_mday);
		sprintf(hora, "%02d:%02d:%02d", localtiempo -> tm_hour, localtiempo -> tm_min, localtiempo -> tm_sec);

		sprintf(mensaje,"%s","");
		consultarBD ();
		
		if (data[0]!=99){
		  sprintf(menAux,"%s","");
		  sprintf(menAux,"ZON%02d;MOT%02d;LUZ%02d;AAC%02d;PER%02d;RIE%02d\t",data[1],data[2],data[3],data[4],data[5],data[6]); //el data[0] es el id
		  strcat(mensaje,menAux);
		  strcat(mensaje,"\n");
		}
		else{
		  printf("No hay actuadores que activar\n\n");
		  sprintf(mensaje,"%s","NODATA\n");
		}
	
		if (strcmp(CABECERA,cabecera)==0){
			ok=1;			
		}else{
			ok=0;			
		}

		if (!fork()) { // Este es el proceso hijo
				if(ok){
				strcat(mensaje,OK);
				if (send(new_fd, mensaje, strlen(mensaje), 0) == -1){
					perror("Error al enviar, Error de send");
					exit(EXIT_FAILURE);
				}

				printf("Enviando datos al cliente\n%s\n\n",mensaje);
			}
			else{
				strcat(mensaje,NOOK);
				if (send(new_fd, mensaje, strlen(mensaje), 0) == -1){
					perror("Error al enviar, Error de send");
					exit(EXIT_FAILURE);
				}

				printf("Enviando datos al cliente\n%s\n\n",mensaje);
			}


			close(new_fd);	// El hijo ya no necesita este descriptor, lo cerramos

			exit(0);

		}

		close(new_fd);  // El proceso padre no lo necesita

		//llamar al proceso save

		 printf("CONTADOR VALE:%d\n",contador);
			if (ok /*&& contador == 5*/){
			//Obligatorio poner un null para finalizar los argumentos.
			char *argumentos[]={PROCESO,zona,mota,temperatura,humedad,luminosidad, movimiento,fecha,hora,NULL};
			printf("Enviando: %s, %s, %s, %s, %s, %s, %s,%s,%s.\n", argumentos[0], argumentos[1], argumentos[2], argumentos[3], argumentos[4], argumentos[5], argumentos[6], argumentos[7], argumentos [8]);
			llamamosProceso(PROCESO, argumentos);
			contador =0;
			
		}
		contador ++;
	}

	return 0;
}

