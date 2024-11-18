import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'dart:math';
import 'package:code_ground/src/pages/correct_page.dart';
import 'package:code_ground/src/pages/wrong_page.dart';

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

    final questionType = question.questionType;
    final codeSnippets = question.codeSnippets.entries;

    // boxNames를 초기화하고 정답을 추가
    List<MapEntry<String, String>> boxNames = [
      MapEntry('정답', question.answer ?? 'No Answer'),
    ];

    // answerChoices를 boxNames에 추가 (오답 항목)
    if (question.answerChoices?.isNotEmpty ?? false) {
      boxNames.addAll(List.generate(question.answerChoices!.length, (i) {
        return MapEntry('오답${i + 1}', question.answerChoices![i]);
      }));
    }

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
            // 제목, 설명, 언어 정보 표시
            _buildTitle(question),
            _buildDescription(question),
            _buildLanguages(question),

            // Code Snippets 표시
            if (question.codeSnippets.isNotEmpty) _buildCodeSnippets(question),

            const SizedBox(height: 20),

            // 문제 유형에 따른 상자 생성
            if (questionType != 'Objective') ...[
              _buildAnswerInputField(_answerController, question),
            ] else ...[
              _buildAnswerChoices(boxNames, codeSnippets),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(question) {
    return Text(
      question.title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          question.description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLanguages(question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Languages: ${question.languages.join(', ')}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCodeSnippets(question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Code Snippets:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...question.codeSnippets.entries.map(
          (entry) => _buildCodeSnippet(entry),
        ),
      ],
    );
  }

  Widget _buildCodeSnippet(MapEntry<String, String> entry) {
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
                entry.key,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  entry.value,
                  style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerInputField(TextEditingController controller, question) {
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
              const Text(
                'Write your Answer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your answer here...',
                  ),
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () =>
                      _checkAnswer(controller.text.trim(), question),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Enter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAnswer(String userAnswer, question) {
    bool isCorrect = userAnswer == question.answer;

    if (isCorrect) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CorrectPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WrongPage()),
      );
    }
  }

  Widget _buildAnswerChoices(List<MapEntry<String, String>> boxNames,
      Iterable<MapEntry<String, String>> codeSnippets) {
    return Column(
      children: boxNames.map((selectedBox) {
        return GestureDetector(
          onTap: () => _handleAnswerChoice(selectedBox, codeSnippets),
          child: _buildAnswerChoiceBox(selectedBox),
        );
      }).toList(),
    );
  }

  void _handleAnswerChoice(MapEntry<String, String> selectedBox,
      Iterable<MapEntry<String, String>> codeSnippets) {
    bool isCorrect =
        codeSnippets.any((entry) => entry.value == selectedBox.value);

    if (isCorrect) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CorrectPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WrongPage()),
      );
    }
  }

  Widget _buildAnswerChoiceBox(MapEntry<String, String> selectedBox) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          selectedBox.key == '정답' ? selectedBox.value : selectedBox.key,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
