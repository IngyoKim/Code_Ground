import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<QuestionViewModel>(context, listen: false)
          .fetchQuestions(),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<QuestionViewModel>(context, listen: false)
          .fetchQuestions(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    final questionViewModel = Provider.of<QuestionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question List'),
        backgroundColor: Colors.black,
      ),
      body: questionViewModel.isLoading && questionViewModel.questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: questionViewModel.questions.length +
                  (questionViewModel.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < questionViewModel.questions.length) {
                  final question = questionViewModel.questions[index];
                  return ListTile(
                    title: Text(question.title),
                    subtitle: Text(question.description),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
