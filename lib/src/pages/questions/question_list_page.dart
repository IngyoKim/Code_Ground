import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/scroll_handler.dart';
import 'package:code_ground/src/utils/paging_controller.dart';
import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/components/question_list_widget.dart';

import 'package:code_ground/src/pages/questions/question_detail_page.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late String _categoryName;
  late PagingController<QuestionData> _pagingController;
  final ScrollController _scrollController = ScrollController();
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() {
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);

    _categoryName = categoryViewModel.selectedCategory;

    Provider.of<QuestionViewModel>(context, listen: false)
        .resetCategoryState(_categoryName);

    _pagingController = PagingController<QuestionData>(
      fetchData: (page, pageSize) async {
        return await Provider.of<QuestionViewModel>(context, listen: false)
            .fetchQuestionsByCategoryPaged(
          category: _categoryName,
          page: page,
          pageSize: pageSize,
        );
      },
      pageSize: 10,
    );

    _resetPageState();
    _loadInitialData();

    _scrollController.addListener(() {
      if (_isInitialLoading) return;
      if (!_pagingController.isFetching && _pagingController.hasMoreData) {
        ScrollHandler.handleScroll<QuestionData>(
          scrollController: _scrollController,
          pagingController: _pagingController,
          onScrollEnd: () async {
            await _pagingController.loadNextPage();
            setState(() {});
          },
        );
      }
    });
  }

  /// 상태 초기화
  void _resetPageState({bool preserveItems = false}) {
    if (!preserveItems) {
      _pagingController.reset();
    }
    _isInitialLoading = true;
    setState(() {});
  }

  /// 초기 데이터 로드
  Future<void> _loadInitialData() async {
    await _pagingController.loadNextPage();
    setState(() => _isInitialLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Provider.of<QuestionViewModel>(context, listen: false).clearQuestions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _isInitialLoading || _pagingController.isFetching;

    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializePage,
          ),
        ],
      ),
      body: Consumer<ProgressViewModel>(
        builder: (context, progressViewModel, _) {
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _pagingController.items.length + 1,
            itemBuilder: (context, index) {
              if (index == _pagingController.items.length) {
                return LoadingIndicator(isFetching: isLoading);
              }

              final question = _pagingController.items[index];
              final questionState = progressViewModel
                  .progressData?.questionState[question.questionId];

              return QuestionListWidget(
                question: question,
                questionState: questionState,
                onTap: () {
                  Provider.of<QuestionViewModel>(context, listen: false)
                      .setSelectedQuestion(question);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionDetailPage(),
                    ),
                  ).then((_) {
                    _resetPageState(preserveItems: true);
                    _loadInitialData();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
