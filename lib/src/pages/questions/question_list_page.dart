import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/questions/question_detail_page.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/utils/question_list_utils.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final QuestionListUtils _listUtils = QuestionListUtils();
  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      _listUtils.handleScroll(
        scrollController: _scrollController,
        fetchNextPage: () {
          final selectedCategory =
              Provider.of<CategoryViewModel>(context, listen: false)
                  .selectedCategory;
          Provider.of<QuestionViewModel>(context, listen: false)
              .fetchQuestions(selectedCategory);
        },
        isLoading:
            Provider.of<QuestionViewModel>(context, listen: false).isLoading,
      );
    });
  @override
  void initState() {
    super.initState();

    debugPrint('QuestionListPage initialized.');

    Future.microtask(() {
      final selectedCategory =
          // ignore: use_build_context_synchronously
          Provider.of<CategoryViewModel>(context, listen: false)
              .selectedCategory;

      debugPrint('Selected category: $selectedCategory');

      final questionViewModel =
          // ignore: use_build_context_synchronously
          Provider.of<QuestionViewModel>(context, listen: false);

      debugPrint('Fetching questions from initState.');
      questionViewModel.clearQuestions();
      questionViewModel.fetchQuestions(selectedCategory);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: questionViewModel.questions.length,
        itemBuilder: (context, index) {
          final question = questionViewModel.questions[index];
          final questionState =
              progressViewModel.progressData?.quizState[question.questionId];

          return _listUtils.buildQuestionTile(
            question: question,
            questionState: questionState,
            onTap: () {
              questionViewModel.selectQuestion(question);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionDetailPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
