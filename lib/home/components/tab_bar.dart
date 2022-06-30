import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../color_constant.dart';
import 'package:intl/intl.dart';

import '../../math_utils.dart';


class TabBarWidget extends StatefulWidget {
  const TabBarWidget({Key? key}) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  var myFormat = DateFormat("yMMMd").format(DateTime.now());

  final CarouselController _controller = CarouselController();
  List ids =[];


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("data").where("date",isEqualTo: myFormat).get().then((value) {
      value.docs.forEach((element) {
        ids.add(element.id);
      });
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> imageSliders = ids
        .map((item) => StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("data").doc(item.toString()).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              Center(
                  child:Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: getVerticalSize(50),
                        left: getHorizontalSize(10),
                        right: getHorizontalSize(10)),
                    child: Text("No Market Today", style:
                    TextStyle(color: Colors.white,
                        fontSize: getFontSize(22),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500),),
                  )
              );
            }
            var docu = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,

              ),
              height: getVerticalSize(115),
              margin: EdgeInsets.symmetric(
                  vertical: getVerticalSize(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getHorizontalSize(120),
                    child: Image.network(docu!["images"][0],fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getHorizontalSize(10),
                        top: getVerticalSize(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.currency_rupee_outlined,
                              size: 17,),
                            Text(
                              docu["rent"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getFontSize(15),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: getVerticalSize(3)),
                          child: Text(docu["layout"] +
                              docu["type"],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: getFontSize(12))),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: getVerticalSize(2),
                              bottom: getVerticalSize(5)),
                          child: Text(
                            docu["locality"] + ", " +
                                docu["city"],
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: getFontSize(16)),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(top:8),
                          child: Row(
                            children: [

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius
                                      .circular(5),
                                  border: Border.all(width: 0.5,
                                    color: Colors.black,),
                                  color: Colors.amber,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: getVerticalSize(8),
                                    horizontal: getHorizontalSize(
                                        30)),
                                alignment: Alignment.center,
                                child: Text("Connect",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(
                                          15)),),
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
        ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // construct the profile details widget here
          SizedBox(
            child: Padding(
              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
              child: Column(
                children: const [
                  Text(
                    'Market Today',
                    style: TextStyle(color: Colors.white, fontSize: 27,
                        fontWeight: FontWeight.w500,decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
          ids.length==1?Container(
            height: getVerticalSize(125),
            margin: EdgeInsets.symmetric(vertical: getVerticalSize(20),horizontal: getHorizontalSize(10)),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("data").doc(ids[0].toString()).snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }
                var docu = snapshot.data;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,

                  ),
                  height: getVerticalSize(115),
                  margin: EdgeInsets.symmetric(
                      vertical: getVerticalSize(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: getHorizontalSize(120),
                        child: Image.network(docu!["images"][0],fit: BoxFit.cover,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: getHorizontalSize(10),
                            top: getVerticalSize(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.currency_rupee_outlined,
                                  size: 17,),
                                Text(
                                  docu["rent"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(15),
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getVerticalSize(3)),
                              child: Text(docu["layout"] +
                                  docu["type"],
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: getFontSize(12))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getVerticalSize(2),
                                  bottom: getVerticalSize(5)),
                              child: Text(
                                docu["locality"] + ", " +
                                    docu["city"],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: getFontSize(16)),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(top:8),
                              child: Row(
                                children: [

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius
                                          .circular(5),
                                      border: Border.all(width: 0.5,
                                        color: Colors.black,),
                                      color: Colors.amber,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: getVerticalSize(8),
                                        horizontal: getHorizontalSize(
                                            30)),
                                    alignment: Alignment.center,
                                    child: Text("Connect",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: getFontSize(
                                              15)),),
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
            ),
          ):Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03),
            child: Container(
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                  // autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.5,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
          ),
          ids.length>1?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ids.map((url) {
              int index = ids.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.amber.shade600
                      : Colors.white
                ),
              );
            }).toList(),
          ):Container(),


        ],
      ),
    );
  }
}