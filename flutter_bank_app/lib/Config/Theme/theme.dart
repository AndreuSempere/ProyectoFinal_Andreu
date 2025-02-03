import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFEEF1F8),
  primarySwatch: Colors.blue,
  fontFamily: "Intel",
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    errorStyle: const TextStyle(height: 0),
    border: defaultInputBorder,
    enabledBorder: defaultInputBorder,
    focusedBorder: defaultInputBorder,
    errorBorder: defaultInputBorder,
  ),
);

const OutlineInputBorder defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
