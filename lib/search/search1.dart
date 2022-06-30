import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zeero_app/leads/showLeadMatch.dart';
import 'package:zeero_app/leads/showleads.dart';

import '../home/home_screen.dart';
import '../match2.dart';
import '../matches/match.dart';
import '../math_utils.dart';
import '../provider.dart';
import '../size_config.dart';
import 'filters.dart';
import 'package:intl/intl.dart';


class Search1 extends StatefulWidget {
  static String routeName = "/search1";

  const Search1({Key? key}) : super(key: key);

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  List<String> _choicesList = ['Buy', 'Rent'];
  List layoutType=["1 BHK","2 BHK","3 BHK","4 BHK","4BHK +"];
  List furnishing=["Raw","Semi-Furnished","Furnished",];
  List floor=["GF(0)","Low Rise(1-4)","Mid Rise(5-8)","High Rise(8+)"];
  String floors = '';
  String choice='';
  String property = '';
  int index1 =0;




  int defaultChoiceIndex1=5;
  int defaultChoiceIndex=5;
  int defaultChoiceIndex3=5;
  int defaultChoiceIndex4=5;
  int defaultChoiceIndex5=5;
  int defaultChoiceIndex2=5;
  List<String> _property = ['Residential', 'Commercial'];


  String layout = '';
  String furnish = '';
  int percent =100;
  List searching =[];
  TextEditingController areaController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      final args = ModalRoute.of(context)!.settings.arguments;
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Match",
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
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                // width: getHorizontalSize(100),
                child: ToggleSwitch(
                  minWidth: 80.0,
                  minHeight: 40.0,
                  fontSize: 17.0,
                  initialLabelIndex: index1,
                  activeBgColor: [Colors.tealAccent],
                  activeFgColor: Colors.black,
                  inactiveBgColor: Colors.black,
                  inactiveFgColor: Colors.white,
                  cornerRadius: 25,
                  totalSwitches: 2,
                  borderWidth: 1,
                  borderColor: [Colors.white],
                  labels: ['Leads', 'Supply'],
                  onToggle: (index) {
                     index1 = index!;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(_choicesList.length, (index) {
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.all(2.0),
                    label: Text(
                      _choicesList[index],
                      style: TextStyle(color: defaultChoiceIndex == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex = value ? index : defaultChoiceIndex;
                        choice = _choicesList[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),

              Wrap(
                spacing: 10,
                children: List.generate(_property.length, (index) {
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.all(2.0),
                    label: Text(
                      _property[index],
                      style: TextStyle(color: defaultChoiceIndex3 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex3 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex3 == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex3 = value ? index : defaultChoiceIndex3;
                        property = _property[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              const SizedBox(
                height: 15,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller:locationController,

                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Location (Sector)",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                "Layout-",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: getHorizontalSize(4),
                children: List.generate(layoutType.length, (index) {
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.all(2.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: rentController,

                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Budget",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Furnishing-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(furnishing.length, (index) {
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.all(2.0),
                    label: Text(
                      furnishing[index],
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
                        furnish = furnishing[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),

              const SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: areaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Area (sq.feet)",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Floor-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(floor.length, (index) {
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.all(2.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: TextButton(
                  child: Text("Match", style: TextStyle(color: Colors.black,
                      fontSize: getFontSize(20),
                      fontWeight: FontWeight.w500),),
                  onPressed: () {
                    print(index1);
                    cart.search.clear();
                    cart.leadSearch.clear();
                    cart.showLeads.clear();
                    if(index1==0){
                      cart.addSearch(locationController.text, layout, rentController.text, furnish, areaController.text, floors);
                      args.toString()=="Zeero"?Navigator.pushReplacementNamed(context, MatchSearch.routeName):args.toString()=="Own"?Navigator.pushReplacementNamed(context, MatchSearch2.routeName):Container();
                    }
                    else if(index1==1){
                      cart.showLeadSearch(locationController.text, layout, rentController.text, furnish, areaController.text, floors);
                      args.toString()=="Zeero"?Navigator.pushReplacementNamed(context, ShowLeads.routeName):args.toString()=="Own"?Navigator.pushReplacementNamed(context, ShowLeadSearch.routeName):Container();
                    }
                    }
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }
}
