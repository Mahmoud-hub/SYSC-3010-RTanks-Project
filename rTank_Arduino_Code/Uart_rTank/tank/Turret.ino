void moveTurret(int x, int y) {

  int degress_per_step = STEPS_PER_OUTPUT_REVOLUTION / 360;
  int new_degrees = atan(y / x);
  int move_degrees = new_degrees - cur_degrees;
  cur_degrees = new_degrees;
  turret.setSpeed(500);
  turret.step(move_degrees);
}
