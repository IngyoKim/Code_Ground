import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final int level;
  final int currentExp;
  final int points;
  final String levelLabel;
  final int maxExp;

  const MainPage({
    super.key,
    required this.level,
    required this.currentExp,
    required this.points,
    required this.levelLabel,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Main Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                'Point: $points',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/${levelLabel.toLowerCase()}.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 10),
                Text(
                  'Lv.$level $levelLabel',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: 0,
                          end: currentExp / maxExp,
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.grey[300],
                            color: Colors.black,
                            minHeight: 10,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$currentExp / $maxExp',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
