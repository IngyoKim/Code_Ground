import 'package:flutter/widgets.dart';
import 'package:code_ground/src/utils/paging/paging_controller.dart';

class ScrollHandler {
  /// Processing scroll events
  static void handleScroll<T>({
    required ScrollController scrollController,
    required PagingController<T> pagingController,
    required VoidCallback onScrollEnd,
  }) {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!pagingController.isFetching && pagingController.hasMoreData) {
        onScrollEnd();
      }
    }
  }
}
