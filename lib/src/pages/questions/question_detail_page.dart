import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'dart:math'; // 랜덤 기능을 사용하기 위해 import
import 'package:code_ground/src/pages/correct_page.dart'; // CorrectPage import
import 'package:code_ground/src/pages/wrong_page.dart'; // WrongPage import

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final question = questionViewModel.selectedQuestion;
    final TextEditingController _answerController = TextEditingController();

    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
          backgroundColor: Colors.black,
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    final questiontype = question.questionType;

    // 문제 내용 및 코드 스니펫들
    final codeSnippets = question.codeSnippets.entries;

    // boxNames를 language와 code 쌍으로 초기화
    List<MapEntry<String, String>> boxNames = [];

    // 코드 스니펫을 boxNames 리스트에 추가
    for (var entry in codeSnippets) {
      boxNames.add(MapEntry('정답', entry.value)); // language와 code를 하나의 항목으로 추가
    }

    boxNames.add(MapEntry('오답1', 'Custom Value 1'));
    boxNames.add(MapEntry('오답2', 'Custom Value 2'));
    boxNames.add(MapEntry('오답3', 'Print Sample Code'));

    // boxNames를 랜덤하게 섞기
    boxNames.shuffle(Random());

    return Scaffold(
      appBar: AppBar(
        title: Text(question.title),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            Text(
              question.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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

            // 코드 스니펫이 있을 때만 보여주기
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
                                code,
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
                },
              ),

            const SizedBox(height: 20),
            // 각 상자를 생성
            if (questiontype != 'Objective') ...[
              const SizedBox(height: 20), // 상단 여백
              Padding(
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
                          'Write your Answer',
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
                          child: TextField(
                            controller: _answerController,
                            decoration: const InputDecoration(
                              border: InputBorder.none, // 상자 안의 기본 경계선 없애기
                              hintText:
                                  'Enter your answer here...', // 텍스트 필드의 힌트 텍스트
                            ),
                            maxLines: 5, // 여러 줄을 입력할 수 있게 설정
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // 버튼과 텍스트 필드 사이 여백
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // 사용자가 입력한 답을 가져와 비교
                              bool isCorrect = false;
                              String userAnswer = _answerController.text.trim();
                              setState(() {
                                isCorrect = userAnswer == codeSnippets;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white, // 텍스트 색상
                            ),
                            child: const Text('Enter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ] else ...[
              const SizedBox(height: 20),
              // 각 상자를 생성
              ...List.generate(boxNames.length, (index) {
                final selectedBox = boxNames[index];
                String boxText = selectedBox.key;

                // "printf"인 경우 code 값을 넣기
                if (selectedBox.key == '정답') {
                  boxText = selectedBox.value;
                }

                return GestureDetector(
                  onTap: () {
                    bool isCorrect = false;

                    // selectedBox는 MapEntry 형태로 (language, code) 값을 포함하고 있음
                    final selectedLanguage = selectedBox.key;
                    final selectedCode = selectedBox.value;

                    // codeSnippets와 비교해서 일치하는지 확인
                    for (var entry in codeSnippets) {
                      final language = entry.key;
                      final code = entry.value;

                      if (selectedCode == code) {
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
                      color: Colors.blueGrey.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        boxText, // 수정된 boxText를 표시
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
