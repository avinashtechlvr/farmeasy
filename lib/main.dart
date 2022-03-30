import 'package:farmeasy/functions/firestore.dart';
import 'package:farmeasy/login/login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:farmeasy/home/home.dart';

late bool isLoggedIn;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const Home();
    } else {
      return const Loginscreen();
    }
  }
}
