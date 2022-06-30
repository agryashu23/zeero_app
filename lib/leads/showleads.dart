import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:zeero_app/businessscreen.dart';
import 'package:zeero_app/provider.dart';
import 'package:zeero_app/search/search1.dart';

import 'package:intl/intl.dart';

import '../Loading.dart';
import '../match2.dart';
import '../matches/match.dart';
import '../math_utils.dart';
import '../search/leadsearching.dart';
import '../search/leadssearch.dart';

class ShowLeads extends StatefulWidget {
  static String routeName = "/show_leads";

  const ShowLeads({Key? key}) : super(key: key);

  @override
  State<ShowLeads> createState() => _ShowLeadsState();
}

class _ShowLeadsState extends State<ShowLeads> {
  List id=[];

  final _fireStore = FirebaseFirestore.instance;
  final data = FirebaseFirestore.instance.collection("data");
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  List userI=[];

  List allData=[];

  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
    FirebaseFirestore.instance.collection("property").doc(
        uid).get().then((value) {
      for (int i = 0; i < value["leadsid"].length; i++) {
        UserIDs.add(value["leadsid"][i]);
      }
    });
  }
  var map = Map();
  List every =[];
  List UserIDs=[];
  List show= [];


  Future getData(ok) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('leads').get();
    // Get data from docs and convert map to List
    querySnapshot.docs.map((doc) {
      if(!UserIDs.contains(doc.id)){
        if(int.parse(doc["locality"])-5<=int.parse(ok[0]["location"]) && int.parse(doc["locality"])+5>=int.parse(ok[0]["location"])){
          allData.add(doc.id);
        }
        if(doc["layout"]==ok[0]["layout"]){
          allData.add(doc.id);
        }
        if(int.parse(doc["rent"])-7000<=int.parse(ok[0]["rent"]) && int.parse(doc["rent"])+7000>=int.parse(ok[0]["rent"]) ){
          allData.add(doc.id);
        }
        if(doc["furnish"]==ok[0]["furnish"]){
          allData.add(doc.id);
        }
        // if(doc["carpet"]==ok[0]["area"]){
        //   allData.add(doc.id);
        // }
        // if(doc["floor"]==ok[0]["floor"]){
        //   allData.add(doc.id);
        // }
      }
    }).toList();
    allData.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });
    // print(map);
    // print(allData);
    var distinctIds = allData.toSet().toList();
    every = distinctIds;

    every.forEach((element) {
      if(map[element]==4){
        show.add(element);
      }
    });
    every.forEach((element) {
      if(map[element]==3){
        show.add(element);
      }
    });
    every.forEach((element) {
      if(map[element]==2){
        show.add(element);
      }
    });
    every.forEach((element) {
      if(map[element]==1){
        show.add(element);
      }
    });
    return allData;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      var ok = cart.showLeads;
      return FutureBuilder(
          future: getData(ok),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) {
            //   return Loading();
            //   //   );
            // }
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Matches",
                      style: TextStyle(color: Colors.amber.shade600),
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
                  backgroundColor: Colors.black,
                  body: Container(
                    margin: EdgeInsets.only(
                      left: getHorizontalSize(10), right: getHorizontalSize(10),),
                    child:
                    Column(
                      children: [
                        show.length==0?Container(alignment: Alignment.center,
                          margin: EdgeInsets.only(left: getHorizontalSize(30),top: getVerticalSize(10)),
                          child: Text("No Matches Found ,\n Please Change Filters",style:
                          TextStyle(color: Colors.white,fontSize: getFontSize(20),letterSpacing: 1.5,fontWeight: FontWeight.w500),),
                        ):
                        Container(
                            height: getVerticalSize(710),
                            child: ListView.builder(
                                itemCount: show.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance.collection('leads').doc(show[index]).snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Loading();
                                        }
                                        var docu = snapshot.data;
                                        double math = map[docu!.id]==null?0.0:map[docu.id]*25.0;
                                        var maths = math.toInt();
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                             color: Colors.white

                                          ),
                                          height: getVerticalSize(145),
                                          margin: EdgeInsets.symmetric(
                                              vertical: getVerticalSize(8)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getHorizontalSize(20),
                                                    top: getVerticalSize(5)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(docu["name"].toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: getFontSize(22),fontWeight: FontWeight.w500)),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: getVerticalSize(4)),
                                                      child: Text(docu["layout"],
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: getFontSize(17),
                                                              fontWeight: FontWeight.w500)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: getVerticalSize(4),),
                                                      child: Text(
                                                        "Sector " +
                                                            docu["locality"],
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: getFontSize(17)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: getVerticalSize(6),),
                                                      child: Text(
                                                        docu["rent"],
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: getFontSize(17)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:EdgeInsets.only(right:getHorizontalSize(5),top: getVerticalSize(2)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black,width: 1.5),
                                                        borderRadius: BorderRadius.circular(50),
                                                        color: Colors.cyanAccent
                                                      ),
                                                      padding: EdgeInsets.all(8),
                                                      alignment: Alignment.center,
                                                      child: Text(maths.toString()+"%",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600,fontSize: getFontSize(16)),),
                                                      margin: EdgeInsets.symmetric(vertical: getVerticalSize(5)),
                                                    ),
                                                    GestureDetector(
                                                      onTap:()async{
                                                        final link = WhatsAppUnilink(
                                                          phoneNumber: '+91 ${docu['contact'].toString()}',
                                                          text: "Hey! I need to know about the property you listed on Zeero",
                                                        );
                                                        await UrlLauncher.launch('$link');

                                                      },
                                                      child: Container(
                                                        width:getHorizontalSize(110),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(5),
                                                          color: Colors.lightGreen,
                                                        ),
                                                        padding: EdgeInsets.symmetric(
                                                          vertical: getVerticalSize(5),
                                                        ),
                                                        margin: EdgeInsets.only(top: getVerticalSize(7)),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment:MainAxisAlignment.center,
                                                          children: [
                                                            Text("WhatsApp",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: getFontSize(
                                                                      15)),),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 4),
                                                              child: Icon(Icons.whatsapp_outlined,color: Colors.white,),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap:()=>UrlLauncher.launch('tel:+${"91"+docu["contact"].toString()}'),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(5),
                                                          color: Colors.lightBlueAccent,
                                                        ),
                                                        width:getHorizontalSize(110),
                                                        margin:EdgeInsets.only(top:getVerticalSize(4)),
                                                        padding: EdgeInsets.symmetric(
                                                          vertical: getVerticalSize(5),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment:MainAxisAlignment.center,
                                                          children: [
                                                            Text("Call",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: getFontSize(
                                                                      15)),),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 4),
                                                              child: Icon(Icons.call,color: Colors.white,),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );


                                })
                        ),
                      ],
                    ),
                  )
              );
            }
      );
    });
  }
}
