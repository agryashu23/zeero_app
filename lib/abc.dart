import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeero_app/businessscreen.dart';
import 'package:zeero_app/provider.dart';
import 'package:zeero_app/search/search1.dart';

import 'math_utils.dart';
import 'package:intl/intl.dart';

class Searching extends StatefulWidget {
  static String routeName = "/searching";

  const Searching({Key? key}) : super(key: key);

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {

  String uid='';
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {

      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              "Match",
              style: TextStyle(color: Colors.tealAccent),
            ),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: Image.asset("assets/images/logo_zoom.png"),
                onPressed: () {},
                iconSize: 120,
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: getVerticalSize(200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/zeero.jpeg",width: getHorizontalSize(350),height: getVerticalSize(150),),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Search1.routeName,arguments: "Own");
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: getVerticalSize(140)),
                    alignment: Alignment.center,
                    width: getHorizontalSize(250),
                    height: getVerticalSize(60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius
                          .circular(25),
                      border: Border.all(width: 0.5,
                        color: Colors.black,),
                      color: Colors.tealAccent,
                    ),
                    child: Text("Match with Own",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getFontSize(
                              22), fontWeight: FontWeight.w500),),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    Navigator.pushNamed(context, Search1.routeName,arguments: "Zeero");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: getHorizontalSize(250),
                    height: getVerticalSize(60),
                    margin: EdgeInsets.only(top: getVerticalSize(40)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius
                          .circular(25),
                      border: Border.all(width: 0.5,
                        color: Colors.black,),
                      color: Colors.tealAccent,
                    ),
                    child: Text("Match with Market",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getFontSize(
                              22), fontWeight: FontWeight.w500),),
                  ),
                ),

              ],
            ),
            padding: EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),

          )
      );
    });
  }
}
