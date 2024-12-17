import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/utils/permission_utils.dart';
import 'package:code_ground/src/pages/questions/question_detail/question_detail_utils.dart';
import 'package:code_ground/src/pages/questions/question_crud/edit_question_page.dart';

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/contents/question_header.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/contents/language_selector.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/contents/code_snippet.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/submit/subjective_submit.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/submit/objective_submit.dart';
import 'package:code_ground/src/pages/questions/question_detail/widgets/submit/sequencing_submit.dart';

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
  bool _hasEditPermission = false;
  UserData? _writer;

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

      await questionViewModel.fetchQuestionById(question.questionId);
      await userViewModel.fetchOtherUserData(question.writer);

      // 권한 확인
      final role = userViewModel.currentUserData?.role ?? '';
      final isOwner = userViewModel.currentUserData?.uid == question.writer;
      _hasEditPermission = RolePermissions.canPerformAction(role, 'edit_all') ||
          (RolePermissions.canPerformAction(role, 'edit_own') && isOwner);

      _writer = userViewModel.otherUserData;

      // 언어 초기화
      final updatedQuestion = questionViewModel.selectedQuestion;
      if (updatedQuestion?.codeSnippets.isNotEmpty == true) {
        _selectedLanguage = updatedQuestion!.codeSnippets.keys.first;
      }
    } catch (error) {
      debugPrint('Error fetching question detail: $error');
    } finally {
      setState(() => _isLoading = false);
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
    final progressViewModel = Provider.of<ProgressViewModel>(context);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    final state =
        progressViewModel.progressData?.questionState[question.questionId];

    return Scaffold(
      appBar: AppBar(
        title: Text(question.questionId),
        actions: [
          if (_hasEditPermission)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditQuestionPage()),
                );
                await _fetchQuestionDetail();
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
                  QuestionHeader(
                    question: question,
                    writer: _writer,
                  ),
                  const SizedBox(height: 20),
                  if (state == 'successed') ...[
                    codeSnippet(
                      MapEntry(
                        'Answer',
                        question.questionType != 'Sequencing'
                            ? question.answer ?? ''
                            : question.codeSnippets.values.join('\n'),
                      ),
                    )
                  ] else if (question.questionType == 'Sequencing') ...[
                    sequencingSubmit(
                      codeSnippets: question.codeSnippets,
                      onSubmit: (orderedKeys) {
                        final isCorrect = QuestionDetailUtil.verifyAnswer(
                            orderedKeys, question);
                        QuestionDetailUtil.showAnswerResult(context, isCorrect);
                      },
                    ),
                  ] else ...[
                    if (question.codeSnippets.isNotEmpty &&
                        _selectedLanguage != null) ...[
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
                      filteredCodeSnippets(
                        codeSnippets: question.codeSnippets,
                        selectedLanguage: _selectedLanguage!,
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    if (question.questionType == 'Subjective')
                      subjectiveSubmit(
                        context: context,
                        controller: _answerController,
                        onAnswerSubmitted: (answer) {
                          final isCorrect =
                              QuestionDetailUtil.verifyAnswer(answer, question);
                          QuestionDetailUtil.showAnswerResult(
                              context, isCorrect);
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
                          final isCorrect = QuestionDetailUtil.verifyAnswer(
                              _selectedAnswer!, question);
                          QuestionDetailUtil.showAnswerResult(
                              context, isCorrect);
                        },
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}
