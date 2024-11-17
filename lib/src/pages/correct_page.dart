import 'package:flutter/material.dart';

class CorrectPage extends StatelessWidget {
  const CorrectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 후 GrammerPage로 돌아가도록 설정
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // GrammerPage로 돌아가기
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Correct Answer'),
      ),
      body: const Center(
        child: Text(
          '축하합니다! 정답입니다!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
