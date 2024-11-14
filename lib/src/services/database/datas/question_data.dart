// question_data.dart
class QuestionData {
  final String questionId;
  final String writer;
  final String category;
  final String questionType; // 주관식 또는 객관식 구분
  DateTime updatedAt;
  String title;
  String description;
  String answer;
  String difficulty;
  int rewardExp;
  int rewardScore;
  int solvedCount; // 푼 사람의 수

  QuestionData({
    required this.questionId,
    required this.writer,
    required this.category,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.answer,
    required this.difficulty,
    required this.rewardExp,
    required this.rewardScore,
    required this.questionType,
    required this.solvedCount,
  });
}
