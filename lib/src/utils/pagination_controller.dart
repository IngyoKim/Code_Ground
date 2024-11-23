import 'package:flutter/foundation.dart';

class PaginationController<T> extends ChangeNotifier {
  final Future<List<T>> Function(int pageSize, int page) fetchPage;

  List<T> _items = [];
  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasMore = true;

  List<T> get items => _items;
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;

  PaginationController({required this.fetchPage});

  Future<void> loadInitialPage(int pageSize) async {
    _currentPage = 0;
    _hasMore = true;
    _items.clear();
    notifyListeners();
    await _fetchNextPage(pageSize);
  }

  Future<void> loadNextPage(int pageSize) async {
    if (_isFetching || !_hasMore) return;
    await _fetchNextPage(pageSize);
  }

  Future<void> _fetchNextPage(int pageSize) async {
    try {
      _isFetching = true;
      notifyListeners();

      final newItems = await fetchPage(pageSize, _currentPage);
      if (newItems.isEmpty || newItems.length < pageSize) {
        _hasMore = false;
      }

      _items.addAll(newItems);
      _currentPage++;
    } catch (e) {
      debugPrint('Error during pagination fetch: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
