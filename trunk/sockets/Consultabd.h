#include <stdio.h>
#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#define SERVER "127.0.0.1" 	// Servidor donde se encuentra la BD
#define USER "root"		// Usuario de la base de datos
#define PASSWORD ""		// Password de este usuario
#define DATABASE "ardomus"		// Base de datos a utilizar
#define PUERTO 3306		// Puerto para acceder a la BD

#define TAMBUF 10

int  data[TAMBUF];

void consultarBD (){

	MYSQL *conn;
	MYSQL_RES *resultado = NULL;
	MYSQL_ROW row = NULL;
	conn = mysql_init(NULL);
	int i = 0;
	char * consulta = "SELECT * FROM ardomus_arduinos LIMIT 0,1";
	char consulta2[500] = "";
	
	for (i=0; i<TAMBUF-1; i++){
		data[i]=99;
		}
	i=0;

	
	// Abrimos Conexion con la BD
	if (!mysql_real_connect(conn, SERVER, USER, PASSWORD, DATABASE, PUERTO, NULL, 0)) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}

	// Almacenamos datos entrada en la base de datos
	
		if (mysql_query(conn, consulta)) {
			fprintf(stderr, "%s\n", mysql_error(conn));
			exit(1);
		}
		
	resultado = mysql_store_result(conn);
	if (resultado == NULL)
		exit(1);
	else{
		while ((row= mysql_fetch_row (resultado)) != NULL)
		{
			for (i=0;i < mysql_num_fields (resultado); i++)
			{
				if (i>0)
					fputc('\t',stdout);
				printf("%s",row[i] !=NULL ? row[i] :"NULL");
				if (row[i] != NULL){
				    
				    data[i] = atoi(row[i]);
				}	
			}
		fputc('\n',stdout);
		}
	
		if (mysql_errno (conn) !=0)
			exit(1);
		else
			printf("Numero de columnas devueltas: %lu\n", (unsigned long) mysql_num_rows (resultado));
		
		mysql_free_result(resultado);

		//borrar el primer elemento de la tabla
		
		sprintf(consulta2,"DELETE FROM ardomus_arduinos WHERE id=%d",data[0]);
		
		if (mysql_query (conn,consulta2)!=0){
			exit(1);
		}
		else{
		printf("Tabla Borrada con éxito\n");
		}
	}
	mysql_close(conn);

}
