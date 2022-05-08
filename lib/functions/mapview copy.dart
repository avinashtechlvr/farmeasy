import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late List<MapLatLng> circles;
  late List<String> damNames;
  late List<int> damValues;
  @override
  void initState() {
    circles = <MapLatLng>[
      const MapLatLng(25.58877623, 79.70789368),
    ];
    damNames = <String>['Maudaha Dam'];
    damValues = <int>[
      1554,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Farm Easy',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0xff008080),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.grain),
              title: const Text('Crop Suggestion'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
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
            zoomPanBehavior: MapZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                enableDoubleTapZooming: true),
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialFocalLatLng: const MapLatLng(25.58877623, 79.70789368),
            initialZoomLevel: 4,
            sublayers: [
              MapCircleLayer(
                circles: List<MapCircle>.generate(
                  circles.length,
                  (int index) {
                    return MapCircle(
                      center: circles[index],
                    );
                  },
                ).toSet(),
                tooltipBuilder: (BuildContext context, int index) {
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
