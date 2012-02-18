
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

void guardamosLog(char *fichero, char *log){

		// Abrimos fichero
		int fd =open(fichero ,O_CREAT|O_APPEND|O_WRONLY, 760); 
		
		if(fd==-1){
			perror("Error al abrir el fichero");		
			exit(EXIT_FAILURE);
		}
	
		// Escribimos en el fichero
		if (write(fd,log,strlen(log))==-1){ 
			perror("Error al escribir en el fichero");
			exit(EXIT_FAILURE);
		}
	
		// Cerramos Fichero	
		if(close(fd)==-1){ 
			perror("Error al cerrar el fichero");
			exit(EXIT_FAILURE);
		}

}
