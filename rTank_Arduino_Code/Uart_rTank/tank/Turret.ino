void moveTurret(int x, int y) {
  //x -> value (0 -> 999)
  //y -> 999
  
  //Output to serial monitor to confirm values (testing)
  output("Moving turret to:X:  ");
  output(x);
  output("   Y:  ");
  outputln(y);
  
  //default value
  double pos = 90.0;

  //Convert x and y into an angle from 0 -> 180
  pos = ((double)x) / ((double) y) * 180.0;

  //Output to serial monitor to confirm position (testing)
  output("Position:  ");
  Serial.println(pos);
  
  //Write position to turret servo motor
  turret.write(pos);
}

//Centre the turret
void zeroTurret() {
  turret.write(90);
}
