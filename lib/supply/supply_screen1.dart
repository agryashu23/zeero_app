import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:zeero_app/supply/supply_screen2.dart';

import '../math_utils.dart';
import '../provider.dart';
import '../size_config.dart';

class  SupplyScreen1 extends StatefulWidget {
  static String routeName = "/supply1";

  @override
  State<SupplyScreen1> createState() => _SupplyScreen1State();
}

class _SupplyScreen1State extends State<SupplyScreen1> {
  int defaultChoiceIndex=4;
  int defaultChoiceIndex1=4;
  int defaultChoiceIndex2=4;
  int defaultChoiceIndex5=4;
  String choice="";
  String property="";
  String type="";
  String countryValue = "";
  String stateValue = "Haryana";
  String cityValue = "Gurgaon";
  String address = "";
  String located = "";

  TextEditingController cityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController societyController = TextEditingController();
  DateTime currentDate = DateTime.now();
  var myFormat = DateFormat("yMMMMd");
  List<String> _choicesList = ['Sell', 'Rent/Lease'];
  List<String> _property = ['Residential', 'Commercial'];
  List<String> _propertytype = ['Apartment', 'Villa/House', 'Builder Floor'];
  List<String> located_type = ['In a mall', 'In a market', 'In a society','Sandalone'];
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

  var thumbType=["Open parking","Covered Parking","Lift","Security Guards","Power Backup","Gym","Park","Swimming Pool","Clubhouse","Gas Pipeline"];
  List<bool> selectedList=[];
  List<String> selectedLanguage=[];
  Widget _listItem(int i) {
    selectedList.add(false);
    return Container(
      margin: EdgeInsets.only(left: 6,right: 6,top: 3,bottom: 3),
      child: FilterChip(
        selectedColor: Colors.tealAccent,
        backgroundColor: Colors.black12,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(thumbType[i]),
        selected: selectedList[i],
        onSelected: (bool value) {
          setState(() {
            if(value){
              selectedLanguage.add(thumbType[i]);
            }else{
              selectedLanguage.remove(thumbType[i]);
            }
            selectedList[i]=value;
            //get selected language
            debugPrint("selected Language :  $selectedLanguage");
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      final arguments = (ModalRoute
          .of(context)
          ?.settings
          .arguments ?? <String, dynamic>{}) as Map;
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Step 1 of 3",
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
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Add Basic Details",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "You are looking to?",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(_choicesList.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "What kind of property?",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(_property.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      _property[index],
                      style: TextStyle(color: defaultChoiceIndex1 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex1 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex1 == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex1 = value ? index : defaultChoiceIndex1;
                        property = _property[index];
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
                "Select Property Type",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(_propertytype.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      _propertytype[index],
                      style: TextStyle(color: defaultChoiceIndex2 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex2 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex2 == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex2 = value ? index : defaultChoiceIndex2;
                        type = _propertytype[index];
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
                height: getVerticalSize(20),
              ),

              CSCPicker(
                showStates: true,
                showCities: true,
                defaultCountry: DefaultCountry.India,
                flagState: CountryFlag.DISABLE,
                disableCountry: true,

                dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.black,
                    border:
                    Border.all(color: Colors.white, width: 1)),
                layout: Layout.vertical,

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black,
                  border:  Border.all(color: Colors.white, width: 1),
                ),

                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",
                // disableCountry: true,

                ///labels for dropdown
                countryDropdownLabel: "India",
                stateDropdownLabel: "Haryana",
                cityDropdownLabel: "Gurgaon",

                selectedItemStyle: TextStyle(
                  color: Colors.white,
                  fontSize: getFontSize(22),
                ),

                dropdownHeadingStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),

                dropdownItemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                dropdownDialogRadius: 10.0,
                searchBarRadius: 10.0,

                ///triggers once country selected in dropdown
                onCountryChanged: (value) {
                  setState(() {
                    ///store value in country variable
                    countryValue = value;
                  });
                },

                ///triggers once state selected in dropdown
                onStateChanged: (value) {
                  setState(() {
                    ///store value in state variable
                    stateValue = value.toString();
                  });
                },

                ///triggers once city selected in dropdown
                onCityChanged: (value) {
                  setState(() {
                    ///store value in city variable
                    cityValue = value.toString();
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),

              Container(

                child: TextFormField(
                  controller: societyController,
                  decoration: InputDecoration(
                    labelText: "Society Name",
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
              Container(
                child: TextFormField(
                  controller: localityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(getHorizontalSize(15)),
                    labelText: "Locality(Sector No.)",
                    labelStyle: TextStyle(color: Colors.white,fontSize: getFontSize(22)),
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
              property=="Commercial"?SizedBox(
                height: 20,
              ):Container(),
              property=="Commercial"?Text(
                "Located-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ):Container(),
              SizedBox(
                height: 10,
              ),
              property=="Commercial"?Wrap(
                spacing: 10,
                children: List.generate(located_type.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      located_type[index],
                      style: TextStyle(color: defaultChoiceIndex5 == index
                          ? Colors.black
                          : Colors.white, fontSize: 14),
                    ),
                    selected: defaultChoiceIndex5 == index,
                    backgroundColor: Colors.black,
                    selectedColor: Colors.tealAccent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: defaultChoiceIndex5 == index
                              ? Colors.grey
                              : Colors.white,
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      setState(() {
                        defaultChoiceIndex5 = value ? index : defaultChoiceIndex5;
                        located = located_type[index];
                      });
                    },
                    // backgroundColor: color,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ):Container(),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 5),
              //
              //   child: TextFormField(
              //     controller:societyController,
              //     decoration: InputDecoration(
              //       labelText: "Society Name",
              //       labelStyle: TextStyle(color: Colors.white),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.white),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.tealAccent),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     maxLines: 1,
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
              // Text(
              //   "Available From-",
              //   style: TextStyle(color: Colors.white, fontSize: 20),
              // ),
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
                                Icons.calendar_month, color: Colors.white, size: 30,))
                        ),
                        // myFormat.format(currentDate).toString(),
                        style: TextStyle(
                            color: Colors.white, fontSize: getFontSize(20)),),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Society Details-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                children: [
                  for(int i = 0; i < thumbType.length; i++) _listItem(i)
                ],
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
                  child: Text("Next",style: TextStyle(color: Colors.black,fontSize: getFontSize(17),fontWeight: FontWeight.w500),),
                  onPressed: () {
                      if(choice==''||property==''||type==''||cityValue==""||
                          localityController.text.isEmpty||dateController.text.isEmpty||societyController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please Enter All Details '),));
                      }
                      else{
                        cart.addAllSupply();
                        setState(() {
                          cart.addSupply1(choice, property, type,stateValue, cityValue, localityController.text,located,
                               dateController.text, selectedLanguage,societyController.text);
                          print(cart.supply1);
                          Navigator.of(context).pushNamed(SupplyScreen2.routeName);
                        });
                      }
                   // print(cart.supply1);

                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }
}
