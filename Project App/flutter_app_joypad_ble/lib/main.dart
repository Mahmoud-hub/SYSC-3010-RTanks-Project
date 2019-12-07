//This file constructs the application and prepares it to be displayed on the screen

import 'package:flutter/material.dart';
import 'package:flutter_app_joypad_ble/controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to RTanks',
      home: SelectPage(),
    );
  }
}