import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();
  final Map<String, int> _idCounters = {};

  /// 카테고리에 따라 문제 번호의 접두사를 반환
  String _getCategoryPrefix(String category) {
    switch (category) {
      case 'Syntax':
        return '1';
      case 'Debugging':
        return '2';
      case 'Output':
        return '3';
      case 'Blank':
        return '4';
      case 'Sequencing':
        return '5';
      default:
        throw Exception("Unknown category: $category");
    }
  }

  /// 데이터베이스에서 현재 문제 번호 가져오기
  Future<int> _fetchLastQuestionId(String category) async {
    try {
      final ref = _databaseService.database.ref('questions/$category');
      final snapshot = await ref.orderByKey().limitToLast(1).get();

      if (snapshot.exists) {
        final lastKey = snapshot.children.first.key;
        if (lastKey != null && lastKey.length > 1) {
          // 문제 번호를 접두사 제거 후 숫자로 변환
          final lastId = int.parse(lastKey.substring(1));
          return lastId;
        }
      }
    } catch (error) {
      debugPrint('Error fetching last question ID: $error');
    }
    return 0; // 기본값: 데이터가 없으면 0 반환
  }

  /// 문제 번호 생성
  Future<String> generateQuestionId(String category) async {
    if (!_idCounters.containsKey(category)) {
      _idCounters[category] = await _fetchLastQuestionId(category);
    }

    // 새로운 문제 번호 생성
    _idCounters[category] = (_idCounters[category] ?? 0) + 1;

    // 접두사와 5자리 문제 번호 생성
    final prefix = _getCategoryPrefix(category);
    final paddedId = _idCounters[category]!.toString().padLeft(5, '0');
    final questionId = '$prefix$paddedId';
    debugPrint('Generated questionId for category $category: $questionId');
    return questionId;
  }

  /// QuestionData를 데이터베이스에 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    try {
      final questionId = await generateQuestionId(questionData.category);
      final path = 'questions/${questionData.category}/$questionId';

      // 데이터 생성
      final data = {
        ...questionData.toMap(),
        'questionId': questionId, // 문제 번호 추가
        'createdAt': DateTime.now().toIso8601String(),
      };

      debugPrint('Writing question data to $path: $data');
      await _databaseService.writeDB(path, data);
      debugPrint('Successfully wrote question data to $path');
    } catch (error) {
      debugPrint('Error writing question data: $error');
      rethrow;
    }
  }

  /// QuestionData를 데이터베이스에서 읽기
  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    try {
      final path = 'questions/$category/$questionId';
      debugPrint('Reading question data from $path');
      final data = await _databaseService.readDB(path);

      if (data is Map<String, dynamic>) {
        debugPrint('Successfully read question data: $data');
        return QuestionData.fromMap(data); // factory 사용
      } else {
        debugPrint(
          "Error: Expected a Map<String, dynamic> but got ${data.runtimeType}",
        );
        return null;
      }
    } catch (error) {
      debugPrint('Error reading question data: $error');
      return null;
    }
  }

  /// QuestionData를 업데이트
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    try {
      final path = 'questions/$category/$questionId';
      debugPrint('Updating question data at $path with $updates');
      await _databaseService.updateDB(path, updates);
      debugPrint('Successfully updated question data at $path');
    } catch (error) {
      debugPrint('Error updating question data: $error');
      rethrow;
    }
  }

  /// 최신 문제 가져오기
  Future<List<QuestionData>> fetchRecentQuestions(String category,
      {int limit = 10, String? startAfter}) async {
    final ref = _databaseService.database.ref('questions/$category');
    Query query = ref.orderByChild('createdAt').limitToFirst(limit);

    if (startAfter != null) {
      query = query.startAfter([startAfter]);
    }

    final snapshot = await query.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        final questionMap = Map<String, dynamic>.from(entry.value as Map);
        debugPrint(questionMap.toString());
        return QuestionData.fromMap(questionMap); // factory 사용
      }).toList();
    }
    return [];
  }
}
