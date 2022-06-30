import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zeero_app/home/home_screen.dart';

import 'login/login_screen.dart';
import 'math_utils.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Image.asset("assets/images/heart3.gif",width: getHorizontalSize(300),height: getVerticalSize(100),),
    );
  }
}

