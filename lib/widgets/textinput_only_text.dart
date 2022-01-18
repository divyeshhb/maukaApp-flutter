// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:mauka/services/current_user.dart';

import '../strings.dart';

//61c57877379a9126b8b006ba
class TextInputOnlyText extends StatefulWidget {
  const TextInputOnlyText(
      {this.data, this.slideHeight, this.slideController, Key? key})
      : super(key: key);

  final dynamic data;
  final double? slideHeight;
  final PageController? slideController;

  @override
  _TextInputOnlyTextState createState() => _TextInputOnlyTextState();
}

class _TextInputOnlyTextState extends State<TextInputOnlyText> {
  late TextEditingController editController = TextEditingController();
  var user;

  getText(slideId) async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        user = jsonDecode(result[1]);
        if (user['slide_response'] != null &&
            user['slide_response'].isNotEmpty) {
          try {
            var response = user['slide_response']
                .firstWhere((element) => element['slide'] == slideId);
            if (response != null) {
              setState(() {
                editController =
                    TextEditingController(text: response['response']);
              });
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
    getText(widget.data['_id']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double slideWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: widget.slideHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //height: slideHeight * 0.2,
              width: slideWidth,
              margin: EdgeInsets.only(
                left: slideWidth * 0.06,
                right: slideWidth * 0.06,
                top: widget.slideHeight! * 0.15,
              ),
              child: AutoSizeText(
                '${widget.data['question']}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                //minFontSize: 14,
              ),
            ),
            SizedBox(
              height: widget.slideHeight! * 0.05,
            ),
            Container(
              width: slideWidth,
              //height: slideHeight * 0.2,
              margin: EdgeInsets.only(
                left: slideWidth * 0.06,
                right: slideWidth * 0.06,
                // top: slideHeight * 0.02,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54),
                  color: Colors.white),
              child: TextField(
                //keyboardType: TextInputType.multiline,
                //autofocus: true,
                controller: editController,
                minLines: 4,
                maxLines: 4,
                //expands: true,
                cursorColor: Colors.black,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (editController.text.isEmpty) {
                        Authenticate()
                            .submitText(user, widget.data['_id'], ' ');
                      }
                      Authenticate().submitText(
                          user, widget.data['_id'], editController.text);
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.blue,
                    ),
                  ),
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
            SizedBox(
              height: widget.slideHeight! * 0.05,
            ),
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
      ),
    );
  }

  Dio() {}
}
