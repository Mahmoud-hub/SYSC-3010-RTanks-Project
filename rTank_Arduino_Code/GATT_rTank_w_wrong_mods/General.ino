void pinSetup() {
  pinMode(ledPin, OUTPUT);
  pinMode(outputPin, OUTPUT);
  digitalWrite(outputPin, HIGH);
  pinMode(A0, OUTPUT);
}
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

void set_X_Y(uint8_t ch) {

  if (setX) {

    if (ch >= 0 && ch <= 9 ) {

      x_val = x_val + ch * counter;
      if (counter == 1) {
        counter = 100;
      }else{
        counter = counter / 10;
      }
    }
  } else if (setY) {
    output("ChY: ");
    outputln(ch);
    if (ch >= 0 && ch <= 9 ) {
      output("Counter: ");
      outputln(counter);
      output("y_val: ");
      outputln(y_val + ch * counter);

      y_val = y_val + ch * counter ;
      
      if (counter == 1) {
        counter = 100;
      }else{
        counter = counter / 10;
      }
    }
  }
}

void setAll(bool drive, bool steer, bool turret) {
  forDrive = drive;
  forSteer = steer;
  forTurret = turret;
}
