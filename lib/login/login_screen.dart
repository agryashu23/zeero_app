import 'package:flutter/material.dart';
import 'package:zeero_app/login/components/login_form.dart';
// import 'package:zeero/login/components/login_form.dart';
// import 'package:zeero/math_utils.dart';

import '../math_utils.dart';
import '../size_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: getVerticalSize(150),
          ),
          Image.asset("assets/images/zeero.jpeg",width: getHorizontalSize(350),height: getVerticalSize(150),),
          const LoginForm(),
        ]),
      ),
    );
  }
}
