#include <WiFi.h>
#include <PubSubClient.h>

#define REFRESH_RATE 10

int numap;

const char* ssid = "LAB_DIGITAL"; //Seu SSID da Rede WIFI
const char* password = "C1-17*2018@labdig"; // A Senha da Rede WIFI
const char* mqtt_server = "192.168.17.191 ";
const int joystick_x_pin = A0; 
const int joystick_y_pin = A3;
const int joystick_D_pin = A6;
const int digital_pin1 = 23; // Change these to your desired digital pin numbers
const int digital_pin2 = 19; // Change these to your desired digital pin numbers
const int digital_pin3 = 4; // Change these to your desired digital pin numbers
const int digital_pin4 = 5; // Change these to your desired digital pin numbers
const int digital_pin5 = 16;
const int digital_pin6 = 17;


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
int value = 0;



void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  if ((char)payload[0] == '1') {
    digitalWrite(digital_pin6, HIGH);
     Serial.println("Colisão detectada!");
     digitalWrite(2, HIGH);
     
  } else {
    digitalWrite(digital_pin6, LOW);
    digitalWrite(2, LOW);
    
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
  

     
    
   
     
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  int x_adc_val, y_adc_val, x_direita_out, x_esquerda_out, y_cima_out, y_baixo_out, botao, apertado; 
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



  apertado = digitalRead (digital_pin5);
  Serial.println( numap);
  if(D_volt == 0){
    numap = numap + 1;
    Serial.println( numap);
    if (numap > 3){
    digitalWrite(digital_pin5, HIGH);
    }
   } else 
   {
   digitalWrite(digital_pin5, LOW);
   numap = 0; 
   }

   apertado = digitalRead (digital_pin5);
   Serial.print("D = ");
   Serial.println(apertado);
   


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
  Serial.print("X DIREITA = ");
  Serial.print(x_direita_out);
  Serial.print("\t");
  Serial.print("x ESQUERDA = ");
  Serial.println(x_esquerda_out);
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
   Serial.print(y_cima_out);
  if (y_cima_out == 1){
  snprintf (msg3, MSG_BUFFER_SIZE, "%ld", y_cima_out);
  client.publish("/broker/set_vel_y",msg3);}
  else {
  y_baixo_out = -1 * y_baixo_out;
  snprintf (msg4, MSG_BUFFER_SIZE, "%ld", y_baixo_out);
  client.publish("/broker/set_vel_y",msg4);}
  Serial.print("y CIMA = ");
  Serial.print(y_cima_out);
  Serial.print("\t");
  Serial.print("y BAIXO = ");
  Serial.println(y_baixo_out);




 


  
  delay(100);
  
  
}
