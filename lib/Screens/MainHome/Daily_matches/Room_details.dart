import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';
class room_Details extends StatefulWidget {
  final String id;
  room_Details({this.id});
  @override
  _room_DetailsState createState() => _room_DetailsState();
}

class _room_DetailsState extends State<room_Details> {
  Future slide;
  Future emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.withou_gamedetails + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      var userData2 = jsonDecode(response.body)['message'];
      print(userData1);
      print(userData2);
      setState(() {
        msg=userData2;
      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var msg;
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
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      body: SingleChildScrollView(child:
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
                            children: [
                              Container(
                                  height: height/2.5,
                                  child: Image.asset('Images/frr.jpg')),
                              Text(snapshot.data[0]['type']+" | "+snapshot.data[0]['control_type']+' | '+snapshot.data[0]['game_id'],
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,)),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: height/30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Type :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text(snapshot.data[0]['type'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        )

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: height/30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Version :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text(snapshot.data[0]['version'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        )

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: height/30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Map :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text(snapshot.data[0]['map'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        )

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: height/30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Match Type :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text("Paid",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        )

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: height/30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Entry Fee :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text("৳ "+snapshot.data[0]['entry_fee'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        )

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          margin: EdgeInsets.only(left: 50,right: 50),
                                          height: height/30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white
                                          ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Time :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text(snapshot.data[0]['date'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        ),


                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text('Prize Details',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,)),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: height/30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white
                                          ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Winner :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text("৳ " + snapshot.data[0]['total_prize'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        ),


                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: height/30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white
                                          ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Per Kill :",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
                                            Text("৳ "+ snapshot.data[0]['per_kill'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ],
                                        ),


                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: height/15,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),

                                              color: Colors.orange
                                          ),                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Room Details Will be shared Before 8 to 10 minutes of  match.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                                            )),
                                          ],
                                        ),


                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              Text('Match Instruction Rule',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,)),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:Text(snapshot.data[0]['instructions']['instruction']!=null?snapshot.data[0]['instructions']['instruction']:"Not Given yet!!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,))

                                      ),
                                    ),
                                  ],
                                ),
                              ),Text('Match participants',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,)),
                              Container(
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data[0]['game_room'].length,
                                    itemBuilder: (_,index){
                                      var indexof=index+1;
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(indexof.toString(), style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,)),
                                              SizedBox(width: 10,),
                                              Text(snapshot.data[0]['game_room'][index]['player_name'], style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,)),
                                            ],
                                          ),
                                          Divider(color: Colors.white,)

                                        ],
                                      );
                                    }),
                              ),



                            ],
                          ),
                        ),
                      )
                          : Text('No data');
                    }
                }
                return CircularProgressIndicator();
              }))

        ),
    );
  }
}
