import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/firebase_services.dart';
import '../utils/colors_util.dart';
import 'login.dart';

class TopGainers extends StatefulWidget {
  const TopGainers({Key? key}) : super(key: key);

  @override
  State<TopGainers> createState() => _TopGainersState();
}

class _TopGainersState extends State<TopGainers> {

  late Timer _timer;
  late Timer _timer2;
  List<dynamic> _TGName = [];
  List<dynamic> _TGPrice = [];
  List<dynamic> _TGGain = [];
  List<dynamic> _TGPercentage = [];
  var imageUrl;
  bool _isLoading = true;
  int _colorIndex = 0;
  List<Color> _colors = [hexStringToColor('#635985'), hexStringToColor('#18122B')];
  int _colorIndex2=1;

  Future _getData() async {
    final url = "http://192.168.1.5:5000/TG";
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data;
  }
  void _startTimer() {
    _timer2 = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        var temp;
        temp = _colorIndex;
        _colorIndex=_colorIndex2;
        _colorIndex2=temp;
      });

    });
    _timer = Timer.periodic(Duration(seconds:2), (timer) {
      _getData().then((data) {
        setState(() {
          _TGName = data["TopGainersName"];
          _TGPrice = data["TopGainersMarketPriceList"];
          _TGGain = data["TopGainersMarketPriceGainList"];
          _TGPercentage = data["TopGainersPercentageList"];
          _isLoading = false;
        });
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    final user = FirebaseAuth.instance.currentUser;
    imageUrl = user!.photoURL;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  Widget _buildListView() {
    return ListView
        .builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _TGName.length,
      itemBuilder: (context, postion) {
        return Card(
          color: hexStringToColor("#635985"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          elevation: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16,12,16,13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(_TGName[postion],style: TextStyle(fontFamily: 'outfit',fontSize: 17,color: hexStringToColor('#ffffff')),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,0,16,12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_TGPrice[postion],style: TextStyle(fontFamily: 'outfit',fontSize: 15),),
                    Text(_TGGain[postion],style: TextStyle(fontFamily: 'outfit',fontSize: 15,color: Colors.green),),
                    Text(_TGPercentage[postion],style: TextStyle(fontFamily: 'outfit',fontSize: 15,color: Colors.green),),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // body:  _isLoading?Center(child: CircularProgressIndicator(),):_buildListView(),
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colors[_colorIndex], _colors[_colorIndex2]/*hexStringToColor("#18122B")*/ ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
          ),
        ),
        child: Column(
          children: [Padding(
            padding: const EdgeInsets.fromLTRB(12, 38, 12, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // new line
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
                                }, child:Text("YES",style: TextStyle(fontFamily: 'outfitm',color:hexStringToColor("#635985")),) )
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

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 7),
                child: Text("TOP GAINERS",style: TextStyle(fontFamily: 'outfit',fontSize: 24,color:Colors.green ),),
              ),
            ],
          )
          ,
            Expanded(child: _isLoading?Center(child: CircularProgressIndicator( color: Colors.white,),):_buildListView()),
          ],
        ),
      ),
    );
  }
}
