import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zeero_app/home/home_screen.dart';

import 'login/login_screen.dart';
import 'math_utils.dart';

class Splash extends StatefulWidget {
  static String routeName = "/splash";

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>  FirebaseAuth.instance.currentUser==null?Navigator.of(context).pushReplacementNamed(LoginScreen.routeName):Navigator.of(context).pushReplacementNamed(HomeScreen.routeName)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: getVerticalSize(300)),
            child: Image.asset("assets/images/logo_zoom.png",width: getHorizontalSize(300),height: getVerticalSize(150),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: getVerticalSize(0)),
            child: Image.asset("assets/images/heart3.gif",width: getHorizontalSize(300),height: getVerticalSize(100),),
          ),
          // Container(
          //   child: const SpinKitDancingSquare(
          //     color: Colors.white,
          //     size: 50.0,
          //   ),
          //
          // )

        ],
      )
    );
  }
}
