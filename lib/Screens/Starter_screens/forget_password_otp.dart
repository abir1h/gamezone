import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart'as http;
import 'package:sports_club/Screens/Starter_screens/Type_pass.dart';

class forget_password_otp extends StatefulWidget {
  @override
  _forget_password_otpState createState() => _forget_password_otpState();
}

class _forget_password_otpState extends State<forget_password_otp> {
  Future saveToken(value) async {
    // Async func to handle Futures easier; or use Future.then
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('confirmOTP', value);
    print(">>>>>>>>>>>>this is the Number$prefs");

    return prefs.setString("confirmOTP", value);
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    child: Text(
                      "Enter 6 Digit OTP code here",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    )),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Form(
                      key:_formKey,
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
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
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async{

                    if(_formKey.currentState.validate()){
                      saveToken(_controller.text);
                      print(_controller.text);
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                            Duration(milliseconds: 400),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutQuint);
                              return ScaleTransition(
                                alignment: Alignment.center,
                                scale: animation,
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation) {
                              return type_pass();
                            },
                          ));
                    }
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
                           "Submit".toUpperCase(),
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
              ],
            ),
          ),
        ));
  }
}
Future Resent_otp(String phone) async {
  Map mapData = {
    'phone':phone
  };

  // ignore: unnecessary_brace_in_string_interps
  print("JsonData ${mapData}");

  Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  try {
    var res = await http.post(
        Uri.parse(
            "https://goals.vivaldi.com.bd/api/auth/resentOtp"),
        headers: requestHeaders,
        body: jsonEncode(mapData));
    print(mapData);
    var data = jsonDecode(res.body);
    print("forget-password/verify loaded");
    print(data);
    print(data['success']);

    if (data['success'] !=
        false) {
      print("valid otp");
      Fluttertoast.showToast(

          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);

    } else {
      Fluttertoast.showToast(
          msg: data['error'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Invalid mobile",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}



