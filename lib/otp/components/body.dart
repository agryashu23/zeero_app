import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeero_app/math_utils.dart';
import 'package:zeero_app/size_config.dart';
// import 'package:zeero/constants.dart';
// import 'package:zeero/size_config.dart';

import '../../constants.dart';
import '../otp_screen.dart';
import 'otp_form.dart';

class Body extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final FirebaseAuth auth;
  const Body({
    Key? key,
    required this.phoneNumber,
    required this.auth,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool control = true;
  bool isLoading = false;
  String verifyId = '';
  int? _resendToken;
  FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    final String obscureNumber =
        widget.phoneNumber.replaceRange(0, 7, "******");
    return SizedBox(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getHorizontalSize(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getVerticalSize(30)),
              Text(
                "A code has been sent to $obscureNumber",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: getVerticalSize(150),),
              Image.asset("assets/images/zeero.jpeg",width: getHorizontalSize(350),height: getVerticalSize(150),),

              SizedBox(height: getVerticalSize(100),),
              OtpForm(auth: widget.auth, verificationId: widget.verificationId),
              SizedBox(height: getVerticalSize(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP?",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async{
                      await auth.verifyPhoneNumber(
                        phoneNumber: widget.phoneNumber,
                        verificationCompleted: (v) {
                          setState(() async {
                            isLoading = false;
                          });
                        },
                        verificationFailed: (verificationFailed) async {
                          setState(() {
                            isLoading = false;
                          });

                          // snackBar(verificationFailed.toString());
                        },
                        codeSent: (vId, resendToken) async {
                          setState(() {
                            isLoading = false;
                            verifyId = vId;
                            _resendToken = resendToken;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => OtpScreen(
                                  auth: auth,
                                  phoneNum: widget.phoneNumber,
                                  verificationId: verifyId,
                                )));
                            //     Navigator.of(context).pushNamed(OtpScreen.routeName,
                            // arguments: _phoneNumController.text);
                          });
                        },
                        timeout: const Duration(seconds: 30),
                        forceResendingToken: _resendToken,
                        codeAutoRetrievalTimeout: (v) {
                          // snackBar(v.toString());
                          setState(() {
                            isLoading = false;
                          });
                        },
                      );
                      // OTP code resend
                    },
                    child: Text(
                      "Resend OTP Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              buildTimer(),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "This code will expire in ",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            color: Colors.white,
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: getProportionateScreenWidth(13),
            ),
          ),
        ),
      ],
    );
  }
}
