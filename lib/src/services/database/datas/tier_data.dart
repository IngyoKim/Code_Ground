class Tier {
  final String name; // 티어 이름 (예: 브론즈, 실버)
  final List<Grade> grades;

  Tier({required this.name, required this.grades});
}

class Grade {
  final String name; // 등급 이름 (예: V, IV)
  final int minScore; // 최소 점수

  Grade({required this.name, required this.minScore});
}

final List<Tier> tiers = [
  Tier(
    name: 'Bronze',
    grades: [
      Grade(name: 'V', minScore: 0),
      Grade(name: 'IV', minScore: 100),
      Grade(name: 'III', minScore: 200),
      Grade(name: 'II', minScore: 300),
      Grade(name: 'I', minScore: 400),
    ],
  ),
  Tier(
    name: 'Silver',
    grades: [
      Grade(name: 'V', minScore: 500),
      Grade(name: 'IV', minScore: 750),
      Grade(name: 'III', minScore: 1000),
      Grade(name: 'II', minScore: 1250),
      Grade(name: 'I', minScore: 1500),
    ],
  ),
  Tier(
    name: 'Gold',
    grades: [
      Grade(name: 'V', minScore: 2000),
      Grade(name: 'IV', minScore: 2500),
      Grade(name: 'III', minScore: 3000),
      Grade(name: 'II', minScore: 3500),
      Grade(name: 'I', minScore: 4000),
    ],
  ),
  Tier(
    name: 'Platinum',
    grades: [
      Grade(name: 'V', minScore: 5000),
      Grade(name: 'IV', minScore: 6000),
      Grade(name: 'III', minScore: 7000),
      Grade(name: 'II', minScore: 8000),
      Grade(name: 'I', minScore: 9000),
    ],
  ),
  Tier(
    name: 'Diamond',
    grades: [
      Grade(name: 'V', minScore: 10000),
      Grade(name: 'IV', minScore: 12500),
      Grade(name: 'III', minScore: 15000),
      Grade(name: 'II', minScore: 17500),
      Grade(name: 'I', minScore: 20000),
    ],
  ),
  Tier(
    name: 'Master',
    grades: [
      Grade(name: '', minScore: 30000), // 단일 등급
    ],
  ),
];
