import 'dart:convert';
import 'dart:io';

import 'package:farmeasy/functions/mapview.dart';
import 'package:farmeasy/home/newhome.dart';

import 'package:farmeasy/home/welcome.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:farmeasy/functions/mongoDB.dart';
import 'package:farmeasy/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmeasy/home/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

late bool isLoggedIn;
late String islocation;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Map<String, dynamic> _locationsData = await getcompleteData();
  // save data to json file
  final String jsonString = json.encode(_locationsData["Locations"]);
  // save to json file using rootBundle
  // final file = File("./assets/data.json");
  // await file.writeAsString(jsonString);
  // print(_locationsData);
  // print("_locationsData[0] : ${_locationsData[0]}");
  // String? _token = await FirebaseAppCheck.instance.getToken();
  // await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: _token);

  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox("database");
  var box = await Hive.box('database');
  box.put('allloc', jsonString);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString('allloc', jsonString);
  print("jsonString : $jsonString");
  // prefs.setStringList("allloc", _locationsData);
  // print(_locationsData);
  // isLoggedIn = await box.get('isloggedin') ?? false;
  // print("isloggedin : $isLoggedIn");

  isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // isLoggedIn = false;
  islocation = box.get('location') ?? "";

  // islocation = prefs.getString('location') ?? "";

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
      return NewHomeScreen(location: islocation);
    } else {
      return const Loginscreen();
    }
    // return const Home(
    //   location: "Kakinada",
    // );
    // return const MapView();
    // return const NewHomeScreen();
  }
}
