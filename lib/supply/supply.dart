import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:zeero_app/supplyshow.dart';

import '../Loading.dart';
import '../leads/matchleads.dart';
import '../math_utils.dart';
import '../provider.dart';
import 'supply_screen1.dart';

class Supply extends StatefulWidget {
  static String routeName = "/Supply";

  const Supply({Key? key}) : super(key: key);

  @override
  State<Supply> createState() => _SupplyState();
}

class _SupplyState extends State<Supply> {
  // List data =[];
  String uid = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  List userId = [];
  List userI = [];

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
  }

  Future getData() async {
    await FirebaseFirestore.instance
        .collection("property")
        .doc(uid)
        .get()
        .then((value) {
      for (int i = 0; i < value["userid"].length; i++) {
        userI.add(value["userid"][i]);
      }
    });
    var distinctIds = userI.toSet().toList();
    userId = distinctIds;
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child) {
      return FutureBuilder(
          future: getData(),
          builder: (BuildContext context, snapshot) {
            // }
            // if (!snapshot.hasData) {
            //   return Loading();
            // }
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Supply",
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
                backgroundColor: Colors.black,
                body: Container(
                  height: getVerticalSize(760),
                  margin: EdgeInsets.only(
                    left: getHorizontalSize(10),
                    right: getHorizontalSize(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: getVerticalSize(40),
                        margin:
                            EdgeInsets.symmetric(vertical: getVerticalSize(10)),
                        decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            child: Text(
                              "Add Supply",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getFontSize(17),
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              setState(() {
                                Navigator.of(context)
                                    .pushNamed(SupplyScreen1.routeName);
                              });
                            }),
                      ),
                      userId.length != 0
                          ? Container(
                              height: getVerticalSize(620),
                              child: ListView.builder(
                                  itemCount: userId.length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("data")
                                            .doc(userId[index].toString())
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Loading();
                                          }
                                          var docu = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            height: getVerticalSize(170),
                                            margin: EdgeInsets.symmetric(
                                                vertical: getVerticalSize(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SupplyShow(
                                                                    id: docu!.id
                                                                        .toString())));
                                                  },
                                                  child: Container(
                                                    width:
                                                        getHorizontalSize(120),
                                                    child: Image.network(
                                                      docu!["images"][0],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) =>
                                          SupplyShow(
                                          id: docu.id
                                              .toString())));
                                          },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            getHorizontalSize(10),
                                                        top: getVerticalSize(8)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .currency_rupee_outlined,
                                                              size:
                                                                  getFontSize(18),
                                                            ),
                                                            Text(
                                                              docu["rent"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      getFontSize(
                                                                          18),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  getVerticalSize(
                                                                      8)),
                                                          child: Text(
                                                              docu["layout"] +
                                                                  docu["type"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      getFontSize(
                                                                          15))),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  getVerticalSize(
                                                                      8)),
                                                          child: Text(
                                                              docu["society"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      getFontSize(
                                                                          15),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: getVerticalSize(
                                                                8),
                                                          ),
                                                          child: Text(
                                                            "Sector " +
                                                                docu["locality"] +
                                                                ", " +
                                                                "Gurgaon",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    getFontSize(
                                                                        17)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  getVerticalSize(
                                                                      24)),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () => docu[
                                                                            "contact"] !=
                                                                        ""
                                                                    ? UrlLauncher
                                                                        .launch(
                                                                            'tel:+${"91" + docu["contact"].toString()}')
                                                                    : ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            const SnackBar(
                                                                        content: Text(
                                                                            'Mobile No. is not Provided'),
                                                                      )),
                                                                child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15),
                                                                    border: Border
                                                                        .all(
                                                                      width: 0.5,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    color: Colors
                                                                        .tealAccent
                                                                        .shade100,
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                    vertical:
                                                                        getVerticalSize(
                                                                            10),
                                                                  ),
                                                                  width:
                                                                      getHorizontalSize(
                                                                          70),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Connect",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            getFontSize(
                                                                                15)),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  final urlImage =
                                                                      docu["images"]
                                                                              [0]
                                                                          .toString();
                                                                  final url =
                                                                      Uri.parse(
                                                                          urlImage);
                                                                  final response =
                                                                      await http
                                                                          .get(
                                                                              url);
                                                                  final bytes =
                                                                      response
                                                                          .bodyBytes;
                                                                  final temp =
                                                                      await getTemporaryDirectory();
                                                                  final path =
                                                                      '${temp.path}/image.jpg';
                                                                  File(path)
                                                                      .writeAsBytesSync(
                                                                          bytes);
                                                                  await Share.shareFiles(
                                                                      [path],
                                                                      text:
                                                                          "Check this Latest Property in \n ${docu["society"]} , Sector ${docu["locality"]} Gurgaon 😍😍 \n Price:"
                                                                          " ${docu["rent"].toString()} \n Layout: ${docu["layout"]} \n\n  "
                                                                          "https://emojipedia.org/smiling-face-with-heart-eyes/");
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(
                                                                      left:
                                                                          getHorizontalSize(
                                                                              5)),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15),
                                                                    border: Border
                                                                        .all(
                                                                      width: 0.5,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    color: Colors
                                                                        .tealAccent
                                                                        .shade100,
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                    vertical:
                                                                        getVerticalSize(
                                                                            10),
                                                                  ),
                                                                  width:
                                                                      getHorizontalSize(
                                                                          60),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Share",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            getFontSize(
                                                                                15)),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  cart.showLeads
                                                                      .clear();
                                                                  cart.showLeadSearch(
                                                                      docu[
                                                                          "locality"],
                                                                      docu[
                                                                          "layout"],
                                                                      docu[
                                                                          "rent"],
                                                                      docu[
                                                                          "furnish"],
                                                                      docu[
                                                                          "carpet"],
                                                                      docu[
                                                                          "floor"]);
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      MatchLeads
                                                                          .routeName);
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(
                                                                      left:
                                                                          getHorizontalSize(
                                                                              5)),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15),
                                                                    border: Border
                                                                        .all(
                                                                      width: 0.5,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    color: Colors
                                                                        .tealAccent
                                                                        .shade100,
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                    vertical:
                                                                        getVerticalSize(
                                                                            10),
                                                                  ),
                                                                  width:
                                                                      getHorizontalSize(
                                                                          65),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Match",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            getFontSize(
                                                                                15)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  }))
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: getVerticalSize(50),
                                  left: getHorizontalSize(10),
                                  right: getHorizontalSize(10)),
                              child: Text(
                                "Supply A Property",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getFontSize(22),
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                    ],
                  ),
                ));
          });
    });
  }
}
