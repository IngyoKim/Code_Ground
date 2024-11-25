import 'package:flutter/foundation.dart';

/// questionId 생성 및 카테고리 분류 작업을 담당하는 클래스
class QuestionIdGenerator {
  static const Map<String, String> _categoryPrefixes = {
    'syntax': '1',
    'debugging': '2',
    'output': '3',
    'blank': '4',
    'sequencing': '5',
  };

  /// 카테고리 접두사 가져오기
  static String getPrefixFromCategory(String category) {
    debugPrint(
        '[getPrefixFromCategory] Resolving prefix for category: $category');
    return _categoryPrefixes[category.toLowerCase()] ?? '0';
  }

  /// ID로 카테고리 추출
  static String? getCategoryFromId(String questionId) {
    debugPrint('[getCategoryFromId] Extracting category for ID: $questionId');
    final prefix = questionId.substring(0, 1);
    final categoryEntry = _categoryPrefixes.entries.firstWhere(
        (entry) => entry.value == prefix,
        orElse: () => const MapEntry('', ''));
    return categoryEntry.key.isNotEmpty ? categoryEntry.key : null;
  }

  /// 새로운 질문 ID 생성
  static Future<String> generateNewId({
    required String category,
    required int lastNumber,
  }) async {
    debugPrint('[generateNewId] Generating ID for category: $category');
    final prefix = getPrefixFromCategory(category);
    final newNumber = (lastNumber + 1).toString().padLeft(5, '0'); // 5자리로 패딩
    final newId = '$prefix$newNumber';
    debugPrint('[generateNewId] Generated ID: $newId');
    return newId;
  }
}
