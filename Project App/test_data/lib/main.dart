import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: FirebaseDemoScreen(),
    );
  }
}

class FirebaseDemoScreen extends StatelessWidget {

  final databaseReference = FirebaseDatabase.instance.reference();

  int i = 0;

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        appBar: AppBar(
            title: Text('Firebase Database Test'),
            ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  RaisedButton(
                      child: Text('Send Data'),
                      onPressed: () {
                        i++;
                        createData();
                      },
                  ),

                  RaisedButton(
                      child: Text('View Data'),
                      onPressed: () {
                        getData();
                      },
                  ),
                  RaisedButton(
                      child: Text('Udate Data'),
                      onPressed: () {
                        updateData();
                      },
                  ),
                  RaisedButton(
                      child: Text('Delete Data'),
                      onPressed: () {
                        deleteData();
                      },
                  ),
                ],
            )
        ),
    );
  }

  void createData(){
    databaseReference.child("games").child("$i").set({
      'Player 1': 'Player 1 scored',
      'Player 2': 'Player 1 killed player 2'
    });
  }
  void getData(){
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void updateData(){
    databaseReference.child('games').child("$i").update({
      'description': 'Score Updated'
    });
  }

  void deleteData(){
    databaseReference.child('games').child("$i").remove();
    i--;
  }
    
}

