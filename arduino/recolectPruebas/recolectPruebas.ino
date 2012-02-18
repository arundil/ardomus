#include <stdio.h> // para utilizar librerias c
#include <SPI.h>
#include <Ethernet.h>

#include <XBee.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192,168,0,4);
byte ipserver[] = {192, 168, 0, 2};
EthernetServer server(3490);
char cabecera[]= "POST /comma-separated-value HTTP/1.0 Host: localhost\n";
EthernetClient client;

XBee xbee = XBee();

char mensaje[500]= "";   // para enviar mensajes
char recibido[100]= "";
char actuador[200]="";
char * enviar;

int tamanyo=0;
int k=0;

int conversion_Mota_Zona[3]= {0x1,0x2,0x3};


void setup (){
  Ethernet.begin(mac, ip);
  delay(1000);
  xbee.begin(9600);
  delay(1000);
  Serial.begin(9600);
  delay(1000);
  pinMode(8,OUTPUT);
}


void loop(){
  EthernetClient client= server.available();
  
  delay(100);
  int j=0;
  int i=0;
  delay(1);
  sprintf(actuador,"%s","");
  delay(1);
  sprintf(recibido,"%s","");
  char recvActuador[100]="";
  int n=0;
  
  Rx16Response rx16 = Rx16Response();
  
  Serial.println("Esperando recibir...");
  
  while(!xbee.getResponse().isAvailable()){
  if (!xbee.readPacket(5000))
    break;
}

if(xbee.getResponse().isAvailable()){
    
   Serial.println("Recibiendo...");
   
   // Comprobamos que lo que hemos recibido es correcto 
   if (xbee.getResponse().getApiId() == RX_16_RESPONSE) {
	
     Serial.println("Recibido correctamente...");   
   
     // si lo es obtiene la informacion
     xbee.getResponse().getRx16Response(rx16);
     

  k=0;
  while(j<3){
       
       if(client.connected()){ // Conectamos
     
          Serial.println("Enviamos:");
          //Serial.println(datos);
          sprintf(mensaje, "%s;ZON%02d;MOT%02d;TEE%02d;TED%02d;HUE%02d;HUD%02d;LUM%02d;MOV%02d;",cabecera,rx16.getData(0),rx16.getData(1),rx16.getData(2),rx16.getData(3),rx16.getData(4),rx16.getData(5),rx16.getData(6),rx16.getData(7));
         // sprintf(mensaje, "%s;ZON%02d;MOT%02d;TEE%02d;TED%02d;HUE%02d;HUD%02d",cabecera,1,1,1,1,1);
          Serial.println(mensaje);
          client.println(mensaje);
          // enviamos los datos
          Serial.println("Esperamos respuesta...");
                    
          delay(500);
    
          if(client.available()){
            i=0;
            while ((actuador[i++] = client.read()) != -1){
            }
          }
          
          i=0;
          while(actuador[i] != '\n'){
                recvActuador[i]= actuador[i]; 
                i++;
          }
          
          tamanyo=i;
           
          n=0;
          
          for (i=tamanyo+1; i<tamanyo+strlen("HTTP/1.0 200 OK")+1; i++){
              recibido[n]= actuador[i];
              n++;
          }
          
          Serial.println("Recibido desde servidor:");
          Serial.println(actuador);
          
          Serial.println("VARIABLE ACTUADOR:");
          Serial.println(recvActuador);
                
      
          Serial.println("Recibido:");
          Serial.println(recibido);
          client.stop();
          //Procesado de la informacion
          
          if (recvActuador[tamanyo-2] =='1'){
            digitalWrite(8,HIGH);         
          }
          if(recvActuador[tamanyo-2]== '0'){
            digitalWrite(8,LOW);
          }
          
          
          if(strcmp(recibido, "HTTP/1.0 200 OK")==0){
         
            j=3;
            Serial.println("Todo Correcto");
            client.stop();
      
          }else{ //no conecta
        
            Serial.println("Cabecera Incorrecta...Lo intentaremos");
            j++;
		    client.stop();  
          }
          
        }else{
        
          j++;
          client.stop(); // paramos la conexion
    
          if(client.connect()){ // Intentamos reconectar
    
            Serial.println("Conectado con exito"); // bien lo conseguimos
    
          }else{
    
            Serial.println("Error de conexion"); // no lo conseguimos
            
          }
          
          Serial.println("");
          
          delay(500);
  
         }
      }
    }
  }
   xbee.getResponse().reset();
   
   int zona;
   int mota;
   int movPersiana;
   int luz;
   int aireAcond;
   int riegoCes;
   char var[2];
   
   if(!strcmp(recvActuador,"NODATA")==0){
   
   var[0]=recvActuador[3];
   var[1]=recvActuador[4];
 
   zona=atoi(var);
   
   var[0]=recvActuador[9];
   var[1]=recvActuador[10];
   
   mota=atoi(var);
   
   var[0]=recvActuador[15];
   var[1]=recvActuador[16];
   
   luz=atoi(var);
   
   var[0]=recvActuador[21];
   var[1]=recvActuador[22];
   
   aireAcond=atoi(var);
   
   var[0]=recvActuador[27];
   var[1]=recvActuador[28];
   
   movPersiana=atoi(var);
   
   var[0]= recvActuador[33];
   var[1]= recvActuador[34];
   
   riegoCes= atoi(var);
   
   //enviamos los datos
     Serial.println("VARIABLES A ENVIAR");
     Serial.println(zona);
     Serial.println(mota);
     Serial.println(luz);
     Serial.println(aireAcond);
     Serial.println(movPersiana);
     Serial.println(riegoCes);
   
     uint8_t datos[] = {luz,aireAcond,movPersiana,riegoCes};
 
     Tx16Request tx16 = Tx16Request(conversion_Mota_Zona[mota-1], datos, sizeof(datos));
     TxStatusResponse txStatus = TxStatusResponse();
    
     k=0;
     while (k<3){
       
     xbee.send(tx16);
     Serial.println("");
     
     if (xbee.readPacket(5000)) {
        if (xbee.getResponse().getApiId() == TX_STATUS_RESPONSE) {
          xbee.getResponse().getZBTxStatusResponse(txStatus);
              if (txStatus.getStatus() == SUCCESS) { 
              Serial.println("Enviado Correctamente...");  
              k=3;
            } else { 
               if (k!=3){ 
              Serial.println("Error al enviar...Lo intentaremos otra vez");
              delay(1000);
                }
                else{
                Serial.println("PAQUETE PERDIDO");
               }	
            }
          }      
        } 
        else {
            if (k!=3){
            Serial.print("Error no hay respuesta...al enviar datos a mota,lo intentamos de nuevo");
            delay(1000);
            }
            else{
            Serial.println("PAQUETE PERDIDO");
            }
            
          //Serial.print(mota);
        }
        Serial.println("");
        k++;
     }
     xbee.getResponse().reset(); 
   }
   else{
   mota=99;
   zona=99;
   luz=99;
   aireAcond=99;
   riegoCes=99;
   movPersiana=99;
   }
   
   delay (100);
 }
