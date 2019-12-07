//Importing any libraries or utilities that will be needed
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:firebase_database/firebase_database.dart';

//
bool stubTest = true;
//Name of the device that it is trying to connect to
String name = "";
int turretX = 9;
int turretY = 91;
int steerX = 9;
int steerY = 91;

//The class sets up the selection screen of the smart phone application
class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rtanks',
      debugShowCheckedModeBanner: false,
      home: JoyPad(),
      theme: ThemeData.dark(),
    );
  }
}

//This class creates the JoyPad State
class JoyPad extends StatefulWidget {
  @override
  _JoyPadState createState() => _JoyPadState();
}

//This class is where information about the select page is stored
class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(children: <Widget>[
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("Images/GameBackground.png"),//Set the image of the background
            fit: BoxFit.cover,
          ),
        ),
      ),
      Align(//Set up for the 'Red Tank' button on the start up page
        alignment: Alignment.centerRight,
        child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
             
              name = "Rtank";
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Controller()));
            },
            child: Text('Red Tank')),
      ),
      Align(//Set up for the 'Blue tank' button on the start up page
        alignment: Alignment.centerLeft,
        child: OutlineButton(
          splashColor: Colors.grey,
          onPressed: () {
            name = "Btank";
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Controller()));
          },
          child: Text('Blue Tank'),
        ),
      )
    ]));
  }
}

class _JoyPadState extends State<JoyPad> {
  //Defining the informationthe flutter_blue needs to connect to the device
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String TARGET_DEVICE_NAME = name;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  //Initilize the class
  @override
  void initState() {
    super.initState();
    if (stubTest == false) {
      disconnectFromDevice();
      startScan();
    }
  }
  //Start scanning for the device
  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        print('DEVICE found');
        stopScan();
        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }
  //Stop scanning for any devices
  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }
  //Connect to the device
  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Device Connecting";
    });
    //Await for a connection
    await targetDevice.connect();
    print('DEVICE CONNECTED');
    //Display on the smart phone screen that the device has connected
    setState(() {
      connectionText = "Device Connected";
    });
    //Instanciate the database reference
    final databaseReference = FirebaseDatabase.instance.reference();
    //Send data to the database to say the first device has connecte
    databaseReference.child("1").set({'0'});

    discoverServices();
  }
  //Disconnect form the selected device
  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();

    setState(() {
      connectionText = "Device Disconnected";
    });
  }
  //Disceover what services the bluetooth devie has to offer
  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) { //For each service
      // If the SERVICE_UUID matches the SERVICE_UUID of the device
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          // If the CHARACTERISTIC_UUID matches the CHARACTERISTIC_UUID of the device
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });
          }
        });
      }
    });
  }
  //read any incoming data from the device
  readData() async {
    var descriptors = targetCharacteristic.descriptors;
    for (BluetoothDescriptor d in descriptors) {
      List<int> value = await d.read();
      print(value);
    }
  }
  //Send information to the device
  writeData(String data) {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
    //sleep(const Duration(milliseconds: 1));
  }
  //Counter to limit the ammount of information the Arduino was recieving
  int count = 0;
  @override
  Widget build(BuildContext context) {
    //Setting the string for the 3 different types of data that will be sent
    String data1 = "";
    String data2 = "";
    String data3 = "";
    //This method is called when the joystick is moved
    //Even is there is a slight change in the position the mthod is called
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
          //A counter was implemented since the Aurdino was recieving to many commands
      if (count > 10) {//If the joystick has moved 10 times
      //This portion was implemented since the AArduino has a different starting refference points to angles then Dart
        if (degrees < 90) {
          degrees = 270 + degrees;
        } else {
          degrees = degrees - 90;
        }
        double y = (distance * sin(degrees * pi / 180.0));
        double x = (distance * cos(degrees * pi / 180.0));
        int magnitude = (x.abs() * 999.0).round();
        //If we want to move forward
        if (y > 0) {
          data1 = "dx${magnitude}y100e";
        } 
        //If we want to move backwards
        else if (y <= 0) {
          data1 = "dx${magnitude}y000e";
        }
        //If not running a stub test
        if (stubTest == false) {
          writeData(data1);
        }
        if (stubTest == true) {
          setState(() {
            connectionText = data1 + " " + data2 + " " + data3;
          });
        }
        count = 0;
      } else {//If the direction has not chnaged atleast 10 times
        count++;
      }
    }
    //This is the method that is called whenever a button is pressed
    PadButtonPressedCallback padButtonPressedCallback(
        int buttonIndex, Gestures gesture) {
      //If we want to steer right
      if (buttonIndex == 0) {
        if (steerX < 700) {
          steerX += 100;
        }
        //If we want to steer left
      } else if (buttonIndex == 1) {
        if (steerX > 150) {
          steerX -= 100;
        }
        //If we want to move the turret left
      } else if (buttonIndex == 2) {
        if (turretX < 700) {
          turretX += 100;
        }
        //If we want to move the turrret right
      } else if (buttonIndex == 3) {
        if (turretX > 150) {
          turretX -= 100;
        }
      }
      String data2 = "sx${steerX}y999e";
      data3 = "tx${turretX}y999e";
      //If we are not running a stub test
      if (stubTest == false) {
        //This was required since the method exits when writeData() is called
        //If we want to change the dirrection of the tank wheel
        if (buttonIndex <= 1) {
          writeData(data2);
        }
        //If we want to shange the direction of the turret
        if (buttonIndex >= 2) {
          writeData(data3);
        }
      }
      //If running a stub test
      if (stubTest == true) {
        setState(() {
          connectionText = data1 + " " + data2 + " " + data3;
        });
      }
    }
   //Main frame of the phone application
    return Scaffold(
      appBar: AppBar(
        title: Text(connectionText),//Set the title to the connection status of the bluetooth device
      ),
      body: Container(
        child: targetCharacteristic == null && stubTest == false
            ? Center(
                child: Text(
                  "Waiting...",
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //initilizing the joystick widget
                  JoystickView(//Setting action events for the joystick
                    onDirectionChanged: onDirectionChanged,
                  ),
                  PadButtonsView(
                    //Initilizing the Button widget
                    padButtonPressedCallback: padButtonPressedCallback, //Settin an action event for the buttons
                  ),
                ],
              ),
      ),
    );
  }
}
