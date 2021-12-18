import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
class prize_details extends StatefulWidget {
  final String id;
  prize_details({this.id});


  @override
  _prize_detailsState createState() => _prize_detailsState();
}

class _prize_detailsState extends State<prize_details> {
  Future slide;
  Future emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.game_prize + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slide=emergency();

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Color(0xFFF7F7F7),

      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );

  }

  contentBox(context){
    String _chosenValue;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
            Container(
              height: 50,
              width: width,
              color: Color(0xFF07031E),
              child:   Center(
                child: Column(
                  children: [
                    Text('Prize Pool',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,)),
                  ],
                ),
              ),
            ),
              Container(
                  constraints: BoxConstraints(),
                  child: FutureBuilder(
                      future: slide,
                      builder: (_, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 5,
                              child: SpinKitThreeInOut(
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              Text('Error: ${snapshot.error}');
                            } else {
                              return snapshot.hasData
                                  ? SingleChildScrollView(
                                child:Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(child: Image.asset('Images/g.gif'),),
                                    Container(
                                      margin: EdgeInsets.only(left:12.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(' Winner -  ',
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,)), Text(snapshot.data[0]['winner'] + " BDT",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)),
                                            ],
                                          ),
                                          Divider(color: Colors.white30,),
                                          Row(
                                            children: [
                                              Text(' First Runner Up - ',
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)), Text(snapshot.data[0]['runner_up1']+ " BDT",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)),
                                            ],
                                          ),
                                          Divider(color: Colors.white30,),

                                          Row(
                                            children: [
                                              Text(' Second Runner Up -',
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)), Text(snapshot.data[0]['runner_up2']+ " BDT",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)),
                                            ],
                                          )     ,                                 Divider(color: Colors.white30,),
                                          Row(
                                            children: [
                                              Text(' Per Kill -  ',
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)), Text(snapshot.data[0]['per_kill']+ " BDT",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)),
                                            ],
                                          ),                                      Divider(color: Colors.white30,),
                                          Row(
                                            children: [
                                              Text(' Total Prize Pool -  ',
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)), Text(snapshot.data[0]['total_price']+ " BDT",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 18,

                                                    fontWeight: FontWeight.w600,)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 100,
                                              padding: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Center(child: Text("Close",style: TextStyle(fontSize: 18,color: Colors.white),)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
