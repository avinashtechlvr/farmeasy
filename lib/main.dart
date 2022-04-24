// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:farmeasy/functions/mongoDB.dart';
import 'package:farmeasy/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmeasy/home/home.dart';

late bool isLoggedIn;
late String islocation;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final List<String> _locationsData = await getcompleteData();
  // save data to json file
  final String jsonString = json.encode({"Locations": _locationsData});
  // save to json file using rootBundle
  // final file = File("./assets/data.json");
  // await file.writeAsString(jsonString);
  // print(_locationsData);
  // print("_locationsData[0] : ${_locationsData[0]}");
  // String? _token = await FirebaseAppCheck.instance.getToken();
  // await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: _token);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("allloc", _locationsData);
  // print(_locationsData);
  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // isLoggedIn = false;

  islocation = prefs.getString('location') ?? "";
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    builder: EasyLoading.init(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return Home(location: islocation);
    } else {
      return const Loginscreen();
    }
    // return const Home(
    //   location: "Kakinada",
    // );
  }
}
