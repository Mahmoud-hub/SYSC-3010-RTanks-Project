void runTests() {
  //Running hardwear tests by moving the motors to either specific positions or in specifc directions in a controlled manner
  //First motor test is the driving motor. It is first stopped (in case it was running prior), then moves forwards from 1s @ 20% speed
  //then moves forwards for 1s @ 100%. This process is then done with direction as backwards.
  outputln("Testing Drive");
  driveMotor(0); //Stops the motor
  delay(200);
  driveMotor(200); // Moves the motor forward at 20%
  runMotor(500, true);
  delay(500);
  driveMotor(999); // Moves the motor forward at 100%
  runMotor(500, true);
  delay(500);
  driveMotor(0); //Stops the motor
  delay(200);
  driveMotor(200); //Move the motor backwards at 20%
  runMotor(500, false);
  delay(1000);
  driveMotor(999); //Move the motor backwards at 100%
  runMotor(500, false);
  delay(500);
  driveMotor(0); //Stops the motor
  delay(200);
  
  

  //Second motor test is steering. It moves the steering from 55 degrees - 125 degrees. 
  outputln("Testing Steering");
  moveToPos(200, 284);
  delay(1000);
  moveToPos(-200, -284);
  delay(1000);
  zeroSteer();
  delay(1000);

  //Third motor test is turret. It moves the turret from 0 degrees - 180 degrees. 
  outputln("Testing turret");
  moveTurret(200, 284);
  delay(1000);
  moveTurret(-200, -284);
  delay(1000);
  zeroTurret();
  delay(1000);

  runStub(); //Runs the stub test
}

//This stub test by sending a hit signal to the phone.
void runStub() {
  
  uint8_t buf[64];
  buf[0] = 234;
  int len = (buf, sizeof(buf));
  sendData(buf, len); //Sends a hit marker to the send function
  
}
