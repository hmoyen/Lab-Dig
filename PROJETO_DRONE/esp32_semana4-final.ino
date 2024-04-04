#include <WiFi.h>
#include <PubSubClient.h>

#define REFRESH_RATE 10

int numap, no_numap;

const char* ssid = "LAB_DIGITAL"; //Seu SSID da Rede WIFI
const char* password = "C1-17*2018@labdig"; // A Senha da Rede WIFI
const char* mqtt_server = "192.168.17.191 ";
// const char* ssid = "FBMSP42G"; //Seu SSID da Rede WIFI
// const char* password = "cruzeirotri2014"; // A Senha da Rede WIFI
// const char* mqtt_server = "192.168.0.2 ";
// const char* ssid = "SkyMobile"; //Seu SSID da Rede WIFI
// const char* password = "voadronezinho"; // A Senha da Rede WIFI
// const char* mqtt_server = "172.20.10.2 ";
const int joystick_x_pin = A0; 
const int joystick_y_pin = A3;
const int joystick_D_pin = A6;
const int digital_pin1 = 19; // direita
const int digital_pin2 = 13; // esquerda
const int digital_pin3 = 4; // cima
const int digital_pin4 = 5; // baixo
const int digital_pin5 = 16; //botao
const int digital_pin6 = 17; //collision out
const int digital_pin7 = 18; // move foward out
const int digital_pin8 = 23; // move back out
const int digital_pin9 = 21; // move left
const int digital_pin10 = 22; // move right
//const int digital_pin11 = 39; //
const int digital_pin12 = 25;
const int digital_pin13 = 26;
const int digital_pin14 = 12;
//const int digital_pin15 = 19; // WORLD1
const int digital_pin16 = 33; // end in
const int digital_pin17 = 32; // reset in
const int digital_pin18 = 27; // init in
 //const int digital_pin19 = 35; // world in






WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE  (50)
char msg[MSG_BUFFER_SIZE];
char msg1[MSG_BUFFER_SIZE];
char msg2[MSG_BUFFER_SIZE];
char msg3[MSG_BUFFER_SIZE];
char msg4[MSG_BUFFER_SIZE];
char msg5[MSG_BUFFER_SIZE];
char msg6[MSG_BUFFER_SIZE];
char msg7[MSG_BUFFER_SIZE];
char msg8[MSG_BUFFER_SIZE];
char msg9[MSG_BUFFER_SIZE];
char msg10[MSG_BUFFER_SIZE];
char msg11[MSG_BUFFER_SIZE];
char msgB[MSG_BUFFER_SIZE];
char msgC[MSG_BUFFER_SIZE];
int value = 0;



void callback(char* topic, byte* payload, unsigned int length) { 
  //  Serial.print("Message arrived [");
  //  Serial.print(topic);
  //  Serial.print("] ");
  for (int i = 0; i < length; i++) {
     //Serial.print((char)payload[i]);
  }
   //Serial.println();


  if(strcmp(topic, "/drone_collision") == 0){
    if ((char)payload[0] == '1') {
    digitalWrite(digital_pin6, HIGH);
     //Serial.println("Colisão detectada!");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin6, LOW);
    digitalWrite(2, LOW);
    
  }

  }

  else if(strcmp(topic, "/move/forward") == 0){
  if ((char)payload[0] == '1') {
    digitalWrite(digital_pin7, HIGH);
     //Serial.println("move foward");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin7, LOW);
    digitalWrite(2, LOW);
    
  }

  }

  else if(strcmp(topic, "/move/backward") == 0){
  if ((char)payload[0] == '1') {
    digitalWrite(digital_pin8, HIGH);
     //Serial.println("move back");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin8, LOW);
    digitalWrite(2, LOW);
    
  }

  }

  else if(strcmp(topic, "/move/left") == 0){
  if ((char)payload[0] == '1') {
    digitalWrite(digital_pin9, HIGH);
     Serial.println("move left");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin9, LOW);
    digitalWrite(2, LOW);
    
  }

  }

  else if(strcmp(topic, "/move/right") == 0){
  if ((char)payload[0] == '1') {
    digitalWrite(digital_pin10, HIGH);
     //Serial.println("move right");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin10, LOW);
    digitalWrite(2, LOW);
    
  }

  }

  
  
}


