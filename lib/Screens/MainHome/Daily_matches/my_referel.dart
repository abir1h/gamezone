import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Refer.dart';

import 'package:http/http.dart'as http;
class refferel_ {
  final String username;
  final String created_at;


  refferel_({
    this.username,
    this.created_at,

  });

  factory refferel_.fromJson(Map<String, dynamic> json) {
    return refferel_(
      username: json['username'],
      created_at: json['created_at'],


    );
  }
}
class my_refer extends StatefulWidget {
  @override
  _my_referState createState() => _my_referState();
}

class _my_referState extends State<my_refer> {
  Future result_d;
  bool has_medicine=false;
  var count_re,earing_ref;

  Future<List<refferel_>> fetchMEdicine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');



    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.my_referral), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        has_medicine=true;
      });
      var parsed = json.decode(response.body)['data1'];
      var user = json.decode(response.body)['data'];

      print('this');
      print(user['f']);
      setState(() {
        count_re=user['f'];
        earing_ref=user['p'];
      });
      // print(parsed.length);

      List jsonResponse = parsed as List;

      print("This is reponse "+jsonResponse.toString());

      print(jsonResponse);
      return jsonResponse.map((job) => new refferel_.fromJson(job)).toList();


    } else {
      setState(() {
        has_medicine=false;
      });

      print("Get Profile No Data${response.body}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result_d=  fetchMEdicine();

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      appBar:AppBar(
        backgroundColor: Color(0xFF07031E),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>refere()));
        },),
        title:                   Text('My Referrals',
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18)),


      ) ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width:width,height: height/25,
                decoration:BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ) ,
                child: Center(
                  child: Text("My Referral Summary", style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
                ),
              ),
            ),
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
                                Text("Referrals" ,style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                                count_re!=0?  Text(count_re!=null?count_re.toString():" " ,style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)):Text("0",style: GoogleFonts.lato(
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
                                Text("Earning" ,style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                                earing_ref!=0?  Text(earing_ref!=null?'৳ '+ earing_ref.toString():" " ,style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)):Text('৳ 0',style: GoogleFonts.lato(
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width:width,height: height/25,
                decoration:BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                ) ,
                child: Center(
                  child: Text("My Referral List", style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
                ),
              ),
            ),
            has_medicine==true? FutureBuilder<List<refferel_>>(
              future:    result_d
              ,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  List<refferel_> data = snapshot.data;
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
                                  DataTable(
                                    dataRowHeight: 50,

                                    columnSpacing: 50.0,

                                    headingRowColor:
                                    MaterialStateColor.resolveWith((states) => Colors.blue),
                                    dataRowColor:                             MaterialStateColor.resolveWith((states) => Colors.white),

                                    sortColumnIndex: 0,
                                    sortAscending: true,
                                    columns: [

                                      DataColumn(
                                        label: Text(
                                          'Date',

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
                                          'Status',
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
                                              width: 80.0,
                                              child: Center(
                                                child: Text(
                                                  DateFormat.yMd().format(DateTime.parse(country.created_at.toString())),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                country.username,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "Registered",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ),



                                        ],
                                      ),
                                    )
                                        .toList(),
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
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('This may take some time..')
                    ],
                  ),
                );
              },
            ):Container(),



          ],
        ),
      ),
    );
  }
}
