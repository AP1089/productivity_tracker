import 'package:click_up/ui_kit/size_config.dart';
import 'package:flutter/material.dart';

class AppStyle {
  ///Font
  static const String font = "Audiowide";

  ///Colors
  static final Color green = Colors.green;
  static final Color purple = Colors.orangeAccent;
  static final Color blue = Colors.blue;
  static final Color red = Colors.red;
  static final Color black = Colors.black;
  static final Color black54 = Colors.black54;
  static final Color black12 = Colors.black12;
  static final Color white38 = Colors.white38;
  static final Color gray = Colors.grey;
  static final Color white = Colors.white;
  static final Color transparent = Colors.transparent;

  ///Text Styles
  static TextStyle titleSizeLargeRegular = TextStyle(
      fontFamily: font,
      fontSize: SizeConfig.textMultiplier * 3.0,
      color: black);

  static TextStyle bodySizeMediumRegular =
      TextStyle(fontFamily: font, fontSize: SizeConfig.textMultiplier * 2.2);

  static TextStyle bodySizeSmallRegular = TextStyle(
      fontFamily: font,
      fontSize: SizeConfig.textMultiplier * 1.7,
      color: AppStyle.black54);
}
