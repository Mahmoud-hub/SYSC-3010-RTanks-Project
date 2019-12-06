import 'package:flutter/material.dart';
import 'flutter_fire_auth.dart';

//This page is unnessecary for the flow of the app, since the user is able to sign from clicking the first button
//It was only used for testing purposes, which is why it is included in the project

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();       //Create a login state
}

class _LoginPageState extends State<LoginPage> {    //Email Sign in (only for testing)
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {      //Email Sign in only (used for testing)
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context){
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 100.0),
              Text("Login", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),),
              const SizedBox(height: 20.0),
              RaisedButton(
                child: Text("Login with Google"),
                onPressed: () async {
                  bool res = await AuthProvider().loginWithGoogle();
                  if(!res)
                    print("error logging in with google");
                },
              ),
              TextField(
                controller: _emailController,   //Originally used for testing, not required anymore (email sign in)
                decoration: InputDecoration(
                    hintText: "Enter email"
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Enter password"
                ),
              ),
              const SizedBox(height: 10.0),
              RaisedButton(
                child: Text("Login"),
                onPressed: ()async {
                  if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                    print("Email and password cannot be empty");
                    return;
                  }
                  bool res = await AuthProvider().signInWithEmail(_emailController.text, _passwordController.text);
                  if(!res) {
                    print("Login failed");
                  }
                },
              )
            ],
          ),
        ),
      ),
      ])
    );
  }
}