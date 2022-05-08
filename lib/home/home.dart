import 'dart:convert';

// import 'package:farmeasy/connection/updatelocation.dart';
// import 'package:farmeasy/functions/mongoDB.dart';
// import 'package:farmeasy/home/locationpage.dart';

import 'package:farmeasy/connection/updateLocation.dart';
import 'package:farmeasy/functions/mapview%20copy.dart';
import 'package:farmeasy/functions/mapview.dart';
// import 'package:farmeasy/functions/soilselection.dart';
// import 'package:farmeasy/home/cropsuggestion.dart';
import 'package:farmeasy/home/newhome.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:hive/hive.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:farmeasy/functions/mapview.dart' as mapview;

class Home extends StatefulWidget {
  const Home({Key? key, required this.location, this.selectedState})
      : super(key: key);
  final String location;
  final String? selectedState;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // chart data

  late String location = widget.location;
  // late String location = "Kakinada";
  late Map<String, dynamic> _locationsData;
  late List<String> _StateData;

  late Map<String, dynamic> _locdata;
  Future<String> getfromhive() async {
    var box = Hive.box('database');
    _locationsData = json.decode(box.get('allloc') ?? '{}');
    _StateData = _locationsData.keys.toList();

    _locdata = json.decode(box.get('data'));
    return box.get('data');
  }

  // Future<String> getJsonFromAssets() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // _locationsData = json.decode(prefs.getString('allloc') ?? '{}');
  //   // _StateData = _locationsData.keys.toList();

  //   return prefs.getString('data') ?? "";
  // }

  List<Predicted> chartData = [];

  Future loadData() async {
    // print("in load data");
    final String jsonString = await getfromhive();
    // print(jsonString);
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    if (jsonResponse["Location"] != widget.location) {
      print("location not found");
      chartData = [];
    } else {
      List keys = jsonResponse.keys.toList();
      keys.remove("Location");
      keys.remove("_id");
      keys.remove("State");
      // List<Predicted> newchartData = [];

      for (var key in keys) {
        chartData.add(Predicted.fromJson(key, jsonResponse[key]));
      }
      setState(() {
        chartData = chartData;
      });
      // setState(() {
      //   _locdata = jsonResponse;

      //   // chartData = chartData.reversed.toList();
      // });
    }
  }

  @override
  void initState() {
    // getfromhive();
    loadData();

    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    bool check_status = false;
    return SafeArea(
        child: Scaffold(
      key: _key,
      bottomNavigationBar: BottomAppBar(
          color: const Color(0xff008080),
          child: Container(
            child: IconButton(
              icon: const Icon(
                Icons.home,
                size: 30,
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewHomeScreen(location: widget.location),
                  ),
                ),
              },
            ),
          )),
      // drawer: Drawer(
      //   child: Column(
      //     children: <Widget>[
      //       const DrawerHeader(
      //         child: Center(
      //           child: Text(
      //             'Farm Easy',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(color: Colors.white, fontSize: 25),
      //           ),
      //         ),
      //         decoration: BoxDecoration(
      //           color: const Color(0xff008080),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Home'),
      //         onTap: () => {Navigator.of(context).pop()},
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.grain),
      //         title: const Text('Crop Suggestion'),
      //         onTap: () => {
      //           // check location present in _locationsData
      //           _locationsData.forEach((key, value) {
      //             value.forEach((k) {
      //               if (k == widget.location) {
      //                 check_status = true;
      //                 // break loop
      //                 return;
      //               }
      //             });
      //           }),
      //           if (check_status)
      //             {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => SoilSelection(
      //                     location: location,
      //                     data: _locdata,
      //                   ),
      //                 ),
      //               ),
      //             }
      //           else
      //             {
      //               Alert(
      //                 context: context,
      //                 type: AlertType.error,
      //                 title: "Location Issue",
      //                 desc:
      //                     "We are not in your Location yet, Please select other locations in our Location Page!",
      //                 buttons: [
      //                   DialogButton(
      //                     color: const Color(0xff008080),
      //                     child: const Text(
      //                       "Update Now",
      //                       style: TextStyle(color: Colors.white, fontSize: 16),
      //                     ),
      //                     onPressed: () {
      //                       Navigator.pushAndRemoveUntil(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) =>
      //                                   UpdateLoc(_StateData, _locationsData)),
      //                           (route) => false);
      //                     },
      //                     width: 140,
      //                   )
      //                 ],
      //               ).show(),
      //             }
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   alignment: Alignment.topRight,
              //   margin: const EdgeInsets.only(left: 20.0),
              //   child: IconButton(
              //     icon: const Icon(
              //       Icons.menu,
              //       size: 38,
              //       color: Color(0xff008080),
              //     ),
              //     onPressed: () => _key.currentState!.openDrawer(),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateLoc(_StateData, _locationsData)),
                        (route) => true);
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 20,
                    color: Colors.black,
                  ),
                  label: Text(
                    location,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
              child: Column(
            children: [
              // Text(
              //   location,
              //   style:
              //       const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              SfCartesianChart(
                  enableAxisAnimation: true,
                  primaryXAxis: CategoryAxis(
                    labelStyle: const TextStyle(fontSize: 20),
                    maximumLabels: 100,
                    autoScrollingDelta: 4,
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(width: 0),
                  ),
                  isTransposed: true,
                  primaryYAxis: NumericAxis(
                      minimum: 1.0,
                      majorGridLines: const MajorGridLines(
                        width: 0,
                      )),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                  series: <ChartSeries>[
                    // Renders column chart
                    BarSeries<Predicted, String>(
                      dataSource: chartData,
                      xValueMapper: (Predicted data, _) => data.years,
                      yValueMapper: (Predicted data, _) => data.waterlevel,
                      pointColorMapper: (Predicted data, _) =>
                          const Color(0xff008080),
                      // const Color.fromRGBO(7, 249, 89, 0.24),
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings: EmptyPointSettings(
                          // Mode of empty point
                          mode: EmptyPointMode.average),
                    ),
                  ]),
            ],
          )),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                "UNDERGROUND WATER LEVEL",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
              child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Text(
              "(billion cubic metres)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )),
          const SizedBox(
            height: 40,
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       UpdateLoc(_StateData, _locationsData)),
          //               (route) => true);
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 1),
          //           child: const SizedBox(
          //             width: 80,
          //             child: Text(
          //               "Update Location",
          //               style: TextStyle(
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.black,
          //               ),
          //             ),
          //           ),
          //         ),
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all<Color>(
          //             const Color(0xff008080),
          //           ),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       mapview.MapView(location: widget.location)),
          //               (route) => true);
          //         },
          //         child: const SizedBox(
          //           width: 120,
          //           child: Text(
          //             "Other Water Resources",
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.w600,
          //               color: Colors.black,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all<Color>(
          //             const Color(0xff008080),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

          Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              mapview.MapView(location: widget.location)),
                      (route) => true);
                },
                child: const SizedBox(
                  width: 240,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Other Water Resources",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xff008080),
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 180, top: 80),
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UpdateLoc(_StateData, _locationsData)),
                      (route) => true);
                },
                child: const Text(
                  "Update Location",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xff008080),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget getLoadMoreViewBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
        future: getfromhive(),

        /// Adding data by updateDataSource method
        builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
          return snapShot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : SizedBox.fromSize(size: Size.zero);
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }
}

class Predicted {
  Predicted(this.years, this.waterlevel);

  final String years;
  final double waterlevel;

  factory Predicted.fromJson(String year, double water) {
    return Predicted(year, water);
  }
}
