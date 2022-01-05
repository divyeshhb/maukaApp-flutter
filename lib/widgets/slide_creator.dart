import 'package:flutter/material.dart';
import 'package:mauka/widgets/intro.dart';

import 'only_text.dart';
import 'image_text.dart';
import 'video_text.dart';
import 'only_video.dart';
import 'textinput_only_text.dart';
import 'mcqinput_only_text.dart';

class SlideCreator {
  Widget slideCreator(
    String typeOfSlide,
    BuildContext context,
    dynamic slideData,
    double slideHeight,
    PageController slideController,
  ) {
    if (typeOfSlide == 'intro') {
      return IntroSlide(context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'only_text') {
      return OnlyText(context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'image_text') {
      return ImageText(context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'video_text') {
      return VideoText(context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'only_video') {
      return OnlyVideo(context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'textinput_only_text' ||
        typeOfSlide == 'textinput_image_text') {
      return TextInputOnlyText(
          context, slideData, slideHeight, slideController);
    } else if (typeOfSlide == 'mcqinput_only_text') {
      return McqInputOnlyText(
        data: slideData,
        slideController: slideController,
        slideHeight: slideHeight,
      );
    } else {
      return Container(child: null);
    }
  }
}
