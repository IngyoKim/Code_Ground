import 'package:flutter/material.dart';
import 'dart:math';

class MathPage extends StatefulWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onCheat;

  const MathPage(
      {super.key, required this.onCorrectAnswer, required this.onCheat});

  @override
  _MathPageState createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  final Random _random = Random();
  late int a;
  late int b;
  final TextEditingController _controller = TextEditingController();
  String message = '';

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      a = _random.nextInt(100) + 1;
      b = _random.nextInt(100) + 1;
      message = '';
      _controller.clear();
    });
  }

  void _checkAnswer() async {
    int answer = int.tryParse(_controller.text) ?? 0;
    if (answer == -1) {
      widget.onCheat();
      setState(() {
        message = 'Chaet';
      });
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    } else if (answer == a + b) {
      widget.onCorrectAnswer();
      setState(() {
        message = 'Correct!';
      });
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    } else {
      setState(() {
        message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Quiz'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What is $a + $b?',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your answer',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
