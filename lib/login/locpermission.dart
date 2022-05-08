import 'dart:convert';

import 'package:farmeasy/connection/updateLocation.dart';
import 'package:farmeasy/home/home.dart';
import 'package:farmeasy/home/newhome.dart';
import 'package:farmeasy/home/welcome.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmeasy/functions/mongoDB.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocPermission extends StatefulWidget {
  final String phone;
  final String location = "";
  const LocPermission({required this.phone});

  @override
  State<LocPermission> createState() => _LocPermissionState();
}

class _LocPermissionState extends State<LocPermission> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;
  late List<geocoding.Placemark> _placemarks;
  late Map<String, dynamic> _data;
  late Map<String, dynamic> _locationsData;
  late List<String> _StateData;
  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Location Issue",
          desc:
              "Location permission is not granted.You can select location manually",
          buttons: [
            DialogButton(
              color: const Color(0xff008080),
              child: const Text(
                "Select Location",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateLoc(_StateData, _locationsData)),
                    (route) => false);
              },
              width: 140,
            )
          ],
        ).show();
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // add here to show a dialog
        Alert(
          context: context,
          type: AlertType.error,
          title: "Location Issue",
          desc:
              "Location permission is not granted.You can select location manually",
          buttons: [
            DialogButton(
              color: const Color(0xff008080),
              child: const Text(
                "Select Location",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateLoc(_StateData, _locationsData)),
                    (route) => false);
              },
              width: 140,
            )
          ],
        ).show();
      }
    }

    final _locationData = await location.getLocation();
    _placemarks = await geocoding.placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    // _placemarks.forEach((element) {
    //   print(element.locality);
    //   print(element.administrativeArea);
    //   print(element.country);
    // });
    setState(() {
      _userLocation = _locationData;
      changePage();
    });
  }

  predictresults(data) async {
    // Change Here
    _data = await getdata2(_placemarks[0].locality.toString());
    // print("in prediction resluts");
    // _data = await getdata2("Kakinada");
    // addtoSharedPref();
    addtohive();
    if (await getdata(widget.phone)) {
      print("data already exists");
    } else {
      mongoadddata(data);
    }
    if (_data != null) {
      setState(() {
        // mongoadddata(data);
        EasyLoading.showSuccess('Location Update Successfull!',
            dismissOnTap: true);

        EasyLoading.dismiss();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeScreen(
                    location: _placemarks[0].locality.toString())),
            (route) => false);
      });
    }
  }

  void addtohive() {
    var box = Hive.box('database');
    box.put('isLoggedIn', true);
    print("Checking what kept in login: ${box.get('isLoggedIn')}");
    print("type of islogin: ${box.get('isLoggedIn').runtimeType}");
    box.put('phone', widget.phone);
    // Chnage Here
    box.put('location', _placemarks[0].locality.toString());

    box.put('data', json.encode(_data));
    addtoSharedPref();
  }

  void addtoSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    //   prefs.setString('phone', widget.phone);
    //   // Chnage Here
    //   prefs.setString('location', _placemarks[0].locality.toString());
    //   // prefs.setString('location', "Kakinada");
    //   //make json to string

    // prefs.setString('data', json.encode(_data));
    //   // prefs.setString(jsonEncode(object));
    //   // String temp = prefs.getString('data') ?? "";
    //   // print(" Opening data from shared prefs: $temp");
  }

  void changePage() async {
    Map<String, dynamic> data = {
      'PhoneNumber': widget.phone,
      'Location': _placemarks[0].locality.toString(),
    };
    predictresults(data);
    EasyLoading.init();
    EasyLoading.show(
      status: 'Fetching Location Data',
      dismissOnTap: false,
    );
  }

  @override
  void initState() {
    super.initState();
    var box = Hive.box('database');
    _locationsData = json.decode(box.get('allloc') ?? '{}');
    _StateData = _locationsData.keys.toList();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    const bgImgPath = './assets/images/loginscreenbg.png';
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    bgImgPath,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                Card(
                  elevation: 10,
                  color: Colors.white.withOpacity(0.5),
                  child: const SizedBox(
                    width: 150,
                    height: 50,
                    child: Center(
                      child: Text(
                        'FARM EASY',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 100)),
            const SizedBox(height: 25),
            // Display latitude & longtitude
            _userLocation != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Text('Your locality is : ${_placemarks[0].locality}'),
                        const SizedBox(width: 10),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
