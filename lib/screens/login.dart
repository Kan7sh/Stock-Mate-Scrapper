import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrapper/screens/home.dart';
import 'package:flutter_scrapper/services/firebase_services.dart';

import '../utils/colors_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration:BoxDecoration(gradient: LinearGradient(colors:
       [
         hexStringToColor("#393053"),
        hexStringToColor("#393053")
     ], begin: Alignment.topCenter, end:Alignment.bottomCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18,45,18,26),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width:800,
                  height: 450,
                  child: Image.asset(
                    'assets/images/intro.gif',
                      fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:22),
              child: Row(
                children: [
                  Text(
                    'STOCK',
                    style: TextStyle(fontSize: 46.0,fontFamily: 'outfit',color:hexStringToColor('#000000')),
                    textAlign: TextAlign.left,
                  ),
                  Text("  MATE",    style: TextStyle(fontSize: 46.0,fontFamily: 'outfit',color:hexStringToColor('#ffffff')),
                    textAlign: TextAlign.left,)
                ],
              ),
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22,8,40,18),
          child: Text("Get real-time updates on stock market with our app. Stay informed with the latest top gainers and top losers, crypto and currency prices, and search for specific stocks. Easily access all NIFTY stock prices in one place. Stay ahead of the game with our comprehensive stock market tool.",
          style: TextStyle(fontFamily: 'oufit',color: Colors.white),
          textAlign: TextAlign.justify,),
        ),
        Expanded(
          flex: 10,

          child: Center(
            child: SizedBox(
              height: 50,
              width: 365,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseServices().signInWithGoogle();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: hexStringToColor("#18122B"),
                    onPrimary: Colors.white,
                    minimumSize: Size(80, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                    )
                ),
                child: Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,55,0),
                      child: Image.asset(
                        'assets/images/googleLogo.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "SIGN IN WITH GOOGLE",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'outfit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
          ],
        ),
      ),




      // body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors:
      // [
      //   hexStringToColor("#ffffff"),
      //   hexStringToColor("#EEEEEE")
      // ], begin: Alignment.topCenter, end:Alignment.bottomCenter)),
      // child: Center(child: Container(margin: EdgeInsets.symmetric(horizontal: 30),
      //
      //   child: ElevatedButton(
      //     onPressed:() async{
      //
      //
      //     },
      //     style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states){
      //       if(states.contains(MaterialState.pressed)){
      //         return Colors.black26;
      //       }
      //       return Colors.white;
      //     })),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         children:<Widget>[
      //           Text("Sign In With Google",
      //           style: TextStyle(color: Colors.black26,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 24),),
      //         ],
      //       ),
      //     ),
      //   ),),),
      // ),
    );
  }
}

































