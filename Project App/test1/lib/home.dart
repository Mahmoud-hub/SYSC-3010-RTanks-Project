import 'package:flutter/material.dart';
import 'package:test1/select.dart';
import 'flutter_fire_auth.dart';

class FirstRoute extends StatelessWidget {
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
                splashColor: Colors.grey,
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if(!res)
                    print("error logging in with google");

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectPage()),
                  );
                },
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("Images/google_logo.png"),
                          height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in to Play',
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
