import 'package:code_ground/src/utils/paging/paging_controller.dart';

class QuestionListUtil<T> {
  final List<T> _visibleItems = [];
  bool _isAdding = false;

  /// 현재 화면에 표시되는 질문
  List<T> get items => List.unmodifiable(_visibleItems);

  /// 질문을 하나씩 추가
  Future<void> addItemsGradually(
    List<T> newItems,
    void Function() refreshCallback,
  ) async {
    if (_isAdding) return;

    _isAdding = true;

    try {
      final List<T> itemsToAdd =
          newItems.where((item) => !_visibleItems.contains(item)).toList();
      for (var item in itemsToAdd) {
        _visibleItems.add(item);
        refreshCallback(); // UI 업데이트
        await Future.delayed(const Duration(milliseconds: 200)); // 애니메이션 효과
      }
    } finally {
      _isAdding = false;
    }
  }

  /// 리스트 초기화
  void reset() {
    _visibleItems.clear();
    _isAdding = false;
  }

  /// 페이징 상태 초기화
  void resetPagingState(PagingController<T> pagingController) {
    pagingController.reset();
    reset();
  }

  /// 다음 페이지 로드 및 아이템 추가
  Future<void> loadNextPageAndAddItems({
    required PagingController<T> pagingController,
    required void Function() refreshCallback,
  }) async {
    if (pagingController.isFetching) return;

    await pagingController.loadNextPage();
    await addItemsGradually(pagingController.items, refreshCallback);
  }
}
