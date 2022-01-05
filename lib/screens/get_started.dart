// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/login_page.dart';
import 'package:mauka/screens/signup_page.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              SizedBox(
                height: size.width * 0.2,
              ),
              // SizedBox(
              //   height: 40,
              // ),
              Center(
                child: Image(
                  image: AssetImage(
                    'assets/images/getstarted.png',
                  ),
                  height: size.width * 0.9,
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 8),
                child: Text(
                  'Consume. Practice. Reflect.',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 45.0),
                child: Text(
                  'By default, a TextField is decorated with an underline. You can add a label, icon, inline hint text, and error text by supplying an InputDecoration.',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'DMSans',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SignupPage();
                  }));
                },
                height: size.width / 6.5,
                width: size.width / 2.3,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                color: Colors.black,
              ),
              AnimatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
                height: size.width / 6.5,
                width: size.width / 2.3,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
