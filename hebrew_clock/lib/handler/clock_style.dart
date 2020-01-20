import 'dart:core';

import 'package:flutter/material.dart';

class ClockStyle {
  static bool isLightMod = true;

  static TextStyle getClockTextStyle(double fontSize, BuildContext context) {
    return TextStyle(
      color: isLightMod ? Colors.white : Color(0xFF2f545b),
      fontSize: fontSize,
      fontFamily: 'Segment7',
      shadows: [
        Shadow(
          blurRadius: 0,
          color: getShadowColors(context),
          offset: Offset(3, 0),
        ),
      ],
    );
  }

  static TextStyle getContentTextStyle(double textSize, BuildContext context) {
    return TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.bold,
        color: getFrontColors(context),
        shadows: isLightMod
            ? [
                Shadow(
                    // bottomLeft
                    offset: Offset(-1, -1),
                    color: getShadowColors(context)),
                Shadow(
                    // bottomRight
                    offset: Offset(1, -1),
                    color: getShadowColors(context)),
                Shadow(
                    // topRight
                    offset: Offset(1, 1),
                    color: getShadowColors(context)),
                Shadow(
                    // topLeft
                    offset: Offset(-1, 1),
                    color: getShadowColors(context)),
              ]
            : null);
  }

  static Color getFrontColors(BuildContext context) {
    return isLightMod ? Colors.white : Color(0xFF2f545b);
  }

  static Color getShadowColors(BuildContext context) {
    return isLightMod ? Color(0xFF2f545b) : Color(0xFFDCF1F8);
  }
}
