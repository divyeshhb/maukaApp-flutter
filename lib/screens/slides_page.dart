// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: unnecessary_string_escapes
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mauka/screens/assignments_screen.dart';
import 'package:mauka/screens/open_camera.dart';
import 'package:mauka/widgets/slide_creator.dart';
import 'package:mauka/services/authenticate.dart';

import '../strings.dart';

class SlidesPage extends StatefulWidget {
  const SlidesPage(
      {Key? key, @required this.lessonId, @required this.user, this.courseId})
      : super(key: key);

  final String? lessonId;
  final String? courseId;
  final user;

  @override
  _SlidesPageState createState() => _SlidesPageState();
}

class _SlidesPageState extends State<SlidesPage> {
  PageController slideController = PageController();
  double? currentSlide = 0;
  List data = [];
  bool slidesLoaded = false;
  bool progressLoaded = false;
  dynamic courseId;

  int progress = 0;

  getSlides(lessonId) async {
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/slides/$lessonId',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          slidesLoaded = true;
          data = response.data;
        });
      } else {
        // err
        // print(response.statusMessage);
      }
    });
  }

  getProgress() {
    try {
      progress = widget.user['lessons_enrolled'].firstWhere(
          (lesson) => lesson['lesson'] == widget.lessonId)['progress'];
    } catch (e) {
      progress = 0;
    }
    setState(() {
      progressLoaded = true;
      print(progress);
    });
  }

  updateProgess(courseProgress, lessonProgress) async {
    Dio dio = Dio();
    if (lessonProgress > progress) {
      var token = await Strings().getToken();
      dio.options.headers["Authorization"] = "Bearer $token";

      try {
        await dio
            .post(
          '${Strings.localhost}users/updateProgress',
          data: jsonEncode({
            'email': widget.user['email'],
            'course': widget.courseId,
            'courseProgress': courseProgress,
            'lesson': widget.lessonId,
            'lessonProgress': lessonProgress,
          }),
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        )
            .then((value) {
          if (value.statusCode == 200) {
            progress = lessonProgress;
          }
        });
      } on DioError catch (err) {
        if (err.response?.statusCode == 400) {
          print(err.message);
        }
      }
    }
  }

  @override
  void initState() {
    print(widget.lessonId);
    getSlides(widget.lessonId);
    getProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    slideController.addListener(() {
      setState(() {
        currentSlide = slideController.page;
      });
    });
    double slideHeight = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
    double slideWidth = MediaQuery.of(context).size.width;
    List selectedOption = [0, 0, 0, 0];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF1F8FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: Container(
            margin: EdgeInsets.only(
              // left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              // bottom: MediaQuery.of(context).size.width * 0.05,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: LinearProgressIndicator(
                backgroundColor: Colors.blue[100],
                color: Color(0xff49abff),
                value: slidesLoaded && data.isNotEmpty && currentSlide! > 0
                    ? (currentSlide!) / (data.length - 1)
                    : 0,
              ),
            ),
          ),
        ),
        body: slidesLoaded && progressLoaded
            ? PageView.builder(
                controller: slideController,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPageChanged: (val) {
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).unfocus();
                  }
                  updateProgess(
                    val,
                    val,
                  );
                },
                physics: ClampingScrollPhysics(),
                allowImplicitScrolling: false,
                itemCount: data.length + 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Container(
                        height: slideHeight,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AssigmentsPage(
                                    lessonId: widget.lessonId);
                              }));
                            },
                            child: Text('Start Practicing'),
                          ),
                        ));
                  }
                  return SlideCreator().slideCreator(
                    widget.lessonId!,
                    data[index]['type'],
                    context,
                    data[index],
                    slideHeight,
                    slideController,
                    progress,
                  );
                })
            : CircularProgressIndicator(),
      ),
    );
  }
}
