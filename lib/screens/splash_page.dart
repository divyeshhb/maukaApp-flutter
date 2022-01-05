// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mauka/screens/slides_page.dart';
import 'package:mauka/screens/get_started.dart';
import 'package:mauka/screens/home_page.dart';
import 'package:mauka/screens/video_recorder.dart';

import '../services/current_user.dart';
import '../strings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  checkUser() async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return GetStarted();
        }));
      }
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return GetStarted();
      }));
    }
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 00), () {
      checkUser();
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (context) {
      // return CoursePage();
      // }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage('assets/images/mauka_whitebg.png'),
              height: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          SizedBox(
            height: size.width * 0.15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
            child: LinearProgressIndicator(
              backgroundColor: Colors.blue,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
