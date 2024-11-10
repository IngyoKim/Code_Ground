import 'package:flutter/material.dart';
import 'CorrectPage.dart';
import 'FalsePage.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0), // 위에서 20픽셀 여백
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    'Q. 이것은 무엇인가요?', // 질문 텍스트
                    style: TextStyle(
                      fontSize: 24.0, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵게
                    ),
                  ),
                ),
                SizedBox(height: 80), // 텍스트와 사각형 사이의 여백 20px
                // Stack 위젯 사용
                Stack(
                  alignment: Alignment.center, // Stack 안에서 자식들이 중앙에 배치되도록 설정
                  children: [
                    Container(
                      width: 400, // 사각형의 너비
                      height: 200, // 사각형의 높이
                      decoration: BoxDecoration(
                        color: Colors.blue, // 사각형 색상
                        borderRadius: BorderRadius.circular(10), // 모서리 곡률
                      ),
                    ),
                    Positioned(
                      child: Image.asset(
                        'asset/header.png',
                        width: 200,
                        height: 200, // 사이즈 조정하는 법 확인하기
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 150.0,
                  color: Colors.grey[850],
                  indent: 20.0,
                  thickness: 0.5,
                  endIndent: 20.0,
                ),
                // 첫 번째 회색 사각형 (a)
                InkWell(
                  onTap: () {
                    // 클릭 시 처리할 작업 (예: 알림, 페이지 이동 등)
                    print('a. 함수 클릭');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FalsePage(),
                        transitionDuration:
                            Duration(seconds: 0), // 애니메이션 없이 바로 전환
                      ),
                    );
                  },
                  child: Container(
                    width: 400, // 사각형의 너비
                    height: 50, // 사각형의 높이
                    decoration: BoxDecoration(
                      color: Colors.grey[400], // 사각형 색상
                      borderRadius: BorderRadius.circular(50), // 모서리 곡률
                    ),
                    child: Center(
                      child: Text(
                        'a. 함수',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // 텍스트 크기
                          fontWeight: FontWeight.bold, // 텍스트 굵게
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // 두 번째 회색 사각형 (b)
                InkWell(
                  onTap: () {
                    // 클릭 시 처리할 작업
                    print('b. 변수 클릭');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FalsePage(),
                        transitionDuration:
                            Duration(seconds: 0), // 애니메이션 없이 바로 전환
                      ),
                    );
                  },
                  child: Container(
                    width: 400, // 사각형의 너비
                    height: 50, // 사각형의 높이
                    decoration: BoxDecoration(
                      color: Colors.grey[400], // 사각형 색상
                      borderRadius: BorderRadius.circular(50), // 모서리 곡률
                    ),
                    child: Center(
                      child: Text(
                        'b. 변수',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // 텍스트 크기
                          fontWeight: FontWeight.bold, // 텍스트 굵게
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // 세 번째 회색 사각형 (c)
                InkWell(
                  onTap: () {
                    // 클릭 시 처리할 작업
                    print('c. 헤더파일 클릭');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CorrectPage(),
                        transitionDuration:
                            Duration(seconds: 0), // 애니메이션 없이 바로 전환
                      ),
                    );
                  },
                  child: Container(
                    width: 400, // 사각형의 너비
                    height: 50, // 사각형의 높이
                    decoration: BoxDecoration(
                      color: Colors.grey[400], // 사각형 색상
                      borderRadius: BorderRadius.circular(50), // 모서리 곡률
                    ),
                    child: Center(
                      child: Text(
                        'c. 헤더파일',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // 텍스트 크기
                          fontWeight: FontWeight.bold, // 텍스트 굵게
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // 네 번째 회색 사각형 (d)
                InkWell(
                  onTap: () {
                    // 클릭 시 처리할 작업
                    print('d. 구조체 클릭');
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FalsePage(),
                        transitionDuration:
                            Duration(seconds: 0), // 애니메이션 없이 바로 전환
                      ),
                    );
                  },
                  child: Container(
                    width: 400, // 사각형의 너비
                    height: 50, // 사각형의 높이
                    decoration: BoxDecoration(
                      color: Colors.grey[400], // 사각형 색상
                      borderRadius: BorderRadius.circular(50), // 모서리 곡률
                    ),
                    child: Center(
                      child: Text(
                        'd. 구조체',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // 텍스트 크기
                          fontWeight: FontWeight.bold, // 텍스트 굵게
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
