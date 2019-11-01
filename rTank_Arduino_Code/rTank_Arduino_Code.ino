//Includes
#include <bluefruit.h>
#include <Stepper.h>
#include <Servo.h>

//Definitions
#define STEPS 2038

//Bluetooth instances
BLEService        hrms = BLEService(0x6666);
BLECharacteristic hrmc = BLECharacteristic(UUID16_CHR_HEART_RATE_MEASUREMENT);
BLECharacteristic bslc = BLECharacteristic(UUID16_CHR_BODY_SENSOR_LOCATION);
BLECharacteristic control = BLECharacteristic(0x0001); //0000 -> can't be used

//Bluetooth battery instances
BLEDis bledis;    // DIS (Device Information Service) helper class instance
BLEBas blebas;    // BAS (Battery Service) helper class instance

//Stepper instance for ir turret
Stepper turret(STEPS, 31, 11, 7, 15);
Servo myservo;
const int in_1 = 30 ;
const int in_2 = 27 ;
const int driveSpeedControlPin = A0;

// Advanced function prototypes
void startAdv(void);
void setupHRM(void);
void connect_callback(uint16_t conn_handle);
void disconnect_callback(uint16_t conn_handle, uint8_t reason);

bool canOutput = true;//Allows easy control of print statements for testing purposes
int pos = 0;

void setup() {
  Serial.begin(115200);
  while ( !Serial ) delay(10);   // for nrf52840 with native usb

  outputln("SmartBand Serial");
  outputln("-----------------------\n");

  // Initialise the Bluefruit module
  outputln("Initialise the Bluefruit nRF52 module");
  Bluefruit.begin();

  // Set the advertised device name (keep it short!)
  outputln("Setting Device Name to 'RTank'");
  Bluefruit.setName("RTank");

  // Set the connect/disconnect callback handlers
  Bluefruit.setConnectCallback(connect_callback);
  Bluefruit.setDisconnectCallback(disconnect_callback);

  // Configure and Start the Device Information Service
  outputln("Configuring the Device Information Service");
  bledis.setManufacturer("RTank");
  bledis.setModel("Universal 1");
  bledis.begin();

  // Start the BLE Battery Service and set it to 100%
  outputln("Configuring the Battery Service");
  blebas.begin();
  blebas.write(100);

  // Setup the Heart Rate Monitor service using
  // BLEService and BLECharacteristic classes
  outputln("Configuring the Heart Rate Monitor Service");
  setupHRM();

  // Setup the advertising packet(s)
  outputln("Setting up the advertising payload(s)");
  startAdv();
  myservo.attach(16);
  outputln("\nAdvertising");
  randomSeed(8);
  outputln("Ending setup");
}

void loop() {
  //  turret.setSpeed(0.01); // 1 rpm
  //  turret.step(2038); // do 2038 steps -- corresponds to one revolution in one minute
  //  delay(1000); // wait for one second
  //  turret.setSpeed(6); // 6 rpm
  //  turret.step(-2038);
  //

  if ( Bluefruit.connected() ) {
    outputln("CONNECTED");
    pos =  (int)random(0, 180);
    moveToPos(pos);
    driveMotor(true, 100);
    delay(10000);
  }
}
