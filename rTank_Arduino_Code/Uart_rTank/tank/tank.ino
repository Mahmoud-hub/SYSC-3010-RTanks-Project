//Include Statements
#include <bluefruit.h>
#include <Stepper.h>
#include <Servo.h>
#include <math.h>


// BLE Service
BLEDis  bledis;  // device information
BLEUart bleuart; // uart over ble
BLEBas  blebas;  // battery

//Stepper instance for ir turret and steering
Servo turret;
Servo steeringServo;

const int STEPS_PER_REV = 200;
Stepper stepper_NEMA17(STEPS_PER_REV, 27, 30, 11, 7);


//USED PINS:
// 7, 11, 15, 16, 27, 30, 31, A0, A1,
const int motorHigh = 27 ;
const int motorGround = 15 ;
const int driveSpeedControlPin = 31;
bool canOutput = true;//Allows easy control of print statements for testing purposes
int recieverPin2 = A2;
int recieverPin1 = A1; //Pin to recieve ir data (if tank is hit)
int emitterPin = A0;
//Toggle which motor to control
bool forDrive = false;
bool forSteer = false;
bool forTurret = false;

//Toggle &control writing to the y & y values
bool setY = false;
bool setX = false;
int multiplier = 100;

//X & y values that are going to be used for the motor that is toggled high
int x_val = 0;
int y_val = 0;


void setup()
{
  //Allows print statments over serial
  Serial.begin(115200);

  //outputs so that the tester knows it is running
  outputln("BTank");
  output("---------------------------\n");

  //Set up BLE and pins
  startUpBLE();
  pinSetup();

  outputln("Ending setup");
}


void loop()
{
  checkForIr(); // Check if the tank has been hit
  shootLazer();
  while ( bleuart.available() ) { // While the tank is connected to a phone
   
    //Reads the data that is coming into the bluefruit
    uint8_t incomingData;
    incomingData = (uint8_t) bleuart.read();

    // Control flow for what to do with the data
    if (incomingData == 'e') { // if a  'e' is read, no more data to read.

      outputln("--------------");
      output("x_val:  ");
      output(x_val);
      output("     y_val:  ");
      outputln(y_val);

      runTank(); // calls the run tank function which calls the correct motor
      resetAll(); // Resets all the markers

    } else if (incomingData == 'd') { //Toggles the driving motor
      output("Driving");
      setAll(true, false, false);

    } else if (incomingData == 's') { //Toggles the steering motor
      setAll(false, true, false);
      output("Steering");

    } else if (incomingData == 't') { //Toggles the turret motor
      output("Turret");
      setAll(false, false, true);

    } else if (incomingData == 'l') { // runs the tests
      outputln("Testing");
      runTests();

    } else if (incomingData >= 48 && incomingData <= 57) { // changes the ascii number to standard number
      incomingData = incomingData - '0';
      set_X_Y(incomingData);

    } else if (incomingData == 'x') { //toggles the x setter that means the incoming digits are x values
      setX = true;
      setY = false;

    } else if (incomingData == 'y') { // toggles the y setter that means the incoming digits are y values
      setX = false;
      setY = true;

    } else if (incomingData == 'b') { //Toggles the steering motor
      setAll(true, true, true);
      outputln("BULLLLLLET");
    } else { //catch all that resets the markers
      resetAll();
      outputln("RESET");
    }
  }
  // Request CPU to enter low-power mode until an event/interrupt occurs
  waitForEvent();
}
