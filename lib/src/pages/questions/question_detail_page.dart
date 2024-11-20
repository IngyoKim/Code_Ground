import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/question_detail_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/question_detail_widget/question_header.dart';
import 'package:code_ground/src/components/question_detail_widget/language_selector.dart';
import 'package:code_ground/src/components/question_detail_widget/code_snippet.dart';
import 'package:code_ground/src/components/question_detail_widget/subjective_submit.dart';
import 'package:code_ground/src/components/question_detail_widget/objective_submit.dart';
import 'package:code_ground/src/components/question_detail_widget/sequencing_submit.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  final TextEditingController _answerController = TextEditingController();
  String? _selectedLanguage;
  String? _selectedAnswer;
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final questionViewModel =
          Provider.of<QuestionViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final question = questionViewModel.selectedQuestion;

      if (question != null) {
        try {
          // 로딩 시작
          setState(() {
            _isLoading = true;
          });

          // 데이터 로드
          _selectedLanguage = question.codeSnippets.keys.isNotEmpty
              ? question.codeSnippets.keys.first
              : null; // 코드 스니펫의 첫 번째 언어로 초기화
          await userViewModel.fetchUserData(uid: question.writer);
        } finally {
          // 로딩 종료
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
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

    // 로딩 중인 경우 로딩 화면 표시
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 질문 데이터가 없는 경우
    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    // 질문 데이터가 준비된 경우
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
                filterdCodeSnippets(
                  codeSnippets: question.codeSnippets,
                  selectedLanguage: _selectedLanguage!,
                ),
            ],
            const SizedBox(height: 20),
            // 답 입력 위젯
            if (question.questionType == 'Subjective')
              subjectiveSubmit(
                context: context,
                controller: _answerController,
                onAnswerSubmitted: (answer) {
                  final isCorrect = verifyAnswer(answer, question);
                  showAnswerResult(context, isCorrect);
                },
              )
            else if (question.questionType == 'Objective')
              objectiveSubmit(
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
              sequencingSubmit(
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
}
