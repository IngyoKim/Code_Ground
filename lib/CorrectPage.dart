import 'package:flutter/material.dart';

class CorrectPage extends StatelessWidget {
  const CorrectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1초 후에 이전 페이지로 돌아가는 코드
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context); // 이전 페이지로 돌아가기
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 수평 중앙 정렬
          children: [
            Icon(
              Icons.check_circle, // 동그라미 체크 아이콘
              color: Colors.green, // 녹색으로 설정
              size: 100.0, // 아이콘 크기 설정
            ),
            SizedBox(height: 20), // 아이콘과 텍스트 사이의 여백
            Text(
              '정답입니다!', // 텍스트 내용
              style: TextStyle(
                fontSize: 24.0, // 텍스트 크기
                fontWeight: FontWeight.bold, // 텍스트 굵게
                color: Colors.green, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }
}
