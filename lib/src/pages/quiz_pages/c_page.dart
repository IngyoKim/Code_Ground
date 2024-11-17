import 'package:flutter/material.dart';

class CPage extends StatelessWidget {
  const CPage({
    super.key,
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
                // 버튼을 누르면 다른 행동을 수행
                Navigator.pop(context);
                // 여기에 경험치 증가 기능을 추가할 수 있습니다.
              },
              child: const Text('Test'),
            ),
            ElevatedButton(
              onPressed: () {
                // 버튼을 누르면 치트 레벨 설정 기능을 수행
                Navigator.pop(context);
                // 여기에 치트 레벨 설정 기능을 추가할 수 있습니다.
              },
              child: const Text('Cheat'),
            ),
          ],
        ),
      ),
    );
  }
}
