void moveTurret(int x, int y) {
  
  #include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 100
#define on 7
#define off 6
#define STEPS_PER_MOTOR_REVOLUTION 32
#define STEPS_PER_OUTPUT_REVOLUTION 32 * 64  //2048 

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper small_stepper(STEPS_PER_MOTOR_REVOLUTION, 8, 10, 9, 11);

// the previous reading from the analog input
int previous = 0;
int  Steps2Take;
int buttonState = 0;

void setup() {
  pinMode (on, INPUT);
  pinMode (off, INPUT);
  pinMode (2,OUTPUT);
  Serial.begin(9600);
  Serial.write("start");
}

void loop() {
  buttonState = digitalRead(on);
 
 Serial.print (buttonState, DEC);
  Serial.println();
  if (buttonState == HIGH) {
    Serial.write("test");
    Steps2Take  = STEPS_PER_OUTPUT_REVOLUTION;  // Rotate CCW 1 turn
    small_stepper.setSpeed(500);
    small_stepper.step(Steps2Take);
    
  }
  else{
    Steps2Take  =  - STEPS_PER_OUTPUT_REVOLUTION;  // Rotate CCW 1 turn
    small_stepper.setSpeed(500);
    small_stepper.step(Steps2Take);
  }

}


}
