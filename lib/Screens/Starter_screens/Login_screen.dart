import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart'as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Register_screen.dart';
import 'forget_pass.dart';



class login_screen extends StatefulWidget {
  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  var token;
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }
  final _formKey = GlobalKey<FormState>();
  bool islogin=false;
  bool issave=false;
  TextEditingController email_ = TextEditingController();
  TextEditingController password_ = TextEditingController();
  Future login(String email,String password)async {
    Map<String, String> requestHeaders = {

      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.login),

    );
    request.fields.addAll({
      'phone': email,
      'password': password,
      'player_id':player_id,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {

          var data = jsonDecode(response.body);
          print(data['status_code']);
          print('response.body ' + data.toString());
          if(data['status_code']==200){
            setState(() {
           islogin=false;
            });

            print(data['token']['plainTextToken']);
            print(player_id);
            print(data['data']['username']);
saveprefs(data['token']['plainTextToken'], data['data']['phone'], data['data']['username'], data['data']['email'], data['data']['last_name'], data['data']['first_name']);
            print("Success! ");
            Fluttertoast.showToast(

                msg: "Login Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));



          }else{
            setState(() {
              islogin=false;
            });
            print("Fail! ");
            Fluttertoast.showToast(

                msg: "Unauthorized",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }else{
          print("Fail! ");
          setState(() {
            islogin=false;
          });

          print(jsonDecode(response.body));

          return response.body;

        }

      });
    });
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
  saveprefs(String token,String phone,String usernamem,String email,String last_name, String first_name, )async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('phone', phone);
    prefs.setString('user_name', usernamem);
    prefs.setString('email', email);
    prefs.setString('last_name', last_name);
    prefs.setString('first_name', first_name);
    setState(() {
      issave=true;
    });
if(issave==true){
  getdata();
}

  }

  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token=prefs.getString('token');
    var user=prefs.getString('user_name');
    var fname=prefs.getString('first_name');
    var lname=prefs.getString('last_name');
    var email=prefs.getString('email');
    var phone=prefs.getString('phone');
print('Token '+token);
print('fname= '+fname);
print('lname '+lname);
print('email '+email);
print('phoneno '+phone);
print('user '+user);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFF07031E),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:  MediaQuery.of(context).size.height/10,),

              Image.asset('Images/app_icon.png',height: 150,width: 150,),
              Padding(
                padding: const EdgeInsets.only(left:70.0,right:70),
                child: Divider(thickness: 10,color: Colors.white,),
              ),              SizedBox(height:  MediaQuery.of(context).size.height/30,),

              InkWell(
                onTap: (){
                  print(player_id);
                },
                child: Text("Sign In",style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 25
                )),
              ),

            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
              TextFormField(
                controller: email_, style: TextStyle(
                  color: Colors.white
              ),
                  validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.white, width: 2.0),),
                    hintText: "Phone",

                    hintStyle: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18
                    )
                  ),
              ),
                    SizedBox(height: height/15,),
                    Column(
                      children: [
                        TextFormField(
                controller: password_,
                          obscureText: true,
                          style: TextStyle(
                              color: Colors.white
                          ),
                  validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                  decoration: InputDecoration(

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.white, width: 2.0),),
                        hintText: "Password",
                        hintStyle: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18
                        )
                  ),
              ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>forget_password()));

                            },
                            child: Text("Forgot Password",style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14
                            )),
                          ),
                        )
                      ],
                    )
            ],),
                )),
              SizedBox(height:  MediaQuery.of(context).size.height/35,),

              islogin==false?InkWell(
                onTap: (){
                  if(_formKey.currentState.validate()){
                    setState(() {
                      islogin=true;
                    });
                    login(email_.text,password_.text);
                  }

                },
                child: Container(
                  height: height/15,
                  width: width/2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                  ),
                  child: Center(
                    child: Text("Log In",style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    )),
                  ),

                ),
              ):SpinKitThreeInOut(color: Colors.white,size: 20,),
              SizedBox(height:  MediaQuery.of(context).size.height/50,),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User ?",style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    )),InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>register_screen()));

                      },
                      child: Text(" Sign up",style: GoogleFonts.lato(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )),
                    ),
                  ],
                ),
              ) ,SizedBox(height:  MediaQuery.of(context).size.height/50,),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have Query ?",style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    )),InkWell(
                      onTap:()async{
                        var url='https://t.me/Sportclubadmin';

                        if (await canLaunch(url))
                          await launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                      },
                      child: Text(" Contact Us",style: GoogleFonts.lato(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
