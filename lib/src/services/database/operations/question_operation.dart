import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:flutter/material.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();

  String generateQuestionId(String category) {
    final prefix = {
      'Syntax': '1',
      'Debugging': '2',
      'Output': '3',
      'Blank': '4',
      'Sequencing': '5',
    }[category]!;
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll('.', '');
    return '$prefix$timestamp';
  }

  Future<void> writeQuestionData(QuestionData questionData) async {
    String questionId = generateQuestionId(questionData.category);
    String path = 'questions/${questionData.category}/$questionId';
    await _databaseService.writeDB(path, questionData.toMap());
  }

  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    String path = 'questions/$category/$questionId';
    final data = await _databaseService.readDB(path);
    if (data is Map<String, dynamic>) {
      return QuestionData.fromMap(data);
    } else {
      debugPrint(
        "Error: Expected a Map<String, dynamic> but got ${data.runtimeType}",
      );
      return null;
    }
  }

  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    String path = 'questions/$category/$questionId';
    await _databaseService.updateDB(path, updates);
  }
}
