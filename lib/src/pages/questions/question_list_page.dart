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
  late String _selectedCategory;
  late PagingController<QuestionData> _pagingController;
  late QuestionListUtil<QuestionData> _listUtil;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  /// 페이지 초기화
  void _initializePage() {
    _selectedCategory =
        Provider.of<CategoryViewModel>(context, listen: false).selectedCategory;

    // ViewModel 초기화
    Provider.of<QuestionViewModel>(context, listen: false)
        .resetCategoryState(_selectedCategory);

    _pagingController = PagingController<QuestionData>(
      fetchData: (page, pageSize) async {
        return await Provider.of<QuestionViewModel>(context, listen: false)
            .fetchQuestionsByCategoryPaged(
          category: _selectedCategory,
          page: page,
          pageSize: pageSize,
        );
      },
      pageSize: 10,
    );

    _listUtil = QuestionListUtil<QuestionData>();
    _resetPageState();
    _loadNextPage();

    _scrollController.addListener(() {
      ScrollHandler.handleScroll<QuestionData>(
        scrollController: _scrollController,
        pagingController: _pagingController,
        onScrollEnd: _loadNextPage,
      );
    });
  }

  /// 상태 초기화
  void _resetPageState() {
    _pagingController.reset(); // PagingController 상태 초기화
    _listUtil.reset(); // 화면 데이터 초기화
    setState(() {});
  }

  /// 다음 페이지 로드 및 질문 하나씩 추가
  Future<void> _loadNextPage() async {
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

  /// 페이지를 나갈 때 상태 초기화
  @override
  void dispose() {
    _scrollController.dispose();

    // ViewModel 상태 초기화
    final viewModel = Provider.of<QuestionViewModel>(context, listen: false);
    viewModel.clearQuestions();
    viewModel.resetCategoryState(_selectedCategory);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _listUtil.items.length + 1,
        itemBuilder: (context, index) {
          if (index == _listUtil.items.length) {
            return LoadingIndicator(isFetching: _pagingController.isFetching);
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
