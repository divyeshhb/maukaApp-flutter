// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ReflectPage extends StatefulWidget {
  const ReflectPage({Key? key}) : super(key: key);

  @override
  _ReflectPageState createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  List reflectData = [
    {
      'type': 'question',
      'question_data': 'How would you reflect?',
    },
    {
      'type': 'feedback',
      'feedback_data': 'You were great',
    },
    {
      'type': 'both',
      'question_data': 'How would you reflect?',
      'feedback_data': 'You were great',
    },
    {},
  ];
  PageController pageController = PageController();
  double? currentPageValue = 0.0;

  @override
  Widget build(BuildContext context) {
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
                controller: pageController,
                itemBuilder: (context, position) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      // vertical: MediaQuery.of(context).size.width * 0.3,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[200]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.05,
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width * 0.1,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                          ),
                          child:
                              Text('${reflectData[position]['question_data']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        currentPageValue! < reflectData.length - 1
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      pageController.nextPage(
                                          duration: Duration(milliseconds: 400),
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
                              )
                            : Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      //submit
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
