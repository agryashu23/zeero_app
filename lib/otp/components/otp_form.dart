import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zeero_app/math_utils.dart';
import 'package:zeero_app/profile.dart';
// import 'package:zeero/default_button.dart';
// import 'package:zeero/home/home_screen.dart';
// import 'package:zeero/size_config.dart';

import '../../Loading.dart';
import '../../default_button.dart';
import '../../home/home_screen.dart';
import '../../size_config.dart';

class OtpForm extends StatefulWidget {
  final String verificationId;
  final FirebaseAuth auth;
  const OtpForm({
    Key? key,
    required this.auth,
    required this.verificationId,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  bool isLoading = false;
  TextEditingController otpEditingController = TextEditingController();
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void dispose() {
  //   otpEditingController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading? Loading():Form(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              child: PinCodeTextField(
                textStyle: const TextStyle(color: Colors.white),
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  borderWidth: 2.5,
                  inactiveColor: Colors.white24,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white24,
                ),
                animationDuration: const Duration(milliseconds: 300),
                controller: otpEditingController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),
            ),
            SizedBox(height: getVerticalSize(10)),
            DefaultButton(
              text: "Continue",
              press: () {
                // debugPrint(con6.text);
                PhoneAuthCredential phoneCredential =
                    PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: otpEditingController.text,
                );
                signInWithPhoneCredential(phoneCredential);
                // Navigator.of(context).pushNamed(HomeScreen.routeName);
              },
            )
          ],
        ),
    );
  }

  void signInWithPhoneCredential(PhoneAuthCredential phoneCredential) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.auth.currentUser != null) {}
      final authCredential =
          await widget.auth.signInWithCredential(phoneCredential);
      setState(() {
        isLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(Profile.routeName,(Route<dynamic> route) => false);
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),));
      setState(() {
        isLoading = false;
      });
    }
  }
}
