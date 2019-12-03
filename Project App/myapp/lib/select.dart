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