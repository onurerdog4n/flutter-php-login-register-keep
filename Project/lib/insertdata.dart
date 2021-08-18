import 'package:flutter/material.dart';

class InsertData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Defaul Page',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Defaul Page'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
