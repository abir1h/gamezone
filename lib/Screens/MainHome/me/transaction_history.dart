import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_club/Screens/MainHome/me/my_wallet.dart';
import 'package:sports_club/Screens/MainHome/me/withdraw_history.dart';

import 'deposite_History.dart';
class transaction_history extends StatefulWidget {
  @override
  _transaction_historyState createState() => _transaction_historyState();
}

class _transaction_historyState extends State<transaction_history> with TickerProviderStateMixin{
  TabController _controllertab;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllertab = new TabController(length: 2, vsync: this);

}
  @override
  Widget build(BuildContext context) {
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
                context, MaterialPageRoute(builder: (_) => my_wallet()));
          },
        ),
        title: Text("My Transaction History",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          TabBar(
            controller: _controllertab,
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: [
              // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
              Tab(child: Text("Withdraw",style:  GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),),),
              Tab(child: Text('Deposite ',style:  GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),),),

            ],

          ),
          Container(
            height: 500,
            child: TabBarView(

              controller: _controllertab,
              children: [

                withdraw_History(),
                deposite_History()

              ],
            ),
          ),
        ],
      ),
    ),

    );
  }
}
