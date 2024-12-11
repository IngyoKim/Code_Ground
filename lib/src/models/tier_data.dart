import 'package:flutter/material.dart';

class Tier {
  final String name; // 티어 이름 (예: 브론즈, 실버)
  final List<Grade> grades; // 등급 리스트
  final int bonusScore; // 보너스 스코어
  final int bonusExp; // 보너스 경험치

  // 생성자
  Tier({
    required this.name,
    required this.grades,
    required this.bonusScore,
    required this.bonusExp,
  });

  /// 정적 메서드: 티어 이름으로 티어 객체 찾기
  static Tier? getTierByName(String tierName) {
    try {
      return tiers.firstWhere((tier) => tier.name == tierName);
    } catch (error) {
      debugPrint("Tier not found for name: $error");
      return null;
    }
  }

  /// 다음 티어까지 접근 가능한지 확인하는 메서드
  bool accessibleTier(String currentTierName) {
    final tierOrder = [
      'Bronze',
      'Silver',
      'Gold',
      'Platinum',
      'Diamond',
      'Master',
      'Grand Master'
    ];

    final targetIndex = tierOrder.indexOf(name);
    final currentIndex = tierOrder.indexOf(currentTierName);

    return currentIndex != -1 &&
        targetIndex != -1 &&
        targetIndex <= currentIndex + 1;
  }
}

class Grade {
  final String name; // 등급 이름 (예: V, IV)
  final int minScore; // 최소 점수

  Grade({
    required this.name,
    required this.minScore,
  });
}

final List<Tier> tiers = [
  Tier(
    name: 'Bronze',
    bonusScore: 10, // 브론즈 보너스 스코어
    bonusExp: 10, // 브론즈 보너스 경험치
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
    bonusScore: 25, // 실버 보너스 스코어
    bonusExp: 30, // 실버 보너스 경험치
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
    bonusScore: 50, // 골드 보너스 스코어
    bonusExp: 100, // 골드 보너스 경험치
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
    bonusScore: 100, // 플래티넘 보너스 스코어
    bonusExp: 500, // 플래티넘 보너스 경험치
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
    bonusScore: 250, // 다이아몬드 보너스 스코어
    bonusExp: 1000, // 다이아몬드 보너스 경험치
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
    bonusScore: 500, // 마스터 보너스 스코어
    bonusExp: 5000, // 마스터 보너스 경험치
    grades: [
      Grade(name: '', minScore: 30000),
    ],
  ),
  Tier(
    name: 'Grand Master',
    bonusScore: 0, // 그랜드마스터 보너스 스코어
    bonusExp: 0, // 그랜드마스터 보너스 경험치
    grades: [
      Grade(name: '', minScore: 50000),
    ],
  ),
];
