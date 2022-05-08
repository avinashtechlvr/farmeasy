import 'package:farmeasy/home/newhome.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key, required this.location}) : super(key: key);
  final String location;
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    const bgImgPath = './assets/images/loginscreenbg.png';
    const welcomepng = './assets/welcome.png';
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
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                const Padding(padding: EdgeInsets.only(top: 40)),
                const Text(
                  "Discover, learn and grow ",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Center(
                  child: const Text(
                    "to optimise your yield!",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    welcomepng,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: 160,
                  height: 40,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color(0xff008080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          )),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewHomeScreen(location: widget.location)),
                            (route) => false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Get Started",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      )),
                )
              ]),
            )
          ],
        ),
      ),
    );
    ;
  }
}
