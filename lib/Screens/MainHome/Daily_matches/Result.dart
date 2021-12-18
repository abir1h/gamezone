import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import '../mainHome.dart';
class medicine {
  final String Player_name;
  final int kills;
  final int winning;


  medicine({
    this.Player_name,
    this.kills,
    this.winning,

  });

  factory medicine.fromJson(Map<String, dynamic> json) {
    return medicine(
      Player_name: json['player_name'],
      kills: json['kill'],
      winning: json['prize'],


    );
  }
}
class booyah_model {
  final String Player_name;
  final int kills;
  final int winning;


  booyah_model({
    this.Player_name,
    this.kills,
    this.winning,

  });

  factory booyah_model.fromJson(Map<String, dynamic> json) {
    return booyah_model(
      Player_name: json['player_name'],
      kills: json['kill'],
      winning: json['prize'],


    );
  }
}class data2 {
  final String Player_name;



  data2({
    this.Player_name,

  });

  factory data2.fromJson(Map<String, dynamic> json) {
    return data2(
      Player_name: json['player_name'],


    );
  }
}

class result_sc extends StatefulWidget {
  final String id;
  result_sc({this.id});
  @override
  _result_scState createState() => _result_scState();
}

class _result_scState extends State<result_sc> {
var type,mobile,g_id,try_value,
win,p_kill,entryfee,time;
var player_name,kills,winnning;
bool haswinner=false;
bool data_get=false;
var datalength;
  Future<List<medicine>> fetchMEdicine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');


