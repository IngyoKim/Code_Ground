import 'package:flutter/material.dart';

class WrongPage extends StatelessWidget {
  const WrongPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 후 GrammerPage로 돌아가도록 설정
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // GrammerPage로 돌아가기
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrong Answer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Wrong! Try Again!',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
