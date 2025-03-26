import 'package:flutter/material.dart';

class KElevatedButtonTheme {
  KElevatedButtonTheme._();
  // Blue Theme Buttons
  static final blueElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final blueDarkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.blueAccent,
      side: const BorderSide(color: Colors.blueAccent),
      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 18),
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}