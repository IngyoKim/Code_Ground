class Tier {
  final String name; // 티어 이름 (예: 브론즈, 실버)
  final List<Grade> grades; // 등급 리스트
  final int baseScore; // 기본 제공 스코어
  final int baseExp; // 기본 제공 경험치

  Tier({
    required this.name,
    required this.grades,
    required this.baseScore,
    required this.baseExp,
  });
}

class Grade {
  final String name; // 등급 이름 (예: V, IV)
  final int minScore; // 최소 점수
  final int bonusScore; // 추가 스코어
  final int bonusExp; // 추가 경험치

  Grade({
    required this.name,
    required this.minScore,
    required this.bonusScore,
    required this.bonusExp,
  });
}

final List<Tier> tiers = [
  Tier(
    name: 'Bronze',
    baseScore: 0, // 브론즈 기본 스코어
    baseExp: 10, // 브론즈 기본 경험치
    grades: [
      Grade(name: 'V', minScore: 0, bonusScore: 5, bonusExp: 10),
      Grade(name: 'IV', minScore: 100, bonusScore: 10, bonusExp: 15),
      Grade(name: 'III', minScore: 200, bonusScore: 15, bonusExp: 20),
      Grade(name: 'II', minScore: 300, bonusScore: 20, bonusExp: 25),
      Grade(name: 'I', minScore: 400, bonusScore: 25, bonusExp: 30),
    ],
  ),
  Tier(
    name: 'Silver',
    baseScore: 25, // 실버 기본 스코어
    baseExp: 20, // 실버 기본 경험치
    grades: [
      Grade(name: 'V', minScore: 500, bonusScore: 30, bonusExp: 50),
      Grade(name: 'IV', minScore: 750, bonusScore: 35, bonusExp: 60),
      Grade(name: 'III', minScore: 1000, bonusScore: 40, bonusExp: 75),
      Grade(name: 'II', minScore: 1250, bonusScore: 45, bonusExp: 90),
      Grade(name: 'I', minScore: 1500, bonusScore: 50, bonusExp: 100),
    ],
  ),
  Tier(
    name: 'Gold',
    baseScore: 40, // 골드 기본 스코어
    baseExp: 30, // 골드 기본 경험치
    grades: [
      Grade(name: 'V', minScore: 2000, bonusScore: 100, bonusExp: 200),
      Grade(name: 'IV', minScore: 2500, bonusScore: 110, bonusExp: 210),
      Grade(name: 'III', minScore: 3000, bonusScore: 125, bonusExp: 225),
      Grade(name: 'II', minScore: 3500, bonusScore: 140, bonusExp: 240),
      Grade(name: 'I', minScore: 4000, bonusScore: 150, bonusExp: 250),
    ],
  ),
  Tier(
    name: 'Platinum',
    baseScore: 60, // 플래티넘 기본 스코어
    baseExp: 50, // 플래티넘 기본 경험치
    grades: [
      Grade(name: 'V', minScore: 5000, bonusScore: 120, bonusExp: 500),
      Grade(name: 'IV', minScore: 6000, bonusScore: 130, bonusExp: 150),
      Grade(name: 'III', minScore: 7000, bonusScore: 140, bonusExp: 160),
      Grade(name: 'II', minScore: 8000, bonusScore: 150, bonusExp: 170),
      Grade(name: 'I', minScore: 9000, bonusScore: 160, bonusExp: 180),
    ],
  ),
  Tier(
    name: 'Diamond',
    baseScore: 80, // 다이아몬드 기본 스코어
    baseExp: 70, // 다이아몬드 기본 경험치
    grades: [
      Grade(name: 'V', minScore: 10000, bonusScore: 180, bonusExp: 200),
      Grade(name: 'IV', minScore: 12500, bonusScore: 200, bonusExp: 220),
      Grade(name: 'III', minScore: 15000, bonusScore: 220, bonusExp: 240),
      Grade(name: 'II', minScore: 17500, bonusScore: 240, bonusExp: 260),
      Grade(name: 'I', minScore: 20000, bonusScore: 260, bonusExp: 280),
    ],
  ),
  Tier(
    name: 'Master',
    baseScore: 100, // 마스터 기본 스코어
    baseExp: 90, // 마스터 기본 경험치
    grades: [
      Grade(name: '', minScore: 30000, bonusScore: 300, bonusExp: 300),
    ],
  ),
  Tier(
    name: 'Grand Master',
    baseScore: 120, // 그랜드마스터 기본 스코어
    baseExp: 110, // 그랜드마스터 기본 경험치
    grades: [
      Grade(name: '', minScore: 50000, bonusScore: 400, bonusExp: 400),
    ],
  ),
];
