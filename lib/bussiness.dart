import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeero_app/businessscreen.dart';
import 'package:zeero_app/home/home_screen.dart';
import 'package:zeero_app/provider.dart';

import 'math_utils.dart';
import 'package:intl/intl.dart';


class Bussiness extends StatefulWidget {
  static String routeName = "/bussiness";

  const Bussiness({Key? key}) : super(key: key);

  @override
  State<Bussiness> createState() => _BussinessState();
}

class _BussinessState extends State<Bussiness> {

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      return WillPopScope(
        onWillPop: (){
          Navigator.popAndPushNamed(context, HomeScreen.routeName);
          return Future(() => false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Add Business",
                style: TextStyle(color: Colors.tealAccent),
              ),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.popAndPushNamed(context, HomeScreen.routeName);
                },
              ),
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
              margin: EdgeInsets.only(top: getVerticalSize(150)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/zeero.jpeg",width: getHorizontalSize(350),height: getVerticalSize(150),),
                  GestureDetector(
                    onTap: () {
                      _showDialog(context);
                    },
                    child: Container(
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
                      margin: EdgeInsets.only(top: getVerticalSize(120)),
                      // padding: EdgeInsets.symmetric(
                      //     vertical: getVerticalSize(20),
                      //     horizontal: getHorizontalSize(
                      //         40)),
                      child: Text("Add Revenue",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getFontSize(
                                22), fontWeight: FontWeight.w500),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDialog2(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: getHorizontalSize(250),
                      height: getVerticalSize(60),
                      margin: EdgeInsets.only(top: getVerticalSize(30)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(25),
                        border: Border.all(width: 0.5,
                          color: Colors.black,),
                        color: Colors.tealAccent,
                      ),
                      // margin: EdgeInsets.only(left: getHorizontalSize(80)),
                      // padding: EdgeInsets.symmetric(
                      //     vertical: getVerticalSize(20),
                      //     horizontal: getHorizontalSize(
                      //         40)),
                      child: Text("Add Expenses",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getFontSize(
                                22), fontWeight: FontWeight.w500),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cart.expenses.clear();
                      cart.revenue.clear();
                      Navigator.pushNamed(context, BusinessScreen.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: getHorizontalSize(250),
                      height: getVerticalSize(60),
                      margin: EdgeInsets.only(top: getVerticalSize(30)),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(25),
                        border: Border.all(width: 0.5,
                          color: Colors.black,),
                        color: Colors.tealAccent,
                      ),
                      // margin: EdgeInsets.only(left: getHorizontalSize(80)),
                      child: Text("View Bussiness",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getFontSize(
                                22), fontWeight: FontWeight.w500),),
                    ),
                  ),


                ],
              ),


            )

        ),
      );
    });
  }
}
_showDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        final User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid.toString();
        String dateText ='Choose Date';
        TextEditingController totalController = TextEditingController();
        TextEditingController collectedController = TextEditingController();
        int uncollected =0;
        DateTime currentDate = DateTime.now();
        var myFormat = DateFormat("yMMMd");
        return AlertDialog(
          contentPadding: EdgeInsets.all(4),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                Future<void> _selectDate(BuildContext context) async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialDate: currentDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2050));
                  if (pickedDate != null && pickedDate != currentDate) {
                    setState(() {
                      currentDate = pickedDate;
                      dateText = myFormat.format(currentDate);
                      print(dateText);
                    });
                  }
                }
                return Container(
                  width: getHorizontalSize(250),
                  height: getVerticalSize(400),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: getVerticalSize(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Total - ", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFontSize(
                                      22), fontWeight: FontWeight.w500),),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: getHorizontalSize(20)),
                                width: getHorizontalSize(90),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)
                                ),
                                child: TextField(
                                  controller: totalController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getFontSize(18)
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: getVerticalSize(30),
                              left: getHorizontalSize(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              Text("Collected - ", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFontSize(
                                      22), fontWeight: FontWeight.w500),),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: getHorizontalSize(20)),
                                width: getHorizontalSize(90),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)
                                ),
                                child: TextField(
                                  controller: collectedController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getFontSize(18)
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      uncollected = int.parse(totalController.text) - int.parse(collectedController.text);
                                    });
                                  },
                                ),
                              )
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: getVerticalSize(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Uncollected - ", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFontSize(
                                      22), fontWeight: FontWeight.w500),),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: getHorizontalSize(20)),
                                width: getHorizontalSize(90),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: getVerticalSize(7)),
                                child: Text(
                                  uncollected.toString(), style:
                                TextStyle(
                                    color: Colors.white,
                                    fontSize: getFontSize(18)
                                ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: getVerticalSize(20)),
                        height: getVerticalSize(50),
                        width: getHorizontalSize(200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:EdgeInsets.only(left: getHorizontalSize(10)),
                              child: Text(
                                dateText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getFontSize(18)),),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.calendar_month, color: Colors.white,
                                    size: 30,),
                                ))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          if(totalController.text.isEmpty||collectedController.text.isEmpty||dateText=='Choose Date'||dateText==""){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please Enter All Details '),));
                          }
                          else{
                            FirebaseFirestore.instance.collection("business").doc(uid).collection("revenue").add(
                                {
                                  "revenue":totalController.text,
                                  "collected":collectedController.text,
                                  "uncollected":uncollected,
                                  "year":int.parse(DateFormat("y").format(currentDate).toString()),
                                  "month":DateFormat("MMMM").format(currentDate).toString(),
                                  "date":int.parse(DateFormat("d").format(currentDate).toString()),
                                });
                            await AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.SUCCES,
                              title: 'Revenue is Added',
                              bodyHeaderDistance: 10.0,
                              autoHide: Duration(seconds: 3,milliseconds: 500),
                              // desc:   'This is also Ignored',
                            ).show();
                            Navigator.of(context).pop();
                          }

                        },
                        child: Container(
                          alignment:Alignment.center,
                          width: getHorizontalSize(120),
                          height: getVerticalSize(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius
                                .circular(25),
                            border: Border.all(width: 0.5,
                              color: Colors.black,),
                            color: Colors.tealAccent,
                          ),
                          margin: EdgeInsets.only(top: getVerticalSize(40)),
                          child: Text("Save",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(
                                    22),fontWeight: FontWeight.w500),),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: MediaQuery
                      //       .of(context)
                      //       .viewInsets
                      //       .bottom),
                      // )


                    ],
                  ),
                );

              }
          ),
        );

      });
}

