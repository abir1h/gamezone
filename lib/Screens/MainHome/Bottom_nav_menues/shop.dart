import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:url_launcher/url_launcher.dart';
class shop extends StatefulWidget {
  @override
  _shopState createState() => _shopState();
}

class _shopState extends State<shop> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.shop), headers: requestHeaders);
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
    return Scaffold(
      backgroundColor: Color(0xFF07031E),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: height/18,
                width: width/2,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)
                ,color: Colors.blue
                ),
                child: Center(
                  child: Text('FreeFire Diamonds',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,)),
                ),
              ),
            ),
            SizedBox(height: height/25,),
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
                                ?                          Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                              height: MediaQuery.of(context).size.height/1,
                              child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 4/3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      var url=snapshot.data[index]['links'];
                                      return InkWell(
                                          onTap: ()async{
                                            if (await canLaunch(url))
                                            await launch(url);
                                            else
                                            // can't launch url, there is some error
                                            throw "Could not launch $url";
                                          },
                                          child:  Container(
                                            height: height/7.5,
                                            width: width/2.4,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.red)

                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:Alignment.topRight,
                                                  child: Container(
                                                    width: width/5,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)
                                                        ,color: Colors.red
                                                    ),
                                                    child: Center(
                                                      child: Text(snapshot.data[index]['percent_rate']+' % off',
                                                          style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,)),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset('Images/diamond.png',height: height/25,width: width/10,),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(snapshot.data[index]['title'],
                                                                    style: GoogleFonts.lato(
                                                                      color: Colors.white,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,)),Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Image.asset('Images/diamond.png',height: 20,width:20),
                                                                ),
                                                              ],
                                                            ),Text('৳ '+snapshot.data[index]['offer_price'],
                                                                style: GoogleFonts.lato(
                                                                  color: Colors.orange,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,)),Text('৳ '+snapshot.data[index]['price'],
                                                                style: GoogleFonts.lato(
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  decoration: TextDecoration.lineThrough,

                                                                  fontWeight: FontWeight.w600,)),
                                                          ],
                                                        )
                                                      ],
                                                    )

                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                      );
                                    }),
                            ),
                                )


                                : Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    })),


          ],
        ),
      )
    );
  }
}
