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
import 'package:mauka/screens/lessons_page.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/current_user.dart';
import 'package:mauka/widgets/slide_creator.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'dart:io';
import '../strings.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  dynamic user;
  List courseData = [];
  bool coursesLoaded = false;

  getUser() async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      print(token);
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
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return SplashPage();
      }));
    }
  }

  getCourses() async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/courses',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          coursesLoaded = true;
          courseData = response.data;
          print(courseData);
        });
      } else {
        //err
        //print(response.statusMessage);
      }
    });
  }

  @override
  void initState() {
    getUser();
    getCourses();
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
          'CoursePage',
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
              var storage = const FlutterSecureStorage();
              const options = IOSOptions(
                accessibility: IOSAccessibility.first_unlock,
              );
              await storage.delete(key: "token", iOptions: options);
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
      body: coursesLoaded
          ? ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LessonsPage(
                        courseId: courseData[index]['_id'],
                      );
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 20,
                      top: 30,
                    ),
                    height: slideHeight * 0.45,
                    decoration: BoxDecoration(color: Colors.blue[100]),
                    child: Column(
                      children: [
                        SizedBox(
                          height: slideHeight * 0.45 * 0.7,
                          width: double.infinity,
                          child: Image.network(
                            'https://media.istockphoto.com/photos/path-leads-to-decision-which-changes-the-path-in-two-directions-picture-id1142622077?k=20&m=1142622077&s=612x612&w=0&h=baEJzSolDZlo2V91thUPgmU4wZ_r6ruFSpJdbrLPwos=',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: slideHeight * 0.45 * 0.3,
                          margin: EdgeInsets.only(
                            left: slideWidth * 0.03,
                            right: slideWidth * 0.03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: slideWidth * 0.03,
                                  right: slideWidth * 0.03,
                                  // bottom: slideHeight * 0.01,
                                  // top: slideHeight * 0.02,
                                ),
                                width: slideWidth * 0.58,
                                child: AutoSizeText(
                                  courseData[index]['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 24,
                                  ),
                                  minFontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: Colors.black,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: courseData.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
