void runTests() {
  
  outputln("Testing Drive");
  driveMotor(0, 0);
  delay(200);
  driveMotor(200, 1);
  delay(1000);
  driveMotor(999, 1);
  delay(1000);
  driveMotor(0, 0);
  delay(200);
  driveMotor(200, 2);
  delay(1000);
  driveMotor(999, 2);
  delay(1000);
  driveMotor(0, 0);
  delay(200);
  
  outputln("Testing Steering");
  moveToPos(-1, 1);
  delay(1000);
  moveToPos(1, 1);
  delay(1000);
  zeroSteer();
  delay(1000);

  outputln("Testing turret");
  moveTurret(-1, 1);
  delay(1000);
  moveTurret(1, 1);
  delay(1000);
  zeroTurret();
  delay(1000);

  //runStub();
}

void runStub(){
  uint8_t buf[64];
  buf[0] = 234;
  int len = (buf, sizeof(buf));
  output("COUNT");
  outputln(len);
  hitDetected(buf, len);
}
