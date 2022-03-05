// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: unnecessary_string_escapes
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/reflect_page.dart';
import 'package:mauka/screens/slides_page.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/current_user.dart';
import 'package:http/http.dart' as http;
import '../strings.dart';
import 'lessons_page.dart';
import 'open_camera.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user;
  bool userLoaded = false;
  bool coursesLoaded = false;
  List userCourses = [];
  dynamic courseId;
  dynamic course;
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
    [],
    [],
    [],
  ];

  List assignmentData = [];
  bool assignmentsLoaded = false;

  Future getAssignment(courseId) async {
    var result;
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
        result = response.data;
      } else {
        return response.statusCode;
      }
    });
    return result;
  }

  getAllAssignments() async {
    for (var course in userCourses) {
      List res = await getAssignment(course['_id']);
      res.forEach((element) {
        assignmentData.add(element);
      });
    }
    for (var assignment in assignmentData) {
      assignment['prompts'].forEach((prompt) =>
          prompts[assignmentData.indexOf(assignment)].add(prompt['prompt']));
    }
    setState(() {
      assignmentsLoaded = true;
    });
  }

  getUser() async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        setState(() {
          user = jsonDecode(result[1]);
          getUserCourses(user);
          // coursesLoaded = true;
          userLoaded = true;
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

  getUserCourses(user) async {
    var token = await Strings().getToken();
    List courses = user['courses_enrolled'];
    List allCourses;
    dynamic res;
    await http.get(
      Uri.parse('${Strings.localhost}users/courses'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    ).then((response) {
      if (response.statusCode == 200) {
        allCourses = jsonDecode(response.body);
        for (var course in courses) {
          try {
            var target = allCourses
                .firstWhere((item) => item['_id'] == course['course']);
            if (target != null) {
              userCourses.add(target);
            }
          } catch (e) {
            print(e);
          }
        }
        // courseId = user['courses_enrolled'][0]["course"];
        courseId = user['courses_enrolled'].last["course"];
        course = user['courses_enrolled'].last;
        setState(() {
          coursesLoaded = true;
        });
        getAllAssignments();
      } else {}
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    double slideHeight = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
    var slideWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: userLoaded
          //&& coursesLoaded
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: slideHeight * 0.1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hey ${user['email'].split('@')[0]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Welcome 🎉',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        CircleAvatar(
                          backgroundImage:
                              user['avatar'] != null && user['avatar'] != ''
                                  ? NetworkImage(user['avatar'])
                                  : AssetImage('assets/images/avatar2.png')
                                      as ImageProvider,
                          radius: slideWidth * 0.07,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      right: 20,
                      left: 20,
                    ),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  coursesLoaded
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return LessonsPage(
                                courseId: courseId,
                              );
                            }));
                          },
                          child: Container(
                            height: slideHeight * 0.12,
                            //width: slideWidth * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.orange[300],
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Colors.black38,
                                  //offset: Offset.fromDirection(-100),
                                )
                              ],
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            margin: EdgeInsets.only(
                              top: 20,
                              right: 20,
                              left: 20,
                            ),
                            padding: EdgeInsets.only(
                              //top: 10,
                              // bottom: 10,
                              right: 20,
                              left: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Resume Course',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${course['name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'DMSans',
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: user['avatar'] != null &&
                                          user['avatar'] != ''
                                      ? NetworkImage(user['avatar'])
                                      : AssetImage('assets/images/resume.png')
                                          as ImageProvider,
                                  radius: slideWidth * 0.07,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
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
                          'My Courses',
                          style: heading1,
                        ),
                        coursesLoaded
                            ? Container(
                                height: slideHeight * 0.3,
                                margin: EdgeInsets.only(
                                  top: 15,
                                ),
                                child: userCourses.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Enroll in a course to get started.',
                                          style: normalText,
                                        ),
                                      )
                                    : ListView.builder(
                                        //physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: userCourses.length,
                                        itemBuilder: (context, index) {
                                          return SingleChildScrollView(
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return LessonsPage(
                                                        courseId:
                                                            userCourses[index]
                                                                ['_id'],
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    height: slideHeight * 0.3,
                                                    width: slideWidth * 0.4,
                                                    child: Center(
                                                        child: Text(
                                                            "${userCourses[index]['name']}")),
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
                              ),
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
                        assignmentsLoaded
                            ? Container(
                                height: slideHeight * 0.3,
                                margin: EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
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
                                                        lessonId:
                                                            assignmentData[
                                                                    index]
                                                                ['lesson'],
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    margin: EdgeInsets.only(
                                                        right: 15),
                                                    height: slideHeight * 0.3,
                                                    width: slideWidth * 0.4,
                                                    child: Center(
                                                      child: Text(
                                                        "${assignmentData[index]['heading']}",
                                                        textAlign:
                                                            TextAlign.center,
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
