import 'package:flutter/material.dart';
import 'math_page.dart';

class SecondPage extends StatelessWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onCheat;

  const SecondPage({
    super.key,
    required this.onCorrectAnswer,
    required this.onCheat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quiz Selection'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            // Math Quiz Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathPage(
                      onCorrectAnswer: onCorrectAnswer,
                      onCheat: onCheat,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.center, // 가로 가운데 정렬
                children: [
                  Icon(Icons.calculate, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Math Quiz',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // English Quiz Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for English Quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'English Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Coding Quiz Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for Coding Quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.code, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Coding Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // UpDown Game Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for UpDown Game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.swap_vert, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Up&Down Game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
