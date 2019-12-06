import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;   //Create a variable that holds an instance of authentication from Firebase

  Future<bool> signInWithEmail(String email, String password) async{    //An async function used to sign in using any email (used only for testing purposes)
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email,password: password);
      FirebaseUser user = result.user;
      if(user != null)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();   //Create a custom google sign in variable
      GoogleSignInAccount account = await googleSignIn.signIn();    //Creates a variable that holds account information
      if(account == null )
        return false;
      AuthResult res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(   //Waits for user to enter account credentials and stores that info in a variable
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      if(res.user == null)    //If nothing is entered return false
        return false;
      return true;
    } catch (e) {
      print("Error logging with google");   //If any exception occurs print a message for the user and return false.
      return false;
    }
  }
}