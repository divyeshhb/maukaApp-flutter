// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:async';

import 'package:mauka/screens/camera_example.dart';

class OpenCamera extends StatefulWidget {
  OpenCamera({Key? key}) : super(key: key);

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
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      if (mounted) {
        setState(() {
          recordingStarted = false;
        });
      }
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        final result = await ImageGallerySaver.saveFile(file.path);
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

  @override
  void initState() {
    super.initState();
    checkCameras();
  }

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
          children: [
            Container(
              margin: EdgeInsets.only(
                top: height * 0.06,
                // // left: width * 0.03,
                // // right: width * 0.03,
                // bottom: height * 0.02,
              ),
              height: height * 0.8,
              child: Center(child: CameraPreview(controller)),
            ),
            Container(
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
