import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/utils/question_detail_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializePage();
    });
  }

  /// 페이지 초기화 로직
  Future<void> _initializePage() async {
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

      // 다른 사용자의 정보 가져오기
      await userViewModel.fetchOtherUserData(question.writer);

      // 언어 설정
      if (question.codeSnippets.isNotEmpty) {
        setState(() {
          _selectedLanguage = question.codeSnippets.keys.first;
        });
      }
    } catch (e) {
      debugPrint('Error initializing QuestionDetailPage: $e');
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
