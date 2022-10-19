import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';

import '../mainHome.dart';
class upload_ss extends StatefulWidget {
  final String id;
  upload_ss({this.id});



  @override
  _upload_ssState createState() => _upload_ssState();
}

class _upload_ssState extends State<upload_ss> {
  Future slide;
  // Future emergency() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');
  //
  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };
  //
  //   var response = await http.get(Uri.parse(AppUrl.game_prize + widget.id),
  //       headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     print('Get post collected' + response.body);
  //     var userData1 = jsonDecode(response.body)['data'];
  //     print(userData1);
  //
  //     return userData1;
  //   } else {
  //     print("post have no Data${response.body}");
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // slide=emergency();

  }
  ImagePicker picker = ImagePicker();
  var _image;
  Future takephoto_gallary() async {
    XFile image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
    //return image;
  }
  bool isrequest=false;
  Future withdraw(String id)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.uploadss),


    );
    request.fields.addAll({
      'game_id': id,

    });

    if(_image!=null){ request.files
        .add(await http.MultipartFile.fromPath('images', _image.path));}
    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            isrequest=false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
          Fluttertoast.showToast(

              msg: "SS Uplaoded Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
        }else{
          setState(() {
            isrequest=false;
          });
          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(

              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);          return response.body;

        }
      }

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Color(0xFFF7F7F7),

      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );

  }

  contentBox(context){
    String _chosenValue;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Container(
                height: 50,
                width: width,
                color: Color(0xFF07031E),
                child:   Center(
                  child: Column(
                    children: [
                      Text('Upload Screenshot of winning',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,)),
                    ],
                  ),
                ),
              ),
              _image!=null?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover,height: 100,
                        width: 100,

                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      _image=null;
                    });

                  }, icon: Icon(Icons.clear))
                ],
              ): Padding(
                padding: const EdgeInsets.all(8.0),
                child:   Image.network(
                    'https://static.sdahaqq.com/images/uploadimageholder.jpg',height: 100,
                  width: 100,

                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      takephoto_gallary();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Upload SS".toUpperCase(),
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ),
                  ),
                  SizedBox(width: 7,),
                  _image!=null?
                  isrequest==false? InkWell(
                    onTap: (){
setState(() {
  isrequest=true;
});
withdraw(widget.id.toString());},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Submit SS".toUpperCase(),
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ),
                  ):SpinKitThreeInOut(
                    color: Colors.blue,
                    size: 20,
                  ):Container()
                ],
              ),
            ],
          ),
        ),
      );
  }
}
