import 'package:flutter/material.dart';

class QuestionStatePage extends StatelessWidget {
  const QuestionStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question State Page'),
      ),
      body: const Center(
        child: Text(
          'This is an empty page',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
