import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/Starter_screens/Login_screen.dart';


class type_pass extends StatefulWidget {
  @override
  _type_passState createState() => _type_passState();
}

class _type_passState extends State<type_pass> {
  TextEditingController password_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                SvgPicture.asset(
                  "Images/undraw_my_password_d6kg.svg",
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: Text(
                      "Type your password",
                      style: TextStyle(
                          color: Colors.black, fontSize: 26, fontWeight: FontWeight.w900),
                    )),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38.0, right: 38),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) => value.isEmpty
                          ? "Please password"
                          : value.length < 5
                          ? "Password should be more than 5 digits"
                          : null,
                      controller: password_controller,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.indigoAccent,
                            size: 22,
                          ),
                          hintText: 'Enter your Password'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      print("Form validate");
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      String otpToken =
                      prefs.getString('confirmOTP');
                      String phone =
                      prefs.getString('phone');
                      Map<String, String> requestHeaders = {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                      };
                      Map mapData = {
                        'phone': phone,
                        'otp': otpToken,
                        'password': password_controller.text,
                      };
                      try {
                        var res = await http.post(
                            Uri.parse(
                                AppUrl.forget_verify),
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
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                Duration(milliseconds: 400),
                                transitionsBuilder: (BuildContext
                                context,
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
                                  return login_screen();
                                },
                              ));

                        } else {
                          Fluttertoast.showToast(
                              msg:  data['error'],
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
                            "GO".toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 26),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
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
