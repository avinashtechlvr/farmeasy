import 'dart:convert';

import 'package:farmeasy/home/newhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key, required this.location}) : super(key: key);
  final String location;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // read json file
  List _jsonData = [];
  List<MapLatLng> circles = <MapLatLng>[
    const MapLatLng(25.58877623, 79.70789368),
  ];
  List<String> damNames = <String>['Maudaha Dam'];
  List<double> damValues = <double>[
    1554,
  ];
  late MapZoomPanBehavior _zoomPanBehavior;
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _jsonData = data;
      for (int i = 0; i < _jsonData[0].length; i++) {
        damNames.add(_jsonData[0][i]);
      }
      for (int i = 0; i < _jsonData[1].length; i++) {
        damValues.add(double.parse(_jsonData[1][i].toString()));
      }
      for (int i = 0; i < _jsonData[2].length; i++) {
        circles.add(MapLatLng(_jsonData[2][i][0], _jsonData[2][i][1]));
      }
      EasyLoading.showSuccess('Fetched Other Water Resources!',
          dismissOnTap: true);

      EasyLoading.dismiss();

      // print("json data: ${_jsonData[0]}");
    });
  }

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior(
      // focalLatLng: MapLatLng(27.1751, 78.0421),
      zoomLevel: 4,
      showToolbar: true,
    );
    EasyLoading.init();
    EasyLoading.show(
      status: 'Fetching Other Water Resources',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      //         onTap: () => {Navigator.of(context).pop()},
      //       ),
      //     ],
      //   ),
      // ),
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
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Other Water Sources",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
        backgroundColor: const Color(0xff008080),
      ),
      body: SfMaps(
        layers: [
          MapTileLayer(
            tooltipSettings: const MapTooltipSettings(
                color: Colors.black,
                strokeColor: Color.fromRGBO(252, 187, 15, 1),
                strokeWidth: 1.5),
            zoomPanBehavior: _zoomPanBehavior,
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialFocalLatLng: const MapLatLng(25.58877623, 79.70789368),
            initialZoomLevel: 4,
            sublayers: [
              MapCircleLayer(
                circles: List<MapCircle>.generate(
                  circles.length,
                  (int index) {
                    return MapCircle(
                      radius: 6,
                      center: circles[index],
                    );
                  },
                ).toSet(),
                tooltipBuilder: (BuildContext context, int index) {
                  print(index);
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Dam name:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('  ' + damNames[index],
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Dam Volume:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('  ' + damValues[index].toString(),
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
