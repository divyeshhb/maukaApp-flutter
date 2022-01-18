// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: unnecessary_string_escapes
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: use_rethrow_when_possible

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mauka/screens/reflect_page.dart';
import 'dart:async';

import '../strings.dart';

class OpenCamera extends StatefulWidget {
  OpenCamera({
    this.user,
    this.lessonId,
    Key? key,
    this.prompts,
  }) : super(key: key);

  final List? prompts;
  final String? lessonId;
  final user;

  @override
  _OpenCameraState createState() => _OpenCameraState();
}

late List<CameraDescription> cameras;

class _OpenCameraState extends State<OpenCamera> {
  XFile? videoFile;
  late CameraController controller;
  bool initialised = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool recordingStarted = false;

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }
    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void submitVideo(xFile) async {
    Uint8List video = File(xFile.path).readAsBytesSync();
    var token = await Strings().getToken();
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    await dio
        .get(
      '${Strings.localhost}users/generateS3Url',
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        await http
            .put(Uri.parse(response.data['url']), body: video)
            .then((res) async {
          if (res.statusCode == 200) {
            Dio dio = Dio();
            try {
              var token = await Strings().getToken();
              dio.options.headers["Authorization"] = "Bearer $token";

              await dio
                  .post(
                    '${Strings.localhost}users/saveAssignment/${widget.lessonId}',
                    data: jsonEncode({
                      'email': widget.user['email'],
                      's3_url': response.data['url'].split('?')[0],
                    }),
                    options: Options(
                      contentType: Headers.jsonContentType,
                    ),
                  )
                  .then((value) => print(value));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return ReflectPage(
                  lessonId: widget.lessonId,
                );
              }));
              //print(response);
              //return response;
            } on DioError catch (err) {
              if (err.response?.statusCode == 400) {
                print("Couldn't do it");
              }
              throw err;
            }
          } else {}
        });
      } else {}
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }
    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }
    try {
      await cameraController.startVideoRecording();
      setState(() {
        recordingStarted = true;
        startTimer();
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void _showCameraException(CameraException e) {
    //logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget buttonNew(text, onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      highlightColor: Color.fromRGBO(1, 1, 1, 0),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'DMSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      if (mounted) {
        setState(() {
          stopTimer();
          recordingStarted = false;
        });
      }
      if (file != null) {
        videoFile = file;
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Dialog(
                //backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25 / 4,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Confirmation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      Text(
                        'Do you want to submit or try again?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DMSans',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buttonNew('Retake', () {
                            Navigator.of(context).pop();
                          }),
                          buttonNew('Submit', () async {
                            submitVideo(videoFile);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  checkCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    setState(() {
      initialised = true;
    });
    controller = CameraController(
      cameras[1],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Duration duration = Duration();
  Timer? timer;

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  stopTimer() {
    setState(() {
      duration = Duration();
    });
    timer?.cancel();
  }

  addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      decoration: BoxDecoration(
        color: recordingStarted ? Colors.red : Color.fromRGBO(1, 1, 1, 0),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(5),
      child: Text(
        '$hours:$minutes:$seconds',
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'DMSans',
          color: recordingStarted ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  bool promptsHidden = false;

  hideShowPrompts() {
    setState(() {
      promptsHidden = !promptsHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    checkCameras();
  }

  int endTime = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
    double width = MediaQuery.of(context).size.width;
    if (!initialised) {
      return CircularProgressIndicator();
    }
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Practice',
            style: TextStyle(
              fontFamily: 'Poppins',
              //fontSize: 28,
              //fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: height * 0.03,
                // // left: width * 0.03,
                // // right: width * 0.03,
                // bottom: height * 0.02,
              ),
              child: Center(
                child: buildTime(),
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    // // left: width * 0.03,
                    // // right: width * 0.03,
                    // bottom: height * 0.02,
                  ),
                  height: height * 0.78,
                  child: Center(child: CameraPreview(controller)),
                ),
                widget.prompts != null && !promptsHidden
                    ? Positioned(
                        top: height * 0.55,
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: GestureDetector(
                          // onHorizontalDragEnd: (_) {
                          //   hideShowPrompts();
                          // },
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.prompts!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: height * 0.07,
                                margin: EdgeInsets.only(
                                  left: width * 0.08,
                                  right: width * 0.4,
                                  bottom: height * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  '${widget.prompts![index]}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                )),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
                // // left: width * 0.03,
                // // right: width * 0.03,
                // bottom: height * 0.02,
              ),
              child: !recordingStarted
                  ? IconButton(
                      icon: Icon(Icons.videocam),
                      onPressed: startVideoRecording,
                      iconSize: 40,
                    )
                  : IconButton(
                      onPressed: onStopButtonPressed,
                      icon: Icon(Icons.stop),
                      iconSize: 40,
                      color: Colors.red,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
