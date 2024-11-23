import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/components/question_list_widget.dart';
import 'package:code_ground/src/pages/questions/question_detail_page.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/utils/paging_controller.dart';
import 'package:code_ground/src/utils/question_list_utils.dart';
import 'package:code_ground/src/utils/scroll_handler.dart';
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
  late String _categoryName;
  late PagingController<QuestionData> _pagingController;
  late QuestionListUtil<QuestionData> _listUtil;
  final ScrollController _scrollController = ScrollController();

  bool _isInitialLoading = true; // 초기 로딩 상태

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  /// 페이지 초기화
  void _initializePage() {
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);

    _categoryName = categoryViewModel.selectedCategory; // 카테고리 이름 설정

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

    _listUtil = QuestionListUtil<QuestionData>();
    _resetPageState();
    _loadInitialData();

    _scrollController.addListener(() {
      if (_isInitialLoading) return; // 초기 로딩 중일 때 추가 fetch 차단
      if (!_pagingController.isFetching && _pagingController.hasMoreData) {
        ScrollHandler.handleScroll<QuestionData>(
          scrollController: _scrollController,
          pagingController: _pagingController,
          onScrollEnd: _loadNextPage,
        );
      }
    });
  }

  /// 상태 초기화
  void _resetPageState() {
    _pagingController.reset();
    _listUtil.reset();
    _isInitialLoading = true; // 초기 로딩 상태 설정
    setState(() {});
  }

  /// 초기 데이터 로드
  Future<void> _loadInitialData() async {
    await _loadNextPage();
    if (mounted) {
      setState(() {
        _isInitialLoading = false; // 초기 로딩 완료
      });
    }
  }

  /// 다음 페이지 로드 및 질문 추가
  Future<void> _loadNextPage() async {
    if (_pagingController.isFetching) return;

    await _pagingController.loadNextPage();

    if (mounted) {
      await _listUtil.addItemsGradually(
        _pagingController.items,
        () {
          if (mounted) setState(() {});
        },
      );
    }
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
        title: Text(_categoryName), // 카테고리 이름 표시
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _listUtil.items.length + 1,
        itemBuilder: (context, index) {
          if (index == _listUtil.items.length) {
            return LoadingIndicator(isFetching: isLoading);
          }

          final question = _listUtil.items[index];
          return QuestionListWidget(
            question: question,
            questionState: null,
            onTap: () {
              Provider.of<QuestionViewModel>(context, listen: false)
                  .setSelectedQuestion(question);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionDetailPage(),
                ),
              ).then((_) {
                _resetPageState();
                _loadNextPage();
              });
            },
          );
        },
      ),
    );
  }
}