void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}



void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      client.publish("outTopic", "hello world");
      client.subscribe("/drone_collision");
      client.subscribe("/move/forward");
      client.subscribe("/move/backward");
      client.subscribe("/move/left");
      client.subscribe("/move/right");
      
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);   /* Define baud rate for serial communication */
  pinMode(2, OUTPUT); // Initialize the LED pin as an output (built-in LED pin on ESP32)
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  pinMode(digital_pin1, OUTPUT);
  pinMode(digital_pin2, OUTPUT);
  pinMode(digital_pin3, OUTPUT);
  pinMode(digital_pin4, OUTPUT);
  pinMode(digital_pin5, OUTPUT);
  pinMode(digital_pin6, OUTPUT);
  pinMode(digital_pin7, OUTPUT);
  pinMode(digital_pin8, OUTPUT);
  pinMode(digital_pin9, OUTPUT);
  pinMode(digital_pin10, OUTPUT);
//  pinMode(digital_pin11, INPUT);
  pinMode(digital_pin12, INPUT);
  pinMode(digital_pin13, OUTPUT);
  pinMode(digital_pin14, INPUT);
  //pinMode(digital_pin15, INPUT);
  pinMode(digital_pin16, INPUT);
  pinMode(digital_pin17, INPUT);
  pinMode(digital_pin18, INPUT);
  //pinMode(digital_pin19, INPUT);
  

     
    
   
     
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  int x_adc_val, y_adc_val, x_direita_out, x_esquerda_out, y_cima_out, y_baixo_out, botao, apertado; 
  int world, init, end, reset, world0, world1, vitoria;
  float x_volt, y_volt, D_volt;
  x_adc_val = analogRead(joystick_x_pin); 
  y_adc_val = analogRead(joystick_y_pin);
  botao = analogRead(joystick_D_pin);
  x_volt = ( ( x_adc_val * 3.3 ) / 4095 );  /*Convert digital value to voltage */
  y_volt = ( ( y_adc_val * 3.3 ) / 4095 );
  D_volt = ( ( botao * 3.3 ) / 4095 );
  Serial.print("X_Voltage = ");
  Serial.print(x_volt);
  Serial.print("\t");
  Serial.print("Y_Voltage = ");
   Serial.print(y_volt);
   Serial.print("\t");
   Serial.print("D_Voltage = ");
   Serial.println(D_volt);
