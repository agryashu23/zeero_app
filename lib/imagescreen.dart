import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../math_utils.dart';
import '../provider.dart';

class ImageScreen extends StatefulWidget {

  const ImageScreen({Key? key , required this.ids}) : super(key: key);
  final List ids;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Images",
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
      body:Builder(
        builder: (context) {
      final double height = MediaQuery.of(context).size.height;
      return CarouselSlider(
        options: CarouselOptions(
          height: height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          // autoPlay: false,
        ),
        items: widget.ids
            .map((item) => Container(
          child: Center(
              child: Image.network(
                item,
                fit: BoxFit.cover,
                height: height,
                width: getHorizontalSize(355),
              )),
        ))
            .toList(),
      );
    },
    ),
    );
  }
}
