class ProgressData {
  final String userId;
  int level;
  int exp;
  String tier;
  int score;
  final Map<String, bool> quizState;
  //final int rank;

  ProgressData({
    required this.userId,
    required this.level,
    required this.exp,
    required this.tier,
    required this.score,
    required this.quizState,
  });
}
