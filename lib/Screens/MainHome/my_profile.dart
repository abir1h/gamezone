import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/Starter_screens/Login_screen.dart';

import 'mainHome.dart';
import 'package:http/http.dart'as http;
class my_profile extends StatefulWidget {
  @override
  _my_profileState createState() => _my_profileState();
}

class _my_profileState extends State<my_profile> {
  TextEditingController first_name=TextEditingController();
  TextEditingController last=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController emailT=TextEditingController();
  TextEditingController phoneT=TextEditingController();
  TextEditingController promo=TextEditingController();
  TextEditingController _oldPassword=TextEditingController();
  TextEditingController _newPassword=TextEditingController();
  TextEditingController _confirmPassword=TextEditingController();
  bool isupdate=false;
  final _formKey = GlobalKey<FormState>();
  final _formKey_duo = GlobalKey<FormState>();
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
    setState(() {
      first_name.text=fname;
      last.text=lname;
      emailT.text=email;
      phoneT.text=phone;
      username.text=user;
    });

  }
  saveprefs(String usernamem,String email,String last_name, String first_name, )async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user_name', usernamem);
    prefs.setString('email', email);
    prefs.setString('last_name', last_name);
    prefs.setString('first_name', first_name);


  }

  Future edit(String firstname,String lastname,String username,String email)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.profile_update),


    );
    request.fields.addAll({
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'username': username,
      'phone':phoneT.text
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            isupdate=false;
          });
          var data = jsonDecode(response.body);
          print(data['status_code']);
       saveprefs(username, email,lastname, firstname);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));

          Fluttertoast.showToast(

              msg: "Profile Updated Succesfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);

        }else{
          setState(() {
            isupdate=false;
          });
          print(jsonDecode(response.body));
          Fluttertoast.showToast(

              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }

      );
    });
  }
  Future change_pass(String old,String new_pass)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.change_pass),


    );
    request.fields.addAll({
      'password': old,
      'new_password': new_pass,

    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            isupdate=false;
          });
          var data = jsonDecode(response.body);
          print(data['status_code']);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));

          Fluttertoast.showToast(

              msg: "Password change Updated Succesfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);

        }else{
          setState(() {
            isupdate=false;
          });
          print(jsonDecode(response.body));
          Fluttertoast.showToast(

              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }

      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF07031E),
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
        title: Text("My Profile",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Edit Profile",
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
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
                                    labelText:"First Name" ,
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
                                    labelText:"Last Name" ,

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
                                    labelText:"User Name" ,
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
                                controller: emailT, style: TextStyle(
                                  color: Colors.black
                              ),
                                validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                    hintText: "Email Address",
                                    labelText:"Email Address" ,
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
                              child:  Text("Mobile : "+phoneT.text,
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                isupdate=true;
                              });
                              if(_formKey.currentState.validate()){
                                edit(first_name.text, last.text, username.text, emailT.text);
                              }
                            },
                            child: Container(
                              height: height/20,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child:  Center(
                                child: isupdate==false?Text("Save".toUpperCase(),
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)):SpinKitThreeInOut(color: Colors.white,size: 20,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             Container(
               child: Form(
                 key: _formKey_duo,
                 child: Column(
                   children: [
                     Text("Change Password",
                         style: GoogleFonts.lato(
                             color: Colors.black,
                             fontWeight: FontWeight.w700,
                             fontSize: 14)),
                     Row(
                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: TextFormField(
                               obscureText: true,
                               controller: _oldPassword, style: TextStyle(
                                 color: Colors.black
                             ),
                               validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                               decoration: InputDecoration(
                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                   hintText: "Old Password",
                                   labelText:"Old Password" ,
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

                               controller: _newPassword, style: TextStyle(
                                 color: Colors.black
                             ),
                               validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                               decoration: InputDecoration(
                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                   hintText: "New Password",
                                   labelText:"New Password" ,
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

                               controller: _confirmPassword, style: TextStyle(
                                 color: Colors.black
                             ),
                               validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                               decoration: InputDecoration(
                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                   hintText: "Confirm Password",
                                   labelText:"Confirm Password" ,
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
                     SizedBox(height: 10,),
                     Center(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: InkWell(
                           onTap: (){
                             setState(() {
                               isupdate=true;
                             });
                             change_pass(_oldPassword.text, _newPassword.text);
                           },
                           child: Container(
                             height: height/20,
                             width: width,
                             decoration: BoxDecoration(
                               color: Colors.black,
                               borderRadius: BorderRadius.circular(5),

                             ),
                             child:  Center(
                               child: isupdate==false?Text("Save".toUpperCase(),
                                   style: GoogleFonts.lato(
                                       color: Colors.white,
                                       fontWeight: FontWeight.w700,
                                       fontSize: 18)):SpinKitThreeInOut(color: Colors.white,size: 20,),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             )
            ],
            ),
          ),
        ),
      )
    );
  }
}
