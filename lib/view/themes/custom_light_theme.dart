import 'package:flutter/material.dart';

class LightThemes {
  ////////////////////////// Thème clair ///////////////////////////////
  static final ThemeData lightTheme1 = ThemeData(
    scaffoldBackgroundColor: const Color(0xffc5f3fd),

    appBarTheme: const AppBarTheme(
      color: Color(0xff065464),
      elevation: 15,
      shadowColor: Color(0xffaae3ef),
      titleTextStyle: TextStyle(
        color: Color(0xffaae3ef),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'ComicSans',
      ),
      iconTheme: IconThemeData(color: Color(0xffaae3ef)),
      actionsIconTheme: IconThemeData(color: Color(0xffaae3ef)),
    ),

    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'ComicSans',
        fontStyle: FontStyle.italic,
        fontSize: 28,
        color: Color(0xff033244),
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'ComicSans',
        fontStyle: FontStyle.italic,
        fontSize: 20,
        color: Color(0xff033244),
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'ComicSans',
        fontStyle: FontStyle.italic,
        fontSize: 4,
        color: Color(0xff033244),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xffcbc7c7), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xff033244), width: 5),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIconColor: const Color(0xff033244),
      suffixIconColor: const Color(0xff033244),
      labelStyle: const TextStyle(
        fontSize: 15,
        backgroundColor: Colors.transparent,
        color: Colors.grey,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'TimeNewRoman',
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff065464),
        foregroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xff173542),
            width: 3,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: const Color(0x8a080808),
        elevation: 20,
      ),
    ),

    listTileTheme: ListTileThemeData(
      tileColor: const Color(0xff58d7f1),
      textColor: Colors.black,
      iconColor: const Color(0xff636160),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xff065464),
      foregroundColor: Colors.white,
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      sizeConstraints: const BoxConstraints.tightFor(width: 100, height: 60),
    ),

    // ✅ Correction ici : CardThemeData au lieu de CardTheme
    cardTheme: const CardThemeData(
      color: Color(0xffd24b4b),
      shadowColor: Colors.grey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Colors.blue, width: 2),
      ),
      margin: EdgeInsets.all(8),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),
  );
}
