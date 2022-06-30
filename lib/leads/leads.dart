import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:zeero_app/provider.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../Loading.dart';
import '../abc.dart';
import '../math_utils.dart';
import 'package:intl/intl.dart';

import '../search/leadsearching.dart';
import '../search/leadssearch.dart';

class Leads1 extends StatefulWidget {
  static String routeName = "/leads1";

  const Leads1({Key? key}) : super(key: key);

  @override
  State<Leads1> createState() => _Leads1State();
}

class _Leads1State extends State<Leads1> {
  String uid='';
  FirebaseAuth auth = FirebaseAuth.instance;
  List addId =[];
  List userId =[];
  List userI =[];


  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();

  }

  Future getData()async{
    await FirebaseFirestore.instance.collection("property").doc(uid).get().then((value) {
      for(int i =0;i<value["leadsid"].length;i++){
          userI.add(value["leadsid"][i]);
      }
    });
    var distinctIds = userI.toSet().toList();
    userId  = distinctIds;
    return userId;

  }


  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {

      return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return  const Loading();
          // //   );
          // }
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(
                  "Leads",
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
                margin: EdgeInsets.only(top: getVerticalSize(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() { addId.clear();});
                        Navigator.pushReplacementNamed(context, LeadsSearch.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: getVerticalSize(20)),
                        alignment: Alignment.center,
                        width: getHorizontalSize(200),
                        height: getVerticalSize(55),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .circular(30),
                          border: Border.all(width: 0.5,
                            color: Colors.black,),
                          color: Colors.tealAccent,
                        ),
                        child: Text("Add Leads",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getFontSize(
                                  22), fontWeight: FontWeight.w500),),
                      ),
                    ),
                    userId.length!=0?
                    SizedBox(
                        height: getVerticalSize(620),
                        child: ListView.builder(
                            itemCount: userId.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                  stream:  FirebaseFirestore.instance.collection("leads").doc(userId[index].toString()).snapshots(),
                                  builder: (context, snapshot) {
                                    if(snapshot.data==null){
                                      return Loading();
                                    }
                                    var docu = snapshot.data;
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                       color: Colors.white
                                      ),
                                      height: getVerticalSize(135),
                                      margin: EdgeInsets.symmetric(
                                          vertical: getVerticalSize(5)),
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
                                                Text(docu!["name"].toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: getFontSize(20),fontWeight: FontWeight.w500)),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: getVerticalSize(5)),
                                                  child: Text(docu["layout"],
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: getFontSize(16),
                                                          fontWeight: FontWeight.w500)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: getVerticalSize(5),),
                                                  child: Text(
                                                    "Sector " +
                                                        docu["locality"],
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: getFontSize(16)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: getVerticalSize(6),),
                                                  child: Text(
                                                    docu["rent"],
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: getFontSize(16)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin:EdgeInsets.only(right:getHorizontalSize(5),top: getVerticalSize(4)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
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
                                                      color: Colors.lightGreenAccent,
                                                    ),
                                                    height: getVerticalSize(40),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding:EdgeInsets.only(right: getHorizontalSize(8)),
                                                          child: Text("WhatsApp",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: getFontSize(
                                                                    15)),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(Icons.whatsapp_outlined,color: Colors.black54,),
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
                                                   height: getVerticalSize(40),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding:EdgeInsets.only(right: getHorizontalSize(20)),
                                                          child: Text("Call",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: getFontSize(
                                                                    15)),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(Icons.call,color: Colors.white,),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    cart.leadSearch.clear();
                                                    cart.addLeadSearch(docu["locality"], docu["layout"], docu["rent"], docu["furnish"], docu["carpet"], docu["floor"]);
                                                    Navigator.pushNamed(context, LeadSearching.routeName);
                                                    },
                                                  child: Container(
                                                    margin:EdgeInsets.only(top:getVerticalSize(4)),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(5),
                                                      color: Colors.amber.shade500,
                                                    ),
                                                    width:getHorizontalSize(110),
                                                   height: getVerticalSize(40),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right:10.0),

                                                          child: Text("Match",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: getFontSize(
                                                                    15)),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right:10.0),
                                                          child: Icon(Icons.diamond,color: Colors.white,)
                                                        ),
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
                    ):Container(alignment: Alignment.center,
                      margin: EdgeInsets.only(left: getHorizontalSize(30),top: getVerticalSize(10)),
                      child: Text("Sorry, Currently no leads are added.",style:
                      TextStyle(color: Colors.white,fontSize: getFontSize(20),letterSpacing: 1.5,fontWeight: FontWeight.w500),),
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
