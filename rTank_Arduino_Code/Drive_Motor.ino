/*
  0 0 BRAKE
  1 0 FORWARD
  0 1 BACKWARD
  1 1 BRAKE
*/
void driveMotor(bool dir, int spd) {
  int pwm = map(spd, 0, 100, 0, 255);
  
  output("SPEED: ");
  output(pwm);
  
  if (dir) {
    Serial.println("");
    Serial.println(dir);
    digitalWrite(in_1, HIGH) ;
    digitalWrite(in_2, LOW) ;
    analogWrite(driveSpeedControlPin, pwm) ;
  } else {
    digitalWrite(in_1, LOW) ;
    digitalWrite(in_2, HIGH);
    analogWrite(driveSpeedControlPin, pwm) ;
  }
}
