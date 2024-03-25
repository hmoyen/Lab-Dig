const int joystick_x_pin = A0;
const int joystick_y_pin = A3;
const int digital_pin1 = 2; // Change these to your desired digital pin numbers
const int digital_pin2 = 3; // Change these to your desired digital pin numbers
const int digital_pin3 = 4; // Change these to your desired digital pin numbers
const int digital_pin4 = 5; // Change these to your desired digital pin numbers

void setup() {
  Serial.begin(115200);   /* Define baud rate for serial communication */
  pinMode(digital_pin1, OUTPUT);
  pinMode(digital_pin2, OUTPUT);
  pinMode(digital_pin4, OUTPUT);
  pinMode(digital_pin3, OUTPUT);
}

void loop() {
  int x_adc_val, y_adc_val; 
  float x_volt, y_volt;
  x_adc_val = analogRead(joystick_x_pin); 
  y_adc_val = analogRead(joystick_y_pin);
  x_volt = ( ( x_adc_val * 3.3 ) / 4095 );  /*Convert digital value to voltage */
  y_volt = ( ( y_adc_val * 3.3 ) / 4095 );  /*Convert digital value to voltage */
  
  // Converting x_volt to digital values
  if (x_volt > 0.45) {
    digitalWrite(digital_pin1, HIGH);
    digitalWrite(digital_pin2, LOW);
  } else if (x_volt > 0.3 && x_volt <= 0.44) {
    digitalWrite(digital_pin1, LOW);
    digitalWrite(digital_pin2, LOW);
  } else {
    digitalWrite(digital_pin1, LOW);
    digitalWrite(digital_pin2, HIGH);
  }
  
  // Converting y_volt to digital values
  // Adjust these conditions similarly for the y-axis
  // For example:

  if (y_volt > 0.45) {
    digitalWrite(digital_pin3, HIGH);
    digitalWrite(digital_pin4, LOW);
  } else if (y_volt > 0.3 && y_volt <= 0.44) {
    digitalWrite(digital_pin3, LOW);
    digitalWrite(digital_pin4, LOW);
  } else {
    digitalWrite(digital_pin3, LOW);
    digitalWrite(digital_pin4, HIGH);
  }
  
  Serial.print("X_Voltage = ");
  Serial.print(x_volt);
  Serial.print("\t");
  Serial.print("Y_Voltage = ");
  Serial.println(y_volt);
  
  delay(100);
}
