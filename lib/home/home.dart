import 'dart:convert';

// import 'package:farmeasy/connection/updatelocation.dart';
// import 'package:farmeasy/functions/mongoDB.dart';
// import 'package:farmeasy/home/locationpage.dart';

import 'package:farmeasy/connection/updateLocation.dart';
import 'package:farmeasy/home/cropsuggestion.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // chart data

  late String location = widget.location;
  // late String location = "Kakinada";
  late List<String> _locationsData;
  late Map<String, dynamic> _locdata;
  Future<String> getJsonFromAssets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _locationsData = prefs.getStringList('allloc') ??
        ["Vijayawada", "Kakinada", "Guntur", "Vizag", "Tirupathi"];

    return prefs.getString('data') ?? "";
  }

  List<Predicted> chartData = [];

  Future loadData() async {
    // print("in load data");
    final String jsonString = await getJsonFromAssets();
    // print(jsonString);
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    if (jsonResponse["Location"] != widget.location) {
      print("location not found");
      chartData = [];
    } else {
      List keys = jsonResponse.keys.toList();
      keys.remove("Location");
      keys.remove("_id");
      // List<Predicted> newchartData = [];

      for (var key in keys) {
        chartData.add(Predicted.fromJson(key, jsonResponse[key]));
      }
      setState(() {
        _locdata = jsonResponse;
        // chartData = chartData.reversed.toList();
      });
    }
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Side menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.grain),
              title: const Text('Crop Suggestion'),
              onTap: () => {
                print("locdata : $_locdata"),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropSugg(
                      location: location,
                      data: _locdata,
                    ),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Farm Easy ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateLoc(_locationsData)),
                          (route) => true);
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 30,
                    ),
                    label: Text(
                      location,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
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
                      pointColorMapper: (Predicted data, _) => Colors.blue,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      emptyPointSettings: EmptyPointSettings(
                          // Mode of empty point
                          mode: EmptyPointMode.average),
                    ),
                  ]),
            ],
          ))
        ],
      ),
    ));
  }

  Widget getLoadMoreViewBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
        future: getJsonFromAssets(),

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
