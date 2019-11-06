void moveTurret(int x, int y) {
  
  turret.setSpeed(0.01); // 1 rpm
  turret.step(2038); // do 2038 steps -- corresponds to one revolution in one minute
  delay(1000); // wait for one second
  turret.setSpeed(6); // 6 rpm
  turret.step(-2038);

}
