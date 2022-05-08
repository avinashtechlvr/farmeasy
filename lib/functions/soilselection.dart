import 'package:farmeasy/home/cropsuggestion.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SoilSelection extends StatefulWidget {
  const SoilSelection({Key? key, required this.location, required this.data})
      : super(key: key);
  final String location;
  final Map<String, dynamic> data;
  @override
  State<SoilSelection> createState() => _SoilSelectionState();
}

class _SoilSelectionState extends State<SoilSelection> {
  String dropdownvalue = 'Select Soil';
  var items = [
    'Select Soil',
    'Alluvial Soils',
    'Black Soil',
    'Red Soil',
    'Yellow Soil',
    'Laterite Soil',
    'Arid Soil',
    'Desert Soil',
  ];
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
            DropdownButton(
              alignment: Alignment.center,
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            const SizedBox(height: 25),
            TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xff008080),
                )),
                onPressed: () {
                  print("dropdownvalue: $dropdownvalue");
                  if (dropdownvalue == 'Select Soil') {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Soil Selection Error",
                      desc: "Please select soil",
                      buttons: [
                        DialogButton(
                          color: const Color(0xff008080),
                          child: const Text(
                            "Select Soil",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            // pop closes the dialog
                            Navigator.pop(context);
                          },
                          width: 140,
                        )
                      ],
                    ).show();
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropSugg(
                                  location: widget.location,
                                  data: widget.data,
                                )),
                        (route) => false);
                  }
                },
                child: const Text(
                  'Crop Suggestions',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
