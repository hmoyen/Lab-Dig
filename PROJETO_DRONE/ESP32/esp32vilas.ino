const int joystick_x_pin = A0; 
const int joystick_y_pin = A3;
const int joystick_D_pin = 22;
const int digital_pin1 = 23; // Change these to your desired digital pin numbers
const int digital_pin2 = 19; // Change these to your desired digital pin numbers
const int digital_pin3 = 4; // Change these to your desired digital pin numbers
const int digital_pin4 = 5; // Change these to your desired digital pin numbers
const int digital_pin5 = 6;


void setup() {
  Serial.begin(115200);   /* Define baud rate for serial communication */
  pinMode (joystick_D_pin, INPUT);
  pinMode(digital_pin1, OUTPUT);
   pinMode(digital_pin2, OUTPUT);
    pinMode(digital_pin3, OUTPUT);
     pinMode(digital_pin4, OUTPUT);
     
    
   
     
}

void loop() {
  int x_adc_val, y_adc_val, x_direita_out, x_esquerda_out, y_cima_out, y_baixo_out, botao; 
  float x_volt, y_volt;
  x_adc_val = analogRead(joystick_x_pin); 
  y_adc_val = analogRead(joystick_y_pin);
  x_volt = ( ( x_adc_val * 3.3 ) / 4095 );  /*Convert digital value to voltage */
  y_volt = ( ( y_adc_val * 3.3 ) / 4095 );  /*Convert digital value to voltage */
  Serial.print("X_Voltage = ");
  Serial.print(x_volt);
  Serial.print("\t");
  Serial.print("Y_Voltage = ");
  Serial.println(y_volt);

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
  
  // Converting y_volt to digital values
  // Adjust these conditions similarly for the y-axis
  // For example:

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
  Serial.print("y CIMA = ");
  Serial.print(y_cima_out);
  Serial.print("\t");
  Serial.print("y BAIXO = ");
  Serial.println(y_baixo_out);

  botao = digitalRead (joystick_D_pin);
  if (botao == 1){
  digitalWrite(digital_pin5, HIGH);
  } else{
    digitalWrite(digital_pin5, LOW); 
  }
  Serial.print("BOTAO = ");
  Serial.println(botao);

  
  delay(100);
  
}
