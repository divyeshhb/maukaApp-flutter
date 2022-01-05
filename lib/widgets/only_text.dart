// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget OnlyText(
    BuildContext context, data, slideHeight, PageController slideController) {
  double slideWidth = MediaQuery.of(context).size.width;
  return Container(
    height: slideHeight,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        data['heading'] != null
            ? Container(
                width: slideWidth,
                margin: EdgeInsets.only(
                  left: slideWidth * 0.06,
                  right: slideWidth * 0.06,
                  bottom: slideHeight * 0.02,
                  // top: slideHeight * 0.02,
                ),
                child: AutoSizeText(
                  '${data['heading']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  // maxFontSize: 28,
                  maxLines: 8,
                ),
              )
            : Container(
                width: slideWidth,
                margin: EdgeInsets.only(
                  left: slideWidth * 0.06,
                  right: slideWidth * 0.06,
                  // top: slideHeight * 0.02,
                ),
                child: AutoSizeText(
                  '"',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
              ),
        data['subtext'] != null
            ? Container(
                //height: slideHeight * 0.2,
                width: slideWidth,
                margin: EdgeInsets.only(
                  left: slideWidth * 0.06,
                  right: slideWidth * 0.06,
                  top: data['heading'] != null ? slideHeight * 0.02 : 0,
                  bottom: slideWidth * 0.02,
                ),
                child: AutoSizeText(
                  '${data['subtext']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'DMSans',
                    fontSize: 20,
                  ),
                  maxLines: 12,
                  //minFontSize: 14,
                ),
              )
            : Container(height: 100),
        // MaterialButton(
        //   onPressed: () {
        //     slideController.nextPage(
        //       duration: Duration(milliseconds: 500),
        //       curve: Curves.decelerate,
        //     );
        //   },
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Continue',
        //           style: TextStyle(
        //             fontFamily: 'DMSans',
        //             fontSize: 19,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //         Icon(Icons.arrow_forward)
        //       ],
        //     ),
        //     margin: EdgeInsets.only(
        //       top: slideHeight * 0.04,
        //       bottom: slideHeight * 0.04,
        //       left: slideWidth * 0.01,
        //     ),
        //     height: slideHeight * 0.07,
        //     width: slideWidth * 0.4,
        //     decoration: BoxDecoration(
        //       color: Colors.black,
        //       borderRadius: BorderRadius.circular(
        //         10,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    ),
    color: Color(0xffF1F8FF),
  );
}
