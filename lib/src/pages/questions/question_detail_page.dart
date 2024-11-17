import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'dart:math'; // 랜덤 기능을 사용하기 위해 import
import 'package:code_ground/src/pages/correct_page.dart'; // CorrectPage import
import 'package:code_ground/src/pages/wrong_page.dart'; // WrongPage import

//해결 과제: 어떤 문제든 같은 페이지가 뜸. 따라서 이름어 따라 다른 페이지가 뜨도록 하기
//출력 문제에서 언어에 따라 하나만 보이게 할거 아님 다 보이게 할거??

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  // late List<String> boxNames;

  // @override
  // void initState() {
  //   super.initState();

  //   // 박스 이름을 초기화하고 섞기
  //   boxNames = [
  //     'printf',
  //     '2번',
  //     '3번',
  //     '4번',
  //   ];

  //   boxNames.shuffle(Random()); // 랜덤으로 섞기
  // }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      //질문이 없을 떄.
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
          backgroundColor: Colors.black,
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    // 코드 스니펫들
    final codeSnippets = question.codeSnippets.entries;

    return Scaffold(
      appBar: AppBar(
        title: Text(question.title),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), //위치 설정
        child: ListView(
          children: [
            // Title
            Text(
              question.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), //문제 이름
            const SizedBox(height: 16),

            // 문제 내용(설명)
            Text(
              question.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 언어(예-파이썬, 자바 등등)
            Text(
              'Languages: ${question.languages.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Code Snippets Section
            if (question.codeSnippets.isNotEmpty)
              const Text(
                'Code Snippets:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            const SizedBox(height: 8),

            if (question.codeSnippets.isNotEmpty)
              ...question.codeSnippets.entries.map(
                (entry) {
                  final language = entry.key;
                  final code = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                code, // codeSnippets 부분
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // build() 안에서 변수 초기화
                  List<String> boxNames = [
                    'printf',
                    '2번',
                    '3번',
                    '4번',
                  ];

                  // boxNames를 랜덤하게 섞기 (상태 변경)
                  boxNames.shuffle(Random());
                },
              ),

            // 여기에 30px 높이의 상자 4개를 추가
            const SizedBox(height: 20), // 20px 간격 추가
            ...List.generate(boxNames.length, (index) {
              return GestureDetector(
                onTap: () {
                  // 박스 클릭 시 텍스트가 code와 일치하는지 확인
                  final selectedBox = boxNames[index];
                  bool isCorrect = false;

                  for (var entry in codeSnippets) {
                    if (selectedBox.contains(entry.value)) {
                      isCorrect = true;
                      break;
                    }
                  }

                  // 정답 여부에 따른 페이지 이동
                  if (isCorrect) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CorrectPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WrongPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade700, // 원하는 색상으로 설정
                    borderRadius: BorderRadius.circular(10), // 곡률을 10으로 설정
                  ),
                  child: Center(
                    child: Text(
                      boxNames[index], // 각 상자의 텍스트
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
