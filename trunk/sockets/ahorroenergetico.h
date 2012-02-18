
#include <string.h>
#include <stdlib.h>
#include <stdio.h>		// Necesarias para trabajar con c
#include <mysql/mysql.h>	// Necesarias para trabajar con la bd 
#include <math.h> //libreria para funciones matemáticas
#include "GuardarBaseDato.h"

#define SERVER "127.0.0.1" 	// Servidor donde se encuentra la BD
#define USER "root"		// Usuario de la base de datos
#define PASSWORD ""		// Password de este usuario
#define DATABASE "ardomus"		// Base de datos a utilizar
#define PUERTO 3306		// Puerto para acceder a la BD

void ahorroenergetico (){
  
  MYSQL *conn;
  MYSQL_RES *resultado = NULL;
  MYSQL_ROW row = NULL;
  
  int activado = 0;
  
  float temperatura =0.0;
  float humedad =0.0;
  int luminosidad=0; 
  int mota[10];
  char zona[4]="";
  
  int motavalida=0;
  int luzvalida =0;
  int temperaturavalida=0;
  int humedadvalida=0;

  int zonaluzvalida =0;
  int zonatemperaturavalida=0;
  int zonahumedadvalida=0;
  
  
  int luzactiva=-1;
  int aireacondactivo=-1;
  int persianaactiva=-1;
  int riegoactivo = -1;
  
  int valorluzHI = -1;
  int valorluzLOW =-1;
  float valorhumHI = -1;
  float valorhumLOW =-1;
  float valortempHI = -1;
  float valortempLOW =-1;
  
  int bandera =0;
  int contador =0;
 
  conn = mysql_init(NULL);
  
  char * consulta1 = "SELECT * FROM ardomus_ahorroenergetico WHERE activado=1";
  char * consulta2 = "SELECT * FROM ardomus_mediciones ORDER BY id desc LIMIT 0,1"; 
  char  consulta3 [500] = ""; 
  char  consulta4 [500] = "";
  char  consulta5 [500] = "";
  char  consulta6 [500] = "";
  
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

  resultado = mysql_use_result(conn);

  // Guardamos los datos de la alarma en variables.	
  while ((row = mysql_fetch_row(resultado)) != NULL){
	activado=atoi(row[1]);
	valorluzHI=atoi(row[3]);
	valorluzLOW=atoi(row[4]);
	valortempHI=atof(row[5]);
	valortempLOW=atof(row[6]);
	valorhumHI=atof(row[7]);
	valorhumLOW=atof(row[8]);
  }	
  
  mysql_free_result(resultado);
	
  if ( activado == 1){
  printf("Modo ahorro enerético activado\n\n");
  row = NULL; char mota[4]="";
  resultado =NULL;
  //aqui va el ahorro energético
  if (mysql_query(conn, consulta2)) {	
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
  }
  
  resultado = mysql_use_result(conn);
  
  while ((row = mysql_fetch_row(resultado)) != NULL){
     //printf("Hola %s\n",row[1]);
	strcpy(zona,row[1]);
	humedad=atof(row[3]);
	temperatura = atof(row[4]);
	luminosidad = atoi(row[5]);
	luminosidad = abs(luminosidad - 100);
  }
  mysql_free_result(resultado);
  printf("Obteniendo Mediciones...\n\n");
  //Consutar si los sensores estan activos
  
  
  sprintf(consulta6, "SELECT id FROM ardomus_motas WHERE zona_id = %s",zona);
  row= NULL;
  resultado=NULL;
  
  printf("Comprobando motas en Zona %s\n\n",zona);
  
  if (mysql_query(conn, consulta6)) {	
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
  }
  
  resultado = mysql_use_result(conn);
  
  contador =-1;
  
  while ((row = mysql_fetch_row(resultado)) != NULL){
	if(contador <10){
	  contador++;
	  mota[contador]= atoi(row[0]);
	}else
	printf("Solo puede haber un máximo de 10 motas por zona\n");
  }
  
  
  mysql_free_result(resultado);

   sprintf(consulta3,"SELECT * FROM ardomus_sensoresactivos WHERE zona_id = %s", zona);
   
  if (mysql_query(conn, consulta3)) {
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
  }
  
  resultado = mysql_use_result(conn);
  
  while ((row = mysql_fetch_row(resultado)) != NULL){
	motavalida= atoi(row[3]);

	zonaluzvalida= atoi (row[4]);
	if (zonaluzvalida == 1){
		luzvalida= 1;
	}
	zonatemperaturavalida= atoi (row[5]);
	if (zonatemperaturavalida == 1){
		temperaturavalida= 1;
	}
	zonahumedadvalida=atof(row[6]);
	if (zonahumedadvalida == 1){
		humedadvalida= 1;
	}
  }
  
   while(contador >= 0){ //Aqui comienza un rastreo de motas activas 
   printf("Contador: %d, id mota:%d \n", contador, mota[contador]);
   row = NULL;
   resultado=NULL;
   
  
  
  mysql_free_result(resultado);
   
  printf("Analizando sensores mota %d\n\n",mota[contador]);
  
  sprintf(consulta4, "SELECT * FROM ardomus_arduinoactuales WHERE zona_id = %s AND mota_id= %d",zona,mota[contador]);
      
  row = NULL;
  resultado=NULL;
   
  if (mysql_query(conn, consulta4)) {	
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
  }
  
  resultado = mysql_use_result(conn);
  
  while ((row = mysql_fetch_row(resultado)) != NULL){
	luzactiva= atoi(row[3]);
	aireacondactivo= atoi(row[4]);
	persianaactiva=atoi(row[5]);
	riegoactivo=atoi(row[6]);
  }
  
  
  mysql_free_result(resultado);
  
  // Cerramos Conexion con la BD 
  
  //dentro de cada insert tengo que saber en que zona y en que mota esta el actuador a activar. es de cier que etengo que hacer un select previo para ver donde esta el actuador
  //Claro... para ello tengo que ver despues si esta activo. Una vez que este activo, es cuando podré realizar el insert de el ahorro energético.
  bandera =0;
  
  if(motavalida ==1){
   
    if (luzvalida==1){
      if (luminosidad > valorluzHI && persianaactiva == 1){ //si la luminosidad es mayor que 50 y la persiana no esta abajo
	//me bajas la persiana 
	persianaactiva = 0;
	printf("Se ha bajado la PERSIANA en la Mota %d: Valor %d\n",persianaactiva, mota[contador]);
	bandera=1;
      }
     if (luminosidad < valorluzLOW && persianaactiva == 0){ //si la luminosidad es menos que 20 y la persina no esta arriba
      //me subes la persiana
	
	persianaactiva = 1;
	printf("Se ha subido la PERSIANA en la Mota %d: Valor %d\n",persianaactiva,mota[contador]);
	bandera =1;
      }
      
    }
    if(humedadvalida ==1){
      
    	if (humedad< valorhumLOW && riegoactivo == 0){
      // me activas el riego 
	riegoactivo = 1;
	printf("Se ha activado el RIEGO en la Mota %d: Valor %d \n",mota[contador],riegoactivo);
	bandera =1;
      }
      if (humedad >valorhumHI && riegoactivo == 1){
      //me cortas el riego
	riegoactivo=0;
	printf("Se ha desactivado el RIEGO en la Mota %d: Valor %d\n",mota[contador],riegoactivo);
	bandera=1;
      }
      
    }
    if (temperaturavalida == 1){
      if (temperatura > valortempHI && aireacondactivo == 0){
	  //activas ac
	aireacondactivo=1;
	printf("Se ha activado el AIRE ACONDICIONADO en la Mota %d: Valor %d\n",mota[contador],aireacondactivo);
	bandera=1;
      }
      if (temperatura < valortempLOW && aireacondactivo == 1){
	//apagas ac
	aireacondactivo = 0;
	printf("Se ha desactivado el AIRE ACONDICIONADO en la Mota %d: Valor %d\n",mota[contador],aireacondactivo);
	bandera=1;
      }
      
    }
    
    sprintf(consulta5,"INSERT INTO ardomus_arduinos (zona_id, mota_id, luz, ac, persianas, riego) VALUES ('%s','%d','%d','%d','%d','%d');", zona, mota[contador],luzactiva,aireacondactivo,persianaactiva,riegoactivo);
    sprintf(consulta6,"UPDATE ardomus_arduinoactuales SET luz = %d, ac= %d, persianas= %d, riego= %d  WHERE zona_id='%s' AND mota_id='%d';",luzactiva, aireacondactivo, persianaactiva,riegoactivo, zona,mota[contador]); 
    
      
  }
  
    if (bandera==1){
      guardarBD(consulta5);
      guardarBD(consulta6);
    }else{
    
      printf("El ahorro energético no ha modificado NINGUN actuador en la mota %d\n\n", mota[contador]);
    }
    contador --;
    
   } //cierre while
  } //cierre if
  
  mysql_close(conn);
}
