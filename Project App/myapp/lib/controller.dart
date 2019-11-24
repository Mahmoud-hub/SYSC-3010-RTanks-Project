import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:firebase_database/firebase_database.dart';

bool stubTest = false;
String UUID= "";
String CharUUID = "";
String name = "";


Future<void> main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joypad with BLE',
      debugShowCheckedModeBanner: false,
      home: SelectPage(),
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
                image: new AssetImage("images/nudes.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(alignment: Alignment.centerRight,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                  UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
                  CharUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
                  name = "Bluefruit52";
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JoyPad())
                  );
                },
                child: Text('Red Tank')
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                  UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
                  CharUUID= "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
                  name = "Bluefruit51";
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JoyPad())
                  );
                },
                child: Text('Blue Tank'),
              ),
            )
        ]));
  }
}


class _JoyPadState extends State<JoyPad> {
  final String SERVICE_UUID = UUID;
  final String CHARACTERISTIC_UUID = CharUUID;
  final String TARGET_DEVICE_NAME = name;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  @override
  void initState() {
    super.initState();
    if (stubTest == false) {
      startScan();
      setState(() {
          connectionText = "Found Target Device";
     });
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

    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();

    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  String _dataParser(List<int> fromDevice){

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
    });
  }

  readData(){

  }

  writeData(String data) {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
    sleep(const Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    String data1 = "";
    String data2 = "";
    String data3 = "";
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
      double y = (distance * sin(degrees * pi / 180.0));
      double x = (distance * cos(degrees * pi / 180.0));
      int magnitude = (x.abs() * 999.0).round();

      if (degrees<90 || degrees>270) {
        data1 = "dx${magnitude}y1e";
      } else {
        data1 = "dx${magnitude}y0e";
      }

      //int steer_direction = ((x*499)+499).round() ;
      int steer = ((y * 499) + 499).round();

      String data2 = "sx${steer}y${steer}e";

      if (stubTest == false) {
        writeData(data1);
        writeData(data2);
      }
      if (stubTest == true) {
        setState(() {
          connectionText = data1 + " " + data2 +  " " +data3;

     });
        
      }
    }

    PadButtonPressedCallback padButtonPressedCallback(
        int buttonIndex, Gestures gesture) {
      String data = "";
      if (buttonIndex == 0) {
        data = "tx074y190e";
      }
      if (buttonIndex ==1){
        
      }
      if (buttonIndex == 2) {
        data = "tx900y800e";
      }
      if (buttonIndex==3){

      }

      if (stubTest == false) {
        writeData(data);
      }
      if (stubTest == true) {
        setState(() {
          connectionText = data1 + " " + data2 +  " " +data3;

     });
      }
    }

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
