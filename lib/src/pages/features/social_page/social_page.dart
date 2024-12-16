import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/features/social_page/friends_page.dart';
import 'package:code_ground/src/pages/features/social_page/ranking/ranking_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        backgroundColor: Colors.white, // 배경색을 흰색으로 설정
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text("Social"),
          toolbarHeight: 40,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ranking"),
              Tab(text: "Friends"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            RankingPage(),
            RegistrateFriends(),
          ],
        ),
      ),
    );
  }
}
