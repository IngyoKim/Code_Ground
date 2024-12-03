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
      uid: json['uid'] ?? '', // 기본값 설정
      level: json['level'] ?? 1, // 기본값 설정
      exp: json['exp'] ?? 0, // 기본값 설정
      score: json['score'] ?? 0, // 기본값 설정
      tier: json['tier'] ?? 'Bronze', // 기본값 설정
      grade: json['grade'] ?? 'V', // 기본값 설정
      questionState:
          Map<String, String>.from(json['questionState'] ?? {}), // 기본값 설정
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
