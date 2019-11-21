void moveTurret(int x, int y) {
  output("Moving turret to:X:  ");
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
    if (x < 0 && y > 0) { //2nd quadrent
      angle = angle + 180.0;
    } else if (x > 0 && y < 0) { //4th quadrent
      angle = angle * -1.0;
    } else if (x < 0 && y < 0) { //3rd quadrent
      angle = 180.0 - angle;
    }
  }
  output("Converted:Angle:  ");
  Serial.println(angle);
  pos = angle;
  output("POSITION: ");
  outputln(pos);
  turret.write(pos);
}
void zeroTurret() {
  turret.write(90);
}
