
#include <bluefruit.h>
#include <Stepper.h>
#include <Servo.h>


//Definitions
#define STEPS 2038

// BLE Service
BLEDis  bledis;  // device information
BLEUart bleuart; // uart over ble
BLEBas  blebas;  // battery

//Stepper instance for ir turret
Stepper turret(STEPS, 31, 11, 7, 15);
Servo myservo;


//USED PINS:
// 7, 11, 15, 16, 27, 30, 31, A0, A1,
const int in_1 = 27 ;
const int in_2 = 30 ;
const int driveSpeedControlPin = A0;

bool canOutput = true;//Allows easy control of print statements for testing purposes
int pos = 0;
int recPin = A1;
int outputPin = 9;
int ledState = false;
int timeDelay = millis();
int ledPin = LED_BUILTIN;
bool runTank = false;

void setup()
{
  Serial.begin(115200);
  while ( !Serial ) delay(10);   // for nrf52840 with native usb

  Serial.println("UART_COM");
  Serial.println("---------------------------\n");

  // Setup the BLE LED to be enabled on CONNECT
  // Note: This is actually the default behaviour, but provided
  // here in case you want to control this LED manually via PIN 19
  Bluefruit.autoConnLed(true);

  // Config the peripheral connection with maximum bandwidth
  // more SRAM required by SoftDevice
  // Note: All config***() function must be called before begin()
  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  Bluefruit.begin();
  // Set max power. Accepted values are: -40, -30, -20, -16, -12, -8, -4, 0, 4
  Bluefruit.setTxPower(4);
  Bluefruit.setName("Bluefruit52");
  //Bluefruit.setName(getMcuUniqueID()); // useful testing with multiple central connections
  Bluefruit.setConnectCallback(connect_callback);
  Bluefruit.setDisconnectCallback(disconnect_callback);

  // Configure and Start Device Information Service
  bledis.setManufacturer("Adafruit Industries");
  bledis.setModel("Bluefruit Feather52");
  bledis.begin();

  // Configure and Start BLE Uart Service
  bleuart.begin();

  // Start BLE Battery Service
  blebas.begin();
  blebas.write(100);

  // Set up and start advertising
  startAdv();

  myservo.attach(16);
  randomSeed(8);
  pinSetup();

  outputln("Ending setup");
}



void loop()
{
  // Forward data from HW Serial to BLEUART
  //  while (Serial.available())
  //  {
  //    // Delay to wait for enough input, since we have a limited transmission buffer
  //    delay(2);
  //
  //    uint8_t buf[64];
  //    int count = Serial.readBytes(buf, sizeof(buf));
  //    bleuart.write( buf, count );
  //  }

  // Forward from BLEUART to HW Serial
  while ( bleuart.available() )
  {
    uint8_t ch;
    ch = (uint8_t) bleuart.read();
    if(ch == 10){
      runTank = true;
      Serial.println("");
    }

    if (ch >= 48 && ch <= 57) {
      ch = ch - '0';
      Serial.print(ch);
    }
    else {
      if (ch == 'x') {
        Serial.print("X");
      }
      if (ch == 'y') {
        Serial.print(" Y");
      }
    }
    
  }



  // Request CPU to enter low-power mode until an event/interrupt occurs
  waitForEvent();
}
