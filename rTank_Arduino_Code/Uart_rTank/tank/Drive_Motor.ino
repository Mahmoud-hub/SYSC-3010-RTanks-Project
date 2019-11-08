/*
  0 0 BRAKE
  1 0 FORWARD
  0 1 BACKWARD
  1 1 BRAKE
*/

void driveMotor(int dir, int spd) {
  int pwm = map(spd, 0, 999, 0, 255);

  output("SPEED: ");
  output(pwm);

  if (dir == 1) {
    Serial.println("");
    Serial.println(dir);
    digitalWrite(in_1, HIGH) ;
    digitalWrite(in_2, LOW) ;
  } else if (dir == 2) {
    digitalWrite(in_1, LOW) ;
    digitalWrite(in_2, HIGH);
  }
  if (dir == 0) {
    outputln("STOPPED");
    analogWrite(driveSpeedControlPin, 0) ;
  } else {
    analogWrite(driveSpeedControlPin, pwm) ;
  }


}
