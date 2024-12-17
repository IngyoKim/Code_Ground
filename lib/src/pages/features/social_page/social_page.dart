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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text("Social"),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 글자 색상 (선택사항)
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
