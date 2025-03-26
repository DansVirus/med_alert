import 'package:flutter/material.dart';
import 'package:med_alert2/utils/themes/custom_themes/appbar_theme.dart';
import 'package:med_alert2/utils/themes/custom_themes/elevated_button_theme.dart';
import 'package:med_alert2/utils/themes/custom_themes/text_field_theme.dart';
import 'package:med_alert2/utils/themes/custom_themes/text_theme.dart';

class KAppTheme {
  KAppTheme._();

  static ThemeData blueTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: KTextTheme.lightTextTheme,
    appBarTheme: KAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: KElevatedButtonTheme.blueElevatedButtonTheme,
    inputDecorationTheme: KTextFormFieldTheme.lightInputDecorationTheme,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static ThemeData blueDarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: KTextTheme.darkTextTheme,
    appBarTheme: KAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: KElevatedButtonTheme.blueDarkElevatedButtonTheme,
    inputDecorationTheme: KTextFormFieldTheme.darkInputDecorationTheme,
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
  );
}
