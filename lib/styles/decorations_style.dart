import 'package:flutter/material.dart';
import 'package:geap_fit/styles/bg.dart';
import 'package:geap_fit/styles/color_provider/color_provider.dart';
import 'package:geap_fit/styles/text.dart';

const double _iconSize = 25;

class MyTheme {
  static const Color grayLight = Color.fromARGB(255, 242, 243, 245);
  static const Color gray = Color.fromARGB(255, 197, 197, 197);
  static const Color secondary = Color.fromARGB(248, 249, 243, 254);
  static const Color error = Color.fromARGB(255, 228, 52, 46);
  static const Color warning = Color.fromARGB(255, 255, 251, 9);
  static const Color labelColor = Color.fromARGB(255, 53, 53, 53);
  static String? fontFamily = "Roboto";

  ThemeData theme(ColorProvider colorProvider) {
    return ThemeData(
      fontFamily: fontFamily, // Set the default font family
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colorProvider.primary(),
        secondary: colorProvider.primaryLight(),
        surface: colorProvider.primaryLight(),
        error: error,
      ),
    );
  }
}
