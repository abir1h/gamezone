
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/Play.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/me.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/ongoing.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/shop.dart';
import 'package:sports_club/Screens/Starter_screens/alerts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Bottom_nav_menues/Result.dart';
import 'Models/rough.dart';
import 'me/my_wallet.dart';
import 'package:http/http.dart'as http;
class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 2;
  List<Widget> _widgetOptions = <Widget>[
    shop(),
ongoing_list(),
    play(),
    Result(),
    me(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  var telegram_link;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.telegram), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['link']);
      setState(() {
        telegram_link=userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var p_id;
  get_playerd()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String player_id = prefs.getString('player_ID');
    setState(() {
      p_id=player_id;
    });


  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    telegram();
    get_playerd();
    badge();
}
  var badge_text;
  Future badge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.motice), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('try');
      print(userData1);
      setState(() {
        badge_text=userData1['notice'];
      });
     if(badge_text!=null){
       Future.delayed(Duration.zero, () {
         // context can be used here...
         showDialog(
             context: context,
             builder: (context){
               return  alert_dialogs(text_par: badge_text,);
             });});
     }
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  final PageStorageBucket bucket=PageStorageBucket();
  Widget currentScreen=play();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFF07031E),

appBar: AppBar(
  automaticallyImplyLeading: false, // Don't show the leading button

  backgroundColor: Color(0xFF07031E),

  title:  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Image.asset('Images/app_icon.png',height: MediaQuery.of(context).size.height/18,),
      Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: InkWell(
          onTap: (){
            print(p_id);
          },
          child: Text("Game Zone".toUpperCase(),style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18
          )),
        ),
      ),
      // Your widgets here
    ],
  ),
  actions: [
    FloatingActionButton(
      backgroundColor: Colors.transparent,
      onPressed: ()async{
        var url=telegram_link;
        if (await canLaunch(url))
          await launch(url);
        else
          // can't launch url, there is some error
          throw "Could not launch $url";
      },
      child: Image.asset('Images/wh.png',height: 40,width: 40,),
    ),
      InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>my_wallet()));

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('Images/wallet.jpeg',height: 40,width: 40,),
          ))
  ],
),


        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.transparent,
        //   onPressed: ()async{
        //     var url=telegram_link;
        //     if (await canLaunch(url))
        //     await launch(url);
        //     else
        //     // can't launch url, there is some error
        //     throw "Could not launch $url";
        //   },
        //   child: Image.asset('Images/wh.png',height: 50,width: 50,),
        // ),
        body: _widgetOptions.elementAt(_selectedIndex),

        bottomNavigationBar: BottomNavigationBar(
          iconSize: 20,

          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,



          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.store),
              label: 'Shop',

              backgroundColor: Color(0xFF07031E),
            ), BottomNavigationBarItem(
              icon:Icon(Icons.timer),
              label: 'Ongoing',

              backgroundColor: Color(0xFF07031E),
            ),BottomNavigationBarItem(
              icon: Icon(
Icons.videogame_asset_rounded              ),
              label: 'Play',
              backgroundColor: Color(0xFF07031E),
            ),BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined,),
              label: 'Result',
              backgroundColor: Color(0xFF07031E),
            ),BottomNavigationBarItem(
              icon:  Icon(
                Icons.person,
              ),
              label: 'Menu',
              backgroundColor: Color(0xFF07031E),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          selectedLabelStyle: TextStyle(color: Color(0xFF07031E)),
          unselectedLabelStyle: TextStyle(color: Color(0xFF07031E)),
          showSelectedLabels: true,
          showUnselectedLabels: true,

          selectedFontSize: 16.0,
          unselectedFontSize: 12.0,
        ),
      ),
    );
  }
}
