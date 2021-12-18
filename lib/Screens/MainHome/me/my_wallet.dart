import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Refer.dart';
import 'package:sports_club/Screens/MainHome/me/transaction_history.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mainHome.dart';
import 'Withdraw.dart';
import 'depostie.dart';
import'package:http/http.dart'as http;


class my_wallet extends StatefulWidget {
  @override
  _my_walletState createState() => _my_walletState();
}

class _my_walletState extends State<my_wallet> {

  var balance_ammount;
  Future blaanceofuser;
  // Future balance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');
  //
  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };
  //
  //   var response = await http.get(Uri.parse(AppUrl.transaction_hostory), headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     print('Get post collected' + response.body);
  //     var userData1 = jsonDecode(response.body)['data'];
  //     print(userData1);
  //     print(userData1['balance']);
  //     setState(() {
  //       balance_ammount=userData1['balance'];
  //       win_earn=userData1['winingBalance'];
  //     });
  //     return userData1;
  //   } else {
  //     print("post have no Data${response.body}");
  //   }
  // }
  var win_earn,deposite_earn,refere_earn;
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
        deposite_earn=userData1['deposit'];
        refere_earn=userData1['ref_earn'];
        balance_ammount=userData1['balance'];
        win_earn=userData1['winingBalance'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var telegram_link;
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

  Future det;
  Timer notification_timer;
  @override
  void dispose() {
    // TODO: implement dispose
    // notification_timer.cancel();


    super.dispose();

  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      det=details();

    });
    if(mounted)
      setState(() {
        det=details();

      });
    _refreshController.loadComplete();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // blaanceofuser=balance();
    det=details();
    // notification_timer=Timer.periodic(Duration(seconds: 10), (_) => det=details());
    telegram();
    get_playerd();
  }
  var p_id;
  get_playerd()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String player_id = prefs.getString('player_ID');

    setState(() {
      p_id=player_id;
    });


  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
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
        title: InkWell(
          onTap: (){
            print(p_id);
          },
          child: Text("My Wallet",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height / 30,
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height / 1,
              width: width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: height / 1,

                  child: Column(

                    children: [
                      SizedBox(height:height/40 ,),
                      Column(
                        children: [
                          Text("Total Balance",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)), balance_ammount!=null?Text("৳ "+balance_ammount.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)):Text("৳.."               .toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)),
                        ],
                      ),

                      Center(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>transaction_history()));

                                  },
                                  child: Container(

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                        Text("View Transaction History",
                                            style: GoogleFonts.lato(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                        Icon(Icons.arrow_forward_ios,color: Colors.grey,),

                                      ],),
                                       ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                  Icon(Icons.wine_bar,color: Colors.yellow,),
                                  Text("Winning Balance",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  Icon(Icons.info,color: Colors.grey,),

                                ],),
                  Text(win_earn!=null?"৳ "+win_earn.toString():"..",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>withdraw()));

                              },
                              child: Container(
                                height: height/20,
                                width: width/3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.green

                                ),
                                child: Row(
                                  children: [
                                    IconButton(icon: Icon(Icons.transfer_within_a_station,color: Colors.white,),),
                                    Text("Withdraw",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                  Icon(Icons.account_balance,color: Colors.blue,),
                                  Text("Deposit Cash",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  Icon(Icons.info,color: Colors.grey,),

                                ],),
                  Text(deposite_earn!=null?"৳ "+deposite_earn.toString():"...",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (_) =>             deposite()));
                              },
                              child: Container(
                                height: height/20,
                                width: width/3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.blue

                                ),
                                child: Row(
                                  children: [
                                    IconButton(icon: Icon(Icons.add_circle,color: Colors.white,),),
                                    Text("Add More",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Icon(Icons.card_giftcard,color: Colors.redAccent,),
                                    Text("Refer",
                                        style: GoogleFonts.lato(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                    Icon(Icons.info,color: Colors.grey,),

                                  ],),
          Text(refere_earn!=null?"৳ "+refere_earn.toString():"..",
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>refere()));

                              },
                              child: Container(
                                height: height/20,
                                width: width/2.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.deepPurpleAccent

                                ),
                                child: Row(
                                  children: [
                                    IconButton(icon: Icon(Icons.share,color: Colors.white,),),
                                    Text("Refer&Earn",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                                  ],
                                ),
                              ),
                            ),
                          )

                        ],
                      ),Divider(color: Colors.black,),

                      Container(
                          constraints: BoxConstraints(),
                          child: FutureBuilder(
                              future: det,
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
                                          ? ListView.builder(

                                          shrinkWrap: true,
                                          itemCount: snapshot.data['tutorial'].length,
                                          itemBuilder: (_,index){
                                            return Column(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(children: [
                                                                Flexible(child: Icon(Icons.play_circle_fill_outlined,color: Colors.redAccent,)),
                                                                Flexible(
                                                                  child: Text(snapshot.data['tutorial'][index]['english_title'],
                                                                      style: GoogleFonts.lato(
                                                                          color: Colors.grey,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 14)),
                                                                ),


                                                              ],),
                                                              Text(snapshot.data['tutorial'][index]['bangla_title'],
                                                                  style: GoogleFonts.lato(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 18)),],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: ElevatedButton.icon(

                                                         onPressed:()async{

                                                           var url=snapshot.data['tutorial'][index]['links'];
                                                           if (await canLaunch(url))
                                                           await launch(url);
                                                           else
                                                           // can't launch url, there is some error
                                                           throw "Could not launch $url";

                                                         },
                                                              icon: IconButton(icon:  Icon(Icons.play_circle_fill_outlined,color: Colors.redAccent,),
                                                              ),
                                                              label: Flexible(child: Text("ভিডিও দেখুন",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                                              ),
                                                            )
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          })
                                          : Text('No data');
                                    }
                                }
                                return CircularProgressIndicator();
                              })),
Center(child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Text(

    'টাকা অ্যাড না হলে এখানে টেক্সট করুন',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,)

  ),
),),

                      ElevatedButton.icon(
onPressed:()async{
  var url=telegram_link;
  if (await canLaunch(url))
    await launch(url);
  else
    // can't launch url, there is some error
    throw "Could not launch $url";
},
                        icon: IconButton(icon:  Icon(Icons.message,color: Colors.white,),
                        ),
                        label: Flexible(child: Text("Contact Us",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),


            ],
          ),
        ),
      ),
    );
  }
}
