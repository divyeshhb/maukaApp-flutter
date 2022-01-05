// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mauka/screens/open_camera.dart';

class VideoRecorder extends StatefulWidget {
  const VideoRecorder({Key? key}) : super(key: key);

  @override
  _VideoRecorderState createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  dynamic videoFile;
  final ImagePicker _picker = ImagePicker();

  recordVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: 9),
      preferredCameraDevice: CameraDevice.front,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Practice',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xffF1F8FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Talk about yourself. The recording will automatically stop after 10 seconds.',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return OpenCamera();
                }));
                ;
              },
              child: Text('Record'),
            ),
            //child: CameraPreview(controller),
          ),
        ],
      ),
    );
  }
}
