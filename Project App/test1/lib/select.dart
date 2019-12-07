import 'package:flutter/material.dart';

//This class is the layout of the selection page, used to provide the user with a choice of which tank they would like to connect to.

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
          Align(alignment: Alignment.centerRight,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {     //Button does not do anything when pressed
                  //Bluetooth connectivity code would be here
                },
                child: Text('Red Tank')
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                  //Button does nothing when pressed
                  //Bluetooth connectivity code would be here
                },
                child: Text('Blue Tank'),
              ),
            )
        ]));
  }
}