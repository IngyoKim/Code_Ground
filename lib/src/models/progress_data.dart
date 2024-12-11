class ProgressData {
  final String uid;
  final int level;
  final int exp;
  final int score;
  final String tier;
  final String grade;
  final Map<String, String> questionState;

  ProgressData({
    required this.uid,
    required this.level,
    required this.exp,
    required this.score,
    required this.tier,
    required this.grade,
    required this.questionState,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      uid: json['uid'] ?? '',
      level: json['level'] ?? 1,
      exp: json['exp'] ?? 0,
      score: json['score'] ?? 0,
      tier: json['tier'] ?? 'Bronze',
      grade: json['grade'] ?? 'V',
      questionState: Map<String, String>.from(json['questionState'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'level': level,
      'exp': exp,
      'score': score,
      'tier': tier,
      'grade': grade,
      'questionState': questionState,
    };
  }
}
