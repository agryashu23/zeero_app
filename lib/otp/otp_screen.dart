import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:zeero/size_config.dart';
import 'package:zeero_app/size_config.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    Key? key,
    required this.auth,
    required this.phoneNum,
    required this.verificationId,
  }) : super(key: key);
  final String verificationId;
  final FirebaseAuth auth;
  final String phoneNum;

  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    // final phoneNum = ModalRoute.of(context)!.settings.arguments as String;
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "OTP Verification",
          style: TextStyle(color: Colors.tealAccent),
        ),
      ),
      body: Body(
          phoneNumber: phoneNum, auth: auth, verificationId: verificationId),
    );
  }
}
