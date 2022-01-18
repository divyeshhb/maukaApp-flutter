// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/assignments_screen.dart';
import 'package:mauka/screens/reflect_page.dart';
import 'package:mauka/screens/splash_page.dart';

//heading
//image_url
//subheading
//button_bool

Widget IntroSlide(BuildContext context, data, slideHeight,
    PageController slideController, lessonId, progress) {
  double slideWidth = MediaQuery.of(context).size.width;
  return Container(
    height: slideHeight,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: slideHeight * 0.4,
              width: slideWidth,
              child: Image.network(
                data['image_url'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: slideWidth,
              margin: EdgeInsets.only(
                  left: slideWidth * 0.06,
                  right: slideWidth * 0.06,
                  top: slideHeight * 0.06),
              child: AutoSizeText(
                '${data['heading']}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                // maxFontSize: 28,
                maxLines: 3,
              ),
            ),
            Container(
              //height: slideHeight * 0.2,
              width: slideWidth,
              margin: EdgeInsets.only(
                  left: slideWidth * 0.06,
                  right: slideWidth * 0.06,
                  top: slideHeight * 0.02),
              child: AutoSizeText(
                '${data['subtext']}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'DMSans',
                  fontSize: 19,
                ),
                maxLines: 8,
                //minFontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: slideHeight * 0.075),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_rounded,
                color: Colors.black,
              ),
              SizedBox(
                width: slideWidth * 0.015,
              ),
              Text(
                '${data['time_to_finish']}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {
            //change
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return ReflectPage(lessonId: lessonId);
            // }));
            slideController.animateToPage(
              progress > 0 ? progress : 1,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
            );
          },
          child: Center(
            child: Container(
              child: Center(
                child: Text(
                  progress > 0 ? 'Resume Lesson' : 'Start Lesson',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                bottom: slideHeight * 0.04,
              ),
              height: slideHeight * 0.09,
              width: slideWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    color: Color(0xffF1F8FF),
  );
}
