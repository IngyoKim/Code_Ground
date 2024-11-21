import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/features/quiz_page.dart';
import 'package:code_ground/src/pages/features/home_page.dart';
import 'package:code_ground/src/pages/features/profile_page.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUserData();
      Provider.of<ProgressViewModel>(context, listen: false)
          .fetchProgressData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          const QuizPage(),
          HomePage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: Icon(
                Icons.group,
                size: 24,
              ),
              text: "Social",
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 24,
              ),
              text: "Home",
            ),
            Tab(
              icon: Icon(
                Icons.person,
                size: 24,
              ),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
