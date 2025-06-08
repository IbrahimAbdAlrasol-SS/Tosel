import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class GlobalToast {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    int durationInSeconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      timeInSecForIosWeb: durationInSeconds,
    );
  }

  static void showSuccess({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    int durationInSeconds = 2,
  }) {
    show(
      message: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      durationInSeconds: durationInSeconds,
    );
  }
}
