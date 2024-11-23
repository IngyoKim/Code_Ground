import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/components/question_list_widget.dart';
import 'package:code_ground/src/pages/questions/question_detail_page.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late String _selectedCategory;
  late QuestionViewModel _questionViewModel;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        Provider.of<CategoryViewModel>(context, listen: false).selectedCategory;
    _questionViewModel = Provider.of<QuestionViewModel>(context, listen: false);

    // 빌드 완료 후 질문 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _questionViewModel.clearQuestions();
      _loadQuestions();
    });
  }

  Future<void> _loadQuestions() async {
    await _questionViewModel.fetchQuestionsByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: Colors.black,
      ),
      body: Consumer<QuestionViewModel>(
        builder: (context, viewModel, child) {
          final categoryQuestions =
              viewModel.categoryQuestions[_selectedCategory] ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: categoryQuestions.length + 1, // 로딩 인디케이터 포함
            itemBuilder: (context, index) {
              if (index == categoryQuestions.length) {
                // 마지막에 로딩 표시
                return LoadingIndicator(isFetching: viewModel.isFetching);
              }

              final question = categoryQuestions[index];
              return QuestionListWidget(
                question: question,
                questionState: null, // 상태는 null로 설정 (확장 가능)
                onTap: () {
                  viewModel.setSelectedQuestion(question);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionDetailPage(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