//


  apertado = digitalRead (digital_pin5);
   Serial.println( numap);
  if(D_volt == 0){
    numap = numap + 1;
    // Serial.println( numap);
    if (numap > 6){
    digitalWrite(digital_pin5, HIGH);
    no_numap = 0;
    }
   } else 
   {
     no_numap = no_numap + 1;

    if (no_numap > 6) {
      digitalWrite(digital_pin5, LOW);

      numap = 0; 
    }
   }

   apertado = digitalRead (digital_pin5);
   Serial.print("D = ");
   Serial.println(apertado);
   snprintf (msgB, MSG_BUFFER_SIZE, "%ld", apertado);
   client.publish("/broker/confirma",msgB);
   


  if (y_volt > 1.0 && y_volt <= 2.0){ 
   // Converting x_volt to digital values
  if (x_volt > 2.0) {
    digitalWrite(digital_pin1, HIGH);
    digitalWrite(digital_pin2, LOW);
  } else if (x_volt > 1.0 && x_volt <= 2.0) {
    digitalWrite(digital_pin1, LOW);
    digitalWrite(digital_pin2, LOW);
  } else {
    digitalWrite(digital_pin1, LOW);
    digitalWrite(digital_pin2, HIGH);
  }
  x_direita_out = digitalRead (digital_pin1);
  x_esquerda_out = digitalRead (digital_pin2);
  // Serial.print("X DIREITA = ");
  // Serial.print(x_direita_out);
  // Serial.print("\t");
  // Serial.print("x ESQUERDA = ");
  // Serial.println(x_esquerda_out);
  if (x_direita_out == 1){
  snprintf (msg1, MSG_BUFFER_SIZE, "%ld", x_direita_out);
  client.publish("/broker/set_vel_x",msg1);}
  else {
  x_esquerda_out = -1 * x_esquerda_out;
  snprintf (msg2, MSG_BUFFER_SIZE, "%ld", x_esquerda_out );
  client.publish("/broker/set_vel_x",msg2);}
  }
  else {
  snprintf (msg5, MSG_BUFFER_SIZE, "0");
  client.publish("/broker/set_vel_x",msg5);
  }

  if (y_volt < 1.0) {
    digitalWrite(digital_pin3, HIGH);
    digitalWrite(digital_pin4, LOW);
  } else if (y_volt > 1.0 && y_volt <= 2.0) {
    digitalWrite(digital_pin3, LOW);
    digitalWrite(digital_pin4, LOW);
  } else {
    digitalWrite(digital_pin3, LOW);
    digitalWrite(digital_pin4, HIGH);
  }
  y_cima_out = digitalRead(digital_pin3); 
   y_baixo_out = digitalRead (digital_pin4);
  // Serial.print(y_cima_out);
  if (y_cima_out == 1){
  snprintf (msg3, MSG_BUFFER_SIZE, "%ld", y_cima_out);
  client.publish("/broker/set_vel_y",msg3);}
  else {
  y_baixo_out = -1 * y_baixo_out;
  snprintf (msg4, MSG_BUFFER_SIZE, "%ld", y_baixo_out);
  client.publish("/broker/set_vel_y",msg4);}
  // Serial.print("y CIMA = ");
  // Serial.print(y_cima_out);
  // Serial.print("\t");
  // Serial.print("y BAIXO = ");
  // Serial.println(y_baixo_out);


  // world0 = digitalRead(digital_pin19);
  // world1 = digitalRead(digital_pin15);

  // if(world1 == 1){
  //   world = world1;
  // snprintf (msg6, MSG_BUFFER_SIZE, "%ld", world);
  // client.publish("/broker/world", msg6);
  // world = digitalRead(digital_pin19);
  // if (world == 1) {
  //   snprintf (msg6, MSG_BUFFER_SIZE, "%ld", world);
  //   client.publish("/broker/world", msg6);
  // }
  // }
  // else if(world0==1){
  // world = world0;
  // snprintf (msg6, MSG_BUFFER_SIZE, "%ld", world);
  // client.publish("/broker/world", msg6);
  // world = digitalRead(digital_pin19);
  // if (world == 1) {
  //   snprintf (msg6, MSG_BUFFER_SIZE, "%ld", world);
  //   client.publish("/broker/world", msg6);
  // } 
  // }


  init = digitalRead(digital_pin18);
  snprintf (msg7, MSG_BUFFER_SIZE, "%ld", init);
  client.publish("/broker/init", msg7);

  reset = digitalRead(digital_pin17);
  snprintf (msg8, MSG_BUFFER_SIZE, "%ld", reset);
  client.publish("/broker/reset", msg8);

  end = digitalRead(digital_pin16);
  if (end == 1) {
  snprintf (msg9, MSG_BUFFER_SIZE, "%ld", end);
  client.publish("/broker/end", msg9);
  }

 vitoria = digitalRead(digital_pin14);
  if (vitoria == 1) {
  snprintf (msgC, MSG_BUFFER_SIZE, "%ld", vitoria);
  client.publish("/broker/vitoria", msgC);
  }




 


  
  delay(0.1);
  
  
}
