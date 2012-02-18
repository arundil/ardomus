// incluimos las librerias necesarias


#include <stdio.h> // para utilizar librerias c
#include <XBee.h>  // para usar librerias xbee

//Xbee 
XBee xbee = XBee();

//identificador Mota y Zona
int mota=03;
int zona=02;

//Sensores
int sensorHum = 2; //humedad

//actuadores
int riego =8;

// valores de los sensores
float valorHum = -1.00;//humedad

// variables para poder imprimir los floats
int EnteroH=0;
int DecimalH=00;

char mensaje[100] = "";

//bucles
int k=0;

void setup(){
  xbee.begin(9600);
  //server.begin();
  delay(1000);
  Serial.begin(9600);  
  //Configuracion de los sensores
  pinMode(sensorHum,INPUT);
  delay(1000);
  pinMode(riego,OUTPUT); 
  delay(1000);
}

void loop(){
  
  Serial.println("Recogiendo Datos...");
  valorHum = analogRead(sensorHum)*0.00488/0.0482; // valor de la humedad, segun linealizacion y conversion, lo tenemos en %
  
  EnteroH=valorHum;
  DecimalH=(valorHum-EnteroH)*100;
  
  Serial.print("Humedad: ");
  Serial.print(EnteroH);
  Serial.print(",");
  Serial.print(DecimalH);
  Serial.println("");
  
  uint8_t datos[] = {zona, mota,NULL,NULL,EnteroH, DecimalH,NULL,NULL};
    
  Serial.println("Enviando...");
  
  k=0;
  while(k<3){
  
    // Preparamos el envio
    Tx16Request tx16 = Tx16Request(0x4, datos, sizeof(datos)); //modificar para cada nodo
    TxStatusResponse txStatus = TxStatusResponse();
    
    // enviamos
    xbee.send(tx16);

    Serial.println("");

    // esperamos si hay respuesta
    if (xbee.readPacket(1000)) {

      // Si ha llegado el paquete  	
      if (xbee.getResponse().getApiId() == TX_STATUS_RESPONSE) {

        xbee.getResponse().getZBTxStatusResponse(txStatus);
         
        // comprobamos si todo es correcto
        if (txStatus.getStatus() == SUCCESS) { 
          Serial.println("Enviado Correctamente...");  
          k=3;
        } else {  
          Serial.println("Error al enviar...Lo intentaremos otra vez");	
        }
      }      
    } else {
      Serial.println("Error no hay respuesta...Lo intentaremos otra vez");
    }
    Serial.println("");
    k++;
  }
  delay(500);
  
  xbee.getResponse().reset();
  
   Rx16Response rx16 = Rx16Response();      // Para preparar lo recibido
 
  
 Serial.println("Esperando recibir...");
  
 while(!xbee.getResponse().isAvailable()){
   if (!xbee.readPacket(1000))
     break;
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
   Serial.println ("MENSASJEE soy");
   Serial.println(mensaje[22]);
   if(mensaje[22]=='1'){
     digitalWrite(riego,HIGH);
   }
   if(mensaje[22]=='0'){
     digitalWrite(riego,LOW);
   }
 }
 xbee.getResponse().reset();
 delay(500);
}
