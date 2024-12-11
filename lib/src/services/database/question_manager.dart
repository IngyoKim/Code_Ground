import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/services/database/database_service.dart';

const basePath = 'Questions';

class QuestionManager {
  final DatabaseService _dbService = DatabaseService();

  // 카테고리별 접두사
  static const Map<String, String> _categoryPrefixes = {
    'syntax': '1',
    'debugging': '2',
    'output': '3',
    'blank': '4',
    'sequencing': '5',
  };

  /// 카테고리 접두사 가져오기
  static String getPrefix(String category) {
    return _categoryPrefixes[category.toLowerCase()] ?? '0';
  }

  /// 질문 ID 존재 여부 확인
  Future<bool> doesQuestionIdExist(String questionId) async {
    final category = _getCategoryFromId(questionId);
    if (category == null) return false;

    final path = '$basePath/${category.toLowerCase()}/$questionId';
    try {
      final data = await _dbService.readDB(path);
      return data != null;
    } catch (error) {
      debugPrint('[doesQuestionIdExist] Error checking ID: $error');
      return false;
    }
  }

  /// ID로 카테고리 추출
  static String? _getCategoryFromId(String questionId) {
    final prefix = questionId.substring(0, 1);
    return _categoryPrefixes.entries
            .firstWhere(
              (entry) => entry.value == prefix,
              orElse: () => const MapEntry('', ''),
            )
            .key
            .isNotEmpty
        ? _categoryPrefixes.entries
            .firstWhere((entry) => entry.value == prefix)
            .key
        : null;
  }

  /// 새로운 질문 ID 생성 및 패딩
  Future<String> generateQuestionId(String category,
      {String input = ''}) async {
    final prefix = getPrefix(category);

    if (input.isNotEmpty) {
      // 입력값이 있을 때, 접두사 + 입력값 + 나머지 부분을 '0'으로 채움
      String baseId = (prefix + input).padRight(6, '0');

      int counter = 1;

      // 중복 확인 및 고유한 ID 생성
      while (await doesQuestionIdExist(baseId)) {
        baseId = prefix +
            input.padRight(6 - prefix.length - counter.toString().length, '0') +
            counter.toString();
        counter++;

        // 최대 6자리를 초과하지 않도록 보장
        if (baseId.length > 6) {
          throw Exception('Cannot generate a unique ID within 6 characters.');
        }
      }

      return baseId;
    }

    debugPrint(
        '[generateQuestionId] Generating new ID for category: $category');

    // 가장 최신의 질문 데이터를 가져옴
    final questions = await fetchQuestions(category);
    final lastNumber = questions
        .map((q) => int.tryParse(q.questionId.substring(1)) ?? 0)
        .fold(0, (max, value) => value > max ? value : max);

    final newNumber = (lastNumber + 1).toString().padLeft(5, '0');
    return '$prefix$newNumber';
  }

  /// 질문 ID로 질문 가져오기
  Future<QuestionData?> fetchQuestionById(String questionId) async {
    final category = _getCategoryFromId(questionId);
    if (category == null) {
      debugPrint('[fetchQuestionById] Invalid question ID: $questionId');
      return null;
    }

    final path = '$basePath/${category.toLowerCase()}/$questionId';
    try {
      final data = await _dbService.readDB(path);
      if (data != null) {
        return QuestionData.fromJson(Map<String, dynamic>.from(data));
      } else {
        debugPrint(
            '[fetchQuestionById] No data found for question ID: $questionId');
        return null;
      }
    } catch (error) {
      debugPrint('[fetchQuestionById] Error fetching question: $error');
      return null;
    }
  }

  /// 질문 데이터 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    debugPrint('[writeQuestionData] Writing question data');
    String questionId = await generateQuestionId(
      questionData.category,
      input: questionData.questionId,
    );

    questionData = questionData.copyWith(questionId: questionId);

    final path =
        '$basePath/${questionData.category.toLowerCase()}/${questionData.questionId}';
    try {
      await _dbService.writeDB(path, questionData.toJson());
      debugPrint(
          '[writeQuestionData] Successfully wrote question data at path: $path');
    } catch (error) {
      debugPrint('[writeQuestionData] Error writing question data: $error');
      rethrow;
    }
  }

  /// 질문 데이터 업데이트
  Future<void> updateQuestionData(QuestionData updatedQuestion) async {
    final path =
        '$basePath/${updatedQuestion.category.toLowerCase()}/${updatedQuestion.questionId}';
    try {
      await _dbService.updateDB(path, updatedQuestion.toJson());
      debugPrint(
          '[updateQuestionData] Successfully updated question at path: $path');
    } catch (error) {
      debugPrint('[updateQuestionData] Error updating question data: $error');
      rethrow;
    }
  }

  /// 특정 카테고리의 질문 가져오기
  Future<List<QuestionData>> fetchQuestions(
    String category, {
    String? lastQuestionId,
    int limit = 10, // 기본값으로 최신 데이터 10개 가져오기
  }) async {
    final path = '$basePath/${category.toLowerCase()}';

    try {
      // Firebase Query 설정
      Query query = _dbService.database.ref(path).orderByKey();

      // 마지막 ID 이전의 데이터 가져오기
      if (lastQuestionId != null && lastQuestionId.isNotEmpty) {
        query = query.endBefore(lastQuestionId); // lastQuestionId 이전 데이터 가져오기
      }

      query = query.limitToLast(limit); // 최신 데이터 제한

      // fetchDB 호출
      final data = await _dbService.fetchDB(path: path, query: query);

      // 데이터를 역순 정렬하여 최신순으로 반환
      return data
          .map((json) => QuestionData.fromJson(json))
          .toList()
          .reversed
          .toList(); // 최신 데이터가 가장 위로 오도록 정렬
    } catch (error) {
      debugPrint('[QuestionOperation.fetchQuestions] Error: $error');
      return [];
    }
  }
}
