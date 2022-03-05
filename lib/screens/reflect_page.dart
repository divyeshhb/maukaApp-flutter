// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/home_page.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:mauka/services/current_user.dart';
import 'package:mauka/strings.dart';

class ReflectPage extends StatefulWidget {
  const ReflectPage({
    Key? key,
    @required this.lessonId,
    @required this.user,
  }) : super(key: key);

  final String? lessonId;
  final user;

  @override
  _ReflectPageState createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  List reflectData = [
    'Reflect on your learnings today.',
    'Question 2?',
    'Question 3?',
    'Question 4?',
    'Question 5?',
  ];
  bool reflectLoaded = false;
  bool sendingResponse = false;

  List<TextEditingController> editingControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  getReflectQuestions() async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.get(
      '${Strings.localhost}users/courseAssignments/${widget.lessonId}',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        //TODO: change here
        //reflectData = response.data;
        reflectLoaded = true;
      });
    }
  }

  sendReflect(reflectResponse) async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";

    Response response = await dio
        .post(
      '${Strings.localhost}users/saveReflect/${widget.lessonId}',
      data: jsonEncode({
        'email': widget.user['email'],
        'responses': reflectResponse,
      }),
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((resp) {
      setState(() {
        sendingResponse = false;
      });
      if (resp.statusCode == 200) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }
      return resp;
    });
  }

  var user;
  getOldResponses() async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        user = jsonDecode(result[1]);
        if (user['reflect_response'] != null &&
            user['reflect_response'].isNotEmpty) {
          try {
            var response = user['reflect_response']
                .lastWhere((element) => element['lesson'] == widget.lessonId);
            if (response != null) {
              print(response);
              for (int i = 0; i < response['responses'].length; i++) {
                editingControllers[i] =
                    TextEditingController(text: response['responses'][i]);
              }
              setState(() {});
            }
          } catch (e) {
            print(e);
          }
        }
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

  @override
  void initState() {
    getReflectQuestions();
    getOldResponses();
    super.initState();
  }

  List reflectRes = [];

  List<String> reflectText = [];
  PageController pageController = PageController();
  double? currentPageValue = 0.0;
  @override
  Widget build(BuildContext context) {
    double slideWidth = MediaQuery.of(context).size.width;
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 240, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
            ),
            child: Text(
              'Reflect on your learnings today.',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              bottom: MediaQuery.of(context).size.width * 0.05,
            ),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.deepPurple,
              value: (1 + currentPageValue!) / reflectData.length,
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView.builder(
                //physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: reflectData.length,
                itemBuilder: (context, position) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      // vertical: MediaQuery.of(context).size.width * 0.3,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    padding: EdgeInsets.symmetric(vertical: slideWidth * 0.05),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[200]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.05,
                        // ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.06,
                              left: MediaQuery.of(context).size.width * 0.06,
                            ),
                            child: Text('${reflectData[position]}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: slideWidth,
                            //height: slideHeight * 0.2,
                            margin: EdgeInsets.only(
                              left: slideWidth * 0.06,
                              right: slideWidth * 0.06,
                              bottom: slideWidth * 0.04,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black54),
                                color: Colors.white),
                            child: TextField(
                              //keyboardType: TextInputType.multiline,
                              //autofocus: true,
                              controller: editingControllers[position],
                              minLines: 12,
                              maxLines: 12,
                              //expands: true,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hoverColor: Colors.black,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.black,
                                hintText: 'Start typing here...',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                        currentPageValue! < reflectData.length - 1
                            ? Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                      // bottom: 30,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.easeInOut);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(0, 0, 0, 1),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.065,
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 10,
                                      // bottom: 30,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          sendingResponse = true;
                                        });
                                        reflectRes = [];
                                        for (var editor in editingControllers) {
                                          if (editingControllers
                                                  .indexOf(editor) <
                                              reflectData.length) {
                                            reflectRes.add(editor.text);
                                          }
                                        }
                                        sendReflect(reflectRes);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(0, 0, 0, 1),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.065,
                                        child: !sendingResponse
                                            ? Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