_showDialog2(context) {

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> items = [
          'Office Rent',
          'Salary',
          'Revenue Share',
          'Electricity',
          'Office Expenses',

        ];

        String? dropdownvalue;
        final User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid.toString();
        String dateText ='Choose date';
        TextEditingController amountController = TextEditingController();
        DateTime currentDate = DateTime.now();
        var myFormat = DateFormat("yMMMd");
        return AlertDialog(
          contentPadding: EdgeInsets.all(4),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                Future<void> _selectDate(BuildContext context) async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialDate: currentDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2050));
                  if (pickedDate != null && pickedDate != currentDate) {
                    setState(() {
                      currentDate = pickedDate;
                      dateText = myFormat.format(currentDate);
                      print(dateText);
                    });
                  }
                }
                return Container(
                  width: getHorizontalSize(250),
                  height: getVerticalSize(300),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: getVerticalSize(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Amount - ", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getFontSize(
                                      22), fontWeight: FontWeight.w500),),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: getHorizontalSize(20)),
                                width: getHorizontalSize(90),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)
                                ),
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getFontSize(18)
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: getVerticalSize(25)),
                        child: DropdownButton(
                          value: dropdownvalue,
                          hint: Text("Type",style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
                          icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                          style: TextStyle(color: Colors.amber.shade600,fontWeight: FontWeight.w500,fontSize: getFontSize(17)),
                          dropdownColor: Colors.black,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: getVerticalSize(20)),
                        height: getVerticalSize(40),
                        width: getHorizontalSize(200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:EdgeInsets.only(left: getHorizontalSize(10)),
                              child: Text(
                                dateText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getFontSize(18)),),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.calendar_month, color: Colors.white,
                                    size: 30,),
                                ))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          if(amountController.text.isEmpty||dropdownvalue==null||dateText=='Choose Date'||dateText==""){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please Enter All Details '),));
                          }
                          else{
                            FirebaseFirestore.instance.collection("business").doc(uid).collection("expenses").add(
                                {
                                  "type":dropdownvalue,
                                  "amount":amountController.text,
                                  "year":int.parse(DateFormat("y").format(currentDate).toString()),
                                  "month":DateFormat("MMMM").format(currentDate).toString(),
                                  "date":int.parse(DateFormat("d").format(currentDate).toString()),
                                });
                            await AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                title: 'Expense is Added',
                                bodyHeaderDistance: 10.0,
                                autoHide: Duration(seconds: 3,milliseconds: 500),
                          // desc:   'This is also Ignored',
                          ).show();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          alignment:Alignment.center,
                          width: getHorizontalSize(120),
                          height: getVerticalSize(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius
                                .circular(25),
                            border: Border.all(width: 0.5,
                              color: Colors.black,),
                            color: Colors.tealAccent,
                          ),
                          margin: EdgeInsets.only(top: getVerticalSize(40)),
                          // padding: EdgeInsets.symmetric(
                          //     vertical: getVerticalSize(20),
                          //     horizontal: getHorizontalSize(
                          //         40)),
                          child: Text("Add",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(
                                    22),fontWeight: FontWeight.w500),),
                        ),
                      ),

                    ],
                  ),
                );

              }
          ),
        );

      });
}
