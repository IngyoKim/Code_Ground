import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/utils/question_detail_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/pages/questions/edit_question_page.dart';

import 'package:code_ground/src/components/question_detail_widgets/contents/question_header.dart';
import 'package:code_ground/src/components/question_detail_widgets/contents/language_selector.dart';
import 'package:code_ground/src/components/question_detail_widgets/contents/code_snippet.dart';
import 'package:code_ground/src/components/question_detail_widgets/submit/subjective_submit.dart';
import 'package:code_ground/src/components/question_detail_widgets/submit/objective_submit.dart';
import 'package:code_ground/src/components/question_detail_widgets/submit/sequencing_submit.dart';
import 'package:code_ground/src/components/loading_indicator.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  final TextEditingController _answerController = TextEditingController();
  String? _selectedLanguage;
  String? _selectedAnswer;
  bool _isLoading = true;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetail();
  }

  /// 질문 상세 데이터 가져오기
  Future<void> _fetchQuestionDetail() async {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      setState(() => _isLoading = true);

      // 질문 데이터를 다시 가져오기
      await questionViewModel.fetchQuestionById(question.questionId);

      // 다른 사용자의 정보 가져오기
      await userViewModel.fetchOtherUserData(question.writer);

      // 언어 설정
      final updatedQuestion = questionViewModel.selectedQuestion;
      if (updatedQuestion?.codeSnippets.isNotEmpty == true) {
        setState(() {
          _selectedLanguage = updatedQuestion!.codeSnippets.keys.first;
        });
      }

      // 작성자인지 확인
      final currentUser = userViewModel.currentUserData;
      if (currentUser?.userId == question.writer) {
        setState(() {
          isEditable = true;
        });
      }
    } catch (e) {
      debugPrint('Error fetching question detail: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

    final userData = userViewModel.otherUserData;

    return Scaffold(
      appBar: AppBar(
        title: Text(question.title),
        actions: [
          if (isEditable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditQuestionPage(),
                  ),
                );
                await _fetchQuestionDetail(); // 돌아온 후 데이터 다시 가져오기
              },
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(isFetching: true)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  if (userData != null) questionHeader(question, userData),
                  if (question.category != 'Sequencing') ...[
                    if (question.codeSnippets.isNotEmpty)
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
                      answerList: question.answerList!,
                      selectedAnswer: _selectedAnswer,
                      onAnswerSelected: (answer) {
                        setState(() {
                          _selectedAnswer = answer;
                        });
                      },
                      onSubmit: () {
                        if (_selectedAnswer == null) {
                          ToastMessage.show('Please select an answer.');
                          return;
                        }
                        final isCorrect =
                            verifyAnswer(_selectedAnswer!, question);
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
