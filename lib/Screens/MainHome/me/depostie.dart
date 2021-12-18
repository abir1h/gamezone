import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import '../mainHome.dart';
class deposite extends StatefulWidget {
  @override
  _depositeState createState() => _depositeState();
}

class _depositeState extends State<deposite> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mobile=TextEditingController();
  TextEditingController amount=TextEditingController();
  bool isrequsted=false;
  var bkash_,rocket_,nagad_;
  Future blaanceofuser;  Future balance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.transaction_hostory), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['balance']);
      setState(() {

      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var player_id;
  func()async{
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
    setState(() {
      player_id=playerId;
    });


  }
  Future withdraw(String wallettype,String phone,String Ammount)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.deposite),


    );
    request.fields.addAll({
      'wallet_type': wallettype,
      'phone_number': phone,
      'send_money': Ammount,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            isrequsted=false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
          Fluttertoast.showToast(

              msg: "Deposit Request Placed Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }else{
          setState(() {
            isrequsted=false;
          });
          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(

              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);          return response.body;

        }
      }

      );
    });
  }
  bool submited=false;
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.bkash
    ), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  bool ischecked=false;
  bool rocket=false;
  bool Nagad=false;
  var selected_country;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slide=emergency();
    func();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
            print(player_id);
          },
          child: Text("Deposit",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
      ),
body: SingleChildScrollView(
  child:   Column(
    children: [
      SizedBox(height: 15,),
      Container(
          height: height/5,
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
                          ?
                      Container(
                        child: Column(
                          children: [

                            Container(

                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (_, index) {

                                    print(snapshot.data.length);


                                    return         Column(
                                      children: [
                                        Container(

                                          child: Row(
                                            children: <Widget>[

                                              Image.asset(snapshot.data[index]['wallet_type']=='bkash'?'Images/bkas.png':snapshot.data[index]['wallet_type']=='nagod'?'Images/nagad.jpg':'Images/rocket.png',height: 40,width: 50,),
                                              SizedBox(width: 10,),
                                              Row(
                                                children: [
                                                  SelectableText(snapshot.data[index]['wallet_number'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.w500,
                                                      )),Text("(Send Money /Cash In)Minimum\n10 TK",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )




                          : Text('No data');
                    }
                }
                return CircularProgressIndicator();
              })),

      SizedBox(height: height/25,),

      Center(child:  Text("Instructions",
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500,
          )),),
      Container(
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: amount, style: TextStyle(
                    color: Colors.black
                ),
                  validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                      hintText: "কত টাকা পাঠিয়েছেন",

                      hintStyle: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: mobile, style: TextStyle(
                    color: Colors.black
                ),
                  validator: (value)=>value.isEmpty?"Field Can't be empty":value.length<3?"Enter Last 4 Digit":value.length>4?"Digit limit 4":null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                      hintText: " নাম্বার এর শেষ ৪ ডিজিট"
                          ,

                      hintStyle: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                      )
                  ),
                ),
              ),
              Center(child:  Text("Select Payment Method",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height:MediaQuery.of(context).size.height/12,
                        width: MediaQuery.of(context).size.width/2,
                        child: Stack(
                          children: [

                            InkWell(
                              onTap:(){
                                setState(() {
                                  ischecked=true;
                                  rocket=false;
                                  Nagad=false;
                                  selected_country='bkash';
                                });
                                print(selected_country);
                              },
                              child: Container(
                                height:MediaQuery.of(context).size.height/10,
                                width: MediaQuery.of(context).size.width/3,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Row(
                                    children: [
                                      Image.asset("Images/bkas.png",height: 40,width: 20,),
                                      Text("Bkash"),
                                    ],
                                  )),
                                ),

                              ),
                            ),
                            Positioned(
                                top: -20,
                                left: MediaQuery.of(context).size.width/6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ischecked==true?Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.indigoAccent,),):Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.transparent,),),
                                )),


                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),

                    Expanded(
                      child: Container(
                        height:MediaQuery.of(context).size.height/12,
                        width: MediaQuery.of(context).size.width/2,
                        child: Stack(
                          children: [

                            InkWell(
                              onTap:(){
                                setState(() {
                                  ischecked=false;
                                  rocket=true;
                                  Nagad=false;
                                  selected_country='rocket';
                                });
                                print(selected_country);
                              },
                              child: Container(
                                height:MediaQuery.of(context).size.height/10,
                                width: MediaQuery.of(context).size.width/3,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Row(
                                    children: [
                                      Image.asset("Images/rocket.png",height: 40,width: 30,),
                                      Text("Rocket"),
                                    ],
                                  )),
                                ),

                              ),
                            ),
                            Positioned(
                                top: -20,
                                left: MediaQuery.of(context).size.width/6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: rocket==true?Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.indigoAccent,),):Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.transparent,),),
                                )),


                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),

                    Expanded(
                      child: Container(
                        height:MediaQuery.of(context).size.height/12,
                        width: MediaQuery.of(context).size.width/2,
                        child: Stack(
                          children: [

                            InkWell(
                              onTap:(){
                                setState(() {
                                  ischecked=false;
                                  rocket=false;
                                  Nagad=true;
                                  selected_country='nagad';
                                });
                                print(selected_country);
                              },
                              child: Container(
                                height:MediaQuery.of(context).size.height/10,
                                width: MediaQuery.of(context).size.width/3,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Row(
                                    children: [
                                      Image.asset("Images/nagad.jpg",height: 40,width: 20,),
                                      Text("Nagad"),
                                    ],
                                  )),
                                ),

                              ),
                            ),
                            Positioned(
                                top: -20,
                                left: MediaQuery.of(context).size.width/6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Nagad==true?Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.indigoAccent,),):Container(
                                    height: 50,
                                    width: 50,

                                    child: Icon(Icons.check_circle,color:Colors.transparent,),),
                                )),


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("* ভেরিফাই করার আগে সেন্ড মানি করতে হবে নাহয় ভেরিফিকেশন সফল হবেনা",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    )),
              ),),
             isrequsted==false? Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        isrequsted=true;
                      });
                      if(_formKey.currentState.validate()){
withdraw(selected_country, mobile.text, amount.text);
                        print(selected_country);
                      }
                    },
                    child: Container(
                      height: height/20,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),

                      ),
                      child:  Center(
                        child: Text("Verify Payment".toUpperCase(),
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              ):Center(child: SpinKitThreeInOut(color: Colors.orange,size: 20,),),

            ],
          ),
        ),
      ),

    ],
  ),
),

    );
  }
}
