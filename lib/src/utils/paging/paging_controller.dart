import 'package:flutter/material.dart';

class PagingController<T> {
  final Future<List<T>> Function(T? lastItem) fetchData; // 마지막 아이템을 기준으로 페이징
  final List<T> _items = [];
  bool _isFetching = false;
  bool _hasMoreData = true;

  PagingController({required this.fetchData});

  /// 데이터 항목 가져오기
  List<T> get items => List.unmodifiable(_items);

  /// 로딩 상태
  bool get isFetching => _isFetching;

  /// 더 가져올 데이터가 있는지 확인
  bool get hasMoreData => _hasMoreData;

  /// 데이터 초기화
  void reset({bool preserveItems = false}) {
    debugPrint("[PagingController] Resetting paging state");
    if (!preserveItems) {
      _items.clear();
    }
    _isFetching = false;
    _hasMoreData = true;
  }

  /// 데이터 페이징 처리
  Future<void> loadNextPage() async {
    if (_isFetching) {
      debugPrint("[PagingController] Already fetching...");
      return;
    }
    if (!_hasMoreData) {
      debugPrint("[PagingController] No more data to load.");
      return;
    }

    _isFetching = true;

    try {
      final lastItem = _items.isNotEmpty ? _items.last : null; // 마지막 아이템 기준
      final newData = await fetchData(lastItem);
      if (newData.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(newData);
        debugPrint("[PagingController] Loaded ${newData.length} items.");
      }
    } catch (error) {
      debugPrint("[PagingController] Error loading data: $error");
    } finally {
      _isFetching = false;
    }
  }
}
