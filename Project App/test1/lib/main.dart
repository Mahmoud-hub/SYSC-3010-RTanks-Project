// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:test1/controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to RTanks',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
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
        alignment: Alignment.center,
        child: OutlineButton(
            child: Text('Play'),
            borderSide: BorderSide(color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 0.8 //width of the border
          ),
            splashColor: Colors.black,
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => SelectPage()));
            }
        )
      )
        ])
    );
  }
}