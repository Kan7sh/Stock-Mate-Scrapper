import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_scrapper/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class FirebaseServices{

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  signInWithGoogle() async{

    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final  GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if(googleSignInAccount!=null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken

        );
        await _auth.signInWithCredential(authCredential);
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
      }
    }on FirebaseAuthException catch(e){
        print(e.message);
        throw e;
    }

  }

  signOut()async{
    await _auth.signOut();
    await _googleSignIn.signOut();
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(SplashScreenState.KEYLOGIN, false);
  }
}