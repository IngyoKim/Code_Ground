class ProgressData {
  final String userId;
  int level;
  int exp;
  final List<String> solvedQuestions; // 푼 문제의 ID 리스트
  final Map<String, DateTime?> questionStatus; // 문제 ID를 키로, 해결 시간을 값으로 저장

  ProgressData({
    required this.userId,
    this.level = 0,
    this.exp = 0,
    required this.solvedQuestions,
    required this.questionStatus,
  });
}
