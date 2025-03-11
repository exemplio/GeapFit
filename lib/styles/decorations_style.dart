import 'package:flutter/material.dart';
import 'package:sports_management/styles/bg.dart';
import 'package:sports_management/styles/color_provider/color_provider.dart';
import 'package:sports_management/styles/text.dart';


const double _iconSize = 25;


class MyTheme {
  static const Color grayLight = Color.fromARGB(255, 242, 243, 245);
  static const Color gray = Color.fromARGB(255, 197, 197, 197);
  static const Color secondary = Color.fromARGB(248, 249, 243, 254);
  static const Color error = Color.fromARGB(255, 228, 52, 46);
  static const Color warning = Color.fromARGB(255, 255, 251, 9);
  static const Color labelColor = Color.fromARGB(255, 53, 53, 53);
  static String? fontFamily = "Big Shoulders Stencil" /* GoogleFonts.roboto().fontFamily */;

  ThemeData theme(ColorProvider colorProvider) {
    return ThemeData(
        drawerTheme: const DrawerThemeData(shape: BeveledRectangleBorder()),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        )),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        )),
        appBarTheme: AppBarTheme(
            titleTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: colorProvider.primary(),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white)),
        textTheme: TextTheme(
          labelLarge: const TextStyle(color: labelColor, fontSize: 16),
          labelMedium: const TextStyle(color: labelColor, fontSize: 12),
          labelSmall: const TextStyle(color: labelColor, fontSize: 8),
          displayLarge:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          titleLarge:
              const TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 16.0, fontFamily: fontFamily),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        datePickerTheme: const DatePickerThemeData(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            dividerColor: Color(0xFF4A148C)),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                iconColor: WidgetStateProperty.all(colorProvider.primary()))),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          titleTextStyle: TitleTextStyle(
            color: ColorUtil.black,
            fontSize: 20,
            fontFamily: fontFamily,
          ),
        ),
        snackBarTheme:
            const SnackBarThemeData(contentTextStyle: TextStyle(fontSize: 14)),
        navigationBarTheme: NavigationBarThemeData(
          height: 50,
          backgroundColor: colorProvider.primary(),
          surfaceTintColor: warning,
          elevation: 0,
          indicatorColor: colorProvider.primaryLight(),
          indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelTextStyle: WidgetStateTextStyle.resolveWith(
              (states) => const TextStyle(fontSize: 10, color: secondary)),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: secondary, size: _iconSize);
            }

            return const IconThemeData(color: gray, size: _iconSize);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        fontFamily: fontFamily,
        primaryColor: colorProvider.primary(),
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: gray,
            cursorColor: colorProvider.primaryLight(),
            selectionHandleColor: colorProvider.primaryLight()),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: colorProvider.primary(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          border: const OutlineInputBorder(),
          iconColor: colorProvider.primaryLight(),
          fillColor: colorProvider.primaryLight(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: colorProvider.primary(),
            secondary: colorProvider.primaryLight(),
            surface: Colors.white,
            error: error));
  }
}
