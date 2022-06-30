import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'math_utils.dart';

class ContactUs extends StatefulWidget {
  static String routeName = "/contactus";

  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  final Map<String,HighlightedWord> _highlights ={
    'zeero':HighlightedWord(
      onTap: ()=>print("Zeero"),
      textStyle: TextStyle(
        color: Colors.amber.shade600,fontWeight: FontWeight.w500,fontSize: getFontSize(17)
      )
    )
  };


  stt.SpeechToText? _speech;
  bool _isListening =false;
  String _text = "Press the Button and start Speaking";
  double _confidence = 1.0;
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';


  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    final User? user = auth.currentUser;
    uid = user!.uid.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: TextStyle(color: Colors.tealAccent,),
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
      body: Container(
        width: getHorizontalSize(360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getVerticalSize(50),),
            // Container(
            //   margin: EdgeInsets.only(top: getVerticalSize(20)),
            //   child: Text("Send Voice Note",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: getFontSize(20)),),
            // ),
            Image.asset("assets/images/zeero.jpeg",width: getHorizontalSize(350),height: getVerticalSize(150),),

            Container(
              padding: EdgeInsets.symmetric(horizontal: getHorizontalSize(5),vertical: getVerticalSize(10)),
              margin: EdgeInsets.only(top: getVerticalSize(140)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              width: getHorizontalSize(300),
              height: getVerticalSize(250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      child: TextHighlight(
                        text:_text,
                        words:_highlights,
                        textStyle: TextStyle(color: Colors.white,fontSize: getFontSize(17)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Colors.red,
                        endRadius: 50.0,
                        duration: Duration(milliseconds: 4000),
                        repeatPauseDuration: Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          onPressed:_listen,
                          child: Icon(_isListening? Icons.mic : Icons.mic_none),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          String body = _text;
                          String subject = "Voice Note from $uid";
                          String email = "zeero.app1@gmail.com";
                          UrlLauncher.launch("mailto:$email?subject=$subject&body=$body");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Mail Sent '),));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.tealAccent
                          ),
                          width: getHorizontalSize(140),
                          height: getVerticalSize(40),
                          alignment: Alignment.center,
                          child: Text("Submit",style: TextStyle(color: Colors.black,fontSize: getFontSize(24),fontWeight: FontWeight.w500),),
                        ),
                      )
                    ],
                  ),

                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(top: getVerticalSize(0),left: getHorizontalSize(30),right: getHorizontalSize(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:()=>UrlLauncher.launch('tel:+91 7819940103'),
                    child: Container(
                      margin: EdgeInsets.only(top: getVerticalSize(30)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlueAccent
                      ),
                      width: getHorizontalSize(130),
                      height: getVerticalSize(50),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text("Call",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(
                                    20),fontWeight: FontWeight.w500),),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.call,color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:()async{
                      final link = WhatsAppUnilink(
                        phoneNumber: '+91 7819940103',
                        text: "Hey! I have query about property.",
                      );
                      await UrlLauncher.launch('$link');

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: getVerticalSize(30)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightGreenAccent
                      ),
                      width: getHorizontalSize(130),
                      height: getVerticalSize(50),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text("WhatsApp",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(
                                    20),fontWeight: FontWeight.w500),),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.whatsapp,color: Colors.black54,),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
  void _listen() async{
    if(!_isListening){
      bool available = await _speech!.initialize(
        onStatus: (val)=>print('onStatus:$val'),
        onError: (val)=>print('onError:$val'),
      );
      if(available){
        setState(() {_isListening =true; });
        _speech?.listen(
          onResult: (val)=>setState(() {
            _text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence>0){
              _confidence = val.confidence;
            }
          })
        );
      }
    }
    else{
      setState(() { _isListening = false;});
      _speech?.stop();
    }
  }
}
