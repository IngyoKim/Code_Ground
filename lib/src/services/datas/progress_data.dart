class ProgressData {
  final String userId;
  final int experience;
  final int level;
  final int expToNextLevel;
  final DateTime lastUpdated;

  // 문제 풀이 기록을 위한 필드들
  final String questionId;
  final DateTime solvedAt;
  final int timeTaken;
  final int attempts;

  ProgressData({
    required this.userId,
    required this.experience,
    required this.level,
    required this.expToNextLevel,
    DateTime? lastUpdated, // 기본값 제공을 위한 optional parameter
    required this.questionId,
    DateTime? solvedAt, // 기본값 제공을 위한 optional parameter
    required this.timeTaken,
    required this.attempts,
  })  : lastUpdated = lastUpdated ?? DateTime.now(), // 기본값으로 현재 시간 할당
        solvedAt = solvedAt ?? DateTime.now(); // 기본값으로 현재 시간 할당
}
