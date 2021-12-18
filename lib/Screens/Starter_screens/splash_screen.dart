import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';

import 'Login_screen.dart';
import 'Maintanence.dart';

import 'package:http/http.dart'as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // static final String onesignal_app_id='185cc73a-68a3-4868-9058-5633f5aeb0a4';
  var token;
  // Future<void> initPlatformState(){  OneSignal.shared.setAppId(onesignal_app_id);
  // }
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }
  var check_main;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response = await http.get(Uri.parse(AppUrl.maintanence), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status']);
      setState(() {
        check_main=userData1['status'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    isLoogedIn();
    // initPlatformState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // Timer(Duration(milliseconds: 200),()=> );
    _controller.forward();
    telegram();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  startTimer() async {
    var duration = Duration(milliseconds:5500);
    return new Timer(duration, route);
  }
  Naviagate(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainHome()));
  }Naviagatelogin(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>login_screen()));
  }Naviagatemain(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>maintanence()));
  }
  var main=3;

  route() {
    check_main==1?Naviagatemain():token==null?Naviagatelogin():Naviagate();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(

        backgroundColor:Color(0xFF07031E),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: MediaQuery.of(context).size.height/3.5,),
              Center(child: Align(alignment:Alignment.center,child: Column(
                children: [
                  Image.asset('Images/app_icon.png',height: 150,width: 150,),
                  SizedBox(height:  MediaQuery.of(context).size.height/25,),
                  Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Text("Sport  Club".toUpperCase(),style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    )),
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height/25,),

                 Padding(
                   padding: const EdgeInsets.only(left:140.0,right:140),
                   child: LinearProgressIndicator(backgroundColor: Colors.white30,

                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                   ),
                 )
                ],
              ))),

            ],
          ),
        )
    );
  }
}

