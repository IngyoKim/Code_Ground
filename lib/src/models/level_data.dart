class LevelData {
  final int level;
  final int requiredExp;

  LevelData({required this.level, required this.requiredExp});
}

LevelData getCurrentLevel(List<LevelData> levels, int currentExp) {
  return levels.lastWhere((level) => currentExp >= level.requiredExp,
      orElse: () => levels.first);
}

LevelData getNextLevel(List<LevelData> levels, int currentExp) {
  return levels.firstWhere((level) => currentExp < level.requiredExp,
      orElse: () => levels.last);
}

List<LevelData> generateLevels() {
  List<LevelData> levelList = [];
  int currentExp = 0;

  for (int i = 1; i <= 100; i++) {
    if (i <= 10) {
      currentExp += 100;
    } else if (i <= 20) {
      currentExp += 150;
    } else if (i <= 30) {
      currentExp += 250;
    } else if (i <= 40) {
      currentExp += 500;
    } else if (i <= 50) {
      currentExp += 1000;
    } else if (i <= 60) {
      currentExp += 1500;
    } else if (i <= 70) {
      currentExp += 2000;
    } else if (i <= 80) {
      currentExp += 2500;
    } else if (i <= 90) {
      currentExp += 4000;
    } else {
      currentExp += 5000;
    }

    levelList.add(LevelData(level: i, requiredExp: currentExp));
  }

  return levelList;
}
