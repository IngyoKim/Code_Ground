import 'package:flutter/material.dart';

class PagingController<T> {
  int _currentPage = 0;
  final int pageSize;
  final List<T> _items = [];
  bool _isFetching = false;
  bool _hasMoreData = true;

  final Future<List<T>> Function(int page, int pageSize) fetchData;

  PagingController({required this.fetchData, this.pageSize = 10});

  /// 현재 페이지 가져오기
  int get currentPage => _currentPage;

  /// 데이터 항목 가져오기
  List<T> get items => List.unmodifiable(_items); // 리스트를 수정할 수 없게 반환

  /// 로딩 상태
  bool get isFetching => _isFetching;

  /// 더 가져올 데이터가 있는지 확인
  bool get hasMoreData => _hasMoreData;

  /// 데이터 초기화
  void reset({bool preserveItems = false}) {
    debugPrint("[PagingController] Resetting paging state");
    _currentPage = 0;
    if (!preserveItems) {
      _items.clear(); // 기존 데이터를 유지하거나 초기화
    }
    _isFetching = false;
    _hasMoreData = true;
  }

  /// 데이터 페이징 처리
  Future<void> loadNextPage() async {
    if (_isFetching) {
      debugPrint("Already fetching data...");
      return;
    }
    if (!_hasMoreData) {
      debugPrint("No more data to load.");
      return;
    }

    debugPrint("Loading next page..");
    _isFetching = true;

    try {
      final newData = await fetchData(_currentPage, pageSize);
      if (newData.isEmpty || newData.length < pageSize) {
        debugPrint("No more data available. Stopping further fetch.");
        _hasMoreData = false; // 데이터가 부족하면 더 이상 로드하지 않음
      }

      _items.addAll(newData);
      _currentPage++;
      debugPrint("Loaded ${newData.length} items. Current page: $_currentPage");
    } catch (error) {
      debugPrint('Error loading page $_currentPage: $error');
    } finally {
      _isFetching = false;
    }
  }
}
