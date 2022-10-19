import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';

import 'Login_screen.dart';
import 'Maintanence.dart';

import 'package:http/http.dart'as http;

import 'Update_app.dart';

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

    var response =
    await http.get(Uri.parse(AppUrl.maintanence), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status']);
      setState(() {
        check_main = userData1['status'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future u() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response =
    await http.get(Uri.parse(AppUrl.mapk), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('ajib');
      print(userData1);
      setState(() {
        update = userData1['version'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  AnimationController _controller;
  var update;
  @override
  void initState() {
    // TODO: implement initState
    isLoogedIn();
    // initPlatformState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    // Timer(Duration(milliseconds: 200),()=> );
    _controller.forward();
    telegram();
    super.initState();
    startTimer();
    u();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  startTimer() async {
    var duration = Duration(milliseconds: 2000);
    return new Timer(duration, route);
  }

  Naviagate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainHome()));
  }

  Naviagatelogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => login_screen()));
  }

  Naviagatemain() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => update_app()));
  }
  Naviagatemain2() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => maintanence()));
  }

  var main = 3;
  var version;
  // getversion()async{
  //   var packageInfo = await PackageInfo.fromPlatform();
  //   String appName = packageInfo.appName;
  //   String packageName = packageInfo.packageName;
  //   String version_ = packageInfo.version;
  //   String buildNumber = packageInfo.buildNumber;
  //   setState(() {
  //     version=version_;
  //   });
  //
  // }

  route() async{
    var packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version_ = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print('New');
    print(version_);
    setState(() {
      version=version_;
    });
    update!=null?update!=version?Naviagatemain():check_main == 1
        ? Naviagatemain2()
        :
    token == null
        ? Naviagatelogin()
        : Naviagate(): Naviagate()  ;
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
                    child: Text("Game Zone".toUpperCase(),style: GoogleFonts.lato(
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

