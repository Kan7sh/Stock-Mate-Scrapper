import 'dart:async';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrapper/screens/home.dart';
import 'package:flutter_scrapper/screens/login.dart';
import 'package:flutter_scrapper/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Mate',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  // create a controller for the animation
  late AnimationController _animationController;

  static const String KEYLOGIN = "login";

  @override
  void initState() {
    super.initState();

    // initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // start the animation when the screen is loaded
    _animationController.forward();

    Timer(Duration(seconds: 3), () {
      whereToGo();
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // dispose the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor("#393053"),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'STOCK',
              style: TextStyle(
                fontSize: 38.0,
                fontFamily: 'outfit',
                color: hexStringToColor('#000000'),
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "  MATE",
              style: TextStyle(
                fontSize: 38.0,
                fontFamily: 'outfit',
                color: hexStringToColor('#ffffff'),
              ),
              textAlign: TextAlign.left,
            ),
            SlideTransition(
              // animate the image from right to left
              position: Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              )),
              child: Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void whereToGo()async{
    await Firebase.initializeApp();
    var sharedPred = await SharedPreferences.getInstance();
    var isLoggedIn=sharedPred.getBool(KEYLOGIN);

    if(isLoggedIn!=null){

      if(isLoggedIn){

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }else{

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }
    }else{

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
  }
}




