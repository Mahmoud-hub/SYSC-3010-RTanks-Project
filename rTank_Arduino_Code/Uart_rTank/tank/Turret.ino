void moveTurret(int x, int y) {
  output("Moving turret to:X:  ");    
  output(x);
  output("   Y:  ");
  outputln(y);
  if (x != 0 && y != 0) {
    int angle = atan(y / x);
    turret.write(angle);
  }else{
    turret.write(90);
  }
}
void zeroTurret(){
  turret.write(90);
}
