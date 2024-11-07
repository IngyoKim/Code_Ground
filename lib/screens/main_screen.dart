import 'package:flutter/material.dart';
import 'main_page.dart';
import 'second_page.dart';
import 'my_page.dart';
import '../services/firestore_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int level = 1;
  int currentExp = 0;
  int points = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    Map<String, dynamic> userData = await _firestoreService.fetchUserData();
    setState(() {
      level = userData['level'];
      currentExp = userData['exp'];
      points = userData['points'];
      isLoading = false;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void increaseExp(int amount) async {
    int maxExp = getMaxExpForLevel(level);
    int targetExp = currentExp + amount;

    while (currentExp < targetExp && currentExp < maxExp) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() {
        currentExp += 1;
      });
    }

    if (currentExp >= maxExp) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        currentExp = 0;
        if (level < 5) {
          level++;
        } else {
          points++;
          level = 1;
          _showLevelResetEffect();
        }
      });
    }
    _firestoreService.saveUserData(level, currentExp, points);
  }

  void setCheatLevel() {
    setState(() {
      level = 5;
      currentExp = 250;
    });
    _firestoreService.saveUserData(level, currentExp, points);
  }

  void _showLevelResetEffect() {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 1 - value,
              child: Transform.translate(
                offset: Offset(0, -20 * value),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '+1 Point!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  int getMaxExpForLevel(int level) {
    switch (level) {
      case 1:
        return 50;
      case 2:
        return 100;
      case 3:
        return 150;
      case 4:
        return 200;
      case 5:
        return 300;
      default:
        return 50;
    }
  }

  String getLevelLabel() {
    switch (level) {
      case 1:
        return 'SEED';
      case 2:
        return 'BUD';
      case 3:
        return 'TREE';
      case 4:
        return 'FLOWER';
      case 5:
        return 'APPLE';
      default:
        return 'SEED';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          MainPage(
            level: level,
            currentExp: currentExp,
            points: points,
            levelLabel: getLevelLabel(),
            maxExp: getMaxExpForLevel(level),
          ),
          SecondPage(
            onCorrectAnswer: () {
              increaseExp(50);
              onTabTapped(0);
            },
            onCheat: () {
              setCheatLevel();
              onTabTapped(0);
            },
          ),
          const MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Page'),
        ],
      ),
    );
  }
}
