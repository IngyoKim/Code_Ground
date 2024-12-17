import 'package:flutter/material.dart';

class Tier {
  final String name; /// Tier name (e.g., Bronze, Silver)
  final List<Grade> grades; /// List of grades
  final int bonusScore; /// Bonus score
  final int bonusExp; /// Bonus experience points

  /// Constructor
  Tier({
    required this.name,
    required this.grades,
    required this.bonusScore,
    required this.bonusExp,
  });

  /// Static method: Find a Tier object by its name
  static Tier? getTierByName(String tierName) {
    try {
      return tiers.firstWhere((tier) => tier.name == tierName);
    } catch (error) {
      debugPrint("Tier not found for name: $error");
      return null;
    }
  }

  /// Method to check if the next tier is accessible
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
  final String name; /// Grade name (e.g., V, IV)
  final int minScore; /// Minimum score required for the grade

  Grade({
    required this.name,
    required this.minScore,
  });
}

final List<Tier> tiers = [
  Tier(
    name: 'Bronze',
    bonusScore: 10, /// Bonus score for Bronze
    bonusExp: 10, /// Bonus experience points for Bronze
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
    bonusScore: 25, /// Bonus score for Silver
    bonusExp: 30, /// Bonus experience points for Silver
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
    bonusScore: 50, /// Bonus score for Gold
    bonusExp: 100, /// Bonus experience points for Gold
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
    bonusScore: 100, /// Bonus score for Platinum
    bonusExp: 500, /// Bonus experience points for Platinum
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
    bonusScore: 250, /// Bonus score for Diamond
    bonusExp: 1000, /// Bonus experience points for Diamond
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
    bonusScore: 500, /// Bonus score for Master
    bonusExp: 5000, /// Bonus experience points for Master
    grades: [
      Grade(name: '', minScore: 30000),
    ],
  ),
  Tier(
    name: 'Grand Master',
    bonusScore: 0, /// Bonus score for Grand Master
    bonusExp: 0, /// Bonus experience points for Grand Master
    grades: [
      Grade(name: '', minScore: 50000),
    ],
  ),
];
