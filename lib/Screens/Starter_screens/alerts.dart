import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class alert_dialogs extends StatefulWidget {
  final String text_par;
  alert_dialogs({this.text_par});
  @override
  _alert_dialogsState createState() => _alert_dialogsState();
}

class _alert_dialogsState extends State<alert_dialogs> {
  Future myFuture,group_; String _mySelection,group_selection;
  var _myJson;

  Future<List<dynamic>> get_notification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String url = "https://stgoals.com/api/tools/academic-classes/";

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body)['data'];
      print("Get Profile has Data");
      print(userData);
      setState(() {
        _myJson=userData as List;
      });
      print(_myJson);
      print(userData);

      return userData;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }

  String Role_of_user = '';
  String name_='partho';
  var Selected_Class;
  var Sekected_group;
  var selected_class_id;
  var selected_groups_id;

  List<String> Class = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  List<String> Group = <String>['Science', 'Commerce', 'Arts'];
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = get_notification();
  }
  var name;
  var val;
  var class_name;

  var group_name;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Badge(
    alignment: Alignment.topRight,
    showBadge: true,
    padding: EdgeInsets.all(0),
    badgeContent: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){Navigator.pop(context);},),

    child: Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.text_par,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
          )
          ],
        ),
      ),
    ),
  );
  classname(String name){
    return Text("partho pps");
  }
}
