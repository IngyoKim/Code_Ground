import 'package:flutter/material.dart';

class QuestionListUtils {
  int currentPage = 0;
  final int pageSize = 10;

  // 스크롤 이벤트 처리
  void handleScroll({
    required ScrollController scrollController,
    required Future<void> Function() fetchNextPage,
    required bool isLoading,
  }) {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchNextPage();
    }
  }

  // 페이징 초기화
  void resetPaging() {
    currentPage = 0;
  }

  // 다음 페이지 번호 가져오기
  int nextPage() {
    return ++currentPage;
  }
}
