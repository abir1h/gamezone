import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import 'forget_password_otp.dart';
class forget_password extends StatefulWidget {
  @override
  _forget_passwordState createState() => _forget_passwordState();
}

class _forget_passwordState extends State<forget_password> {
  TextEditingController _controller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future saveToken(value) async {
    // Async func to handle Futures easier; or use Future.then
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', value);
    print(">>>>>>>>>>>>this is the Number$value");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.indigoAccent,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:Column(
        children: [
          SvgPicture.asset("Images/OTP Image.svg",height: 200,width: 200,),SizedBox(height: 15,),
          Center(child: Text("Forget Password",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.w900),)),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left:38.0,right: 38),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                validator: (String value) {
                  if (!RegExp(r"[\d]{6}").hasMatch(value)) {
                    return "Please provide a valid Number";
                  }
                  return null;
                },
                decoration:  InputDecoration(

                  hintText:"Enter Phone",

                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: ()async{

              if(_formKey.currentState.validate()){
                Map<String, String> requestHeaders = {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                };

                try {
                  var res = await http.post(
                      Uri.parse(
                          "https://sportclubff.com/api/forget/password"),
                      headers: requestHeaders,
                      body: jsonEncode(
                          {'phone': _controller.text}));
                  var data = jsonDecode(res.body);
                  print(data);
                  if (data['success'] == true) {
                    print("forget-password loaded");
                    saveToken(_controller.text);
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
                            return forget_password_otp();
                          },
                        ));
                  } else {
                    Fluttertoast.showToast(

                        msg: data['message'],
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } catch (e) {
                  Fluttertoast.showToast(

                      msg: "Error",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
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
                    Text("Continue",style: TextStyle(fontWeight:FontWeight.w700,color: Colors.white,fontSize: 24),),

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
    );
  }
}
