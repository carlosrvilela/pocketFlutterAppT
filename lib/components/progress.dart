import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String message;

  const Progress({Key? key, this.message = 'Loading'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  // String message;
  //
  // ProgressView({Key? key, String message = 'Sending...'}) : super(key: key){
  //  this.message = message;
  // }
  final String message;

  const ProgressView(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing'),
      ),
      body: Progress(
        message: message,
      ),
    );
  }
}
