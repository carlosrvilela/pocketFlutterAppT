import 'package:flutter/material.dart';

final bytebankTheme = ThemeData(
  primaryColor: Colors.green[900],
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: Colors.green[800], secondary: Colors.blueAccent[700]),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueAccent[700],
    textTheme: ButtonTextTheme.primary,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.green[800],
    actionTextColor: Colors.white,
  ),
);
