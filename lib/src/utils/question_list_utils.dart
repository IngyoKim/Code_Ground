import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionListUtils {
  /// 질문 상태별 아이콘 반환
  IconData? getLeadingIcon(bool? questionState) {
    if (questionState == true) return Icons.check_circle;
    if (questionState == false) return Icons.cancel;
    return null;
  }

  /// 질문 상태별 아이콘 색상 반환
  Color? getIconColor(bool? questionState) {
    if (questionState == true) return Colors.green;
    if (questionState == false) return Colors.red;
    return null;
  }

  /// 스크롤 이벤트 처리
  void handleScroll({
    required ScrollController scrollController,
    required VoidCallback fetchNextPage,
    required bool isLoading,
  }) {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchNextPage();
    }
  }

  /// 질문 타일 빌드
  Widget buildQuestionTile({
    required QuestionData question,
    required bool? questionState,
    required VoidCallback onTap,
  }) {
    final leadingIcon = getLeadingIcon(questionState);
    final iconColor = getIconColor(questionState);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading:
            leadingIcon != null ? Icon(leadingIcon, color: iconColor) : null,
        title: Text(
          question.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          question.codeSnippets.keys.join(', '),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
