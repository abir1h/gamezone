import 'package:flutter/material.dart';
class rough extends StatefulWidget {
  @override
  _roughState createState() => _roughState();
}

class _roughState extends State<rough> {
  bool value = false;
bool ischecked=false;
bool rocket=false;
bool Nagad=false;
var selected_country;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height:MediaQuery.of(context).size.height/10,
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
                              child: Center(child: Row(
                                children: [
                                  Image.asset("Images/bkas.png",height: 40,width: 20,),
                                  Text("Bkash"),
                                ],
                              )),

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
                              height:MediaQuery.of(context).size.height/10,
                              width: MediaQuery.of(context).size.width/3,
                              color: Colors.white,
                              child: Center(child: Row(
                                children: [
                                  Image.asset("Images/rocket.ong",height: 40,width: 20,),
                                  Text("Rocket"),
                                ],
                              )),

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
                      height:MediaQuery.of(context).size.height/10,
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
                              child: Center(child: Row(
                                children: [
                                  Image.asset("Images/nagad.png",height: 40,width: 20,),
                                  Text("Nagad"),
                                ],
                              )),

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
              )
            ],
          ),
        )
      ),
    );
  }
}
