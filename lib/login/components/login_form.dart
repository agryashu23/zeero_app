import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zeero_app/math_utils.dart';
import 'package:zeero_app/otp/otp_screen.dart';
// import 'package:zeero/otp/otp_screen.dart';
import '../../Loading.dart';
import '../../default_button.dart';
import '../../size_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneNumController = TextEditingController();
  bool isLoading = false;
  String myPhoneNum = '';
  String verifyId = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: getVerticalSize(180),
                ),
                // Text(
                //   "Enter your phone number",
                //   style: TextStyle(
                //     fontSize: getProportionateScreenWidth(20),
                //     color: Colors.white,
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                IntlPhoneField(
                  controller: _phoneNumController,
                  initialCountryCode: "IN",
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) {
                    print(val.completeNumber);
                    myPhoneNum = val.completeNumber;
                    if(val.completeNumber.length==13){
                      FocusManager.instance.primaryFocus?.unfocus();

                    }
                  },
                ),
                SizedBox(
                  height: getVerticalSize(0),
                ),
                DefaultButton(
                  text: "Start",
                  press: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await auth.verifyPhoneNumber(
                      phoneNumber: myPhoneNum,
                      verificationCompleted: (v) {
                        debugPrint("TOKEN: ${v.token}");
                        debugPrint("Verfication ID: ${v.verificationId}");
                        debugPrint("Provider ID: ${v.providerId}");
                        debugPrint("SIGN in Meyhod: ${v.signInMethod}");
                        setState(() async {
                          isLoading = false;
                        });
                      },
                      verificationFailed: (verificationFailed) async {
                        print('VERFICATION FAILED');
                        setState(() {
                          isLoading = false;
                        });

                        // snackBar(verificationFailed.toString());
                      },
                      codeSent: (vId, token) async {
                        print('////////////////');
                        print("VID: $vId");
                        print('////////////////');
                        setState(() {
                          isLoading = false;
                          verifyId = vId;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => OtpScreen(
                                    auth: auth,
                                    phoneNum: myPhoneNum,
                                    verificationId: verifyId,
                                  )));
                          //     Navigator.of(context).pushNamed(OtpScreen.routeName,
                          // arguments: _phoneNumController.text);
                        });
                      },
                      codeAutoRetrievalTimeout: (v) {
                        // snackBar(v.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                    );
                  },
                  // press: () {
                  //   Navigator.of(context).pushNamed(OtpScreen.routeName,
                  //       arguments: _phoneNumController.text);
                  // },
                )
              ],
            ),
          );
  }
}
