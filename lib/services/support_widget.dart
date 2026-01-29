import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle healineTextStyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightTextStyle() {
    return const TextStyle(
      color: Colors.black54,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }
}