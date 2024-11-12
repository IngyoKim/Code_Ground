import 'package:flutter/material.dart';

class CPage extends StatelessWidget {
  final Function(int) increaseEXP;
  final VoidCallback setCheatLevel;

  const CPage({
    super.key,
    required this.increaseEXP,
    required this.setCheatLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C Page'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'C',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // 간격 추가
            ElevatedButton(
              onPressed: () {
                // 버튼을 누르면 경험치가 50 증가
                Navigator.pop(context);
                increaseEXP(30);
              },
              child: const Text('Test'),
            ),
            ElevatedButton(
              onPressed: () {
                setCheatLevel(); // 버튼을 누르면 경험치가 50 증가
                Navigator.pop(context);
              },
              child: const Text('Cheat'),
            ),
          ],
        ),
      ),
    );
  }
}
