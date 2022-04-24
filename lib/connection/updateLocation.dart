import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:farmeasy/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmeasy/functions/mongoDB.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdateLoc extends StatefulWidget {
  final List<String> _locationsData;
  const UpdateLoc(this._locationsData, {Key? key}) : super(key: key);
  @override
  State<UpdateLoc> createState() => _UpdateLocState();
}

class _UpdateLocState extends State<UpdateLoc> {
  String? _selectedItem;
  bool _checkbox = false;
  late final _search;
  bool isloading = true;
  var _data;
  late final List<SearchFieldListItem<String>> _searchData;
  final List<SearchFieldListItem<String>> _tempData = [];
  void setLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', _selectedItem!);
    String? phoneNo = prefs.getString('phone');
    mongoupdate(phoneNo!, _selectedItem!);
  }

  @override
  void initState() {
    setState(() {
      _search = widget._locationsData;
      print(_search);
      _search.forEach((element) {
        _tempData
            .add(SearchFieldListItem<String>(element, child: Text(element)));
      });

      _searchData = _tempData;
    });

    super.initState();
  }

  void updateData() async {
    _data = await getdata2(_selectedItem!);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Fetched Data : $_data");
    if (_data != null) {
      setState(() {
        EasyLoading.showSuccess('Location Update Successfull!',
            dismissOnTap: true);

        EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Home(location: _selectedItem!)),
            (route) => false);
      });
    }
    prefs.setString('data', json.encode(_data));
    print("Location Update Successfull");
  }

  @override
  Widget build(BuildContext context) {
    // if (mounted) {
    //   setState(() {
    //     _searchData = _tempData;
    //   });
    // }

    const bgImgPath = './assets/images/loginscreenbg.png';
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(children: <Widget>[
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
              const Padding(padding: EdgeInsets.only(top: 50)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Select your location',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SearchField<String>(
                        hint: 'Select Location',
                        searchInputDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue.withOpacity(0.8),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxSuggestionsInViewPort: 6,
                        itemHeight: 50,
                        suggestionsDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSuggestionTap: (value) {
                          setState(() {
                            _selectedItem = value.searchKey;
                          });

                          // print(value);
                        },
                        suggestions: _searchData,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 20, top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Do you want to update your location as default location?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      enableFeedback: true,
                      value: _checkbox,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            _checkbox = !_checkbox;
                          });
                        }
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Checkbox(
                    //       value: _checkbox,
                    //       onChanged: (value) {
                    //         setState(() => _checkbox = !_checkbox);
                    //       },
                    //     ),
                    //     const SizedBox(
                    //       width: 250,
                    //       child: Text(
                    //         'Do you want to update your location as default location?',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //         ),
                    //         textDirection: TextDirection.ltr,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _selectedItem == null
                            ? const Text(
                                'Please select your place to Continue',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                              )
                            : Text(_selectedItem!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600)),
                        MaterialButton(
                          onPressed: () {
                            if (_selectedItem != null) {
                              if (_checkbox) {
                                setLocation();
                              }
                              updateData();
                              EasyLoading.init();
                              EasyLoading.show(
                                status: 'Fetching Location Data',
                                dismissOnTap: false,
                              );
                            } else {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "No Location Selected",
                                desc: "Please select your location from above",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Update Now",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 140,
                                  )
                                ],
                              ).show();
                            }
                          },
                          color: Colors.black,
                          minWidth: 50,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueGrey,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ])));
  }
}
