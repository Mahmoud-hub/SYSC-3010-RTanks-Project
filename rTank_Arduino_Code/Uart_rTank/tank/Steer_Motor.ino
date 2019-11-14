void moveToPos(int x, int y) {
  output("STEERING:X:  ");
  output(x);
  output("   Y:  ");
  outputln(y);
  if (x != 0 && y != 0) {
    int pos = 90;
    int angle = atan(y / x);
    if (angle < 55 || angle > 270) { //Top right
      pos = 55;
    } else if (angle > 125 && angle < 270) { //Bottom right
      pos = 125;
    } else {
      pos = angle;
    }

    myservo.write(pos);
  }
}
