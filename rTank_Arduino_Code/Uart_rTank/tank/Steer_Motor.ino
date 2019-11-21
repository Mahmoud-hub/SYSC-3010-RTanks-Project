void moveToPos(int x, int y) {
  output("STEERING:X:  ");
  output(x);
  output("   Y:  ");
  outputln(y);
  int pos = 90;
  double angle = 0;
  //x = map(x, 0, 999, 0, 180);
  //y = map(y, 0, 999, 0, 180);

  if (x != 0 && y != 0) {
    
    angle = atan(((double)y) / ((double) x)) * 57.2958;
    output("ANGLE: ");
    Serial.println(angle);
    if (x < 0 && y > 0) { //2nd uadrent
      angle = angle + 180.0;
    } else if (x > 0 && y < 0) { //4th quadrent
      angle = angle * -1.0;
    } else if (x < 0 && y < 0) { //3rd quadrent
      angle = 180.0 - angle;
    }
  }
  output("Converted:Angle:  ");
  Serial.println(angle);
  if (angle < 55) { //Top right
    pos = 55;
  } else if (angle > 125.0) { //Bottom right
    pos = 125;
  } else {
    pos = (int)angle;
  }
  output("POSITION: ");
  outputln(pos);
  steeringServo.write(pos);
}
void zeroSteer() {
  steeringServo.write(90);
}