    var id=widget.id;

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.result_details+widget.id), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        has_medicine=true;
      });
      var parsed = json.decode(response.body)['data'];
      var user = json.decode(response.body)['data1'];
      var user2 = json.decode(response.body)['data2'];
      var user3 = json.decode(response.body)['dataCount'];
      print('data2');
      print(user3);

      print(parsed.length);
      setState(() {
        data_get=true;
try_value=user3!=null?user3:0;
type=user[0]['type'];
        mobile=user[0]['control_type'];
        g_id=user[0]['game_id'].toString();
        time=user[0]['date'];
        win=user[0]['total_prize'].toString();
        p_kill=user[0]['per_kill'].toString();
        entryfee=user[0]['entry_fee'].toString();

      });

      List jsonResponse = parsed as List;

      print("This is reponse "+jsonResponse.toString());

      print(jsonResponse);
      return jsonResponse.map((job) => new medicine.fromJson(job)).toList();


    } else {
      setState(() {
        has_medicine=false;
      });

      print("Get Profile No Data${response.body}");
    }
  }
  Future<List<data2>> getval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');


    var id=widget.id;

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.result_details+widget.id), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        has_medicine=true;
      });
      var user2 = json.decode(response.body)['data2'];
      print('data2');



      List jsonResponse = user2 as List;

      print("This is reponse "+jsonResponse.toString());

      print(jsonResponse);
      return jsonResponse.map((job) => new data2.fromJson(job)).toList();


    } else {
      setState(() {
        has_medicine=false;
      });

      print("Get Profile No Data${response.body}");
    }
  }
  Future<List<booyah_model>> fetch_boyaah() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');



    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.result_details+widget.id), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        haswinner=true;
      });
      var parsed = json.decode(response.body)['booyah'];
      // var user = json.decode(response.body)['data1'];
      // print(user[0]['game_id']);
      // print(parsed.length);


      List jsonResponse = parsed as List;

      print("This is reponse "+jsonResponse.toString());

      print(jsonResponse);
      return jsonResponse.map((job) => new booyah_model.fromJson(job)).toList();


    } else {
      setState(() {
        haswinner=false;
      });

      print("Get Profile No Data${response.body}");
    }
  }
  Future slide;
  Future emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.game_details + widget.id),
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
Future result_d,value2;
  Future booyah_;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result_d=  fetchMEdicine();
    slide=emergency();
    booyah_=fetch_boyaah();
    value2=getval();

  }
  bool has_medicine=false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
          title: InkWell (
            onTap: (){
            },
            child: Text("My Result",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
data_get==true?Container(
child:  Column(
  children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width:width,height: height/10,
          decoration:BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ) ,
          child: Column(
            children: [
            Row(
              children: [
                Expanded(child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(has_medicine==true?type+ " | "+mobile+" | "+g_id:" ",style: GoogleFonts.lato(
        color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16)),
                  ),
                ))
              ],
            ),Row(
              children: [
                Expanded(child: Center(
                  child: Text(has_medicine==true?"Organised on - " +time :" ",style: GoogleFonts.lato(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
                ))
              ],
            )
          ],),
        ),
      ),
    SizedBox(height: height/20,),
    Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width:width,height: height/10,
        decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ) ,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Wining Prize" ,style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                        Text(has_medicine==true?"৳ "+win:" " ,style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                      ],
                    ),
                  ),
                )),
                Expanded(child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Per Kill" ,style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                        Text(has_medicine==true?"৳ "+p_kill:" " ,style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                      ],
                    ),
                  ),
                )),
                Expanded(child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Entry Fee" ,style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                        Text(has_medicine==true?"৳ "+entryfee:" ",style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ],),
      ),
    ),
    SizedBox(height: height/20,),

    Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width:width,height: height/25,
        decoration:BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(2),
        ) ,
        child: Center(
          child: Text("BOOYAH", style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
        ),
      ),
    ),
    haswinner==true?
    FutureBuilder<List<booyah_model>>(
      future:    booyah_
      ,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          List<booyah_model> data = snapshot.data;
          print(data);
          // print(data);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: DataTable(
                            dataRowHeight: 25,
                            columnSpacing: 30.0,

                            headingRowColor:
                            MaterialStateColor.resolveWith((states) => Colors.black),
                            dataRowColor:                             MaterialStateColor.resolveWith((states) => Colors.white),

                            sortColumnIndex: 0,
                            sortAscending: true,
                            columns: [

                              DataColumn(
                                label: Text(
                                  '      #',

                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                              ), DataColumn(
                                label: Text(
                                  'Player Name',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Kills',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Winning',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                              ),



                            ],
                            rows: data
                                .map(
                                  (country) => DataRow(
                                cells: [

                                  DataCell(
                                    Container(
                                      width: 40.0,
                                      child: Center(
                                        child: Text(
                                          "#",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        country.Player_name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        country.kills.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),

                                  DataCell(
                                    Center(
                                      child: Text(
                                        '৳ '+ country.winning.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        Divider(
                          color: Colors.indigoAccent,
                        ),

                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 500),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              'An Error Occured!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            content: Text(
              "${snapshot.error}",
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
        // By default, show a loading spinner.
        return Container();
      },
    ):Container(),
    Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width:width,height: height/25,
        decoration:BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(2),
        ) ,
        child: Center(
          child: Text("FULL RESULT", style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
        ),
      ),
    ),

   try_value>0 ? has_medicine==true?
    FutureBuilder<List<medicine>>(
      future:    result_d
      ,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          List<medicine> data = snapshot.data;
          print(data);
          // print(data);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Padding(
                  padding: EdgeInsets.only(top:10.0
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Container(
                            width:MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: DataTable(
                              dataRowHeight: 25,
                              columnSpacing: 30.0,

                              headingRowColor:
                              MaterialStateColor.resolveWith((states) => Colors.black),
                              dataRowColor:                             MaterialStateColor.resolveWith((states) => Colors.white),

                              sortColumnIndex: 0,
                              sortAscending: true,

                              columns: [

                                DataColumn(
                                  label: Text(
                                    '      #',

                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                  ),
                                ), DataColumn(
                                  label: Text(
                                    'Player Name',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Kills',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Winning',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                  ),
                                ),



                              ],
                              rows: data
                                  .map(
                                    (country) => DataRow(

                                  cells: [

                                    DataCell(
                                      Container(
                                        width: 40.0,
                                        child: Center(
                                          child: Text(
                                          '#',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          country.Player_name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          country.kills.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Center(
                                        child: Text(
                                          '৳ '+ country.winning.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                          Divider(
                            color: Colors.indigoAccent,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 500),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              'An Error Occured!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            content: Text(
              "${snapshot.error}",
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
        // By default, show a loading spinner.
        return Container();
      },
    ):Container():FutureBuilder<List<data2>>(
     future:    value2
     ,
     builder: (ctx, snapshot) {
       if (snapshot.hasData) {
         print(snapshot.data);
         List<data2> data = snapshot.data;
         print(data);
         // print(data);
         return SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[


               Padding(
                 padding: EdgeInsets.only(top:10.0
                 ),
                 child: Center(
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Column(
                       children: [
                         Container(
                           width:MediaQuery.of(context).size.width,
                           color: Colors.white,
                           child: DataTable(
                             dataRowHeight: 25,
                             columnSpacing: 30.0,

                             headingRowColor:
                             MaterialStateColor.resolveWith((states) => Colors.black),
                             dataRowColor:                             MaterialStateColor.resolveWith((states) => Colors.white),

                             sortColumnIndex: 0,
                             sortAscending: true,

                             columns: [

                               DataColumn(
                                 label: Text(
                                   '      #',

                                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                 ),
                               ), DataColumn(
                                 label: Text(
                                   'Player Name',
                                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                 ),
                               ),
                               DataColumn(
                                 label: Text(
                                   'Kills',
                                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                 ),
                               ),
                               DataColumn(
                                 label: Text(
                                   'Winning',
                                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),
                                 ),
                               ),



                             ],
                             rows: data
                                 .map(
                                   (country) => DataRow(

                                 cells: [

                                   DataCell(
                                     Container(
                                       width: 40.0,
                                       child: Center(
                                         child: Text(
                                           '#',
                                           style: TextStyle(
                                               fontWeight: FontWeight.normal),
                                         ),
                                       ),
                                     ),
                                   ),
                                   DataCell(
                                     Center(
                                       child: Text(
                                         country.Player_name,
                                         style: TextStyle(
                                             fontWeight: FontWeight.normal),
                                       ),
                                     ),
                                   ),
                                   DataCell(
                                     Center(
                                       child: Text(
                                           '0',
                                         style: TextStyle(
                                             fontWeight: FontWeight.normal),
                                       ),
                                     ),
                                   ),

                                   DataCell(
                                     Center(
                                       child: Text(
                                         '৳ '+ '0',
                                         style: TextStyle(
                                             color: Colors.black,
                                             fontWeight: FontWeight.normal),
                                       ),
                                     ),
                                   ),


                                 ],
                               ),
                             )
                                 .toList(),
                           ),
                         ),
                         Divider(
                           color: Colors.indigoAccent,
                         ),

                       ],
                     ),
                   ),
                 ),
               ),
               // SizedBox(height: 500),
             ],
           ),
         );
       } else if (snapshot.hasError) {
         return AlertDialog(
           title: Text(
             'An Error Occured!',
             textAlign: TextAlign.center,
             style: TextStyle(
               color: Colors.redAccent,
             ),
           ),
           content: Text(
             "${snapshot.error}",
             style: TextStyle(
               color: Colors.blueAccent,
             ),
           ),
           actions: <Widget>[
             FlatButton(
               child: Text(
                 'Go Back',
                 style: TextStyle(
                   color: Colors.redAccent,
                 ),
               ),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             )
           ],
         );
       }
       // By default, show a loading spinner.
       return Container();
     },
   ),



  ],
)
):Center(child: SpinKitThreeInOut(
  color: Colors.white,
  size: 20,
))
            ],
          ),
        ),
      ),
    );
  }
}
