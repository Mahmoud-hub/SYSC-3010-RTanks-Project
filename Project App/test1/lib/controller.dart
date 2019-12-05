import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';
import 'dart:io';

import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:firebase_database/firebase_database.dart';

bool stubTest = false;
String name = "";
int turretX = 9;
int turretY = 91;
int steerX = 9;
int steerY = 91;

/* Future<void> main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

  runApp(MainScreen());
} */

final databaseReference = FirebaseDatabase.instance.reference();
int i = 1;

class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joypad with BLE',
      debugShowCheckedModeBanner: false,
      home: JoyPad(),
      theme: ThemeData.dark(),
    );
  }
}

class JoyPad extends StatefulWidget {
  @override
  _JoyPadState createState() => _JoyPadState();
}

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(children: <Widget>[
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("Images/GameBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Align(
        alignment: Alignment(0.75, 0),
        child: OutlineButton(
            splashColor: Colors.red,
            onPressed: () {
              //UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
              //CharUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
              name = "Rtank";
              databaseReference.child('games').child("$i").update({
                'Red Tank': '2'
              });
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => Controller()));
            },
            child: Text('Red Tank')),
      ),
      Align(
        alignment: Alignment(-0.75, 0),
        child: OutlineButton(
          splashColor: Colors.blue,
          onPressed: () {
            //UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
            //CharUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
            name = "Btank";
            databaseReference.child('games').child("$i").update({
                'Blue Tank': '3'
              });
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
  //UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  //CharUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  //name = "Bluefruit52";
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String TARGET_DEVICE_NAME = name;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;
  List<BluetoothService> service;

  String connectionText = "";

  @override
  void initState() {
    super.initState();
    if (stubTest == false) {
      disconnectFromDevice();
      startScan();
    }
  }

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

  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Device Connecting";
    });

    await targetDevice.connect();
    print('DEVICE CONNECTED');
    setState(() {
      connectionText = "Device Connected";
    });

    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child("1").set({'0'});

    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();

    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  String _dataParser(List<int> fromDevice) {
    return utf8.decode(fromDevice);
  }

  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            //writeData("Hi there, ESP32!!");
            setState(() {
              connectionText = "All Ready with ${targetDevice.name}";
            });
          }
        });
      }
      readData() async {
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
          List<int> value = await c.read();
          print(_dataParser(value));
        }
      }

      readData();
    });
  }


  writeData(String data) {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
    //sleep(const Duration(milliseconds: 1));
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    String data1 = "";
    String data2 = "";
    String data3 = "";
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
      if (count > 10) {
        if (degrees < 90) {
          degrees = 270 + degrees;
        } else {
          degrees = degrees - 90;
        }
        double y = (distance * sin(degrees * pi / 180.0));
        double x = (distance * cos(degrees * pi / 180.0));
        int magnitude = (x.abs() * 999.0).round();

        if (y>0) {
          data1 = "dx${magnitude}y100e";
        } else if (y<=0){
          data1 = "dx${magnitude}y000e";
        }
        //int steer_direction = ((x*499)+499).round() ;
        //int steer = ((y * 499) + 499).round();

        //String data2 = "sx${x}y${y}e";

        if (stubTest == false) {
          //writeData(data2);
          //sleep(const Duration(milliseconds: 1));
          writeData(data1);
        }
        if (stubTest == true) {
          setState(() {
            connectionText = data1 + " " + data2 + " " + data3;
          });
        }
        count = 0;
      } else {
        count++;
      }
    }

    PadButtonPressedCallback padButtonPressedCallback(
        int buttonIndex, Gestures gesture) {
      String data = "";
      if (buttonIndex == 0) {
        if (steerX < 700) {
          steerX += 100;
          //steerY += 10;
        }
      } else if (buttonIndex == 1) {
        if (steerX > 150) {
          steerX -= 100;
          //steerY -= 10;
        }
      } else if (buttonIndex == 2) {
        if (turretX > 100) {
          turretX -= 100;
          //turretY += 10;
        }
        //data = "tx900y800e";
      } else if (buttonIndex == 3) {
        if (turretX < 700) {
          turretX += 100;
          //turretY += 10;
        }
      }
      String data2 = "sx${steerX}y999e";
      data = "tx${turretX}y999e";
      
      if (stubTest == false) {
        if (buttonIndex<=1){
        writeData(data2);
      }
      if (buttonIndex>=2){
        writeData(data);
      }     
        
        
      }
      if (stubTest == true) {
        setState(() {
          connectionText = data1 + " " + data2 + " " + data3;
        });
      }
    }

    databaseReference.child("games").child('1').child('Blue Tank').once().then((DataSnapshot snapshot) {
      if(snapshot.value == 3){
        databaseReference.child("games").child('1').update({
          'Blue Tank' : 'WINS!'
        });
      }
    });
    databaseReference.child("games").child('1').child('Red Tank').once().then((DataSnapshot snapshot) {
      if(snapshot.value == 3){
        databaseReference.child("games").child('1').update({
          'Red Tank' : 'WINS!'
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(connectionText),
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
                  JoystickView(
                    onDirectionChanged: onDirectionChanged,
                  ),
                  PadButtonsView(
                    padButtonPressedCallback: padButtonPressedCallback,
                  ),
                ],
              ),
      ),
    );
  }
}
