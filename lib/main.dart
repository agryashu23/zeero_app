import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeero_app/abc.dart';
import 'package:zeero_app/businessscreen.dart';
import 'package:zeero_app/bussiness.dart';
import 'package:zeero_app/contactus.dart';
import 'package:zeero_app/home/home_screen.dart';
import 'package:zeero_app/leads/leads.dart';
import 'package:zeero_app/leads/showLeadMatch.dart';
import 'package:zeero_app/leads/showleads.dart';
import 'package:zeero_app/login/login_screen.dart';
import 'package:zeero_app/matches/match.dart';
import 'package:zeero_app/profile.dart';
import 'package:zeero_app/provider.dart';
import 'package:zeero_app/search/leadsearching.dart';
import 'package:zeero_app/search/leadssearch.dart';
import 'package:zeero_app/search/search1.dart';
import 'package:zeero_app/splash.dart';
import 'package:zeero_app/supply/supply_screen1.dart';
import 'package:zeero_app/supply/supply_screen2.dart';
import 'package:zeero_app/supply/supply_screen3.dart';
import 'package:zeero_app/supplyshow.dart';

import 'leads/matchleads.dart';
import 'match2.dart';
import 'supply/supply.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => FormModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zeero',
      home: const Splash(),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        Splash.routeName: (ctx) => const Splash(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        Bussiness.routeName: (ctx) => Bussiness(),
        SupplyScreen1.routeName: (ctx) => SupplyScreen1(),
        SupplyScreen2.routeName: (ctx) => SupplyScreen2(),
        SupplyScreen3.routeName: (ctx) => const SupplyScreen3(),
        Search1.routeName: (ctx) => const Search1(),
        Supply.routeName: (ctx) => const Supply(),
        MatchSearch.routeName: (ctx) => const MatchSearch(),
        MatchSearch2.routeName: (ctx) => const MatchSearch2(),
        BusinessScreen.routeName: (ctx) => const BusinessScreen(),
        Searching.routeName: (ctx) => const Searching(),
        ContactUs.routeName: (ctx) => const ContactUs(),
        Leads1.routeName: (ctx) => const Leads1(),
        LeadsSearch.routeName: (ctx) => const LeadsSearch(),
        LeadSearching.routeName: (ctx) => const LeadSearching(),
        Profile.routeName: (ctx) => const Profile(),
        ShowLeads.routeName: (ctx) => const ShowLeads(),
        MatchLeads.routeName: (ctx) => const MatchLeads(),
        ShowLeadSearch.routeName: (ctx) => const ShowLeadSearch(),
        // Profile.routeName: (ctx) => const Profile(),
      },
    );
  }
}
