import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

import 'package:code_ground/src/components/question_detail_widget/question_header.dart';
import 'package:code_ground/src/components/question_detail_widget/language_selector.dart';
import 'package:code_ground/src/components/question_detail_widget/code_snippet.dart';
import 'package:code_ground/src/components/question_detail_widget/subjective_answer.dart';
import 'package:code_ground/src/components/question_detail_widget/objective_answer.dart';
import 'package:code_ground/src/components/question_detail_widget/sequencing_answer.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  String? _selectedLanguage;
  String? _selectedAnswer;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 사용자 데이터 fetch를 한 번만 호출
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final questionViewModel =
          Provider.of<QuestionViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final question = questionViewModel.selectedQuestion;

      if (question != null) {
        await userViewModel.fetchUserData(uid: question.writer);
        if (mounted) {
          setState(() {
            _selectedLanguage ??= question.codeSnippets.keys.first;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(question.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 제목 및 설명
            if (userViewModel.userData != null)
              questionHeader(question, userViewModel.userData!),
            // 언어 선택 및 코드 스니펫 표시
            if (question.category != 'Sequencing') ...[
              languageSelector(
                languages: question.codeSnippets.keys.toList(),
                selectedLanguage: _selectedLanguage!,
                onLanguageSelected: (language) {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedLanguage != null)
                buildFilteredCodeSnippets(
                  codeSnippets: question.codeSnippets,
                  selectedLanguage: _selectedLanguage!,
                ),
            ],
            const SizedBox(height: 20),
            // 답 입력 위젯
            if (question.questionType == 'Subjective')
              buildSubjectiveAnswerInput(
                context: context,
                controller: _answerController,
                onAnswerSubmitted: (answer) {
                  final isCorrect = verifyAnswer(answer, question);
                  showAnswerResult(context, isCorrect);
                },
              )
            else if (question.questionType == 'Objective')
              buildObjectiveAnswerInput(
                context: context,
                answerChoices: question.answerChoices ?? [],
                selectedAnswer: _selectedAnswer,
                onAnswerSelected: (answer) {
                  setState(() {
                    _selectedAnswer = answer;
                  });
                },
                onSubmit: () {
                  if (_selectedAnswer == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an answer.')),
                    );
                    return;
                  }
                  final isCorrect = verifyAnswer(_selectedAnswer!, question);
                  showAnswerResult(context, isCorrect);
                },
              )
            else if (question.questionType == 'Sequencing')
              buildSequencingAnswerInput(
                codeSnippets: question.codeSnippets,
                onSubmit: (orderedKeys) {
                  final isCorrect = verifyAnswer(orderedKeys, question);
                  showAnswerResult(context, isCorrect);
                },
              ),
          ],
        ),
      ),
    );
  }

  bool verifyAnswer(dynamic userAnswer, QuestionData question) {
    if (question.questionType != 'Sequencing') {
      return userAnswer.toString().trim() == question.answer.toString().trim();
    }
    // Sequencing의 경우 배열 비교
    final userAnswerList = userAnswer as List<int>;
    final correctAnswerList =
        question.codeSnippets.keys.map((key) => int.parse(key)).toList();
    return ListEquality().equals(userAnswerList, correctAnswerList);
  }

  void showAnswerResult(BuildContext context, bool isCorrect) {
    Fluttertoast.showToast(
      msg: isCorrect ? "Correct!" : "Wrong! Try Again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }
}
