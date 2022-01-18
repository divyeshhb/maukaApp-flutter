// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mauka/screens/splash_page.dart';
import 'package:mauka/services/authenticate.dart';
import 'package:mauka/services/current_user.dart';

import '../strings.dart';

class McqInputOnlyText extends StatefulWidget {
  const McqInputOnlyText({
    Key? key,
    this.data,
    this.slideHeight,
    this.slideController,
  }) : super(key: key);

  final dynamic data;
  final double? slideHeight;
  final PageController? slideController;

  @override
  _McqInputOnlyTextState createState() => _McqInputOnlyTextState();
}

class _McqInputOnlyTextState extends State<McqInputOnlyText> {
  List selectedOption = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  var user;
  bool optionsLoaded = false;
  getSelectedOptions(slideId) async {
    var token = await Strings().getToken();
    if (token != null && token.isNotEmpty) {
      var result = await CurrentUser().checkToken(token);
      if (result[0]) {
        user = jsonDecode(result[1]);
        setState(() {
          optionsLoaded = true;
        });
        if (user['slide_response'] != null &&
            user['slide_response'].isNotEmpty) {
          try {
            var response = user['slide_response']
                .firstWhere((element) => element['slide'] == slideId);
            if (response != null) {
              setState(() {
                selectedOption = response['response'].split(',');
                // selectedOption
                //     .forEach((element) => {element = int.parse(element)});
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
    getSelectedOptions(widget.data['_id']);
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
            Expanded(
              flex: 2,
              child: optionsLoaded
                  ? ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.data['options'][0].length,
                      itemBuilder: (BuildContext context, index) {
                        if (index == 0) {
                          return Container();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // selectedOption = [0, 0, 0, 0, 0];
                                if (selectedOption[index] == '1') {
                                  selectedOption[index] = '0';
                                } else {
                                  selectedOption[index] = '1';
                                }
                              });
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: slideWidth * 0.65,
                                    child: AutoSizeText(
                                      '${widget.data['options'][0]['option_${String.fromCharCode(96 + index)}']}',
                                      // '${sample1[0]['option_${String.fromCharCode(96 + index)}']}',
                                      style: TextStyle(
                                        color: selectedOption[index] == '1'
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  selectedOption[index] == '1'
                                      ? Icon(Icons.check)
                                      : Container(),
                                ],
                              ),
                              padding: EdgeInsets.only(
                                  left: slideWidth * 0.06,
                                  right: slideWidth * 0.06),
                              margin: EdgeInsets.only(
                                right: slideWidth * 0.06,
                                left: slideWidth * 0.06,
                                bottom: widget.slideHeight! * 0.02,
                              ),
                              width: slideWidth,
                              height: widget.slideHeight! * 0.09,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ),
                                color: selectedOption[index] == '1'
                                    ? Colors.blue
                                    : Color(0xffC0E1FF),
                                border: Border.all(
                                  width: 2,
                                  color: selectedOption[index] == '1'
                                      ? Colors.blue
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Authenticate()
                      .submitMcq(user, widget.data['_id'], selectedOption);
                },
                child: Text('Submit'),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        color: Color(0xffF1F8FF),
      ),
    );
  }
}
