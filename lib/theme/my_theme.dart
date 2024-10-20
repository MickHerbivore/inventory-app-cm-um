import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary = Color.fromRGBO(145, 171, 225, 1); 
  static const Color secondary = Color.fromRGBO(103, 119, 152, 1);
  
  static final ThemeData myTheme = ThemeData(
    primaryColor: primary,
    shadowColor: secondary,
    brightness: Brightness.light,
    fontFamily: 'Raleway',
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 10,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      )
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        )
      ),
    ),
    floatingActionButtonTheme: 
      const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      )
    ),
  );
}