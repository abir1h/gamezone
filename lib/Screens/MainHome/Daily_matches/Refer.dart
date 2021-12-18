import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainHome.dart';
import 'my_referel.dart';
class refere extends StatefulWidget {
  @override
  _refereState createState() => _refereState();
}

class _refereState extends State<refere> {
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
      username=user;
    });
  }var username;
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
      backgroundColor: Color(0xFF07031E),
      appBar:AppBar(
        backgroundColor: Color(0xFF07031E),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
        },),
           actions: [
             PopupMenuButton(
                 onSelected: (value) {
                   print(value);
                   if(value==1){
                     print('tapped'+value.toString());
                     Navigator.push(context, MaterialPageRoute(builder: (_)=>my_refer()));
                   }


                 },
                 itemBuilder: (context) => [
                   PopupMenuItem(
                     child: Text("My Referrals"),
                     value: 1,
                   ),

                 ]
             )

           ],

      ) ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height/4,
               width: MediaQuery.of(context).size.width/2,

               decoration:BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 image: DecorationImage(
                   image: AssetImage('Images/rt.png'),
                   fit: BoxFit.cover
                 )
               ),
              ),
            ),
            Text('Refer More to Earn More'.toUpperCase(),
                style: GoogleFonts.lato(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Invite your friends on App Your Promo code to Earn ৳10 ,when they join their First match they also get ৳ 5',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                children: [
                  Text('Your Promo Code',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                  SizedBox(height: 15,),
                  Center(
                    child: Container(
                        height: height / 20,
                        width: width / 4,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors
                                    .black),
                            color:
                            Colors.orange),
                        child: Center(
                          child: Text(
                            username!=null?username:' ',
                            style: GoogleFonts.lato(
                                color: Colors
                                    .black,
                                fontWeight:
                                FontWeight
                                    .w700,
                                fontSize: 18),
                          ),
                        )),
                  ),
                  SizedBox(height: 30,),
                  Text('How Does it work!',
                      style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 25)),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Refer',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),  Icon(Icons.arrow_forward_ios,color: Colors.blue,size: 30,),

                      Text('Join a Match',
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)), Icon(Icons.arrow_forward_ios,color: Colors.blue,size: 30,),

                      Text('Get Reward',
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: ()async{
                    Share.share('Use my Referral Code- " $username " to get Free Balance!!   https://sportclubff.com', subject: 'Join Sport Club now !');

                  }, child: Text("Refer Now"))

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
