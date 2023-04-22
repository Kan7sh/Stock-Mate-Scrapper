import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import '../utils/colors_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scrapper/screens/crypto.dart';
import 'package:flutter_scrapper/screens/currency.dart';
import 'package:flutter_scrapper/screens/login.dart';
import 'package:flutter_scrapper/screens/search.dart';
import 'package:flutter_scrapper/screens/topGainers.dart';
import 'package:flutter_scrapper/screens/topLosers.dart';
import 'package:flutter_scrapper/services/firebase_services.dart';
import 'package:http/http.dart' as http;



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  late Timer _timer;
  List<dynamic>? _NIName = [];
  List<dynamic>? _NIPrice = [];
  List<dynamic>? _NIGain = [];
  List<dynamic>? _NIPercentage = [];
  bool _isLoading=true;
  var imageUrl;
  final FocusNode _focusNode = FocusNode();


  var searchController = TextEditingController();
  Future _getData()async{
    final url="http://192.168.1.5:5000/NI";// add your own domain,here it runs on localhost
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data;
  }

  void _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _getData().then((data) =>{
        setState((){
          _NIName = data["HeaderName"];
          _NIPrice = data["HeaderPriceList"];
          _NIGain = data["HeaderLGList"];
          _NIPercentage = data["HeaderPerList"];
          _isLoading = false;
        })
      });
    });
  }

  void _stopTimer(){
    _timer.cancel();
  }

  @override
  void initState(){
    super.initState();
    _startTimer();
    final user = FirebaseAuth.instance.currentUser;
    imageUrl = user!.photoURL;
   /* var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

    } else {
      print('No internet connection');
    }*/

  }

  @override
  void dispose(){
    _stopTimer();
    super.dispose();
  }

  Widget coloredText(String text) {
    Color color = Colors.black; // default color
    if (text.startsWith("+")) {
      color = Colors.green;
    } else if (text.startsWith("-")) {
      color = Colors.red;
    }
    return Text(
      text,
      style: TextStyle(
        color: color,fontFamily: 'outfit'
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#393053'),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 38, 12, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("STOCK",style: TextStyle(fontFamily: 'outfit',fontSize: 28,color:hexStringToColor('#000000')),
                      textAlign: TextAlign.left,
                    ),
                    Text("  MATE",    style: TextStyle(fontSize: 28,fontFamily: 'outfit',color:hexStringToColor('#ffffff')),
                      textAlign: TextAlign.left,),
                  ],
                ),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: GestureDetector(
                    onTap:(){ showDialog(
                      context: context,
                      builder: (BuildContext){
                        return AlertDialog(
                          backgroundColor: hexStringToColor("#18122B"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text("Are you sure you want to logout?",style: TextStyle(fontFamily: 'outfitm',color: Colors.white),),
                          actions:<Widget>[
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();

                            }, child: Text("NO",style: TextStyle(fontFamily: 'outfitm',color:hexStringToColor("#635985")),)  ),
                            TextButton(onPressed: ()async{
                              await FirebaseServices().signOut();

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            }, child:Text("YES",style: TextStyle(fontFamily: 'outfitm',color: hexStringToColor("#635985")),) )
                          ]
                        );
                      }
                    );},
                    child: CircleAvatar(
                      radius: 100,
                      child: ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                            return Image.asset('assets/images/ProfilePicture.png');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12,8,24,8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.75,
                  height: 56,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)
                  ),
                    child: TextField(

                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Search Stocks",
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          fillColor: hexStringToColor('#635985'),
                          filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          )
                      ),
                      controller: searchController,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: IconButton(
                    style: IconButton.styleFrom(
                    ),
                      onPressed: (){
                        _focusNode.unfocus();
                        var searchStock = searchController.text;
                        if(searchStock==""){
                          Fluttertoast.showToast(
                              msg: "Search Bar is empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchStock)));
                        }
                      },
                      icon: Icon(Icons.search,color: hexStringToColor('#635985'),),
                  ),
                ),

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
            children: [
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.46,
                    height: 100,
                    child: Card(
                      color: hexStringToColor('#18122B'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      elevation: 4,
                      child:_isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,20,18,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_NIName![0],style: TextStyle(fontFamily: 'outfit',color: Colors.white)),
                                coloredText(_NIGain![0])

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,10,18,15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_NIPrice![0],style: TextStyle(fontFamily: 'outfitm',color: Colors.white),),
                                coloredText(_NIPercentage![0])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.46,
                    height: 100,

                    child: Card(
                      color: hexStringToColor('#18122B'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      elevation: 4,
                      child: _isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,20,18,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIName![1],style: TextStyle(fontFamily: 'outfit',color: Colors.white),),
                                coloredText(_NIGain![1])

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,10,18,15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIPrice![1],style: TextStyle(fontFamily: 'outfitm',color: Colors.white)),
                                coloredText(_NIPercentage![1])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(

                    width: MediaQuery.of(context).size.width*0.46,
                    height: 100,

                    child: Card(
                      color: hexStringToColor('#18122B'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      elevation: 4,
                      child: _isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,20,18,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIName![2],style: TextStyle(fontFamily: 'outfit',color: Colors.white),),
                                coloredText(_NIGain![2])

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,10,18,15),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIPrice![2],style: TextStyle(fontFamily: 'outfitm',color: Colors.white)),
                                coloredText(_NIPercentage![2])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(

                    width: MediaQuery.of(context).size.width*0.46,
                    height: 100,

                    child: Card(
                      color: hexStringToColor('#18122B'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      elevation: 4,
                      child: _isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,20,18,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIName![3],style: TextStyle(fontFamily: 'outfit',color: Colors.white)),
                                coloredText(_NIGain![3])

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,10,18,15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(_NIPrice![3],style: TextStyle(fontFamily: 'outfitm',color: Colors.white)),
                                coloredText(_NIPercentage![3])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )

            ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22,10,14,10),
                child: Text("BROWSE MARKET",style: TextStyle(fontFamily: 'outfit',fontSize:22),
                textAlign: TextAlign.start,),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,2,0,6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

      ElevatedButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TopGainers()));
        },
        style: ElevatedButton.styleFrom(
            primary: hexStringToColor('#635985'),
            onPrimary: Colors.white,
            minimumSize: Size(88, 36),
            padding: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/TG.png',
                width: 135.0,
                height: 135.0,// Adjust the size of the image as needed
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'TOP GAINERS',
                  style: TextStyle(fontSize: 16.0,fontFamily: 'outfitm'), // Adjust the font size as needed
                ),
              ),
            ],
        ),
                  ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TopLosers()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: hexStringToColor('#635985'), // Change the background color of the button
                    onPrimary: Colors.white, // Change the text color of the button
                    minimumSize: Size(88, 36), // Set the minimum size of the button
                    padding: EdgeInsets.symmetric(horizontal: 16), // Set the padding of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0), // Set the border radius of the button
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/TL.png',
                        width: 135.0,
                        height: 135.0,// Adjust the size of the image as needed
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'TOP LOSERS',
                          style: TextStyle(fontSize: 16.0,fontFamily: 'outfitm'), // Adjust the font size as needed
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,4,0,6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Crypto()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: hexStringToColor('#635985'), // Change the background color of the button
                    onPrimary: Colors.white, // Change the text color of the button
                    minimumSize: Size(88, 36), // Set the minimum size of the button
                    padding: EdgeInsets.symmetric(horizontal: 16), // Set the padding of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0), // Set the border radius of the button
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/CR.png',
                        width: 135.0,
                        height: 135.0,// Adjust the size of the image as needed
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'CRYPTO',
                          style: TextStyle(fontSize: 16.0,fontFamily: 'outfitm'), // Adjust the font size as needed
                        ),
                      ),
                    ],
                  ),),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Currency()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: hexStringToColor('#635985'),
                    onPrimary: Colors.white,
                    minimumSize: Size(88, 36),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/CU.png',
                        width: 135.0,
                        height: 135.0,// Adjust the size of the image as needed
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'CURRENCIES',
                          style: TextStyle(fontSize: 16.0,fontFamily: 'outfitm'), // Adjust the font size as needed
                        ),
                      ),
                    ],
                  ),),
              ],
            ),
          ),
        ],
      ),
    ),);
  }
}
