import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';
import '../utils/colors_util.dart';
import 'login.dart';

class Search extends StatefulWidget {

  var searchItem;
  Search(this.searchItem);
  @override
  State<Search> createState() => _SearchState(searchItem);
}

class _SearchState extends State<Search> {

  var searchItem;
  _SearchState(this.searchItem);

  var searchController = TextEditingController();
  late Timer _timer2;
  List<dynamic> _Symbol = [];
  List<dynamic> _Exch = [];
  List<dynamic> _Name = [];
  List<dynamic> _StockType = [];
  var imageUrl;
  bool _isLoading = true;
  final FocusNode _focusNode = FocusNode();


  void _getData() async {
    final url = "http://192.168.1.5:5000/SEARCH?input=$searchItem";//// add your own domain,here it runs on localhost
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    setState(() {
      _Symbol = data["Symbol"];
      _Exch = data["Exch"];
      _Name = data["Name"];
      _StockType = data["StockType"];
      if(_Symbol.isEmpty&&searchItem!=''){
        Fluttertoast.showToast(
            msg: "No result found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      _isLoading = false;
    });
  }


  @override
  void initState(){
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    imageUrl = user!.photoURL;
    _getData();

  }

    Widget _buildListView(){
      return ListView.builder(
        itemCount: _Symbol.length,

        itemBuilder: (context, position) {

          return GestureDetector(
            onTap: ()async{
              final url = "https://finance.yahoo.com/quote/${_Symbol[position]}";
              print("Opening URL: $url");
              if (await canLaunch(url)) {
                print("Launching URL: $url");
                await launch(url);

              } else {
                print("Error launching URL: $url");
              }
            },
            child:Padding(
              padding: const EdgeInsets.fromLTRB(16,0,16,2),
              child: Card(

                color: hexStringToColor("#635985"),

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22,12,22,13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(_Name[position],style: TextStyle(fontFamily: 'outfit',fontSize: 15,color: hexStringToColor('#ffffff')),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24,0,24,12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_Symbol[position],style: TextStyle(fontFamily: 'outfit',fontSize: 15),),
                          Text(_Exch[position],style: TextStyle(fontFamily: 'outfit',fontSize: 15,),),
                          Text(_StockType[position],style: TextStyle(fontFamily: 'outfit',fontSize: 15,),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

          );
        },

      );
    }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#393053'),
      // body:  _isLoading?Center(child: CircularProgressIndicator(),):_buildListView(),
      body: Column(
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

                              }, child: Text("NO",style: TextStyle(fontFamily: 'outfitm',color: hexStringToColor("#635985")),)  ),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      fillColor: hexStringToColor('#635985'),
                      filled: true,
                      hintText: "Search Stocks",
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

                  searchItem = searchController.text;
                  if(searchItem==''){
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
                  setState(() {
                    searchItem = searchController.text;
                  });}
                  _getData();
                },
                icon: Icon(Icons.search,color: hexStringToColor('#635985'),),
              ),
            ),

          ],
        ),
      ),

          Expanded(child: _isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):_buildListView()),
        ],
      ),
    );
  }
}




/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: searchController,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchItem = searchController.text;
              });
              _getData();
            },
            child: Text("Search"),
          ),
          Expanded(
            child: _isLoading?Center(child: CircularProgressIndicator(),):_buildListView(),
          ),
        ],
      ),
    );
  }
}*/
