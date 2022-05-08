import 'dart:convert';

import 'package:farmeasy/connection/updateLocation.dart';
import 'package:farmeasy/functions/soilselection.dart';
import 'package:farmeasy/home/home.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  final List<String> imageList = [
    './assets/images/1.png',
    './assets/images/2.png',
    './assets/images/3.png'
  ];
  late Map<String, dynamic> _locationsData;
  late Map<String, dynamic> _locdata;
  late List<String> _StateData;
  Future<String> getfromhive() async {
    var box = Hive.box('database');
    _locationsData = json.decode(box.get('allloc') ?? '{}');
    _StateData = _locationsData.keys.toList();
    _locdata = json.decode(box.get('data'));
    return box.get('data');
  }

  @override
  void initState() {
    // getfromhive();
    getfromhive();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool check_status = false;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  color: Color(0xff008080),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
              // add ellipse at top right corner
              Positioned(
                top: -64,
                left: 307,
                child: Container(
                  child: GFBorder(
                    type: GFBorderType.circle,
                    dashedLine: [2, 0],
                    color: Colors.white,
                    strokeWidth: 3,
                    child: Text(""),
                  ),
                ),
                height: 67,
                width: 60,
              ),
              Positioned(
                top: -80,
                left: 260,
                child: Container(
                  child: GFBorder(
                    type: GFBorderType.circle,
                    dashedLine: [3, 0],
                    color: Colors.white,
                    strokeWidth: 3,
                    child: Text(""),
                  ),
                ),
                height: 87,
                width: 79,
              ),
              Positioned(
                top: 104,
                left: 22,
                child: Container(
                  child: GFBorder(
                    type: GFBorderType.circle,
                    dashedLine: [3, 0],
                    color: Colors.white,
                    strokeWidth: 3,
                    child: Text(""),
                  ),
                ),
                height: 87,
                width: 79,
              ),
              Positioned(
                top: 114,
                left: -12,
                child: Container(
                  child: GFBorder(
                    type: GFBorderType.circle,
                    dashedLine: [2, 0],
                    color: Colors.white,
                    strokeWidth: 3,
                    child: Text(""),
                  ),
                ),
                height: 67,
                width: 61,
              ),
              const Positioned(
                top: 60,
                left: 30,
                child: Text(
                  "Hello",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Positioned(
                top: 100,
                left: 30,
                child: Text(
                  "Lets start together",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 220,
                    width: 150,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        color: Colors.black,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(location: widget.location)),
                                  (route) => true);
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/bargraph.png",
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 20, top: 150),
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Under ground water level",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textWidthBasis: TextWidthBasis.parent,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                )
                              ],
                            )))),
                Container(
                    height: 220,
                    width: 150,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        color: Colors.black,
                        child: GestureDetector(
                            onTap: () {
                              // check location present in _locationsData
                              _locationsData.forEach((key, value) {
                                value.forEach((k) {
                                  if (k == widget.location) {
                                    check_status = true;
                                    // break loop
                                    return;
                                  }
                                });
                              });
                              if (check_status) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SoilSelection(
                                      location: widget.location,
                                      data: _locdata,
                                    ),
                                  ),
                                );
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Location Issue",
                                  desc:
                                      "We are not in your Location yet, Please select other locations in our Location Page!",
                                  buttons: [
                                    DialogButton(
                                      color: const Color(0xff008080),
                                      child: const Text(
                                        "Update Now",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UpdateLoc(
                                                    _StateData,
                                                    _locationsData)),
                                            (route) => false);
                                      },
                                      width: 140,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/cropsawing.png",
                                    fit: BoxFit.cover,
                                    height: 300,
                                    width: double.infinity,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 150),
                                  child: SizedBox(
                                    width: 140,
                                    child: Text(
                                      "Know which crop is best suitable",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textWidthBasis: TextWidthBasis.parent,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                )
                              ],
                            )))),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 163,
            width: 278,
            child: GFCarousel(
              autoPlay: true,
              items: imageList.map(
                (url) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xff008080), width: 1),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      child: Image.asset(
                        url,
                        fit: BoxFit.cover,
                        width: 1000.0,
                      ),
                    ),
                  );
                },
              ).toList(),
              onPageChanged: (index) {
                setState(() {
                  index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
