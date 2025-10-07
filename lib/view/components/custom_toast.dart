import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  displayAToast() {
    Fluttertoast.showToast(
      msg: "Your entries are not valide",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 100000,
      backgroundColor: Color(0xFF1A6175),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
