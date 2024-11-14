import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:flutter/material.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();

  // questionId를 생성 시간 기반으로 생성하는 메서드
  String generateQuestionId() {
    return DateTime.now()
        .toIso8601String()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll('.', '');
  }

  // QuestionData를 데이터베이스에 저장하는 함수
  Future<void> writeQuestionData(QuestionData questionData) async {
    // questionId를 생성
    String questionId = generateQuestionId();

    String path = 'questions/${questionData.category}/$questionId';
    await _databaseService.writeDB(path, questionData.toMap());
  }

  // QuestionData를 데이터베이스에서 읽어오는 함수
  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    String path = 'questions/$category/$questionId';
    final data = await _databaseService.readDB(path);

    if (data is Map<String, dynamic>) {
      // 데이터가 Map 형식이면 적절한 서브클래스로 변환
      return QuestionData.fromMap(data);
    } else {
      // 데이터 형식이 Map이 아닌 경우 오류 메시지 출력
      debugPrint(
        "Error: Expected a Map<String, dynamic> but got ${data.runtimeType}",
      );
      return null;
    }
  }

  // QuestionData를 업데이트하는 함수
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    String path = 'questions/$category/$questionId';
    await _databaseService.updateDB(path, updates);
  }
}
