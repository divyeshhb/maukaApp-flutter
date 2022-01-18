// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mauka/services/authenticate.dart';

class ReflectPage extends StatefulWidget {
  const ReflectPage({
    Key? key,
    this.lessonId,
  }) : super(key: key);

  final String? lessonId;

  @override
  _ReflectPageState createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  List reflectData = [
    'Reflect on your learnings today.',
    'Question 2?',
    'Question 3?',
    'Question 4?',
    'Question 5?'
  ];

  List<TextEditingController> editingControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

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
                                      onTap: () {
                                        for (var editor in editingControllers) {
                                          reflectRes.add(editor.text);
                                        }
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
                      ],
                    ),
                  );
                },
                itemCount: reflectData.length,
              )),
        ],
      ),
    );
  }
}
