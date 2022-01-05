// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mauka/services/authenticate.dart';

import '../strings.dart';

class ReflectPage extends StatefulWidget {
  const ReflectPage({
    Key? key,
  }) : super(key: key);

  @override
  _ReflectPageState createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  String? answer1;
  String? answer2;
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
                'Self Reflect Page',
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
                Text(
                  'Question 1',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    //fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Fill answer here for question 1',
                      hintStyle:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    onChanged: (val) {
                      answer1 = val;
                    },
                    onSubmitted: (_) {
                      focusNode.requestFocus();
                    },
                    // autofocus: true,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Question 2',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    //fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
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
                      hintText: 'Answer here for question 2',
                      hintStyle:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                    focusNode: focusNode,
                    //obscureText: true,
                    onChanged: (val) {
                      answer2 = val;
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                if (answer1 != null && answer2 != null) {
                  if (answer1!.isNotEmpty && answer2!.isNotEmpty) {
                    var token = await Strings().getToken();
                    await Authenticate()
                        .reflect(token!, answer1!, answer2!, context);
                  }
                } else {
                  print('error');
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
            //add api call
            Text(
              'Feedback Will Come Here',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                //fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
