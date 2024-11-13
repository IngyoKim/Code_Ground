class QuestionData {
  final String questionId;
  final String title;
  final String category;
  final String description;
  final String difficulty;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionData({
    required this.questionId,
    required this.title,
    required this.category,
    required this.description,
    required this.difficulty,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}
