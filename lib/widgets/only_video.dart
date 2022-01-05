// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: avoid_print
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: non_constant_identifier_names

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

Widget OnlyVideo(BuildContext context, data, slideHeight, slideController) {
  var index = data['video_url'].indexOf('?v=');
  String videoId = data['video_url'].substring(index + 3);

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId,
    params: YoutubePlayerParams(
      autoPlay: true,
      // showControls: true,
      showFullscreenButton: true,
    ),
  );

  double slideWidth = MediaQuery.of(context).size.width;
  return Container(
    height: slideHeight,
    child: DelayedDisplay(
      delay: Duration(
        milliseconds: 200,
      ),
      slidingBeginOffset: Offset(0.0, 0.0),
      slidingCurve: Curves.easeIn,
      child: YoutubePlayerIFrame(
        controller: _controller,
        aspectRatio: 9 / 16,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
      ),
    ),
    color: Color(0xffF1F8FF),
  );
}
