import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void saveUserData(int level, int exp, int points) async {
  print("Saving user data to Firestore...");
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('users').doc('unique_user_id').set({
      'level': level,
      'exp': exp,
      'points': points,
      'updated_at': FieldValue.serverTimestamp(),
    });
    print("User data saved successfully!");
  } catch (e) {
    print("Failed to save user data: $e");
  }
}

Future<Map<String, dynamic>> fetchUserData() async {
  print("Fetching user data from Firestore...");
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot doc =
      await firestore.collection('users').doc('unique_user_id').get();

  if (doc.exists) {
    print("User data fetched successfully!");
    return doc.data() as Map<String, dynamic>;
  } else {
    print("No user data found. Using default values.");
    return {'level': 1, 'exp': 0, 'points': 0}; // 기본값
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  print("Firebase initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int level = 1;
  int currentExp = 0;
  int points = 0;
  bool isLoading = true; // 로딩 상태 추가
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    Map<String, dynamic> userData = await fetchUserData();
    setState(() {
      level = userData['level'];
      currentExp = userData['exp'];
      points = userData['points'];
      isLoading = false; // 데이터 로드 완료 후 로딩 상태 false로 변경
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

    saveUserData(level, currentExp, points);
  }

  void setCheatLevel() {
    setState(() {
      level = 5;
      currentExp = 250;
    });
    saveUserData(level, currentExp, points);
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
    // 로딩 중일 때 로딩 인디케이터 표시
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // 로딩 인디케이터
        ),
      );
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz Selection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final int level;
  final int currentExp;
  final int points;
  final String levelLabel;
  final int maxExp;

  const MainPage({
    super.key,
    required this.level,
    required this.currentExp,
    required this.points,
    required this.levelLabel,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Main Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                'Point: $points',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/${levelLabel.toLowerCase()}.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 10),
                Text(
                  'Lv.$level $levelLabel',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: 0,
                          end: currentExp / maxExp,
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.grey[300],
                            color: Colors.black,
                            minHeight: 10,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$currentExp / $maxExp',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onCheat;

  const SecondPage({
    super.key,
    required this.onCorrectAnswer,
    required this.onCheat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quiz Selection'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            // Math Quiz Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathPage(
                      onCorrectAnswer: onCorrectAnswer,
                      onCheat: onCheat,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.center, // 가로 가운데 정렬
                children: [
                  Icon(Icons.calculate, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Math Quiz',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // English Quiz Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for English Quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'English Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Coding Quiz Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for Coding Quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.code, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Coding Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // UpDown Game Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for UpDown Game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.swap_vert, size: 40.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Up&Down Game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MathPage extends StatefulWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onCheat;

  const MathPage(
      {super.key, required this.onCorrectAnswer, required this.onCheat});

  @override
  _MathPageState createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  final Random _random = Random();
  late int a;
  late int b;
  final TextEditingController _controller = TextEditingController();
  String message = '';

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      a = _random.nextInt(100) + 1;
      b = _random.nextInt(100) + 1;
      message = '';
      _controller.clear();
    });
  }

  void _checkAnswer() async {
    int answer = int.tryParse(_controller.text) ?? 0;
    if (answer == -1) {
      widget.onCheat();
      setState(() {
        message = 'Cheat Activated!';
      });
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    } else if (answer == a + b) {
      widget.onCorrectAnswer();
      setState(() {
        message = 'Correct!';
      });
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    } else {
      setState(() {
        message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Math Quiz'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What is $a + $b?',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your answer',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Page'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Welcome to My Page',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
