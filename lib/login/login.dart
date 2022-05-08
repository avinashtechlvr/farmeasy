import 'package:farmeasy/login/otp.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode inputNumber = FocusNode();
  @override
  Widget build(BuildContext context) {
    const bgImgPath = './assets/images/loginscreenbg.png';
    const bgImgUrl =
        'https://raw.githubusercontent.com/avinashtechlvr/database/main/images/loginscreenbg.png';
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
                child: Column(
                  children: const <Widget>[
                    Center(
                      child: Text('Welcome!',
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center),
                    ),
                    Center(
                      child: Text(
                        'Learn and Grow',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Phone Number :',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 10, right: 30, left: 30),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Phone Number',
                            counterText: "",
                            prefix: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                '+91',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: const Color(0xff80cbc4),
                            filled: true),
                        focusNode: inputNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: _controller,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        height: 54,
                        width: 130,
                        margin: const EdgeInsets.only(top: 40),
                        child: TextButton(
                          child: const Text(
                            'GET OTP',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          style: TextButton.styleFrom(
                              elevation: 2,
                              backgroundColor: const Color(0xff008080),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OTPScreen(_controller.text),
                            ));
                          },
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
