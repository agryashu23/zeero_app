
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeero_app/supply/supply_screen3.dart';
import 'package:path/path.dart' as Path;
import '../Loading.dart';
import '../math_utils.dart';
import '../provider.dart';
import '../size_config.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyScreen2 extends StatefulWidget {
  static String routeName = "/supply2";

  @override
  State<SupplyScreen2> createState() => _SupplyScreen2State();
}

class _SupplyScreen2State extends State<SupplyScreen2> {
  String text='';

  bool selected = false;
  int defaultChoiceIndex =8;
  int defaultChoiceIndex1 =4;
  int defaultChoiceIndex2 =4;
  int defaultChoiceIndex5 =4;
  int defaultChoiceIndex6 =5;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _imagepath;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  List floor=["GF(0)","Low Rise(1-4)","Mid Rise(5-8)","High Rise(8+)"];
  String floors = '';



  TextEditingController carpetController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController SecurityController = TextEditingController();


  List layoutType=["1 BHK","2 BHK","3 BHK","4 BHK","4BHK +"];
  List furnishing=["Raw","Semi-Furnished","Furnished",];
  List washroom=["1","2","3","More than 3"];
  List balcony=["0","1","2","3"];
  String layout = '';
  String furnish = '';
  String Washroom = '';
  String Balcony = '';
  List imagepaths =[];
  List<File> images = [];

  final ImagePicker imgpicker = ImagePicker();
  List urlImage = [];
  List<XFile>? imagefiles;
  void openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      if(pickedfiles != null){
        imagefiles = pickedfiles;
        setState(() {
        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }
  Future uploadFiles() async {
    setState(() {
      isLoading= true;

    });
    for(File img in images){
      ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async{
        await ref.getDownloadURL().then((value) async {
          imgRef.add({"url":value});
          urlImage.add(value);
        }
        );
      }
      );
    }

  }


  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection("imageURLs");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormModel>(builder: (context, cart, child)
    {
      return isLoading?Center(
        child: Loading(),
      ):Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Step 2 of 3",
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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: const Text(
                  "Advance Details",
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
              GestureDetector(
                onTap: () {
                  openImages();
                },
                child: Container(
                  margin: EdgeInsets.only(right: getHorizontalSize(240)),
                  height: getVerticalSize(70),
                  // width: getHorizontalSize(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                      color: Colors.tealAccent
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.add_photo_alternate_outlined,size: getHorizontalSize(60),)
                ),
              ),
              imagefiles != null ? Padding(
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: getHorizontalSize(
                      5.00,
                    ),
                    crossAxisSpacing: getHorizontalSize(
                      5.00,
                    ),
                  ),
                  itemCount: imagefiles?.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        height: 100, width: 110,
                        child: Image.file(File(imagefiles![index].path),
                          fit: BoxFit.cover,),
                      ),
                    );
                  },
                ),
              )
                  : Container(),
              SizedBox(
                height: 20,
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
              Text(
                "WashRoom-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(washroom.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(4.0),
                    label: Text(
                      washroom[index],
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
                        defaultChoiceIndex1 =
                        value ? index : defaultChoiceIndex1;
                        Washroom = washroom[index];
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
                "Balcony-",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: List.generate(balcony.length, (index) {
                  return ChoiceChip(
                    labelPadding: EdgeInsets.all(4.0),
                    label: Text(
                      balcony[index],
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
                        defaultChoiceIndex2 =
                        value ? index : defaultChoiceIndex2;
                        Balcony = balcony[index];
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                  );
                }),
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: carpetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Carpet Area (in sq. feet)",
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

              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: rentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: cart.supply1[0]["choice"]=="Rent/Lease"?"Rent":"Price",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder:
                    OutlineInputBorder(
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

              cart.supply1[0]["choice"]=="Rent/Lease"?Container(
                margin: EdgeInsets.symmetric(horizontal: 5),

                child: TextFormField(
                  controller: SecurityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Security Deposit ",
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
              ):Container(),
              cart.supply1[0]["choice"]=="Rent/Lease"?SizedBox(
                height: 10,
              ):Container(),
              Container(

                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: TextButton(
                  child: Text("Next",style: TextStyle(color: Colors.black,fontSize: getFontSize(17),fontWeight: FontWeight.w500),),
                  onPressed: () async{
                    if(imagefiles!.isEmpty||layout==''||Washroom==''||Balcony==''||carpetController.text.isEmpty||
                    floors==''||rentController.text.isEmpty||furnishing.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please Enter All Details '),));
                    }
                    else{
                      for(int i=0;i<imagefiles!.length;i++){
                        images.add(File(imagefiles![i].path));
                      }
                      await uploadFiles();
                      // print(urlImage);

                      setState(() {

                        cart.addSupply2(urlImage,layout, Washroom, Balcony, furnish,carpetController.text, floors, rentController.text, SecurityController.text);
                        isLoading = false;
                      });


                      // print(cart.supply2);
                      Navigator.of(context).pushNamed(SupplyScreen3.routeName);
                      // print(imagefiles![0].path);
                    }

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
  // void _loadimage() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     for(int i =1;i<=imagefiles!.length;i++){
  //       imagepaths.add(prefs.getString("image$i"));
  //     }
  //
  //   });
  // }
}
