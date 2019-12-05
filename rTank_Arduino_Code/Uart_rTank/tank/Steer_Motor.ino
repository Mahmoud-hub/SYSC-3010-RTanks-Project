void moveToPos(int x, int y) {
  //Function used to steer the tank
  //Tank steering is controlled with a servo motor
  
  //Parameters:
  //x -> horizontal position on joystick
  //y -> vertical position on joystick
  
  //Output to serial monitor to check parameters (testing)
  output("STEERING:X:  ");
  output(x);
  output("   Y:  ");
  outputln(y);
  
  //default position of servo motor
  int pos = 90;
  
  //angle variable
  double angle = 0;

  if (x != 0 && y != 0) {//checks if joystick is being moved
    
    angle = atan(((double)y) / ((double) x)) * 57.2958;//converts x/y coordinates to an angle
    
    //Output to serial monitor to check angle (testing)
    output("ANGLE: ");
    Serial.println(angle);
    
    //CAST rule adjustments to angle
    if (x < 0 && y > 0) { //2nd uadrent
      angle = angle + 180.0;
    } else if (x > 0 && y < 0) { //4th quadrent
      angle = angle * -1.0;
    } else if (x < 0 && y < 0) { //3rd quadrent
      angle = 180.0 - angle;
    }
  }
  //Output to serial monitor to check converted angle (testing)
  output("Converted:Angle:  ");
  Serial.println(angle);
  
  //turning radius = 45
  //max left = 90 - 45 = 55
  //max right = 90 + 45 = 125
  if (angle < 55) {
    pos = 55;
  } else if (angle > 125.0) {
    pos = 125;
  } else {
    pos = (int)angle;
  }
  
  //Output to serial monitor to check final written angle (testing)
  output("POSITION: ");
  outputln(pos);
  
  //write position to steering servo motor
  steeringServo.write(pos);
}

//centres the steering (straight)
void zeroSteer() {
  steeringServo.write(90);
}
