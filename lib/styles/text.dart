import 'package:flutter/material.dart';

import 'bg.dart';

const Color dfltTextColor = Color.fromARGB(255, 53, 53, 53);

titleStyleText(String mycolor, double fontSize) {
  return TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);
}

Color primaryColor() {
  return Colors.black;
}

subtitleStyleText(String mycolor, double fontSize) {
  return TextStyle(fontSize: fontSize);
}

class TitleTextStyle extends TextStyle {
  const TitleTextStyle({
    super.inherit = true,
    super.color,
    super.backgroundColor,
    super.fontSize,
    super.fontWeight = FontWeight.normal,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    super.overflow,
  });
}
