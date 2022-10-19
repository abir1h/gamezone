import 'package:avatar_letter/avatar_letter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
class developer_page extends StatefulWidget {
  @override
  _developer_pageState createState() => _developer_pageState();
}

class _developer_pageState extends State<developer_page> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.call,color: Colors.white,),
          label: Text('Message Us',style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600
            )),
          onPressed: ()async{
var url='http://m.me/codecell.com.bd';
              if (await canLaunch(url))
                await launch(url);
              else
                // can't launch url, there is some error
                throw "Could not launch $url";
          },
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(

            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  height: height/3,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('Images/bgss.png'),
                      fit: BoxFit.fill,
                    )
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child:   Container(child: Column(
//     children: [
//       SizedBox(height: height/10,),
//           Center(
//             child: Text('Code Cell '.toUpperCase(),style: GoogleFonts.lato(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.w600
//             ),),
//           ), Center(
//             child: Row(
//               children: [
//                 Icon(Icons.location_on_rounded,color: Colors.white,),
//                 Text(' Kamarpara, Uttara, Dhaka 1230 '.toUpperCase(),style: GoogleFonts.lato(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w300
//                 ),),
//               ],
//             ),
//           ),
//     ],
//   )),
// ),
                      Positioned(
                        top:height/4,left:width/3.2,
                        child: CircularProfileAvatar(null,
                            borderColor: Colors.transparent,
                            child:AvatarLetter(
                              size: 50,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 100,
                              upperCase: true,
                              numberLetters: 1,
                              letterType: LetterType.Circular,
                              text: "Code ",
                            ),
                            elevation: 5,
                            radius: 70),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height/7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('we provide '.toUpperCase(),style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),),  Text('truly prominent IT solutions.'.toUpperCase(),style: GoogleFonts.lato(
                        color: Color(0xFF1088CB),
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),),
                  ],
                ),
                SizedBox(height: height/30,),

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Code Cell'.toUpperCase(),style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800
                        ),),
                        SizedBox(height: 10),

                        Text('A Software Development Company with a focus on turnkey solutions that Drive Digital Transformation.'.toUpperCase(),style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal
                        ),),
                        SizedBox(height: height/20),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
