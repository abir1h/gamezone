import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:url_launcher/url_launcher.dart';
class maintanence extends StatefulWidget {
  @override
  _maintanenceState createState() => _maintanenceState();
}

class _maintanenceState extends State<maintanence> {
  var button_status;
  var button_link;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response = await http.get(Uri.parse(AppUrl.apk), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status']);
      print(userData1['link']);
      setState(() {
        button_status=userData1['status'];
        button_link=userData1['link'];
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
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Column(
          children: [
            Center(child: Align(alignment:Alignment.center,child: Column(
              children: [
                SizedBox(height:  MediaQuery.of(context).size.height/5,),

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
                Image.asset('Images/un.gif',height: 300,width: 300,),
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.red,
                  child: Text("This App is under Maintenance Break".toUpperCase(),style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16
                  )),
                ),
                SizedBox(height:  MediaQuery.of(context).size.height/25,),
                button_link!=null? ElevatedButton.icon(onPressed: ()async{

                   var url='https://t.me/Sportclubadmin';

                   if (await canLaunch(button_link))
                     await launch(button_link);
                   else
                     // can't launch url, there is some error
                     throw "Could not launch $url";

               }, icon: Icon(Icons.update,color: Colors.white,), label: Text("Update App")):Container()

              ],
            ))),
            // Text("This app is under Maintenance")

          ],
        ),
      ),
    );
  }
}
