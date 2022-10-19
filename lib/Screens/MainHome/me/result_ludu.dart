import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/MainHome/Daily_matches/Result.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/prize_details.dart';
import 'package:url_launcher/url_launcher.dart';

class Result_ludu extends StatefulWidget {
  final String type,image;
  Result_ludu({this.type,this.image});
  @override
  _Result_luduState createState() => _Result_luduState();
}

class _Result_luduState extends State<Result_ludu> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.result + widget.type),
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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      slide = emergency();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      slide = emergency();
    });
    if (mounted)
      setState(() {
        slide = emergency();
      });
    _refreshController.loadComplete();
  }

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
    return Scaffold(
        backgroundColor: Colors.white,
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
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (_, __) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 48.0,
                                          height: 48.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  itemCount: 6,
                                ),
                              ),
                            );

                          default:
                            if (snapshot.hasError) {
                              Text('Error: ${snapshot.error}');
                            } else {
                              return snapshot.hasData
                                  ? snapshot.data.length > 0
                                  ? Container(
                                height: height / 1.2,
                                child: SmartRefresher(
                                  enablePullDown: true,
                                  enablePullUp: false,
                                  header: WaterDropHeader(),
                                  footer: CustomFooter(
                                    builder: (BuildContext context,
                                        LoadStatus mode) {
                                      Widget body;
                                      if (mode == LoadStatus.idle) {
                                        body = Text("pull up load");
                                      } else if (mode ==
                                          LoadStatus.loading) {
                                        body =
                                            CupertinoActivityIndicator();
                                      } else if (mode ==
                                          LoadStatus.failed) {
                                        body = Text(
                                            "Load Failed!Click retry!");
                                      } else if (mode ==
                                          LoadStatus.canLoading) {
                                        body = Text(
                                            "release to load more");
                                      } else {
                                        body = Text("No more Data");
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  onLoading: _onLoading,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        var total = int.parse(snapshot
                                            .data[index]
                                        ['total_participant']);
                                        var game =
                                        snapshot.data[index]
                                        ['game_player_count'];
                                        var left_ = total - game;
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              result_sc(
                                                                id: snapshot
                                                                    .data[index]['id']
                                                                    .toString(),
                                                              )));
                                                },
                                                child: Container(
                                                  width: width / 1,
                                                  decoration: BoxDecoration(
                                                      color: Color(
                                                          0xFF07031E),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child:
                                                                Container(
                                                                  child:
                                                                  Row(
                                                                    children: [
                                                                      CircularProfileAvatar(null,
                                                                          borderColor: Colors.transparent,
                                                                          child:  Image.asset(
                                                                            widget.image,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                          elevation: 5,
                                                                          radius: 30),
                                                                      Expanded(
                                                                        child: Container(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(snapshot.data[index]['title'] + ' | ' + snapshot.data[index]['control_type'] + ' | ' + snapshot.data[index]['game_id'],
                                                                                    style: GoogleFonts.lato(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    )),
                                                                                Row(
                                                                                  children: [
                                                                                    Text('Time : ' + snapshot.data[index]['date'],
                                                                                        style: GoogleFonts.lato(
                                                                                          color: Colors.red,
                                                                                          fontWeight: FontWeight.w600,
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
                                                              child:
                                                              Container(
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    Text('Total Prize', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                    Text(' ৳ ' + snapshot.data[index]['total_prize'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            // Expanded(
                                                            //   child:
                                                            //   Container(
                                                            //     child:
                                                            //     Column(
                                                            //       children: [
                                                            //         Text('Per Kill', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                            //         Text(' ৳ ' + snapshot.data[index]['per_kill'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    Text('Entry Fee', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                    Text(' ৳ ' + snapshot.data[index]['entry_fee'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                  ],
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
                                                              child:
                                                              Container(
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    Text('Type', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                    Text(snapshot.data[index]['type'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                child:
                                                                Column(
                                                                  children: [
                                                                    Text('Version', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                    Text(snapshot.data[index]['version'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            // Expanded(
                                                            //   child:
                                                            //   Container(
                                                            //     child:
                                                            //     Column(
                                                            //       children: [
                                                            //         Text('Map', style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
                                                            //         Text(snapshot.data[index]['map'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                            //       ],
                                                            //     ),
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
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: snapshot.data[index]['result'] != null
                                                                      ? snapshot.data[index]['result']['link'] != null
                                                                      ? Container(
                                                                      child: ElevatedButton(
                                                                        onPressed: () async {
                                                                          print(snapshot.data[index]['result']['link']);
                                                                          var url = snapshot.data[index]['result']['link'];
                                                                          if (await canLaunch(url))
                                                                            await launch(url);
                                                                          else
                                                                            // can't launch url, there is some error
                                                                            throw "Could not launch $url";
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.green, //background color of button
                                                                          elevation: 3, //elevation of button
                                                                        ),
                                                                        child: Text(
                                                                          "Watch",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                      : Container(
                                                                      child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Fluttertoast.showToast(msg: "Not Uploaded Yet!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.white54, textColor: Colors.white, fontSize: 16.0);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.green, //background color of button
                                                                          elevation: 3, //elevation of button
                                                                        ),
                                                                        child: Text(
                                                                          "Watch",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                      : Container(
                                                                      child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Fluttertoast.showToast(msg: "Not Uploaded Yet!", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.white54, textColor: Colors.white, fontSize: 16.0);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.green, //background color of button
                                                                          elevation: 3, //elevation of button
                                                                        ),
                                                                        child: Text(
                                                                          "Watch",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ))),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: snapshot.data[index]['game_player_have'] == 0
                                                                      ? Container(
                                                                      child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => result_sc(
                                                                                    id: snapshot.data[index]['id'].toString(),
                                                                                  )));
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.blue, //background color of button
                                                                          side: BorderSide(width: 3, color: Colors.blue), //border width and color
                                                                          elevation: 3, //elevation of button
                                                                        ),
                                                                        child: Text(
                                                                          "Match Results",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                      : Container(
                                                                      child: ElevatedButton(
                                                                        onPressed: () {},
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: Colors.blue, //background color of button
                                                                          side: BorderSide(width: 3, color: Colors.blue), //border width and color
                                                                          elevation: 3, //elevation of button
                                                                        ),
                                                                        child: Text(
                                                                          "Joined",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ))),
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
                                                              child:
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 8.0,
                                                                    right: 8.0,
                                                                    bottom: 8.0),
                                                                child: Container(
                                                                    child: ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        showDialog(
                                                                            context: context,
                                                                            builder: (context) {
                                                                              return prize_details(
                                                                                id: snapshot.data[index]['id'].toString(),
                                                                              );
                                                                            });
                                                                      },
                                                                      style:
                                                                      ElevatedButton.styleFrom(
                                                                        primary: Colors.white, //background color of button
                                                                        side: BorderSide(width: 3, color: Colors.blue), //border width and color
                                                                        elevation: 3, //elevation of button
                                                                      ),
                                                                      child:
                                                                      Text(
                                                                        "Total Prize Details",
                                                                        style: TextStyle(
                                                                          color: Colors.blue,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              )
                                  : Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height / 5,
                                      ),
                                      Image.asset(
                                        'Images/gt.gif',
                                        height: height / 4,
                                      ),
                                    ],
                                  ))
                                  : Text('No data');
                            }
                        }
                        return CircularProgressIndicator();
                      })),
            ],
          ),
        ));
  }
}
