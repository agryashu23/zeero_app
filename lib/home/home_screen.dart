import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:zeero_app/login/login_screen.dart';

import '../abc.dart';
import '../businessscreen.dart';
import '../leads/leads.dart';
import '../profile.dart';
import '../supply/supply.dart';



import '../bussiness.dart';
import '../constants.dart';
import '../contactus.dart';
import '../math_utils.dart';
import '../size_config.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: Colors.white,
      ),
      title: Text(title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      onTap: tapHandler,
    );
  }
  bool isEnglish = true;
  var myFormat = DateFormat("yMMMMd").format(DateTime.now());

  final CarouselController _controller = CarouselController();
  List supplyIds =[];
  List leadsIds =[];
  String uid='';
  late final Future? myFuture;
  FirebaseAuth auth = FirebaseAuth.instance;
  String startMonth = DateFormat("MMMM").format(DateTime.now());
  int startYear = int.parse(DateFormat("y").format(DateTime.now()));
  int startDay = int.parse(DateFormat("d").format(DateTime.now()));
  int reven=0;
  int collect=0;
  List revenues =[];
  int mysupply=0;
  int myleads=0;
  int expense=0;
  String namme='';
  String image2='';
  List store=[];
  List store2=[];



  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        namme = value["name"];
        image2 = value["image"];
      });
      });


    FirebaseFirestore.instance.collection("data").get().then((value) {
      value.docs.forEach((element) {
        if(element["date"].replaceAll(RegExp('[^A-Za-z]'), '')==startMonth) {
          setState(() {
            supplyIds.add(element.id);
          });
          FirebaseFirestore.instance.collection("property").doc(uid).get().then((val) {
            for(int i=0;i<val["userid"].length;i++){
              if(val["userid"][i] == element.id){
                setState(() {
                  mysupply+=1;

                });
              }
            }
          });
        }
      });
    });
    FirebaseFirestore.instance.collection("leads").get().then((value) {
      value.docs.forEach((element) {
        if(element["date"].replaceAll(RegExp('[^A-Za-z]'), '')==startMonth){
          setState(() {
            leadsIds.add(element.id);
            store.add(element["locality"]);
            var distinctIds = store.toSet().toList();
            store2 = distinctIds;
          });
          FirebaseFirestore.instance.collection("property").doc(uid).get().then((val) {
            for(int i=0;i<val["leadsid"].length;i++){
              if(val["leadsid"][i] == element.id){
                setState(() {
                  myleads+=1;

              });
              }
            }
          });
        }

      });
    });

    // FirebaseFirestore.instance.collection("property").doc(uid).get().then((value) {
    //       setState(() {
    //         mysupply = value["userid"].length;
    //         myleads = value["leadsid"].length;
    //       });
    // });
    FirebaseFirestore.instance.collection('business').doc(uid)
        .collection("revenue").where("month",isEqualTo: startMonth).get().then((value) {
      value.docs.forEach((element) {
          setState(() {
            reven = int.parse(element["revenue"])+ reven;
            collect = int.parse(element["collected"]) + collect;
          });
      });
    });
    FirebaseFirestore.instance.collection('business').doc(uid)
        .collection("expenses").where("month",isEqualTo: startMonth).get().then((value) {
      value.docs.forEach((element) {
          setState(() {
            expense = int.parse(element["amount"])+ expense;
          });
      });
    });
    // Future.delayed(Duration(seconds: 1),(){
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return HomeScreen();
    //   }));
    // });
  }



  @override
  Widget build(BuildContext context) {
    // print("date123".replaceAll(RegExp('[^A-Za-z]'), ''));
    SizeConfig().init(context);
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        return Scaffold(
              backgroundColor: Colors.black,
              drawer: Drawer(
                backgroundColor: Colors.black,
                width: getHorizontalSize(220),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: getVerticalSize(100),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      color: Colors.tealAccent.shade100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: ()=>Navigator.pushNamed(context, Profile.routeName,arguments: "now"),
                            child: Padding(
                              padding:EdgeInsets.only(left:getHorizontalSize(0,),top: getVerticalSize(25)),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(image2) ,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: getHorizontalSize(5)),
                                    child: Text(
                                      namme,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: getFontSize(20),
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // FlutterSwitch(
                          //     width: 60,
                          //     height: 25 ,
                          //     valueFontSize: 12,
                          //     toggleSize: 20,
                          //     showOnOff: true,
                          //     activeText: "Eng",
                          //     inactiveText: "Hin",
                          //     activeTextColor: Colors.white,
                          //     inactiveTextColor: Colors.white,
                          //     activeColor: Colors.black,
                          //     inactiveColor: Colors.black,
                          //     value: isEnglish,
                          //     onToggle: (value) {
                          //       setState(() {
                          //         isEnglish = value;
                          //       });
                          //     }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildListTile("Supply", Icons.home, () {
                      Navigator.of(context).pop();

                      Navigator.of(context)
                          .pushNamed(Supply.routeName);
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile("Leads", Icons.person_add, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Leads1.routeName);
                      // Navigator.of(context).pop();

                      // Navigator.of(context).pushNamed(Leads.routeName);
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile("Match", Icons.diamond, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Searching.routeName);


                    }),
                    // buildListTile("Match", Icons.arrow_right, () {}),
                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile("Business", CupertinoIcons.briefcase, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(Bussiness.routeName);
                    }),

                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile("Contact Us", Icons.contact_mail, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(ContactUs.routeName);
                    }),

                    const SizedBox(
                      height: 5,
                    ),
                    buildListTile("Log out", Icons.account_circle, () {
                      showAlertDialog(context);


                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    const Spacer(),
                    const Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("\u{00a9} 2022 Zeero",
                          style: TextStyle(fontSize: 15, color: kPrimaryLightColor)),
                    ),
                  ],
                ),
              ),
          appBar: AppBar(
            title: Text(
              "Dashboard",
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.0),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.tealAccent
                ),
                margin: EdgeInsets.all(4),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                              'Market (${myFormat.replaceAll(RegExp('[^A-Za-z]'), '')})',
                              style: TextStyle(color: Colors.white, fontSize: getFontSize(30),
                                  fontWeight: FontWeight.w500,),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black
                                  ),
                                  margin: EdgeInsets.only(left: getHorizontalSize(20),top: getVerticalSize(15)),
                                  padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),
                                  height: getVerticalSize(100),
                                  width: getHorizontalSize(150),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Fresh Supply",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),),
                                      Text(supplyIds.length.toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                                    ],
                                  ),
                                ) ,
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                      color: Colors.black

                                  ),
                                  margin: EdgeInsets.only(left: getHorizontalSize(20),top: getVerticalSize(15)),
                                  padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),

                                  height: getVerticalSize(100),
                                  width: getHorizontalSize(150),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Fresh Leads",style: TextStyle(color:Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),),
                                      Text(leadsIds.length.toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                  color: Colors.black

                              ),
                              margin: EdgeInsets.only(top: getVerticalSize(15)),
                              padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),
                              height: getVerticalSize(190),
                              width: getHorizontalSize(320),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Area in Demand",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),),
                                  leadsIds.isNotEmpty?Container(
                                    height: getVerticalSize(130),
                                    margin: EdgeInsets.only(left: getHorizontalSize(100),top: getVerticalSize(5)),
                                    child: ListView.builder(
                                      itemCount:store2.length<=5?store2.length:5,
                                      itemBuilder: (context,index){
                                        return Padding(
                                          padding: EdgeInsets.only(top: getVerticalSize(4),left: getHorizontalSize(10)),
                                          child: Text("Sector ${store2[index]}",style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(20)),),
                                        );

                                        //   StreamBuilder<DocumentSnapshot>(
                                        //   stream: FirebaseFirestore.instance.collection("leads").doc(leadsIds[index].toString()).snapshots(),
                                        //   builder: (context, snapshot) {
                                        //     var docu = snapshot.data;
                                        //     return docu!=null&& store.contains(docu["locality"])?Padding(
                                        //       padding: EdgeInsets.only(top: getVerticalSize(3)),
                                        //       child: Text("Sector ${docu["locality"]}",style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(20)),),
                                        //     ):Container();
                                        //   }
                                        // );
                                      },
                                    ),
                                  ):Container(
                                    margin: EdgeInsets.only(top: getVerticalSize(50)),
                                    child:Text("No Area in Demand",style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(20)),),
                                  ),
                                  // Text(supplyIds.length.toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(20)),)
                                ],
                              ),
                            ) ,

                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: getVerticalSize(30)),child:   Text(
                      'My Office',
                      style: TextStyle(color: Colors.white, fontSize: getFontSize(30),
                          fontWeight: FontWeight.w500,),
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context)
                                .pushNamed(Supply.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.black

                            ),
                            margin: EdgeInsets.only(left: getHorizontalSize(1),top: getVerticalSize(15)),
                            padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),
                            height: getVerticalSize(100),
                            width: getHorizontalSize(105),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Supply",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                                Text(mysupply.toString().toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                              ],
                            ),
                          ),
                        ) ,
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(Leads1.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.black

                            ),
                            margin: EdgeInsets.only(left: getHorizontalSize(4),top: getVerticalSize(15)),
                            padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),

                            height: getVerticalSize(100),
                            width: getHorizontalSize(105),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Leads",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                                Text(myleads.toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                              ],
                            ),
                          ),
                        ),GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(BusinessScreen.routeName);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.black


                            ),
                            margin: EdgeInsets.only(left: getHorizontalSize(4),top: getVerticalSize(15)),
                            padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),

                            height: getVerticalSize(100),
                            width: getHorizontalSize(130),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Text("Revenue",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                Text(reven.toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(BusinessScreen.routeName);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.black

                            ),
                            margin: EdgeInsets.only(left: getHorizontalSize(2),top: getVerticalSize(10)),
                            padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),
                            height: getVerticalSize(100),
                            width: getHorizontalSize(170),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Uncollected",style: TextStyle(color: Colors.lightBlue.shade300,fontSize: getFontSize(22),fontWeight: FontWeight.w500),),
                                Text((reven-collect).toString(),style: TextStyle(color: Colors.cyanAccent,fontSize: getFontSize(24)),)
                              ],
                            ),
                          ),
                        ) ,
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed(BusinessScreen.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.black

                            ),
                            margin: EdgeInsets.only(left: getHorizontalSize(8),top: getVerticalSize(10)),
                            padding: EdgeInsets.only(top: getVerticalSize(10),bottom: getVerticalSize(15)),
                            height: getVerticalSize(100),
                            width: getHorizontalSize(170),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text((reven-expense)>=0?"Profit":"Loss",style: TextStyle(color: (reven-expense)>=0?Colors.lightGreen.shade300:Colors.redAccent,fontSize: getFontSize(22),fontWeight: FontWeight.w500),),
                                Text(((reven-expense).abs()).toString(),style: TextStyle(color: Colors.tealAccent,fontSize: getFontSize(24)),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
      }
    );
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(color: Colors.black,fontSize: getFontSize(18))),
      onPressed:  () {
        Navigator.of(context).pop();

      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes",style: TextStyle(color: Colors.red,fontSize: getFontSize(18)),),
      onPressed:  () {
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, LoginScreen.routeName);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Zeero",textAlign: TextAlign.center,),
      content: Text("Would you really want to Log Out?"),
      actions: [
        cancelButton,
        Container(width: getHorizontalSize(40),),
        continueButton,
        Container(width: getHorizontalSize(20),),

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
