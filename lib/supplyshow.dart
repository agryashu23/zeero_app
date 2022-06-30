import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:zeero_app/imagescreen.dart';

import '../math_utils.dart';
import '../provider.dart';

class SupplyShow extends StatefulWidget {

  const SupplyShow({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<SupplyShow> createState() => _SupplyShowState();
}

class _SupplyShowState extends State<SupplyShow> {
  ScreenshotController screenshotController = ScreenshotController();
  List<String> ids =[];
  String id = "fgh";
  int _current = 0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("data").doc(widget.id).get().then((value) {
      setState((){
        for(int i =0;i<value["images"].length;i++){
          ids.add(value["images"][i]);
        }
      });
    });
    print(ids);

  }
  final CarouselController _controller = CarouselController();

  Future takeScreenshot(Uint8List bytes)async{
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/image.png');
    image.writeAsBytesSync(bytes);
   
    await Share.shareFiles([image.path]);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments
     List<Widget> imageSliders = ids
        .map((item) => Container(
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageScreen(ids:ids)));
                      },
                      child: Image.network(item, fit: BoxFit.cover,width: getHorizontalSize(320),)),
                ],
              )),
        ))
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Property",
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
      body:Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: getVerticalSize(5)),
                child: CarouselSlider(
                  items: imageSliders,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 2,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ids.map((url) {
                  int index = ids.indexOf(url);
                  return GestureDetector(
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current==index?
                               Colors.tealAccent
                              : Colors.white)
                    ),
                  );
                }).toList(),
              ),
              SingleChildScrollView(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection("data").doc(widget.id).snapshots(),
                  builder: (context, snapshot) {
                    var docu = snapshot.data;
                    return Container(
                      margin: EdgeInsets.only(top: getVerticalSize(15),left: getHorizontalSize(50)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Price :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu!["rent"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Sector :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["locality"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Type :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["property"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Society :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["society"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Layout :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["layout"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Available From :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["date"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Furnish :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["furnish"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Floor :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["floor"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Washroom :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["washroom"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Balcony :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: docu["balcony"].toString(),
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Area :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: "${docu["carpet"].toString()} sq.ft",
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),

                          docu["security"]==''?Container():Container(
                            margin: EdgeInsets.only(top: getVerticalSize(5)),
                            child: Text.rich(
                                TextSpan(
                                    text: 'Security :   ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: "${docu["security"].toString()}",
                                        style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),
                                      )
                                    ]
                                )
                            ),
                          ),
                          Container(
                            height:getVerticalSize(40),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text('Amenities : ',style:TextStyle(color:Colors.white,fontSize: getFontSize(20)))),
                                Container(
                                  alignment:Alignment.center,
                                  width:getHorizontalSize(190),
                                  margin: EdgeInsets.only(top: getVerticalSize(10),left: 2),
                                  child:ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: docu["amenities"].length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Text(docu["amenities"][index]+" , ",style: TextStyle(fontSize: getFontSize(20),fontWeight: FontWeight.bold,color: Colors.tealAccent),);
                                      }),
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    );
                  }
                ),
              ),
              GestureDetector(
                onTap:()async {
                  final image = await screenshotController.capture();
                  takeScreenshot(image!);
                },
                child: Container(
                  margin:EdgeInsets.only(left:getHorizontalSize(100),top: getVerticalSize(15)),
                  width:getHorizontalSize(160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius
                        .circular(25),
                    border: Border.all(width: 0.5,
                      color: Colors.black,),
                    color: Colors.tealAccent,
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: getVerticalSize(15),
                      ),
                  alignment: Alignment.center,
                  child: Text("Share",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(
                            15)),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
_showDialog2(context, String item) {

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: getHorizontalSize(300),
                  height: getVerticalSize(500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(item,fit: BoxFit.cover),
                );

              }
          ),
        );

      });
}

