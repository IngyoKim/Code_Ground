import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();
  final Map<String, int> _idCounters = {
    'Syntax': 0,
    'Debugging': 0,
    'Output': 0,
    'Blank': 0,
    'Sequencing': 0,
  };

  // 간단한 questionId 생성
  String generateQuestionId(String category) {
    if (_idCounters.containsKey(category)) {
      _idCounters[category] = (_idCounters[category] ?? 0) + 1;

      // 5자리로 포맷팅
      final paddedId = _idCounters[category]!.toString().padLeft(5, '0');
      debugPrint('Generated questionId for category $category: $paddedId');
      return paddedId; // 예: "00001"
    } else {
      throw Exception("Unknown category: $category");
    }
  }

  // QuestionData를 데이터베이스에 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    try {
      // questionId 생성
      String questionId = generateQuestionId(questionData.category);

      // 데이터를 저장할 경로
      String path = 'questions/${questionData.category}/$questionId';

      // 데이터 생성 (`questionId` 필드는 추가하지 않음)
      final data = {
        ...questionData.toMap(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      debugPrint('Writing question data to $path: $data');
      await _databaseService.writeDB(path, data);
      debugPrint('Successfully wrote question data to $path');
    } catch (e) {
      debugPrint('Error writing question data: $e');
      rethrow;
    }
  }

  // QuestionData를 데이터베이스에서 읽기
  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    try {
      String path = 'questions/$category/$questionId';
      debugPrint('Reading question data from $path');
      final data = await _databaseService.readDB(path);

      if (data is Map<String, dynamic>) {
        debugPrint('Successfully read question data: $data');
        return QuestionData.fromMap(data);
      } else {
        debugPrint(
          "Error: Expected a Map<String, dynamic> but got ${data.runtimeType}",
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error reading question data: $e');
      return null;
    }
  }

  // QuestionData를 업데이트
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    try {
      String path = 'questions/$category/$questionId';
      debugPrint('Updating question data at $path with $updates');
      await _databaseService.updateDB(path, updates);
      debugPrint('Successfully updated question data at $path');
    } catch (e) {
      debugPrint('Error updating question data: $e');
      rethrow;
    }
  }
}
