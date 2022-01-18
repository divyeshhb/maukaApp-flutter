// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:animated_button/animated_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mauka/screens/open_camera.dart';
import 'package:mauka/screens/slides_page.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/current_user.dart';
import 'package:mauka/widgets/slide_creator.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'dart:io';
import '../strings.dart';

class AssigmentsPage extends StatefulWidget {
  const AssigmentsPage({Key? key, @required this.lessonId}) : super(key: key);
  final String? lessonId;
  @override
  _AssigmentsPageState createState() => _AssigmentsPageState();
}

class _AssigmentsPageState extends State<AssigmentsPage> {
  dynamic user;
  var assigmentData;
  bool assignmentsLoaded = false;
  List prompts = [];

  getUser() async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        setState(() {
          user = jsonDecode(result[1]);
        });
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return SplashPage();
        }));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SplashPage();
      }));
    }
  }

  getAssignments(lessonId) async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/assignment/$lessonId',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          assignmentsLoaded = true;
          assigmentData = response.data;
          assigmentData['prompts']
              .forEach((prompt) => prompts.add(prompt['prompt']));
        });
      } else {
        // err
        // print(response.statusMessage);
      }
    });
  }

  @override
  void initState() {
    getUser();
    getAssignments(widget.lessonId);
    super.initState();
  }

  Widget buttonNew(text, onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      highlightColor: Color.fromRGBO(1, 1, 1, 0),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double slideHeight = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
    double slideWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assigments',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              var token = await Strings().getToken();
              Authenticate().logout(token!);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return SplashPage();
              }));
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffF1F8FF),
      body: assignmentsLoaded
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     // left: slideWidth * 0.04,
                  //     top: slideHeight * 0.04,
                  //   ),
                  //   child: Text(
                  //     'Lesson Name',
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontFamily: 'Poppins',
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: slideWidth * 0.08,
                      right: slideWidth * 0.08,
                      top: slideHeight * 0.04,
                    ),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25 / 4,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              '${assigmentData['heading']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                        Text(
                          '${assigmentData['subtext']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                          ),
                        ),
                        buttonNew('Record', () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return OpenCamera(
                              prompts: prompts,
                              user: user,
                              lessonId: widget.lessonId,
                            );
                          }));
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
