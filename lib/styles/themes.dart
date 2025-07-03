import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = Colors.orange;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.black;
  static const Color _darkPrimaryAppBarColor = Colors.white;

  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: _lightPrimaryColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
    fontFamily: ApplevelConstants.fontFamily,
  );

  static final darkTheme = ThemeData(
    // scaffoldBackgroundColor: _darkPrimaryColor,
    appBarTheme: const AppBarTheme(
      color: _darkPrimaryAppBarColor,
      iconTheme: IconThemeData(color: _darkPrimaryColor),
    ),

    fontFamily: ApplevelConstants.fontFamily,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _lightPrimaryColor,
    ),

    // TEXTS
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      displayLarge: TextStyle(
        color: _darkPrimaryColor,
        fontSize: 96.0,
        letterSpacing: -1.5,
      ),
      displayMedium: TextStyle(
        color: _darkPrimaryColor,
        fontSize: 60.0,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        color: _darkPrimaryColor,
        fontSize: 48.0,
        letterSpacing: 0.0,
      ),
      headlineMedium: TextStyle(
        color: _darkPrimaryColor,
        fontSize: 34.0,
        letterSpacing: 0.25,
      ),
      headlineSmall: TextStyle(
        letterSpacing: 0.0,
        fontSize: 25.0,
      ),
      titleLarge: TextStyle(
        letterSpacing: 0.15,
        fontSize: 20.0,
      ),
    ),
  );
}
