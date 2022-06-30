import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeero_app/leads/leads.dart';

import '../home/home_screen.dart';
import '../match2.dart';
import '../matches/match.dart';
import '../math_utils.dart';
import '../provider.dart';
import '../size_config.dart';
import 'filters.dart';
import 'package:intl/intl.dart';

class LeadsSearch extends StatefulWidget {
  static String routeName = "/leads_search";

  const LeadsSearch({Key? key}) : super(key: key);

  @override
  State<LeadsSearch> createState() => _LeadsSearchState();
}

class _LeadsSearchState extends State<LeadsSearch> {
  List<String> _choicesList = ['Buy', 'Rent'];
  List layoutType=["1 BHK","2 BHK","3 BHK","4 BHK","4BHK +"];
  List type1=["Family","Bachelor","Other"];
  List floor=["GF(0)","Low Rise(1-4)","Mid Rise(5-8)","High Rise(8+)"];
  String floors = '';
  List furnishing=["Raw","Semi-Furnished","Furnished"];
String furnish='';




  int defaultChoiceIndex1=5;
  int defaultChoiceIndex4=5;
  int defaultChoiceIndex5=5;
  int defaultChoiceIndex2=5;
  int defaultChoiceIndex6=6;
  TextEditingController dateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  var myFormat = DateFormat("yMMMMd");

  String layout = '';
  String type2 = '';
  int percent =100;
  List searching =[];
  TextEditingController areaController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController contactController = TextEditingController(text: "");
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        dateController.text = myFormat.format(currentDate);
      });
  }

  String uid='';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Add Leads",
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
          EdgeInsets.symmetric(horizontal: getHorizontalSize(20)),
          child: ListView(
            children: [
              SizedBox(
                height: 5,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller:locationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Location (Sector)",contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
                height: 10,
              ),

              Text(
                "Layout-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: getHorizontalSize(4),
                children: List.generate(layoutType.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      layoutType[index],
                      style: TextStyle(color: defaultChoiceIndex4 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex4 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex4 == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex4 =
                        value ? index : defaultChoiceIndex4;
                        layout = layoutType[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: rentController,

                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Budget",
                    contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
                height: 10,
              ),
              Text(
                "Type-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(type1.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.symmetric(horizontal: getHorizontalSize(5),vertical: getVerticalSize(2)),
                    label: Text(
                      type1[index],
                      style: TextStyle(color: defaultChoiceIndex5 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex5 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex5== index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex5 = value ? index : defaultChoiceIndex5;
                        type2 = type1[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: areaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Area (sq.feet)",
                    contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
                height: 10,
              ),
              Text(
                "Floor-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(floor.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      floor[index],
                      style: TextStyle(color: defaultChoiceIndex1 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex1== index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex1== index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex1 = value ? index : defaultChoiceIndex1;
                        floors = floor[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Furnishing-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(furnishing.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      furnishing[index],
                      style: TextStyle(color: defaultChoiceIndex6 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex6== index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex6== index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex6 = value ? index : defaultChoiceIndex6;
                        furnish = furnishing[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),


              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(15)),
                height: getVerticalSize(60),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width:getHorizontalSize(280),
                      child: TextField(
                        controller:dateController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            hintText: "Available From",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey,fontSize: getFontSize(23),fontWeight: FontWeight.w500 ),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Icon(
                                  Icons.calendar_month, color: Colors.white, size:getHorizontalSize(25),))
                        ),
                        // myFormat.format(currentDate).toString(),
                        style: TextStyle(
                            color: Colors.white, fontSize: getFontSize(20)),),
                    ),
                  ],
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
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
                    labelText: "Contact",
                    contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),

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
                  validator: (val){
                    if(val!.length < 10){
                      return "Please Enter 10 digit mobile number";
                    }
                  },
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: TextButton(
                    child: Text("Save", style: TextStyle(color: Colors.black,
                        fontSize: getFontSize(20),
                        fontWeight: FontWeight.w500),),
                    onPressed: ()async{
                      if(nameController.text.isEmpty||contactController.text.length<10||type2==''||locationController.text.isEmpty||
                          layout==''||floors==""||rentController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please Enter All Details '),));
                      }
                      else{
                        FirebaseFirestore.instance.collection("leads").add(
                          {
                            "name": nameController.text,
                            "contact": contactController.text,
                            "type": type2,
                            "locality": locationController.text,
                            "date": dateController.text,
                            "layout": layout,
                            "floor": floors,
                            "rent": rentController.text,
                            "carpet":areaController.text,
                            "furnish":furnish,
                          },).then((value) {
                          setState(() {
                            cart.leadsUserID(value.id);
                            FirebaseFirestore.instance.collection("property").doc(uid).update({
                              "leadsid":FieldValue.arrayUnion(cart.leadsUserI),
                            },);
                          });
                        });
                        await AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.SUCCES,
                          // autoHide: Duration(seconds: 2),
                          // body: Center(child: Text(
                          //   'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                          //   style: TextStyle(fontStyle: FontStyle.italic),
                          // ),),
                          title: 'Leads Are Added',
                          bodyHeaderDistance: 10.0,
                          autoHide: Duration(seconds: 3,milliseconds: 500),
                          // desc:   'This is also Ignored',
                        ).show();
                        print(cart.leadsUserI);
                        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                      }
                      }
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
