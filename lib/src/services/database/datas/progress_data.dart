class ProgressData {
  final String userId;
  int level;
  int exp;
  String tier; // 티어 이름
  String grade; // 등급 이름
  int score;
  final Map<String, bool> questionState;

  ProgressData({
    required this.userId,
    required this.level,
    required this.exp,
    required this.tier,
    required this.grade,
    required this.score,
    required this.questionState,
  });
}
