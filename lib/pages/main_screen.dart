import 'package:flutter/material.dart';
import 'second_page.dart';
import 'profile_page.dart';
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

  Future<void> onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
          Container(),
          SecondPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Select'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Page'),
        ],
      ),
    );
  }
}
