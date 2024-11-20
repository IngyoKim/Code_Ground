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
  bool _isUserDataFetched = false; // 데이터 fetch 상태

  @override
  void initState() {
    super.initState();

    // 사용자 데이터 fetch를 한 번만 호출
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final questionViewModel =
          Provider.of<QuestionViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final question = questionViewModel.selectedQuestion;

      if (question != null && !_isUserDataFetched) {
        _selectedLanguage = question.codeSnippets.keys.isNotEmpty
            ? question.codeSnippets.keys.first
            : null; // 코드 스니펫의 첫 번째 언어로 초기화
        await userViewModel.fetchUserData(uid: question.writer);
        if (mounted) {
          setState(() {
            _isUserDataFetched = true;
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
            // 제목, 설명, 언어 정보 표시
            _buildTitle(question),
            _buildDescription(question),
            _buildLanguages(question),

            // Code Snippets 표시
            if (question.codeSnippets.isNotEmpty)
              _buildFilteredCodeSnippets(question, question.languages),
            const SizedBox(height: 20),

            // 문제 유형에 따른 상자 생성
            if (question.questionType != 'Objective') ...[
              _buildAnswerInputField(answerController, question),
            ] else ...[
              _buildAnswerChoices(boxNames, question.codeSnippets.entries),
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
