import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';

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

    Future.microtask(() {
      final selectedCategory =
          Provider.of<CategoryViewModel>(context, listen: false)
              .selectedCategory;

      final questionViewModel =
          Provider.of<QuestionViewModel>(context, listen: false);

      questionViewModel.clearQuestions();
      questionViewModel.fetchQuestions(selectedCategory);
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !questionViewModel.isLoading) {
      final selectedCategory =
          Provider.of<CategoryViewModel>(context, listen: false)
              .selectedCategory;
      questionViewModel.fetchQuestions(selectedCategory);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryViewModel.selectedCategory,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.black,
      ),
      body: questionViewModel.isLoading && questionViewModel.questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : questionViewModel.questions.isEmpty
              ? const Center(
                  child: Text(
                    'No questions found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: questionViewModel.questions.length +
                      (questionViewModel.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < questionViewModel.questions.length) {
                      final question = questionViewModel.questions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
    );
  }
}
