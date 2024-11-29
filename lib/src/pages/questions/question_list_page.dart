import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/components/question_list_widget.dart';
import 'package:code_ground/src/pages/questions/question_detail_page.dart';

import 'package:code_ground/src/utils/question_list_utils.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late String _categoryName;
  final ScrollController _scrollController = ScrollController();
  final QuestionListUtil _questionListUtil = QuestionListUtil();
  bool _isInitialLoading = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _initializePage();
    _scrollController.addListener(_onScroll);
  }

  /// 초기 페이지 세팅
  /// 초기 페이지 세팅
  Future<void> _initializePage() async {
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);

    _categoryName = categoryViewModel.selectedCategory;

    setState(() {
      _isInitialLoading = true;
    });

    _questionListUtil.reset();

    // fetchQuestions를 build 완료 후 호출
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await questionViewModel.fetchQuestions(category: _categoryName);

      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }

      // 하나씩 로드 시작
      await _questionListUtil.addItemsGradually(
        questionViewModel.categoryQuestions[_categoryName] ?? [],
        () {
          if (mounted) {
            setState(() {}); // UI 업데이트
          }
        },
      );
    });
  }

  /// 스크롤 이벤트 핸들러
  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      await _fetchMoreData();
    }
  }

  /// 추가 데이터 로드
  Future<void> _fetchMoreData() async {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);

    if (!questionViewModel.hasMoreData || questionViewModel.isFetching) return;

    setState(() {
      _isFetchingMore = true;
    });

    await questionViewModel.fetchQuestions(category: _categoryName);

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
      });
    }

    // 추가 데이터 하나씩 로드
    await _questionListUtil.addItemsGradually(
      questionViewModel.categoryQuestions[_categoryName] ?? [],
      () {
        if (mounted) {
          setState(() {}); // UI 업데이트
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questionListUtil.items;

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
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: questions.length + 1,
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  return LoadingIndicator(isFetching: _isFetchingMore);
                }

                final question = questions[index];
                return QuestionListWidget(
                  question: question,
                  onTap: () {
                    final questionViewModel =
                        Provider.of<QuestionViewModel>(context, listen: false);
                    questionViewModel.setSelectedQuestion(question);
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
