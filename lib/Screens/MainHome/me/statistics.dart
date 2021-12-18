import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Refer.dart';
import 'package:sports_club/Screens/MainHome/me/transaction_history.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mainHome.dart';
import 'Withdraw.dart';
import 'depostie.dart';
import'package:http/http.dart'as http;


class statistics extends StatefulWidget {
  @override
  _statisticsState createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {

  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.statistics), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future det;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
slide=emergency();
    notification_timer=Timer.periodic(Duration(seconds: 10), (_) => slide=emergency());
  }
  Timer notification_timer;
  @override
  void dispose() {
    // TODO: implement dispose
    notification_timer.cancel();


    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      appBar: AppBar(
        backgroundColor: Color(0xFF07031E),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          },
        ),
        title: Text("My Statistics",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
         children: [
           Container(
             height: height,
               constraints: BoxConstraints(),
               child: FutureBuilder(
                   future: slide,
                   builder: (_, AsyncSnapshot snapshot) {
                     print(snapshot.data);
                     switch (snapshot.connectionState) {
                       case ConnectionState.waiting:
                         return  SizedBox(
                           width: MediaQuery.of(context).size.width,
                           height: MediaQuery.of(context).size.height/5,

                           child: SpinKitThreeInOut(color: Colors.white,size: 20,),
                         );
                       default:
                         if (snapshot.hasError) {
                           Text('Error: ${snapshot.error}');
                         } else {
                           return snapshot.hasData
                               ?                                               Container(
                             height: height / 1.1,
                             child: Column(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Container(
                                     child: Row(
                                       children: [
                                         Text("#                          ",
                                             style: GoogleFonts.lato(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w700,
                                                 fontSize: 12)),
                                         Text("Match Info ",
                                             style: GoogleFonts.lato(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w700,
                                                 fontSize: 12)),
                                         SizedBox(width: width/4,),
                                         Expanded(child: Text("Paid",
                                             style: GoogleFonts.lato(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w700,
                                                 fontSize: 12))),
                                         Expanded(child: Text("Winnings",
                                             style: GoogleFonts.lato(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w700,
                                                 fontSize: 12))),
                                       ],
                                     ),
                                   ),

                                 ),

                                 Container(
                                   height: height / 1.1,

                                   child: ListView.builder(
                                       shrinkWrap: true,
                                       itemCount: snapshot.data.length,
                                       itemBuilder: (_, index) {

print(snapshot.data.length);


                                         return           Container(
                                           child: Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Container(
                                               color: Colors.white,
                                               width: width,
                                               child: Row(
                                                 children: [
                                                   Expanded(
                                                     child: Text(" #             ",
                                                         style: GoogleFonts.lato(
                                                             color: Colors.black,
                                                             fontWeight: FontWeight.w700,
                                                             fontSize: 12)),
                                                   ),
                                                   Container(
                                                     child: Column(

                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [

                                                         Container(
                                                        width:width/3,
                                                           child: Row(
                                                             children: [
                                                               Flexible(
                                                                 child: Text(snapshot.data[index]['games'][0]['title']+ " | "+snapshot.data[index]['games'][0]['type']+" | "+snapshot.data[index]['games'][0]['game_id'],
                                                                     style: GoogleFonts.lato(
                                                                         color: Colors.grey,
                                                                         fontWeight: FontWeight.w600,
                                                                         fontSize: 12)),
                                                               ),
                                                             ],
                                                           ),
                                                         ), Container(                                                        width:width/3,

                                                           child: Row(
                                                             children: [
                                                               Flexible(
                                                                 child: Text("Played " +" on "+  snapshot.data[index]['games'][0]['date']+"       ",
                                                                     style: GoogleFonts.lato(
                                                                         color: Colors.grey,
                                                                         fontWeight: FontWeight.w600,
                                                                         fontSize: 12)),
                                                               ),
                                                             ],
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(width: width/10,),
                                                   Expanded(
                                                     child: Text('৳ ' +snapshot.data[index]['amount'].toString(),
                                                         style: GoogleFonts.lato(
                                                             color: Colors.black,
                                                             fontWeight: FontWeight.w700,
                                                             fontSize: 12)),
                                                   ),
                                                   SizedBox(width: width/6,),

                                                   snapshot.data[index]['game_player']!=null?Expanded(
                                                     child: Text('৳ '+ snapshot.data[index]['game_player'].toString(),
                                                         style: GoogleFonts.lato(
                                                             color: Colors.black,
                                                             fontWeight: FontWeight.w700,
                                                             fontSize: 12)),
                                                   ):Expanded(
                                                     child: Text('৳ 0 ',
                                                         style: GoogleFonts.lato(
                                                             color: Colors.black,
                                                             fontWeight: FontWeight.w700,
                                                             fontSize: 12)),
                                                   ),
                                                 ],
                                               ),
                                             ),

                                           )
                                         );
                                       }),
                                 ),
                               ],
                             ),
                           )




                               : Text('No data');
                         }
                     }
                     return CircularProgressIndicator();
                   })),

         ],
        ),
      ),
    );
  }
}
