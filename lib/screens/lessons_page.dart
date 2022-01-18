// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:animated_button/animated_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mauka/screens/slides_page.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/current_user.dart';
import 'package:mauka/widgets/slide_creator.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'dart:io';
import '../strings.dart';
import 'open_camera.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key? key, @required this.courseId}) : super(key: key);
  final String? courseId;
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  dynamic user;
  List lessonData = [];
  bool lessonsLoaded = false;
  List assignmentData = [];
  bool assignmentsLoaded = false;
  int progress = 0;
  List<List> prompts = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  TextStyle heading = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 23,
  );

  TextStyle heading1 = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: 'Poppins',
    fontSize: 21,
  );

  TextStyle normalText = TextStyle(
    color: Colors.black,
    fontFamily: 'DMSans',
    fontSize: 16,
  );

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

  getLessons(courseId) async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/lessons/$courseId',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          lessonsLoaded = true;
          lessonData = response.data;
        });
      } else {
        // err
        // print(response.statusMessage);
      }
    });
  }

  getAssignments(courseId) async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/courseAssignments/$courseId',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          assignmentData = response.data;
          for (var assignment in assignmentData) {
            assignment['prompts'].forEach((prompt) =>
                prompts[assignmentData.indexOf(assignment)]
                    .add(prompt['prompt']));
          }
          assignmentsLoaded = true;
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
    getLessons(widget.courseId);
    getAssignments(widget.courseId);
    super.initState();
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
          'LessonsPage',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Lessons',
                  style: heading1,
                ),
                lessonsLoaded
                    ? Container(
                        height: slideHeight * 0.3,
                        margin: EdgeInsets.only(
                          top: 15,
                        ),
                        child: lessonData.isEmpty
                            ? Center(
                                child: Text(
                                  'Something went wrong.',
                                  style: normalText,
                                ),
                              )
                            : ListView.builder(
                                //physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: lessonData.length,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return SlidesPage(
                                                lessonId: lessonData[index]
                                                    ['_id'],
                                                user: user,
                                                courseId: widget.courseId,
                                              );
                                            }));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.only(right: 15),
                                            height: slideHeight * 0.3,
                                            width: slideWidth * 0.4,
                                            child: Center(
                                                child: Text(
                                                    "${lessonData[index]['name']}")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Assignments',
                  style: heading1,
                ),
                lessonsLoaded
                    ? Container(
                        height: slideHeight * 0.3,
                        margin: EdgeInsets.only(
                          top: 15,
                        ),
                        child: assignmentData.isEmpty
                            ? Center(
                                child: Text(
                                  'Something went wrong.',
                                  style: normalText,
                                ),
                              )
                            : ListView.builder(
                                //physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: assignmentData.length,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return OpenCamera(
                                                prompts: prompts[index],
                                                user: user,
                                                lessonId: assignmentData[index]
                                                    ['lesson'],
                                              );
                                            }));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            margin: EdgeInsets.only(right: 15),
                                            height: slideHeight * 0.3,
                                            width: slideWidth * 0.4,
                                            child: Center(
                                              child: Text(
                                                "${assignmentData[index]['heading']}",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
