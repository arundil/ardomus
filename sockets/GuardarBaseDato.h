#include <stdio.h>
#include <stdlib.h>
#include <mysql/mysql.h>

#define SERVER "127.0.0.1" 	// Servidor donde se encuentra la BD
#define USER "root"		// Usuario de la base de datos
#define PASSWORD ""		// Password de este usuario
#define DATABASE "ardomus"		// Base de datos a utilizar
#define PUERTO 3306		// Puerto para acceder a la BD


void guardarBD(char *insertar){


	MYSQL *conn;			// Conexion

	conn = mysql_init(NULL);

	// Abrimos Conexion con la BD			
	if (!mysql_real_connect(conn, SERVER, USER, PASSWORD, DATABASE, PUERTO, NULL, 0)) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}
			
	// Almacenamos datos entrada en la base de datos 
	if (mysql_query(conn, insertar)) {
		fprintf(stderr, "%s\n", mysql_error(conn));
		exit(1);
	}
		
	// Cerramos Conexion con la BD 
	mysql_close(conn);
}
