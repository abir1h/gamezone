import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
class deposite_History extends StatefulWidget {
  @override
  _deposite_HistoryState createState() => _deposite_HistoryState();
}

class _deposite_HistoryState extends State<deposite_History> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.transaction_hostory), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data']['deposit'];
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
    return Scaffold(
      body: SingleChildScrollView(

        child: Column(
          children: [
            Container(
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
                                ?                                    Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (_,index){

                                    return Column(
                                      children: [
                                        ListTile(leading: Icon(Icons.money,color: Colors.green,),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("৳"+snapshot.data[index]['send_money'].toString(),style:  GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              ),),

                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data[index]['created_at'].toString()),)),
                                              SizedBox(height: 10,)

                                              ,int.parse(snapshot.data[index]['status']!=null?snapshot.data[index]['status']:'0')==1?Text("Approved",style:  GoogleFonts.lato(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )):int.parse(snapshot.data[index]['status']!=null?snapshot.data[index]['status']:'0')==2?Text("Declined",style:  GoogleFonts.lato(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )):Text("Requested",style:  GoogleFonts.lato(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              ))

                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("To " ,style:  GoogleFonts.lato(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                  )),
                                                  snapshot.data[index]['phone_number']!=null?  Text(snapshot.data[index]['phone_number'],style:  GoogleFonts.lato(
                                                      color: Colors.orange,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                  )):  Text("Refunded",style:  GoogleFonts.lato(
                                                      color: Colors.orange,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                  )),
                                                ],
                                              ),Row(
                                                children: [
                                                  Text("Type " ,style:  GoogleFonts.lato(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                  )),Text(snapshot.data[index]['wallet_type'],style:  GoogleFonts.lato(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                  )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(color: Colors.black54,)
                                      ],
                                    );
                                  }),
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
