void moveTurret(int x, int y) {
  output("Moving turret to:X:  ");
  output(x);
  output("   Y:  ");
  outputln(y);
  
  double pos = 90.0;
  //x = map(x, 0, 999, 0, 180);
  //y = map(y, 0, 999, 0, 180);

  pos = ((double)x) / ((double) y) * 180.0;


//  if (x != 0 && y != 0) {
//    
//    //angle = atan(((double)y) / ((double) x)) * 57.2958;
//    output("ANGLE: ");
//    Serial.println(angle);
////    if (x < 0 && y > 0) { //2nd quadrent
////      angle = angle + 180.0;
////    } else if (x > 0 && y < 0) { //4th quadrent
////      angle = angle * -1.0;
////    } else if (x < 0 && y < 0) { //3rd quadrent
////      angle = 180.0 - angle;
////    }
//      //angle = angle + x;
//  }
  output("Position:  ");
  Serial.println(pos);
  //pos = 180 - angle;
  //output("POSITION: ");
  //outputln(pos);
  turret.write(pos);
}
void zeroTurret() {
  turret.write(90);
}
