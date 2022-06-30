import 'package:flutter/material.dart';

// HeartBeatAppBar Component
import '../components/HeartBeatAppBar/heartBeatAppBar.dart';

class HeartBeatPage extends StatelessWidget {
  static List<Widget> defaultPages = [
    Container(),
    Center(
        child: Text(
      "Heart page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
    // Center(
    //     child: Text(
    //   "Search page",
    //   style: TextStyle(
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // )),
    // Center(
    //     child: Text(
    //   "Chat page",
    //   style: TextStyle(
    //     fontWeight: FontWeight.bold,
    //     fontSize: 25,
    //   ),
    // )),
    Center(
        child: Text(
      "Cart page",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    )),
  ];
  final Widget body;

  final int from, to;

  HeartBeatPage({required this.from, required this.to, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HeartBeatAppBar(
        from: from == null ? this.to : from,
        to: to,
      ),
      extendBody: true,
      body: (body == null) ? HeartBeatPage.defaultPages[to] : body,
    );
  }
}
