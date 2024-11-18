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
    baseScore: 10,
    baseExp: 5,
    grades: [
      Grade(name: 'V', minScore: 0, bonusScore: 5, bonusExp: 5),
      Grade(name: 'IV', minScore: 100, bonusScore: 10, bonusExp: 10),
      Grade(name: 'III', minScore: 200, bonusScore: 15, bonusExp: 15),
      Grade(name: 'II', minScore: 300, bonusScore: 20, bonusExp: 20),
      Grade(name: 'I', minScore: 400, bonusScore: 25, bonusExp: 25),
    ],
  ),
  Tier(
    name: 'Silver',
    baseScore: 20,
    baseExp: 10,
    grades: [
      Grade(name: 'V', minScore: 500, bonusScore: 0, bonusExp: 0),
      Grade(name: 'IV', minScore: 750, bonusScore: 15, bonusExp: 10),
      Grade(name: 'III', minScore: 1000, bonusScore: 30, bonusExp: 20),
      Grade(name: 'II', minScore: 1250, bonusScore: 45, bonusExp: 30),
      Grade(name: 'I', minScore: 1500, bonusScore: 60, bonusExp: 40),
    ],
  ),
  Tier(
    name: 'Gold',
    baseScore: 30,
    baseExp: 20,
    grades: [
      Grade(name: 'V', minScore: 2000, bonusScore: 0, bonusExp: 0),
      Grade(name: 'IV', minScore: 2500, bonusScore: 20, bonusExp: 15),
      Grade(name: 'III', minScore: 3000, bonusScore: 40, bonusExp: 30),
      Grade(name: 'II', minScore: 3500, bonusScore: 60, bonusExp: 45),
      Grade(name: 'I', minScore: 4000, bonusScore: 80, bonusExp: 60),
    ],
  ),
  Tier(
    name: 'Platinum',
    baseScore: 40,
    baseExp: 30,
    grades: [
      Grade(name: 'V', minScore: 5000, bonusScore: 0, bonusExp: 0),
      Grade(name: 'IV', minScore: 6000, bonusScore: 25, bonusExp: 20),
      Grade(name: 'III', minScore: 7000, bonusScore: 50, bonusExp: 40),
      Grade(name: 'II', minScore: 8000, bonusScore: 75, bonusExp: 60),
      Grade(name: 'I', minScore: 9000, bonusScore: 100, bonusExp: 80),
    ],
  ),
  Tier(
    name: 'Diamond',
    baseScore: 50,
    baseExp: 40,
    grades: [
      Grade(name: 'V', minScore: 10000, bonusScore: 0, bonusExp: 0),
      Grade(name: 'IV', minScore: 12500, bonusScore: 30, bonusExp: 25),
      Grade(name: 'III', minScore: 15000, bonusScore: 60, bonusExp: 50),
      Grade(name: 'II', minScore: 17500, bonusScore: 90, bonusExp: 75),
      Grade(name: 'I', minScore: 20000, bonusScore: 120, bonusExp: 100),
    ],
  ),
  Tier(
    name: 'Master',
    baseScore: 70,
    baseExp: 50,
    grades: [
      Grade(name: '', minScore: 30000, bonusScore: 0, bonusExp: 0), // 단일 등급
    ],
  ),
  Tier(
    name: 'Grand Master',
    baseScore: 100,
    baseExp: 70,
    grades: [
      Grade(name: '', minScore: 50000, bonusScore: 0, bonusExp: 0), // 단일 등급
    ],
  ),
];
