/*
  0 0 BRAKE
  1 0 FORWARD
  0 1 BACKWARD
  1 1 BRAKE
*/

void driveMotor(int spd) {
  output("Drive:SPD:  ");
  output(spd);
  
  
  int pwm = map(spd, 0, 999, 0, 255);
  output("Drive:PWM:  ");
  output(pwm);
  digitalWrite( driveSpeedControlPin, pwm);


}

void runMotor(int distance, bool dir) {

  if (dir) {//Controls direction

    Serial.println("Motor Running forwards");
    lastDebounceTime = millis(); // For deboucing
    stepper_NEMA17.setSpeed(100);
    stepper_NEMA17.step(distance);

  } else if (!dir) {

    Serial.println("Motor Running forwardd)");
    lastDebounceTime = millis(); // For deboucing
    stepper_NEMA17.setSpeed(100);
    stepper_NEMA17.step(-distance);
  }
}
