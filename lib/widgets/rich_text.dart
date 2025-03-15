import 'package:flutter/cupertino.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/text.dart';

class MRichText extends RichText {
  MRichText({super.key, required super.text});

  static RichText rich(
          {required String title,
          required String text,
          double? fontSize = 16}) =>
      MRichText(
          text: TextSpan(children: [
        TextSpan(
            text: title,
            style: TitleTextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: ColorUtil.black)),
        TextSpan(
            text: text,
            style: TitleTextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.normal,
                color: ColorUtil.black))
      ]));
}
