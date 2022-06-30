import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'dart:io';
import '../Loading.dart';
import '../math_utils.dart';
import '../provider.dart';

class  MatchSearch extends StatefulWidget {
  static String routeName = "/match_search";

  const MatchSearch({Key? key}) : super(key: key);

  @override
  State<MatchSearch> createState() => _MatchSearchState();
}

class _MatchSearchState extends State<MatchSearch> {
  List id=[];

  final _fireStore = FirebaseFirestore.instance;
  final data = FirebaseFirestore.instance.collection("data");
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  List userI=[];

  List allData=[];

  List show=[];

  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
    FirebaseFirestore.instance.collection("property").doc(
        uid).get().then((value) {
      for (int i = 0; i < value["userid"].length; i++) {
        UserIDs.add(value["userid"][i]);
      }
    });
  }
  var map = Map();
  List every =[];
  List UserIDs=[];


  Future getData(ok) async {
    QuerySnapshot querySnapshot = await _fireStore.collection('data').get();
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

    // show.clear();
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
      var ok = cart.leadSearch.isEmpty?cart.search:cart.leadSearch;
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
                            "Market Matches",
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
                          margin: EdgeInsets.only(
                            left: getHorizontalSize(10), right: getHorizontalSize(10),),
                          child:
                          Column(
                            children: [
                              show.length==0?Center(
                                  child: Container(
                                      margin: EdgeInsets.only(top: getVerticalSize(200)),
                                      alignment: Alignment.center,
                                      child: Text("No Matches Found ,\n Please Change Filters",style: TextStyle(color: Colors.white,fontSize: getFontSize(24),fontWeight: FontWeight.w500),))
                              ):
                              Container(
                                  height: getVerticalSize(724),
                                  child: ListView.builder(
                                      itemCount: show.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return show.isNotEmpty?StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance.collection('data').doc(show[index]).snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return new Text("Loading");
                                              }
                                              var userDoc = snapshot.data;
                                              double math = map[userDoc!.id]*25.0;
                                              var maths = math.toInt();
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white,

                                                ),
                                                height: getVerticalSize(150),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: getVerticalSize(10)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: getHorizontalSize(120),
                                                      child: Image.network(userDoc["images"][0],fit: BoxFit.cover,),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getHorizontalSize(10),
                                                          top: getVerticalSize(5)),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            width:getHorizontalSize(200),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons.currency_rupee_outlined,
                                                                        size: 17,),
                                                                      Text(
                                                                        userDoc["rent"],
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: getFontSize(15),
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.black,width: 1.5),
                                                                    borderRadius: BorderRadius.circular(50),
                                                                    color: Colors.cyanAccent.shade100
                                                                  ),
                                                                  padding: EdgeInsets.all(8),
                                                                  alignment: Alignment.center,
                                                                  child: Text(maths.toString()+"%",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: getFontSize(16)),),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: getVerticalSize(3)),
                                                            child: Text(userDoc["layout"] +
                                                                userDoc["type"],
                                                                style: TextStyle(
                                                                    color: Colors.black87,
                                                                    fontSize: getFontSize(14))),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: getVerticalSize(3)),
                                                            child: Text(userDoc["society"],
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: getFontSize(14),
                                                                    fontWeight: FontWeight.w300)),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: getVerticalSize(2),
                                                                bottom: getVerticalSize(3)),
                                                            child: Text(
                                                              "Sector "+userDoc["locality"] + ", " +
                                                                  "Gurgaon",
                                                              style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: getFontSize(16)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:EdgeInsets.only(top:10),
                                                            child: Row(
                                                              children: [

                                                                GestureDetector(
                                                                  onTap:()=>userDoc["contact"]!=""?UrlLauncher.launch('tel:+${"91"+userDoc["contact"].toString()}'): ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                    content: Text('Mobile No. is not Provided'),)),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .circular(5),
                                                                      color: Colors.tealAccent.shade100,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getVerticalSize(5),
                                                                        horizontal: getHorizontalSize(
                                                                            30)),
                                                                    alignment: Alignment.center,
                                                                    child: Text("Connect",
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: getFontSize(
                                                                              15)),),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:()async{
                                                                    final urlImage = userDoc["images"][0].toString();
                                                                    final url = Uri.parse(urlImage);
                                                                    final response = await http.get(url);
                                                                    final bytes = response.bodyBytes;
                                                                    final temp = await getTemporaryDirectory();
                                                                    final path = '${temp.path}/image.jpg';
                                                                    File(path).writeAsBytesSync(bytes);
                                                                    await Share.shareFiles([path],text: "Check this Latest Property in \n ${userDoc["society"]} , Sector ${userDoc["locality"]} Gurgaon 😍😍 \n Price:"
                                                                        " ${userDoc["rent"].toString() } \n Layout: ${userDoc["layout"]} \n\n  "
                                                                        "https://emojipedia.org/smiling-face-with-heart-eyes/");

                                                                  },
                                                                  child: Container(
                                                                    margin:EdgeInsets.only(left:getHorizontalSize(5)),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .circular(5),
                                                                      color: Colors.tealAccent.shade100,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getVerticalSize(5),
                                                                        horizontal: getHorizontalSize(
                                                                            25)),
                                                                    alignment: Alignment.center,
                                                                    child: Text("Share",
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: getFontSize(
                                                                              15)),),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )

                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        ):Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: getVerticalSize(200)),
                                                child: Text("No Matches Found ,\n Please Change Filters",style: TextStyle(color: Colors.white,fontSize: getFontSize(24),fontWeight: FontWeight.w500),))
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
