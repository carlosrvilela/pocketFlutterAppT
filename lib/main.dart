import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'http/web_cliente.dart';
import 'models/contact.dart';

void main() {
  runApp(const BytebankApp());
  //save(Transaction(100.0, Contact(0, 'Ciclano', 8000))).then((transaction) => print('save transactions: $transaction'));
  //findAll().then((transactions) => print('new transectios: $transactions'));
}

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.green[800], secondary: Colors.blueAccent[700]),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
    );
  }
}
