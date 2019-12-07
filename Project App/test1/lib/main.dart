// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/home.dart';
import 'package:test1/login.dart';

void main() => runApp(MyApp());   //Command that runs the app using the main app class MyApp

class MyApp extends StatelessWidget {   //The main app class, sets homepage to the MainScreen class below
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to RTanks',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context,AsyncSnapshot<FirebaseUser> snapshot) {
        if(!snapshot.hasData || snapshot.data == null)    //If firebase is unable to identify data, return back to the login page otherwise begin at homepage
          return LoginPage();
        return FirstRoute();
      },
    );
  }
}