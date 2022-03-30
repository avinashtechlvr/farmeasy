import 'package:flutter/material.dart';

class LocPermission extends StatefulWidget {
  final String phone;
  final String location = "";
  const LocPermission({required this.phone});

  @override
  State<LocPermission> createState() => _LocPermissionState();
}

class _LocPermissionState extends State<LocPermission> {
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
          ],
        ),
      ),
    );
  }
}
