import 'package:code_ground/src/utils/paging/paging_controller.dart';

class RankingUtils<T> {
  final List<T> _visibleItems = [];
  bool _isAdding = false;

  /// 현재 화면에 표시되는 랭킹 데이터
  List<T> get items => List.unmodifiable(_visibleItems);

  /// 데이터를 점진적으로 추가
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
        refreshCallback(); // UI 갱신
        await Future.delayed(const Duration(milliseconds: 200)); // 애니메이션 효과
      }
    } finally {
      _isAdding = false;
    }
  }

  /// 데이터를 즉시 추가
  void addItems(List<T> newItems) {
    final List<T> itemsToAdd =
        newItems.where((item) => !_visibleItems.contains(item)).toList();
    _visibleItems.addAll(itemsToAdd);
  }

  /// 데이터 초기화
  void reset() {
    _visibleItems.clear();
    _isAdding = false;
  }

  /// 다음 페이지 데이터를 로드하고 추가
  Future<void> loadNextPageAndAddItems({
    required PagingController<T> pagingController,
    required void Function() refreshCallback,
    bool gradual = false, // 점진적 추가 여부
  }) async {
    if (pagingController.isFetching) return;

    await pagingController.loadNextPage();

    if (gradual) {
      await addItemsGradually(pagingController.items, refreshCallback);
    } else {
      addItems(pagingController.items);
      refreshCallback();
    }
  }
}
