import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/profile_page.dart';
import 'package:code_ground/src/components/expandable_fab.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // 페이지 스와이프 비활성화
        children: const [
          Center(child: ExpandableFab()), // ExpandableFab이 포함된 첫 번째 탭
          Center(child: Text("Content for Tab 2")),
          Center(child: ProfilePage()),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Tab 1"),
          Tab(text: "Tab 2"),
          Tab(text: "Profile"),
        ],
      ),
    );
  }
}
