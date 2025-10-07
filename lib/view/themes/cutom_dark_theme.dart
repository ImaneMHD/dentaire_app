import 'package:flutter/material.dart';

class DarkThemes {
  ////////////////////////// Thème sombre////////////////////////////
  static final ThemeData darkTheme1 = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    // Style des textes
    textTheme: TextTheme(
      bodyLarge: const TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[300]),
    ),
    // Style pour TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),
    // Style pour ListView
    listTileTheme: ListTileThemeData(
      tileColor: Colors.grey[900],
      textColor: Colors.white,
      iconColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
