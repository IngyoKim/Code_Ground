import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();
  final Map<String, int> _idCounters = {
    'Syntax': 0,
    'Debugging': 0,
    'Output': 0,
    'Blank': 0,
    'Sequencing': 0,
  };

  // 카테고리에 따라 문제 번호의 접두사를 반환
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

  // 문제 번호 생성
  String generateQuestionId(String category) {
    if (_idCounters.containsKey(category)) {
      _idCounters[category] = (_idCounters[category] ?? 0) + 1;

      // 접두사와 5자리 문제 번호 생성
      final prefix = _getCategoryPrefix(category);
      final paddedId = _idCounters[category]!.toString().padLeft(5, '0');
      final questionId = '$prefix$paddedId';
      debugPrint('Generated questionId for category $category: $questionId');
      return questionId; // 예: "100001"
    } else {
      throw Exception("Unknown category: $category");
    }
  }

  // QuestionData를 데이터베이스에 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    try {
      // 문제 번호 생성
      String questionId = generateQuestionId(questionData.category);

      // 데이터를 저장할 경로
      String path = 'questions/${questionData.category}/$questionId';

      // 데이터 생성
      final data = {
        ...questionData.toMap(),
        'questionId': questionId, // 문제 번호 추가
        'createdAt': DateTime.now().toIso8601String(),
        'tier': questionData.tier?.name, // tier 추가
        'grade': questionData.grade?.name, // grade 추가
        if (questionData.solvers != null) 'solvers': questionData.solvers,
        if (questionData.answerChoices != null)
          'answerChoices': questionData.answerChoices,
      };

      debugPrint('Writing question data to $path: $data');
      await _databaseService.writeDB(path, data);
      debugPrint('Successfully wrote question data to $path');
    } catch (error) {
      debugPrint('Error writing question data: $error');
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

        // tier와 grade를 객체로 변환
        final tier = data['tier'] != null
            ? tiers.firstWhere((t) => t.name == data['tier'])
            : null;
        final grade = (tier != null && data['grade'] != null)
            ? tier.grades.firstWhere((g) => g.name == data['grade'])
            : null;

        return QuestionData.fromMap({
          ...data,
          'tier': tier,
          'grade': grade,
          'codeSnippets': Map<String, String>.from(
              data['codeSnippets'] ?? {}), // codeSnippets 처리
          'solvers': data['solvers'] ?? 0, // solvers 처리
          'answerChoices': data['answerChoices'] != null
              ? List<String>.from(data['answerChoices'])
              : null,
        });
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

  // QuestionData를 업데이트
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    try {
      String path = 'questions/$category/$questionId';
      debugPrint('Updating question data at $path with $updates');
      await _databaseService.updateDB(path, updates);
      debugPrint('Successfully updated question data at $path');
    } catch (error) {
      debugPrint('Error updating question data: $error');
      rethrow;
    }
  }

  // 최신 문제 가져오기
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

        // tier와 grade 처리
        final tier = questionMap['tier'] != null
            ? tiers.firstWhere((t) => t.name == questionMap['tier'])
            : null;
        final grade = (tier != null && questionMap['grade'] != null)
            ? tier.grades.firstWhere((g) => g.name == questionMap['grade'])
            : null;

        return QuestionData.fromMap({
          ...questionMap,
          'tier': tier,
          'grade': grade,
          'codeSnippets': Map<String, String>.from(
              questionMap['codeSnippets'] ?? {}), // codeSnippets 처리
          'solvers': questionMap['solvers'] ?? 0,
          'answerChoices': questionMap['answerChoices'] != null
              ? List<String>.from(questionMap['answerChoices'])
              : null,
        });
      }).toList();
    }
    return [];
  }
}
