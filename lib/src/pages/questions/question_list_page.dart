import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/questions/question_detail_page.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/utils/question_list_utils.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final ScrollController _scrollController = ScrollController();
  final QuestionListUtils _listUtils = QuestionListUtils();

  @override
  void initState() {
    super.initState();

    // 초기 데이터 로드
    final selectedCategory =
        Provider.of<CategoryViewModel>(context, listen: false).selectedCategory;
    _loadQuestions(selectedCategory);

    // 스크롤 이벤트 추가
    _scrollController.addListener(() {
      final questionViewModel =
          Provider.of<QuestionViewModel>(context, listen: false);
      final categoryQuestions =
          questionViewModel.categoryQuestions[selectedCategory] ?? [];

      _listUtils.handleScroll(
        scrollController: _scrollController,
        fetchNextPage: () => _loadQuestions(selectedCategory),
        isLoading: categoryQuestions.isEmpty,
      );
    });
  }

  Future<void> _loadQuestions(String category) async {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    await questionViewModel.fetchQuestionsByCategory(category);
    setState(() => _listUtils.nextPage());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = context.watch<QuestionViewModel>();
    final selectedCategory =
        Provider.of<CategoryViewModel>(context).selectedCategory;
    final categoryQuestions =
        questionViewModel.categoryQuestions[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: Colors.black,
      ),
      body: categoryQuestions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: categoryQuestions.length,
              itemBuilder: (context, index) {
                final question = categoryQuestions[index];

                // Sequencing 카테고리의 answer 처리
                final hasAnswer = (question.answer.isNotEmpty);

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      // 선택한 질문 설정
                      questionViewModel.setSelectedQuestion(question);

                      // 질문 상세 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionDetailPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                'Category: ${question.category}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Difficulty: ${question.tier}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            question.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          if (question.category == 'Sequencing' && !hasAnswer)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Answer not provided for Sequencing question.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
