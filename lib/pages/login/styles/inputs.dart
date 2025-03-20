import 'package:flutter/material.dart';

TextStyle kHintTextStyle() {
  return const TextStyle(fontFamily: 'OpenSans');
}

TextStyle kLabelStyle() {
  return const TextStyle(
    // color: color,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
}

BoxDecoration kBoxDecorationStyle() {
  return BoxDecoration(
    // color: color,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [BoxShadow(blurRadius: 6.0, offset: Offset(0, 2))],
  );
}
