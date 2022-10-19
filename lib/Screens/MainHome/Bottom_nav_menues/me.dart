import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Refer.dart';
import 'package:sports_club/Screens/MainHome/Developer_page.dart';
import 'package:sports_club/Screens/MainHome/me/my_wallet.dart';
import 'package:sports_club/Screens/MainHome/me/statistics.dart';
import 'package:sports_club/Screens/Starter_screens/Login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../my_profile.dart';
import 'package:http/http.dart'as http;

class me extends StatefulWidget {
  @override
  _meState createState() => _meState();
}

class _meState extends State<me> {
  Future logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return await http.post(
      Uri.parse(AppUrl.logout),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': "Bearer $token",
      },
    );
  }
  var balance_ammount,match_played,total_kills,paid;
  Future blaanceofuser,det;
  var telegram_link;
  Future details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.match_count), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['matchCount']);
      setState(() {
        match_played=userData1['matchCount'];
        total_kills=userData1['killCount'];
        paid=userData1['deposit'];
        balance_ammount=userData1['balance'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var complain;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.telegram), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['link']);
      setState(() {
        telegram_link=userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future complain_() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.complain), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['link']);
      setState(() {
        complain=userData1['link'];
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
    det=details();
    telegram();
    complain_();
  }
  // RefreshController _refreshController =
  // RefreshController(initialRefresh: false);
  //
  // void _onRefresh() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }
  //
  // void _onLoading() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   if(mounted)
  //     setState(() {
  //       det=details();
  //
  //     });
  //   _refreshController.loadComplete();
  // }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF07031E),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height / 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CircularProfileAvatar(null,
                          borderColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.person),
                          ),
                          elevation: 5,
                          radius: 30),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            match_played!=null?  Text(match_played.toString(),
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)):Text('...',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                            Text('Match Played',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            total_kills!=null?  Text(total_kills.toString(),
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)):Text('...',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                            Text('Total KIlls',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            paid!=null?  Text('৳'+paid.toString(),
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)):Text('...',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18)),
                            Text('Paid',
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height / 15,
              ),
              Container(
                child: Column(
                  children: [
                    balance_ammount!=null?  Text('৳'+balance_ammount.toString(),
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)):Text('...',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    Text('Available Balance',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    ListTile(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (_)=>refere()));
                      },
                      leading: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                      ),
                      title:  Text('Refer & Earn',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (_)=>my_profile()));
                      },
                      leading: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title:  Text('My Profile',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        logoutApi();

                        Navigator.push(context, MaterialPageRoute(builder: (_)=>my_wallet()));

                      },
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      title:  Text('My Wallet',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: ()async{
                        var url=complain;

                        if (await canLaunch(url))
                          await launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                      },
                      leading: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      title:  Text('Complain Box',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>statistics()));


                      },
                      leading: Icon(
                        Icons.analytics,
                        color: Colors.white,
                      ),
                      title:  Text('Statistics',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        Share.share('check out my website https://gamezonetour.com/', subject: 'Look what I made!');
                      },
                      leading: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      title:  Text('Share',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        pushNewScreen(context, screen: developer_page());
                      },
                      leading: Icon(
                        Icons.class_,
                        color: Colors.white,
                      ),
                      title:  Text('Developers Profile',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      onTap: ()async{
                        SharedPreferences preferences = await SharedPreferences. getInstance(); await preferences. clear();
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title:  Text('Log out',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
