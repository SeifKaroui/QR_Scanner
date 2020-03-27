import 'package:flutter/material.dart';

class Screen {
  static double width;
  static double height;
  static double widthBlock = 5;
  static double heightBlock;
  static double textBlock;

  static void init(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);

    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    widthBlock = _mediaQueryData.size.width / 100;
    heightBlock = _mediaQueryData.size.height / 100;
    textBlock = widthBlock/ 4;
  }
}
