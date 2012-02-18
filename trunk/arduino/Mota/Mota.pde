// incluimos las librerias necesarias


#include <stdio.h> // para utilizar librerias c
#include <XBee.h>  // para usar librerias xbee

//Xbee 
XBee xbee = XBee();

//identificador Mota y Zona
int mota=02;
int zona=01;

//Sensores
int sensorTem = 4; //temperatura
int sensorLum = 3; //luminosidad
int sensorMov = 7; //movimiento
int sensorHum = 2; //humedad

// valores de los sensores
int valorLum = -1;         //luminosidad
float valorTem = -100.00;  //temperatura
int valorMov = -1;         //movimiento
float valorHum = -1.00;    //humedad

// variables para poder imprimir los floats
int EnteroT=0;
int DecimalT=00;
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
  pinMode(sensorMov,INPUT);
  delay(1000);
  pinMode(sensorLum,INPUT);
  delay(1000);
  pinMode(sensorTem,INPUT);
  delay(1000); 
  pinMode(sensorHum,INPUT);
  delay(1000);
  pinMode(13,OUTPUT); 
  delay(1000);
  pinMode(8,OUTPUT);
  
  delay(1000);
}

void loop(){
  
  Serial.println("Recogiendo Datos...");
  valorLum = analogRead(sensorLum)*0.0976;         // valor de la luminosidad lo pasamos en %
  valorTem = analogRead(sensorTem)*4.8875/10;      // valor de la temperatura, segun linealizacion y conversion, lo tenemos en ºF
  valorTem = (valorTem-32)/1.8;                    // pasamos el valor de la temperatura a ºC
  valorHum = analogRead(sensorHum)*0.00488/0.0482; // valor de la humedad, segun linealizacion y conversion, lo tenemos en %
  valorMov = digitalRead(sensorMov);
  
  EnteroT=valorTem;
  DecimalT=(valorTem-EnteroT)*100;
  EnteroH=valorHum;
  DecimalH=(valorHum-EnteroH)*100;
  
  Serial.println("Luminosidad: ");
  Serial.print(valorLum);
  Serial.println(", Temperatura: ");
  Serial.print(EnteroT);
  Serial.print(",");
  Serial.print(DecimalT);
  Serial.println(", Humedad: ");
  Serial.print(EnteroH);
  Serial.print(",");
  Serial.print(DecimalH);
  Serial.println(",Movimiento: ");
  Serial.print(valorMov);
  Serial.println("");
  
  uint8_t datos[] = {zona, mota ,EnteroT, DecimalT, EnteroH, DecimalH, valorLum,valorMov};
    
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
    if (xbee.readPacket(5000)) {

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
  delay(1000);
  
  xbee.getResponse().reset();
  
   Rx16Response rx16 = Rx16Response();      // Para preparar lo recibido
 
  
 Serial.println("Esperando recibir...");
  
 while(!xbee.getResponse().isAvailable()){
   if (!xbee.readPacket(5000))
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
     
      sprintf(mensaje, "LUZ%02d,ACC%02d,PER%02d,RIE%02d",rx16.getData(0),rx16.getData(1),rx16.getData(2),rx16.getData(3),rx16.getData(4));
      Serial.println(mensaje);
   }
   if(mensaje[4]=='1'){
     digitalWrite(8,HIGH);
   }
   if(mensaje[4]=='0'){
     digitalWrite(8,LOW);
   }
 }
 xbee.getResponse().reset();
 delay(2000);
}
