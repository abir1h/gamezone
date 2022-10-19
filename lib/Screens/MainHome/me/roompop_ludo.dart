import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';

class roompop_ludo extends StatefulWidget {
  final String id;
  roompop_ludo({this.id});

  @override
  _roompop_ludoState createState() => _roompop_ludoState();
}

class _roompop_ludoState extends State<roompop_ludo> {
  Future slide;
  var message;
  Future emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.room_details + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      var userData2 = jsonDecode(response.body)['messageData'];
      print("Thjis");
      print(userData1);
      print(userData2);
      setState(() {
        message = userData2['message'];
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
    slide = emergency();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );
  }

  contentBox(context) {
    String _chosenValue;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                width: width,
                color: Color(0xFFFFD700),
                child: Center(
                  child: Column(
                    children: [
                      Text('Room Details',
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
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
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Text(
                                              snapshot.data[0]['type'] +
                                                  " | " +
                                                  snapshot.data[0]
                                                  ['control_type'] +
                                                  ' | ' +
                                                  snapshot.data[0]
                                                  ['game_id'],
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.w600,
                                              )),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                        height:
                                                        height / 25,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: Colors
                                                                .white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Type :",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                            Flexible(
                                                                child:
                                                                Text(
                                                                  snapshot.data[
                                                                  0][
                                                                  'type'],
                                                                  style:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                )),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: Colors
                                                                .white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Board Type :",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                            Flexible(
                                                                child:
                                                                Text(
                                                                  snapshot.data[
                                                                  0][
                                                                  'version'],
                                                                  style:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                )),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Padding(
                                                //     padding:
                                                //     const EdgeInsets
                                                //         .all(8.0),
                                                //     child: Container(
                                                //         decoration: BoxDecoration(
                                                //             borderRadius:
                                                //             BorderRadius
                                                //                 .circular(
                                                //                 20),
                                                //             color: Colors
                                                //                 .white),
                                                //         child: Row(
                                                //           mainAxisAlignment:
                                                //           MainAxisAlignment
                                                //               .center,
                                                //           children: [
                                                //             Text(
                                                //               "Map :",
                                                //               style:
                                                //               TextStyle(
                                                //                 color: Colors
                                                //                     .grey,
                                                //                 fontWeight:
                                                //                 FontWeight
                                                //                     .bold,
                                                //               ),
                                                //             ),
                                                //             Flexible(
                                                //                 child:
                                                //                 Text(
                                                //                   snapshot.data[
                                                //                   0]
                                                //                   ['map'],
                                                //                   style:
                                                //                   TextStyle(
                                                //                     color: Colors
                                                //                         .black,
                                                //                     fontWeight:
                                                //                     FontWeight
                                                //                         .bold,
                                                //                   ),
                                                //                 )),
                                                //           ],
                                                //         )),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                        height:
                                                        height / 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: Colors
                                                                .white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Match Type :",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Paid",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                        height:
                                                        height / 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            color: Colors
                                                                .white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Entry Fee :",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "৳ " +
                                                                  snapshot.data[0]
                                                                  [
                                                                  'entry_fee'],
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                      margin:
                                                      EdgeInsets.only(
                                                          left: 50,
                                                          right: 50),
                                                      height: height / 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20),
                                                          color: Colors
                                                              .white),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            "Time :",
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot.data[
                                                            0]
                                                            ['date'],
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
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
                                                fontWeight:
                                                FontWeight.w600,
                                              )),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                      height: height / 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20),
                                                          color: Colors
                                                              .white),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            "Winner :",
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "৳ " +
                                                                snapshot.data[
                                                                0]
                                                                [
                                                                'total_prize'],
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                      height: height / 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20),
                                                          color: Colors
                                                              .white),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Text(
                                                            "Per Kill :",
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "৳ " +
                                                                snapshot.data[
                                                                0]
                                                                [
                                                                'per_kill'],
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
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
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              5),
                                                          color: Colors
                                                              .orange),
                                                      child: Column(
                                                        children: [
                                                          message != null
                                                              ? Text(
                                                            "Room Details",
                                                            style:
                                                            TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          )
                                                              : Text(''),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Flexible(
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        8.0),
                                                                    child:
                                                                    SelectableText(
                                                                      message !=
                                                                          null
                                                                          ? message
                                                                          : "Room Details Will be shared Before 8 to 10 minutes of  match.",
                                                                      style:
                                                                      TextStyle(
                                                                        color:
                                                                        Colors.white,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Text('No data');
                            }
                        }
                        return Text("Not Uploaded Yet!!",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ));
                      })),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                          child: Text(
                            "Close",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
