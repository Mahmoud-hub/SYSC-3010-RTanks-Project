import 'package:flutter/material.dart';
import 'package:test1/select.dart';
import 'flutter_fire_auth.dart';

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(    //Return a widget that holds the contents of the app
        body: new Stack(children: <Widget>[   //Stack is used to list different widgets in order of priority (back to front)
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("Images/GameBackground.png"),     //Adds a background image and fits it the size of the app
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,    //Creates a button that is aligned in the center; used to start off the app
              child: OutlineButton(
                splashColor: Colors.grey,
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();    //When pressed, waits for user to sign in and authenticate information
                  if(!res)
                    print("error logging in with google");    //If autherization is false, notify user

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectPage()),    //After signing in, navigate to the tank selection page
                  );
                },
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),   //Position button from edges
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("Images/google_logo.png"),    //Add an image inside the button to indicate google sign in
                          height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in to Play',    //Add text to button
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ]));
  }
}
