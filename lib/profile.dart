
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeero_app/math_utils.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

import 'Loading.dart';
import 'home/home_screen.dart';




class Profile extends StatefulWidget {
  static String routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;
  String uid='';
  bool isLoading = false;
  String urlImage ='';




  Future<void> getPicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        // final imageTemp = File(image.path);
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } on PlatformException catch (err) {
      //debugPrint('Failed to Pick up the Image: $err');
    }
    print(_imageFile);
  }
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  Future uploadFiles() async {
    ref = firebase_storage.FirebaseStorage.instance.ref().child('users/${Path.basename(_imageFile!.path)}');
    await ref.putFile(_imageFile!).whenComplete(() async{
      await ref.getDownloadURL().then((value) async {
        imgRef.add({"url":value});
        setState(() {
          urlImage = value;
        });
      }
      );
    }
    );
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController officeNameController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  int defaultChoiceIndex=4;
  int counter =0;

  List<String> _choicesList = ['Employee', 'Freelancer'];
  String choice="";
  FirebaseAuth auth = FirebaseAuth.instance;
  String? phone;
  @override
  void initState(){
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
    imgRef = FirebaseFirestore.instance.collection("userImages");
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value){
      if(value.exists){
        setState((){
          counter=1;
        });
      }
    });
    phone = FirebaseAuth.instance.currentUser?.phoneNumber!;
    setState((){
      contactController.text = phone.toString();
    });
    print(uid);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Profile",
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
      body: isLoading?Loading():
      counter==1?StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.data!=null){
              var docu = snapshot.data;
              int defaultChoiceIndex1 = docu!["type"]=="Employee"?0:1;
              TextEditingController nameController1 = TextEditingController(text: docu["name"]);
              TextEditingController officeNameController1 = TextEditingController(text:docu["office name"]);
              TextEditingController officeAddressController1 = TextEditingController(text:docu["office address"]);
              TextEditingController contactController1 = TextEditingController(text:phone);
              urlImage = docu["image"];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: getHorizontalSize(120),
                        height: getVerticalSize(120),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        child: docu["image"] != null
                            ? Stack(
                          children: [
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(docu["image"]),
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(

                                onPressed: () {
                                  setState(() {
                                    getPicture();
                                  });
                                },
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.cyan,
                              ),
                            ),
                          ],
                        )
                            : Container(
                          alignment: Alignment.center,
                          child:CircularProgressIndicator(),
                        )
                    ),
                    SizedBox(
                      height: getVerticalSize(30),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: nameController1,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),

                      child: TextFormField(
                        controller: officeNameController1,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),

                      child: TextFormField(
                        controller: officeAddressController1,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),

                      child: TextFormField(
                        controller: contactController1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyan),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "User Type",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 20,
                      children: List.generate(_choicesList.length, (index) {
                        return ChoiceChip(
                          labelPadding: EdgeInsets.all(2.0),
                          label: Text(
                            _choicesList[index],
                            style: TextStyle(
                                color: defaultChoiceIndex1 == index
                                    ? Colors.black
                                    : Colors.white, fontSize: 14),
                          ),
                          selected: defaultChoiceIndex1 == index,
                          backgroundColor: Colors.black,
                          selectedColor: Colors.cyan,
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
                      height: 30,
                    ),
                    Container(
                      width: getHorizontalSize(250),
                      decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextButton(
                        child: Text("Save", style: TextStyle(color: Colors
                            .black,
                            fontSize: getFontSize(18),
                            fontWeight: FontWeight.w500),),
                        onPressed: () async {
                          uploadFiles();
                          FirebaseFirestore.instance.collection("users")
                              .doc(uid)
                              .update({
                            "image": urlImage,
                            "name": nameController1.text,
                            "office name": officeNameController1.text,
                            "office address": officeAddressController1.text,
                            "contact": contactController1.text,
                            "type": choice,
                          });
                          Navigator.of(context).pushReplacementNamed(
                              HomeScreen.routeName);
                        },

                      ),
                    ),

                  ],
                ),
              );
            }
            else{
              return Loading();
            }


          }
            ):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: getHorizontalSize(120),
              height: getVerticalSize(120),
              decoration: BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5,
                  color: Colors.white,
                ),
              ),
              child: _imageFile != null
                  ? Stack(
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: FileImage(File(_imageFile!.path),
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(

                      onPressed: () {
                        setState(() {
                          getPicture();
                        });
                      },
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                ],
              )
                  : InkWell(
                onTap: () {
                  setState(() {
                    getPicture();
                  });
                },
                child: Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.tealAccent,
                    size: 34,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getVerticalSize(30),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),

              child: TextFormField(
                controller: officeNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Office Name",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),

              child: TextFormField(
                controller: officeAddressController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: "Office Address",
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
              height: 20,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),

              child: TextFormField(
                controller: contactController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "User Type",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 20,
              children: List.generate(_choicesList.length, (index) {
                return ChoiceChip(
                  labelPadding: EdgeInsets.all(2.0),
                  label: Text(
                    _choicesList[index],
                    style: TextStyle(color: defaultChoiceIndex == index
                        ? Colors.black
                        : Colors.white, fontSize: 14),
                  ),
                  selected:defaultChoiceIndex==index,
                  backgroundColor: Colors.black,
                  selectedColor: Colors.cyan,
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
              height: 30,
            ),
            Container(
              width: getHorizontalSize(250),
              decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextButton(
                child: Text("Save",style: TextStyle(color: Colors.black,fontSize: getFontSize(18),fontWeight: FontWeight.w500),),
                onPressed: () async{
                  if(_imageFile==null||nameController.text.isEmpty||officeNameController.text.isEmpty||officeAddressController.text.isEmpty||contactController.text.isEmpty||choice==""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please Enter All Details '),));
                  }
                  else{
                    setState((){
                      isLoading = true;
                    });
                    await uploadFiles();
                    FirebaseFirestore.instance.collection("users").doc(uid).set({
                      "image":urlImage,
                      "name":nameController.text,
                      "office name":officeNameController.text,
                      "office address":officeAddressController.text,
                      "contact":contactController.text,
                      "type":choice,
                    });
                    setState((){
                      isLoading = false;
                    });
                    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                  }

                },
              ),
            ),

          ],
        ),
      ) ,

    );
  }
}
