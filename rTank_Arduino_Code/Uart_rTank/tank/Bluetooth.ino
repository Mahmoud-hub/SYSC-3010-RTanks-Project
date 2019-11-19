//Method that starts the BLE advertising
void startAdv(void)
{

  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE); // Advertising packet
  Bluefruit.Advertising.addTxPower();


  Bluefruit.Advertising.addService(bleuart); // Include bleuart 128-bit uuid
  Bluefruit.ScanResponse.addName(); //adds name


  Bluefruit.Advertising.restartOnDisconnect(true); //Enable auto advertising if disconnected
  Bluefruit.Advertising.setInterval(32, 244);    // sets the interval period and speed mode
  Bluefruit.Advertising.setFastTimeout(30);      // number of seconds in fast mode
  Bluefruit.Advertising.start(0);                // Don't stop advertising
}


//Callback for when the bluefruit connects
void connect_callback(uint16_t conn_handle)
{
  char central_name[32] = { 0 };
  Bluefruit.Gap.getPeerName(conn_handle, central_name, sizeof(central_name));

  output("Connected to ");
  outputln(central_name);
}

//Callback for when the bluefruit disconnects.
void disconnect_callback(uint16_t conn_handle, uint8_t reason)
{
  (void) conn_handle;
  (void) reason;

  outputln("");
  outputln("Disconnected");
}

//Initlizes the BLE device
void startUpBLE() {

  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX); // configures the ble device's bandwidth
  Bluefruit.begin(); // Inilizes the ble chip
  Bluefruit.setTxPower(4); // sets the transmission power
  Bluefruit.setName("Rtank"); //sets the name as RTank
  Bluefruit.setConnectCallback(connect_callback); //adds the connect callback
  Bluefruit.setDisconnectCallback(disconnect_callback); // adds the disconnect callback

  // Configure and Start Device Information Service
  bledis.setManufacturer("Adafruit Industries"); //Sets the manufacturing device creator
  bledis.setModel("Bluefruit Feather52"); // sets the device model
  bledis.begin(); //Inilizes BLE Device information
 
  bleuart.begin();  // Configure and Start BLE Uart Service
  
  startAdv(); // Set up and start advertising
}

//Sends the data to the phone
void sendData(uint8_t *value, int len) {
  bleuart.write( value, len );
}
