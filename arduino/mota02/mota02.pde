// incluimos las librerias necesarias


#include <stdio.h> // para utilizar librerias c
#include <XBee.h>  // para usar librerias xbee

//Xbee 
XBee xbee = XBee();

//identificador Mota y Zona
int mota=02;
int zona=01;

//actuadores
int actluz = 8;
int actAC = 11;

char mensaje[100] = "";

//bucles
int k=0;

void setup(){
  xbee.begin(9600);
  delay(1000);
  Serial.begin(9600);  
  //Configuracion de los sensores
  pinMode(actluz,OUTPUT);
  delay(1000);
  pinMode(actAC,OUTPUT);
  delay(1000);
}

void loop(){
  
  xbee.getResponse().reset();
  
   Rx16Response rx16 = Rx16Response();      // Para preparar lo recibido
  
 Serial.println("Esperando recibir...");
  
 while(!xbee.getResponse().isAvailable()){
   xbee.readPacket();
 }
  
 // Leemos lo recibido
 if(xbee.getResponse().isAvailable()){
    
   Serial.println("Recibiendo...");
   
   // Comprobamos que lo que hemos recibido es correcto 
   if (xbee.getResponse().getApiId() == RX_16_RESPONSE) {
	
     Serial.println("Recibido correctamente...");   
   
     // si lo es obtiene la informacion
     xbee.getResponse().getRx16Response(rx16);
     
      sprintf(mensaje, "LUZ%02d,AAC%02d,PER%02d,RIE%02d",rx16.getData(0),rx16.getData(1),rx16.getData(2),rx16.getData(3));
      Serial.println(mensaje);
   }
   if(mensaje[4]=='1'){
     digitalWrite(actluz,HIGH);
   }
   if(mensaje[4]=='0'){
     digitalWrite(actluz,LOW);
   }
   if (mensaje[10]=='1'){
     digitalWrite(actAC,HIGH);
   }
   if (mensaje[10] == '0'){
     digitalWrite (actAC,LOW);
   }
 }
 xbee.getResponse().reset();
 delay(1000);
}
