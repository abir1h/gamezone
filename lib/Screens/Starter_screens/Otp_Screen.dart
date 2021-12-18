import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';

import 'Login_screen.dart';
class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  OtpVerificationScreen({this.phone});
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  String pass='';
  TextEditingController codeController = TextEditingController();
  TextEditingController email = TextEditingController();
  bool issave=false;



  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future otpconfirm(String otp)async{

    Map<String, String> requestHeaders = {

      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.otp),

    );
    request.fields.addAll({
      'otp': otp,
      'phone':widget.phone
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


            saveprefs(data['token']['plainTextToken'], data['data']['phone'], data['data']['username'], data['data']['email'], data['data']['last_name'], data['data']['first_name']);

            Fluttertoast.showToast(

                msg: "Registered Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));



          }else{
            print("Fail! ");
            Fluttertoast.showToast(

                msg: data['message'],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }else{
          print("Fail! ");

          return response.body;

        }

      });
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

  // ignore: unused_element
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // ignore: unused_field
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    codeController.clear();
  }

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(

            msg: "Can't go back at this stage!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text("OTP Screen",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
              SvgPicture.asset(
                "Images/OTP Image.svg",
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: InkWell(
                    onTap: (){
                      print(widget.phone);
                    },
                    child: Text(
                      "Enter 6 Digit OTP here!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        border:UnderlineInputBorder(),
                        hintText: "Enter Code",
                        hintStyle: TextStyle(
                            fontSize: 19, color: Colors.black.withOpacity(0.6)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0)),
                    validator: (String value) {
                      if (!RegExp(r"[\d]{6}").hasMatch(value)) {
                        return "Please provide a valid OTP";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async{
                  if (_formKey.currentState.validate()) {
                    otpconfirm(codeController.text);
                  } else {}
                },
                child: Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Go".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 24),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),


            ],
          ),
        ),
      ),
    );
  }
}
