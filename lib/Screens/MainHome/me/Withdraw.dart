import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';

import '../mainHome.dart';
import 'package:http/http.dart'as http;
class withdraw extends StatefulWidget {
  @override
  _withdrawState createState() => _withdrawState();
}

class _withdrawState extends State<withdraw> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mobile=TextEditingController();
TextEditingController amount=TextEditingController();
bool isrequsted=false;
var balance_ammount;
Future blaanceofuser;

  Future withdraw(String wallettype,String phone,String Ammount)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.withdraw),


    );
    request.fields.addAll({
      'wallet_type': wallettype,
      'phone_number': phone,
      'withdraw_money': Ammount,
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
              isrequsted=false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
            Fluttertoast.showToast(

                msg: "Withdraw Request Placed Successfully",
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
            Fluttertoast.showToast(

                msg: "Insufficient Balance",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);          return response.body;

          }
        }
        }

      );
    });
  }
  var bkash_,rocket_,nagad_;
  var player_id;
  func()async{
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
    setState(() {
      player_id=playerId;
    });


  }
  Future balance() async {
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
      print(userData1['balance']);
      setState(() {
        balance_ammount=userData1['balance'];
        win=userData1['winingBalance'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var win;

  bool ischecked=false;
  bool rocket=false;
  bool Nagad=false;
  var selected_country;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    blaanceofuser=balance();
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
        title: Text("Withdraw",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height/20,),
            Text('Available Amount',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,)),  Text('৳'+win.toString(),
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,)),

            Center(child: Image.asset('Images/money.png',width: 100,height: 50,)),
            SizedBox(height: height/20,),

            Text('Select Payment Method',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,)),
            SizedBox(height: height/30,),

            Row(
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
                    height:MediaQuery.of(context).size.height/10,
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
                            height:MediaQuery.of(context).size.height/12,
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
                                  Image.asset("Images/nagad.jpg",height: 40,width: 30,),
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
            Container(
              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        controller: mobile, style: TextStyle(
                          color: Colors.black
                      ),
                        validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                            hintText: "Mobile Number",

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
                        controller: amount, style: TextStyle(
                          color: Colors.black
                      ),
                        validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                            hintText: "Amount To be Withdraw",

                            hintStyle: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text('*Minimum Withdraw Ammount 100',
                style: GoogleFonts.lato(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,)),
            SizedBox(height: height/20,),

           isrequsted==false? Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: (){
                   if(_formKey.currentState.validate()){
                     setState(() {
                       isrequsted=true;
                     });
                     if( int.parse(amount.text)>=100){
                       setState(() {
                         isrequsted=true;
                       });
                       if(int.parse(amount.text)<=win ){

                         withdraw(selected_country, mobile.text, amount.text);

                       }else{
                         setState(() {
                           isrequsted=false;
                         });
                         Fluttertoast.showToast(

                             msg: "Withdraw should exceed available ammount",
                             toastLength: Toast.LENGTH_LONG,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIosWeb: 3,
                             backgroundColor: Colors.red,
                             textColor: Colors.white,
                             fontSize: 16.0);
                       }
                     }else{
                       setState(() {
                         isrequsted=false;
                       });
                       Fluttertoast.showToast(

                           msg: "Withdraw should be minimum 100 BDT",
                           toastLength: Toast.LENGTH_LONG,
                           gravity: ToastGravity.BOTTOM,
                           timeInSecForIosWeb: 3,
                           backgroundColor: Colors.red,
                           textColor: Colors.white,
                           fontSize: 16.0);
                     }

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
                      child: Text("Withdraw".toUpperCase(),
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

    );
  }
}
