// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:mauka/screens/slides_page.dart';
import 'package:mauka/screens/feedback.dart';
import 'package:mauka/screens/reflect_page.dart';
import 'package:mauka/screens/get_started.dart';
import 'package:mauka/screens/signup_page.dart';
import 'screens/course_page.dart';
import 'screens/login_page.dart';
import 'screens/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        // textTheme: const TextTheme(
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.normal),
        //   //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'DMSans'),
        // ),
      ),
      home: SplashPage(),
    );
  }
}
