
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:zeero_app/math_utils.dart';
import 'package:zeero_app/provider.dart';


class BusinessScreen extends StatefulWidget {
  static String routeName = "/BusinessScreen";

  const BusinessScreen({Key? key}) : super(key: key);


  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen>with SingleTickerProviderStateMixin {
  DateTimeRange? _selectedDateRange;
  int? startDate;
  bool dates = false;
  String? startMonth;
  int? startYear;
  int? endDate;
  String? endMonth;
  int? endYear;
  bool dat = false;
  String uid = '';
  // List expense = [];
  // List revenue = [];
  int reven=0;
  int collect=0;
  int officeRent=0;
  int salary=0;
  int share=0;
  int electricity=0;
  int officeExp=0;
  int totalExpense=0;
  bool item1 = false;
  bool item2 = false;
  bool item3 = false;
  bool show = false;

  void _show(FormModel cart) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );
    if (result != null) {
      setState(() {
        _selectedDateRange = result;
        startDate = int.parse(
            DateFormat("d").format(_selectedDateRange!.start).toString());
        startMonth =
            DateFormat("MMMM").format(_selectedDateRange!.start).toString();
        startYear = int.parse(
            DateFormat("y").format(_selectedDateRange!.start).toString());
        endDate = int.parse(
            DateFormat("d").format(_selectedDateRange!.end).toString());
        endMonth =
            DateFormat("MMMM").format(_selectedDateRange!.end).toString();
        endYear = int.parse(
            DateFormat("y").format(_selectedDateRange!.end).toString());
        if (DateFormat("yMMMd").format(_selectedDateRange!.start).toString() ==
            DateFormat("yMMMd").format(_selectedDateRange!.end).toString()) {
          dates = true;
        }
        dat = true;

      });
      await FirebaseFirestore.instance.collection('business').doc(uid)
          .collection("revenue").where("year", isEqualTo: startYear).get().then((value) {
        value.docs.forEach((element) {
          if(element["month"]==startMonth.toString()&&element["date"]>=startDate&&element["date"]<=endDate){
            setState(() { cart.addRevenue(element.id); });
          }
        });
      });
      await FirebaseFirestore.instance.collection('business').doc(uid)
          .collection("expenses").where("year", isEqualTo: startYear).get().then((value) {
        value.docs.forEach((element) {
          if(element["month"]==startMonth.toString()&&element["date"]>=startDate&&element["date"]<=endDate){
            setState(() {  cart.addExpense(element.id); });

          }
        });
      });
      print(cart.expenses);
      print(cart.revenue);
      setState(() {
        show = true;
      });

      // getData(cart);

    }
    getData(cart);

  }

  // DateRangePickerController pickerController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
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
            "My Business",
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              show ? Container() : GestureDetector(
                onTap: () {
                  _show(cart);
                },
                child: Container(
                  margin: EdgeInsets.only(top: getVerticalSize(100)),
                  alignment: Alignment.center,
                  width: getHorizontalSize(160),
                  height: getVerticalSize(45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius
                        .circular(15),
                    border: Border.all(width: 0.5,
                      color: Colors.black,),
                    color: Colors.tealAccent,
                  ),
                  child: Text("Select Date",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(
                            20), fontWeight: FontWeight.w500),),
                ),
              ),
              show?Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0)
                ),
                margin: EdgeInsets.only(left: getHorizontalSize(20),
                    right: getHorizontalSize(20),
                    top: getVerticalSize(30)),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.blue,
                      title: Text('Total Revenue', style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(20)),),
                      trailing: Text(
                        (reven)
                            .toString(), style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(20)),),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getHorizontalSize(15)),
                    ),
                    SizedBox(height: getVerticalSize(10),),

                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {},
                      children: [
                        ExpansionPanel(
                          backgroundColor: item1
                              ? Colors.amber.shade600
                              : Colors.white,
                          headerBuilder: (BuildContext context,
                              bool isExpanded) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item1 = !item1;
                                  });
                                },
                                child: ListTile(
                                  title: Text('Total Revenue', style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                  dense: true,
                                ),
                              ),
                            );
                          },
                          body: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.blue,
                                title: Text('Revenue', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(reven.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ), ListTile(
                                title: Text('Collected', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(collect.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                              ListTile(
                                title: Text('UnCollected', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text((reven - collect).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                            ],
                          ),
                          isExpanded: item1,
                        ),
                        ExpansionPanel(
                          backgroundColor: item2
                              ? Colors.amber.shade600
                              : Colors.white,
                          headerBuilder: (BuildContext context,
                              bool isExpanded) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item2 = !item2;
                                  });
                                },
                                child: ListTile(
                                  title: Text('Fixed Expenses',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getFontSize(20),
                                        color: Colors.black),),
                                  dense: true,
                                ),
                              ),
                            );
                          },
                          body: Column(
                            children: [
                              ListTile(
                                title: Text('Office Rent', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(officeRent.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ), ListTile(
                                title: Text('Salary', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(salary.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                              ListTile(
                                tileColor: Colors.blue,
                                title: Text('Total Fixed', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text((officeRent + salary).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                            ],
                          ),
                          isExpanded: item2,
                        ),
                        ExpansionPanel(
                          backgroundColor: item3
                              ? Colors.amber.shade600
                              : Colors.white,
                          headerBuilder: (BuildContext context,
                              bool isExpanded) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item3 = !item3;
                                  });
                                },
                                child: ListTile(
                                  title: Text('Controllable Expenses',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getFontSize(20),
                                        color: Colors.black),),
                                  dense: true,
                                ),
                              ),
                            );
                          },
                          body: Column(
                            children: [
                              ListTile(
                                title: Text('Revenue Share', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(share.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ), ListTile(
                                title: Text('Electricity', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text(electricity.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                              ListTile(
                                title: Text('Office Expenses', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getFontSize(20)),),
                                trailing: Text((officeExp).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                              ListTile(
                                tileColor: Colors.blue,
                                title: Text('Total Controllable Expenses',
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                trailing: Text(
                                  (share + electricity + officeExp).toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(20)),),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getHorizontalSize(15)),
                              ),
                            ],
                          ),
                          isExpanded: item3,
                        ),
                      ],
                    ),
                    SizedBox(height: getVerticalSize(20),),
                    ListTile(
                      tileColor: Colors.amber.shade600,
                      title: Text('Total Expenses', style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(20)),),
                      trailing: Text(
                        (officeRent + salary + share + electricity + officeExp)
                            .toString(), style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(20)),),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getHorizontalSize(15)),
                    ),
                    SizedBox(height: getVerticalSize(20),),
                    reven - (officeRent + salary + share + electricity +
                        officeExp) > 0 ? ListTile(
                      tileColor: Colors.green,
                      title: Text('Profit', style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: getFontSize(
                          20)),),
                      trailing: Text(((reven - (officeRent + salary + share +
                          electricity + officeExp)).abs()).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: getFontSize(
                            20)),),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getHorizontalSize(15)),
                    ) : ListTile(
                      tileColor: Colors.red,
                      title: Text('Loss', style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: getFontSize(
                          20)),),
                      trailing: Text(((officeRent + salary + share +
                          electricity + officeExp) - reven).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: getFontSize(
                            20)),),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getHorizontalSize(15)),
                    )
                  ],
                ),
              )
              : Container(
                child: Text("Select Date to Show Business",style: TextStyle(color: Colors.white,fontSize: getFontSize(22)),),
                margin: EdgeInsets.only(top: getVerticalSize(50)),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      );
    });
  }

  getData(FormModel cart){
    // cart.runF();

    for(int i =0;i<cart.revenue.length;i++){
      FirebaseFirestore.instance.collection("business").doc(uid).collection("revenue").doc(cart.revenue[i].toString()).get().then((value) {
        setState(() {   reven = reven + int.parse(value.data()!["revenue"]);
        collect = collect + int.parse(value.data()!["collected"]); });
      });
    }

    for(int i =0;i<cart.expenses.length;i++){
      FirebaseFirestore.instance.collection("business").doc(uid).collection("expenses").doc(cart.expenses[i]).get().then((value) {
        if(value.data()!["type"]=="Office Rent"){
          setState(() {           officeRent = officeRent + int.parse(value.data()!["amount"]);
          });
        }
        if(value.data()!["type"]=="Salary"){
          setState(() {           salary = salary + int.parse(value.data()!["amount"]);
          });
        }
        if(value.data()!["type"]=="Revenue Share"){
          setState(() {           share = share + int.parse(value.data()!["amount"]);
          });
        }
        if(value.data()!["type"]=="Electricity"){
          setState(() { electricity = electricity + int.parse(value.data()!["amount"]);
          });
        }
        if(value.data()!["type"]=="Office Expenses"){
          setState(() {  officeExp = officeExp + int.parse(value.data()!["amount"]); });

        }
      });
    }


  }
}

