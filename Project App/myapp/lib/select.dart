import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("Images/Game Background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(alignment: Alignment.centerRight,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                    String UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
                    String CharUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
                    String name = "Bluefruit52";
                    
                },
                child: Text('Red Tank')
              ),
            ),
            Align(alignment: Alignment.centerLeft,
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {


                },
                child: Text('Blue Tank'),
              ),
            )
        ]));
  }
}