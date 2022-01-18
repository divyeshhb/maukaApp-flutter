// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mauka/services/authenticate.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String? feedback;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dropdownCourse = 'Course A';
    String dropdownUser = 'User A';
    //final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 255, 1),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(25, 25, 25, 1),
            //   child: Image(
            //     image: AssetImage('assets/images/mauka_whitebg.png'),
            //     height: 100,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 100, 25, 1),
              child: Text(
                'Feedback Form !',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                DropdownButton<String>(
                  value: dropdownCourse,
                  icon: const Icon(Icons.arrow_downward, color: Colors.black),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownCourse = newValue!;
                    });
                  },
                  items: <String>[
                    'Course A',
                    'Course B',
                    'Course C',
                    'Course D'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: dropdownUser,
                  icon: const Icon(Icons.arrow_downward, color: Colors.black),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownUser = newValue!;
                    });
                  },
                  items: <String>['User A', 'User B', 'User C', 'User D']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54),
                      color: Colors.white),
                  child: TextField(
                    cursorColor: Colors.black,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusColor: Colors.black,
                      hintText: '   Write Here....',
                      hintStyle:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    focusNode: focusNode,
                    onChanged: (val) {
                      setState(() {
                        feedback = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                if (feedback != null && feedback!.isNotEmpty) {
                  //print('in here');
                  // await Authenticate().feedback(arguments['token'],
                  //     dropdownCourse, dropdownUser, feedback!, context);
                  // response.then((value) {
                  //   String token = jsonDecode(value.toString())['token'];
                  //   Navigator.pushNamed(context, '/logout',
                  //       arguments: {'token': token});
                  // });
                } else {
                  print('error in sending');
                  //throw err;
                }
              },
              splashColor: Color.fromRGBO(0, 0, 0, 0.5),
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
