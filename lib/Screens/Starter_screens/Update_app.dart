import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:url_launcher/url_launcher.dart';

class update_app extends StatefulWidget {
  @override
  _update_appState createState() => _update_appState();
}

class _update_appState extends State<update_app> {
  var button_status;
  var button_link;
  OtaEvent currentEvent;

  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response =
    await http.get(Uri.parse(AppUrl.apk), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status']);
      print(userData1['link']);
      setState(() {
        button_status = userData1['status'];
        button_link = userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    telegram();
    u();
    version_number();
    getversion();
  }
  Future<void> tryOtaUpdate() async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        link_,
        destinationFilename: 'absports.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        // sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',

      )
          .listen(
            (OtaEvent event) {
          setState(() => currentEvent = event);
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     // return object of type Dialog
          //     return AlertDialog(
          //       title: new Text("Alert Dialog title"),
          //       content:     currentEvent!=null?    Center(
          //         child: Text('OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
          //       ):Container(),
          //       actions: <Widget>[
          //         // usually buttons at the bottom of the dialog
          //         new FlatButton(
          //           child: new Text("Close"),
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //         ),
          //       ],
          //     );
          //   },
          // );
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');

    }
  }
  getversion()async{
    var packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version_ = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      version=version_;
    });
    print(version);

  }
  var update;
  Future version_number() async {
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

  var version;
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
      print('version test');
      print(userData1);
      setState(() {
        link_ = userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var link_;

  bool up=false;
bool di=false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),

                        // Row(
                        //   children: [
                        //     Image.asset('Images/app_icon.png',height: 150,width: 150,),
                        //     Shimmer.fromColors(
                        //       baseColor: Colors.grey,
                        //       highlightColor: Colors.white,
                        //       child: Text("Sport  Club".toUpperCase(),style: GoogleFonts.lato(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 20
                        //       )),
                        //     ),
                        //   ],
                        // ),
                       Container(
                         child: Row(
                           children: [
                             Icon(Icons.download_sharp,color: Colors.teal,size: 80,),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                     "New Update is available"
                                         .toUpperCase(),
                                     style: GoogleFonts.lato(
                                         color: Colors.orange,
                                         fontWeight: FontWeight.w800,
                                         fontSize: 22)), update!=null?  Text(
                                     "New version :  v$update "
                                   ,
                                     style: GoogleFonts.lato(
                                         color: Colors.black,
                                         fontWeight: FontWeight.w800,
                                         fontSize: 16)):
                                 Text(
                "New version :  .. "
                    .toUpperCase(),
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),


                               ],
                             )
                           ],
                         ),
                       ),
                      Container(
                        margin: EdgeInsets.only(left: 5,right:6),
                        width: width,
                        height: height/10,
                        child:   Row(
                          children: [
                            Text(
                                "আপডেট করতে সমস্যা হলে "
                                    .toUpperCase(),
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16)),
                           Expanded(child:  InkWell(
                             onTap: ()async{

                               var url = 'https://gamezonetour.com/';

                               if (await canLaunch(url))
                                 await launch(url);
                               else
                                 // can't launch url, there is some error
                                 throw "Could not launch $url";
                             },
                             child: Text(
                                 "https://gamezonetour.com/"
                                 ,
                                 style: GoogleFonts.lato(
                                     color: Colors.blue,
                                     fontWeight: FontWeight.w800,
                                     fontSize: 16)),
                           ),),

                          ],
                        ),
                      ),
                        Text(
                            "থেকে ডাউনলোড করে নিন "
                                .toUpperCase(),
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 16)),

                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                        ),
                      link_!=null? di==false? ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                up=true;
                                di=true;
                              });
                              tryOtaUpdate();
                              // var url = 'https://t.me/Sportclubadmin';
                              //
                              // if (await canLaunch(button_link))
                              //   await launch(button_link);
                              // else
                              //   // can't launch url, there is some error
                              //   throw "Could not launch $url";
                            },
                            icon: Icon(
                              Icons.update,
                              color: Colors.white,
                            ),
                            label: Text("Update App")):Container():Container(),
                        up==true?Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Color(0xFFFFD700),
                              child:   currentEvent!=null?    Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(currentEvent.value=='unable to create ota_update folder in internal storage' || currentEvent.value=='timeout'?"Connectivity Problem!! Please try again later!!":'Downloading status : ${currentEvent.value} %\n'),
                                ),
                              ):Container()
                            ),
                            currentEvent!=null?currentEvent.value=='unable to create ota_update folder in internal storage' || currentEvent.value=='timeout'?Container(): Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(),
                            ):Container(),
                            currentEvent!=null?currentEvent.value=='unable to create ota_update folder in internal storage' || currentEvent.value=='timeout'?Container():  Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Color(0xFFFFD700),
                              child: Text("Please wait..".toUpperCase(),
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10)),
                            ):Container(),
                          ],
                        ):Container()
                      ],
                    ))),
            // Text("This app is under Maintenance")
          ],
        ),
      ),
    );
  }
}
