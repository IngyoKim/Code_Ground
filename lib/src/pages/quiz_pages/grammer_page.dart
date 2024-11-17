import 'dart:math';
import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/correct_page.dart';
import 'package:code_ground/src/pages/wrong_page.dart'; // WrongPage 임포트

class Grammer extends StatefulWidget {
  const Grammer({super.key});

  @override
  _GrammerState createState() => _GrammerState();
}

class _GrammerState extends State<Grammer> {
  int correctBox = -1; // 초기값은 -1로 설정 (클릭 전에는 선택된 박스 없음)
  final random = Random();
  List<String> boxNames = ['박스 1', '박스 2', '박스 3', '박스 4']; // 박스 이름 리스트

  // 랜덤 번호를 한 번만 지정하는 함수 (문제 생성 시)
  void generateRandomBox() {
    setState(() {
      correctBox = random.nextInt(4); // 0, 1, 2, 3 중 랜덤 번호 선택
      // 박스 이름을 초기화
      boxNames = ['박스 1', '박스 2', '박스 3', '박스 4'];
    });
  }

  void navigateToCorrectPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CorrectPage()),
    );
  }

  void navigateToWrongPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const WrongPage()), // WrongPage로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    // 문제를 한 번만 생성하도록 수정
    if (correctBox == -1) {
      generateRandomBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammer'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            // 첫 번째 큰 박스
            Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '문제 나올 부분',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 200.0,
              color: Colors.grey,
              thickness: 0.5,
              endIndent: 20.0,
            ),
            // ListView.builder로 4개의 작은 박스를 만들기
            Expanded(
              child: ListView.builder(
                itemCount: 4, // 아이템 개수
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: GestureDetector(
                      onTap: () {
                        // 클릭 시에는 랜덤 번호를 새로 지정하지 않음
                        if (index == correctBox) {
                          print('Correct'); // 선택된 랜덤 번호의 박스에만 'Correct' 출력
                          // 박스 이름을 '정답!'으로 변경
                          setState(() {
                            boxNames[index] = '정답!'; // 클릭된 박스를 정답으로 표시
                          });
                          // 정답을 맞췄을 때 CorrectPage로 이동
                          navigateToCorrectPage();
                        } else {
                          print('Wrong'); // 나머지 박스에는 'Wrong' 출력
                          // Wrong 신호를 받았을 때 WrongPage로 이동
                          navigateToWrongPage();
                        }
                      },
                      child: Container(
                        width: double.infinity, // 좌우 길이는 전체 화면 크기
                        height: 30.0, // 높이는 30으로 설정
                        decoration: BoxDecoration(
                          color: index == correctBox // 정답인 박스는 색상 변경
                              ? Colors.green // 정답은 초록색
                              : Colors.orange, // 나머지는 주황색
                          borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            index == correctBox
                                ? '정답!' // 정답인 박스는 '정답!'으로 표시
                                : boxNames[index], // 나머지 박스 이름 그대로 표시
                            style: const TextStyle(
                              color: Colors.white, // 텍스트 색상
                              fontSize: 14.0, // 텍스트 크기
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//score, 난이도 가져오기, 푼사람 계정 보내기.
