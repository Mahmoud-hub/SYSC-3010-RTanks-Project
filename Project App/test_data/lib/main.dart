import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());   //Runs the app

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: Database(),   //Sets the main page when the app is executed
    );
  }
}

class Database extends StatelessWidget {

  final databaseReference = FirebaseDatabase.instance.reference();    //Creates a variable that refers to the data inside the database, used to access the database data at any instance

  int i = 0;    //Used as an incremental value for sending data to the database

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(      //Creates the contents of the app
        appBar: AppBar(
            title: Text('Firebase Database Test'),
            ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  RaisedButton(
                      child: Text('Send Data'),   //Creates the Send Data button
                      onPressed: () {
                        i++;
                        sendData();   //Calls the function that sends data when button is pressed
                      },
                  ),

                  RaisedButton(
                      child: Text('View Data'),   //Creates the View Data button
                      onPressed: () {
                        getData();     //Calls the function that retrieves data when button is pressed
                      },
                  ),
                  RaisedButton(
                      child: Text('Udate Data'),  //Creates the Update Data button
                      onPressed: () {
                        updateData();   //Calls the function that Updates existing data when button is pressed
                      },
                  ),
                  RaisedButton(
                      child: Text('Delete Data'), //Creates the Delete Data button
                      onPressed: () {
                        deleteData();   //Calls the function that deletes existing data when button is pressed
                      },
                  ),
                ],
            )
        ),
    );
  }

  void sendData(){
    databaseReference.child("games").child("$i").set({    //Uses the database reference variable created above to create data in the database
      'Player 1': '0',
      'Player 2': '0'
    });
  }
  void getData(){
    databaseReference.once().then((DataSnapshot snapshot) {   //Takes a snapshot of all the data currently existing in the database and prints it
      print('Data : ${snapshot.value}');
    });
  }

  void updateData(){
    databaseReference.child('games').child("$i").update({   //Uses the database reference variable created above to access the data in the database and updates it
      'Player 1': '4'
    });
  }

  void deleteData(){
    databaseReference.child('games').child("$i").remove();    //Uses the database reference variable created above to access the data inside and remove it
    i--;
  }
    
}

