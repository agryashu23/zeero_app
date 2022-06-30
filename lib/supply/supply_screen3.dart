import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:zeero_app/supply/supply.dart';
import '../home/home_screen.dart';
import '../math_utils.dart';
import '../provider.dart';
import '../size_config.dart';

class SupplyScreen3 extends StatefulWidget {
  static String routeName = "/supply3";

  const SupplyScreen3({Key? key}) : super(key: key);

  @override
  State<SupplyScreen3> createState() => _SupplyScreen3State();
}

class _SupplyScreen3State extends State<SupplyScreen3> {
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController unitController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController contactController = TextEditingController(text: "");
  List Supply3 = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid='';

  // List addId=[];


  @override
  void initState() {
    super.initState();
      final User? user = auth.currentUser;
      uid = user!.uid.toString();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Step 3 of 3",
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
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Optional Details",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    )),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Other Info.",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      contentPadding: EdgeInsets.only(
                          left: getHorizontalSize(10),
                          top: getVerticalSize(10),
                          bottom: getVerticalSize(10))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller: unitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Unit Number",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Owner Name",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Owner Contact",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(17),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                     FirebaseFirestore.instance.collection("data").add(
                          {
                            "text": controller.text,
                              "unit": unitController.text,
                              "name": nameController.text,
                              "contact": contactController.text,
                              "choice": cart.supply1[0]["choice"],
                              "property": cart.supply1[0]["property"],
                              "type": cart.supply1[0]["type"],
                              "state": cart.supply1[0]["state"],
                              "city": cart.supply1[0]["city"],
                              "locality": cart.supply1[0]["locality"],
                              "located": cart.supply1[0]["located"],
                              "date": cart.supply1[0]["date"],
                              "amenities": cart.supply1[0]["amenities"],
                              "images": cart.supply2[0]["images"],
                              "layout": cart.supply2[0]["layout"],
                              "washroom": cart.supply2[0]["washroom"],
                              "balcony": cart.supply2[0]["balcony"],
                              "furnish": cart.supply2[0]["furnish"],
                              "carpet": cart.supply2[0]["carpet"],
                              "floor": cart.supply2[0]["floor"],
                              "rent": cart.supply2[0]["rent"],
                              "security": cart.supply2[0]["security"],
                            "society":cart.supply1[0]["society"]

                          },).then((value) {
                              setState(() {
                                cart.addID(value.id);
                                FirebaseFirestore.instance.collection("property").doc(uid).set({
                                  "userid":FieldValue.arrayUnion(cart.IDs),
                                },SetOptions(merge: true));
                              });
                      });
                     cart.addAllSupply();
                     await AwesomeDialog(
                       context: context,
                       animType: AnimType.SCALE,
                       dialogType: DialogType.SUCCES,
                       title: 'Supply Are Added',
                       bodyHeaderDistance: 10.0,
                       autoHide: Duration(seconds: 3,milliseconds: 500),
                       // desc:   'This is also Ignored',
                     )..show();
                     Navigator.pushAndRemoveUntil(
                       context,
                       MaterialPageRoute(builder: (context) => HomeScreen()), // this mymainpage is your page to refresh
                           (Route<dynamic> route) => false,
                     );
                    // Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);

                  },
                ),
    ),
            ],
          ),
        ),
      );
    });
  }
}

// _showDialog(context) {
//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.of(context).pop(true);
//         });
//         return AlertDialog(
//           content: Container(
//             width: getHorizontalSize(200),
//             height: getVerticalSize(100),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text("Your Property is Posted",style: TextStyle(fontWeight: FontWeight.w500,fontSize: getFontSize(24),color: Colors.black),),
//             ),
//           ),
//         );
//       });
// }
