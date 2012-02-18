#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <string.h>

void llamamosProceso(char *proceso, char *argumentos[] ){

	int ret=fork();	//creacion de un proceso con codigo igual que el padre
	int stado;	// Para saber el estado
	char *prog[]= { "ls", "-la", NULL };
	char ruta[100] = "";
	strcpy(ruta,getenv("HOME"));	
	strcat(ruta,"/PFC/Ardomus/sockets/");	// Ruta de los procesos
	
	sprintf(ruta, "%s%s", ruta, proceso);

	// Parte del Proceso Padre (Espera del fin del proceso hijo)
	if(ret>0){
		if(wait(&stado)==-1){
			perror("Error de wait\n");
			exit(EXIT_FAILURE);
		}
		else{
			printf("Proceso Finalizado %s\n\n", proceso);
		}
	// Parte del Proceso Hijo (Llamada de los otros procesos)
	}else if(ret==0){ 
		printf("Llamando al proceso %s\n\n", proceso);
		execvp(ruta,argumentos);
		perror("Error de exec\n");
		exit(EXIT_FAILURE);
	// Error...
	}else if(ret==-1){
		perror("Error en fork");
	}
}
