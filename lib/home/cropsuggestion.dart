import 'package:farmeasy/functions/mongoDB.dart';
import 'package:farmeasy/home/home.dart';
import 'package:farmeasy/home/newhome.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CropSugg extends StatefulWidget {
  const CropSugg({Key? key, required this.location, required this.data})
      : super(key: key);
  final String location;
  final Map<String, dynamic> data;
  @override
  State<CropSugg> createState() => _CropSuggState();
}

class _CropSuggState extends State<CropSugg> {
  var _crop;

  List<Map<String, dynamic>> _suggestions = [];

  var locLevel = 0.0;
  void getLevel() {
    EasyLoading.init();
    EasyLoading.show(
      status: 'Fetching Crop Suggestions',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    var jsonResponse = widget.data;
    // print("jsonResponse : $jsonResponse");
    var level = 0.0;
    List keys = jsonResponse.keys.toList();
    keys.remove("Location");
    keys.remove("_id");
    keys.remove("State");

    keys.sort();
    List<int> key = keys.map((e) => int.parse(e)).toList();
    key.sort();
    var lastkey = key.last;
    level = double.parse(jsonResponse[lastkey.toString()].toString());
    // print("level : $level");

    locLevel = double.parse(level.toString());

    if (0 < level && level <= 5) {
      _crop = 1;
    } else if (5 < level && level <= 10) {
      _crop = 2;
    } else if (10 < level && level <= 180) {
      _crop = 3;
    }
    print("locLevel : $locLevel");
    print("_crop : $_crop");
    if (_crop != null) {
      setState(() {
        getData();
      });
    }
  }

  void getData() async {
    List<Map<String, dynamic>> data = await getdata3(_crop);
    // print("data : $data");
    data.forEach((element) {
      element.removeWhere((key, value) => key == "Level");
    });
    // List<JsonTableColumn> temp = [];

    setState(() {
      // print("data : $data");
      _suggestions = data;
      EasyLoading.showSuccess('Fetched Crop Suggestions!', dismissOnTap: true);

      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    getLevel();

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
      //         onTap: () => {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => Home(location: widget.location),
      //             ),
      //           ),
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.grain),
      //         title: const Text('Crop Suggestion'),
      //         onTap: () => {Navigator.of(context).pop()},
      //       ),
      //     ],
      //   ),
      // ),

      appBar: AppBar(
        title: const Center(
            child: Text(
          "Crop Suggestion",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
        backgroundColor: const Color(0xff008080),
      ),
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
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                const Text(
                  "Water Level in BCM",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(widget.location,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.all(10)),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 50,
                      child: LiquidLinearProgressIndicator(
                        value: locLevel / 100, // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(Colors
                            .blue), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors
                            .white, // Defaults to the current Theme's backgroundColor.
                        borderColor:
                            Colors.blueAccent, //border color of the bar
                        borderWidth: 5.0, //border width of the bar
                        borderRadius: 12.0, //border radius
                        direction: Axis.horizontal,
                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                        center: Text("$locLevel"), //text inside bar
                      )),
                ),
                const Padding(padding: EdgeInsets.all(25)),
                const Text(
                  "Crop Suggestions",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                DataTable(
                  showBottomBorder: true,
                  border: TableBorder.all(color: Colors.grey, width: 2),
                  columns: const [
                    DataColumn(
                        label: Text(
                          'Crop Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        tooltip: 'Name of the Crop'),
                    DataColumn(
                        label: Text(
                          'Season',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        tooltip: 'Season which crops grow'),
                  ],
                  rows: _suggestions
                      .map(
                        (data) =>
                            // we return a DataRow every time
                            DataRow(
                                // List<DataCell> cells is required in every row
                                cells: [
                              DataCell(Text(data["Crop"])),
                              DataCell(Text(data["season"])),
                            ]),
                      )
                      .toList(),
                ),
                const Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
