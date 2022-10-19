import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'Login_screen.dart';
import 'Otp_Screen.dart';

class register_screen extends StatefulWidget {
  @override
  _register_screenState createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  TextEditingController first_name=TextEditingController();
  TextEditingController last=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController promo=TextEditingController();
  TextEditingController Password=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future registerApi_(String fname,String lname,String email,String phone,String password_,String promo,String Username )async {
    Map<String, String> requestHeaders = {

      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.reg),

    );
    request.fields.addAll({
      'first_name': fname,
      'last_name': lname,
      'email': email,
      'username': Username,
      'phone': phone,
      'password': password_,
      'promo_code':promo
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 201) {

          var data = jsonDecode(response.body);
          print(data);
          print('response.body ' + data.toString());
          Fluttertoast.showToast(

              msg: "Register Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));

        }else{
          print("Fail! ");
          var data = jsonDecode(response.body);


          data['error']['phone'] != null && data['error']['username'] != null
              ? Fluttertoast.showToast(
              msg: data['error']['phone'][0] +
                  '\n' +
                  data['error']['username'][0],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0)
              : data['error']['phone'] == null &&
              data['error']['username'] != null
              ? Fluttertoast.showToast(
              msg: data['error']['username'][0],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0)
              : data['error']['phone'] != null &&
              data['error']['username'] == null
              ? Fluttertoast.showToast(
              msg: data['error']['phone'][0],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0)
              : Fluttertoast.showToast(
              msg: 'error',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);

          return response.body;

        }

      });
    });
  }

  Future registerApi(String fname,String lname,String email,String phone,String password_,String promo ) async {
    Map mapData = {
      'first_name': fname,
      'last_name': lname,
      'email': email,
      'phone': phone,
      'password': password_,
      'promo_code':promo
    };

    // ignore: unnecessary_brace_in_string_interps
    print("JsonData ${mapData}");

    var res = await http.post(
        Uri.parse(AppUrl.reg),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(mapData));

    print("registerApi api loaded");

    if (res.statusCode==201) {
      Fluttertoast.showToast(

          msg: "Otp Sent  Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0);
      print("navigate");
    }else{
      var data = jsonDecode(res.body);
      Fluttertoast.showToast(

          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      appBar: AppBar(
        backgroundColor:Color(0xFF07031E),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => login_screen()));
          },
        ),
        title: Text("Create Account",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 10,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height / 1.1,
                    width: width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: height/8,),
                        Form(
                            key: _formKey,
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: first_name, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "First Name",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: last, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "Last Name",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: username, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "User Name",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: phone, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "Phone",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: email, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "Email",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: Password, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "Password",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: promo, style: TextStyle(
                                        color: Colors.black
                                    ),
                                      // validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                          hintText: "Promo Code ( Optional )",

                                          hintStyle: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14
                                          )
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            InkWell(
                              onTap: (){
                                if(_formKey.currentState.validate()){
                                  registerApi_(first_name.text, last.text, email.text, phone.text, Password.text,promo.text,username.text);

                                }
                              },
                              child: Container(
                                height: height/15,
                                width: width/2,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                child: Center(
                                  child: Text("Register",style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20
                                  )),
                                ),

                              ),
                            ),
                            SizedBox(height:  MediaQuery.of(context).size.height/50,),

                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account ?",style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  )),InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));

                                    },
                                    child: Text(" Sign In",style: GoogleFonts.lato(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16
                                    )),
                                  ),
                                ],
                              ),
                            )


                          ],
                        ))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height / 5000,
                  left: width / 2.8,
                  child: CircularProfileAvatar(
                    null,
                    borderColor: Colors.black,
                    borderWidth: 3,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.person),
                    ),
                    elevation: 5,
                    radius: 50

                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
