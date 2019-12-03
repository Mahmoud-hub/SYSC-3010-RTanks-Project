// Initlizes the Digital pins
void pinSetup() {
  pinMode(emitterPin, OUTPUT);
  pinMode(recieverPin1, INPUT);
  pinMode(recieverPin2, INPUT);
  turret.attach(15);
  steeringServo.attach(16);
}

//Control print statements
void output(String txt) {
  if (canOutput) {
    Serial.print(txt);
  }
}
void output(int txt) {
  if (canOutput) {
    Serial.print(txt);
  }
}
void outputln(String txt) {
  if (canOutput) {
    Serial.println(txt);
  }
}
void outputln(int txt) {
  if (canOutput) {
    Serial.println(txt);
  }
}

//Sets the x_val & y_val values. Which is edited is controlled by setX, setY variables.
//The count variable is used because the number come in seperately and therefore need a multiplier.
//It decreases bc the numbers come in from largest -> smallest. e.g. incoming x_val data = 192
//then the values come in as 1, 9, 2. count is then multipied to change the base.
// x_val = 1 * count@100 + 9 * count@10 + 2*count@1
//count is then reset for y
void set_X_Y(uint8_t incomingData) {
  if (incomingData >= 0 && incomingData <= 9 ) { //checks to see if the variable is between 0-9

    if (setX && !setY) { // checks to see if setX = 1 and setY = 0
      x_val = x_val + incomingData * multiplier; //adds new number * multiplier to x_val
      if (multiplier == 1) {
        multiplier = 100; // resets multiplier
      } else {
        multiplier = multiplier / 10; //reduces mutiplier
      }

    } else if (setY && !setX) { // checks to see if setY = 1 and setX = 0
      y_val = y_val + incomingData * multiplier ; //adds new number * multiplier to y_val
      if (multiplier == 1) {
        multiplier = 100; // resets multiplier
      } else {
        multiplier = multiplier / 10; //reduces mutiplier
      }
    }
  }
}
void magicPeaShooter() {
  digitalWrite(emitterPin, HIGH);
  delay(1);
  digitalWrite(emitterPin, LOW);
}

//Sets all motor controls
void setAll(bool drive, bool steer, bool turret) {
  forDrive = drive;
  forSteer = steer;
  forTurret = turret;
}

//resets toggles, x/y values and multiplier
void resetAll() {
  x_val = 0;
  y_val = 0;
  multiplier = 100;
  setX = false;
  setY = false;
  setAll(false, false, false);
}

//sends data to motor thats toggled
void runTank() {
  if (forDrive && forSteer && forTurret) {
    outputln("b for bullet");
    shootLazer();
  } else if (forDrive) {
    runMotor(x_val, y_val);
  } else if (forSteer) {
    moveToPos(x_val, y_val);
  } else if (forTurret) {
    moveTurret(x_val, y_val);
  }
}
