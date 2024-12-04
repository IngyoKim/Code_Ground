import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/friend_page.dart';
import 'package:code_ground/src/pages/ranking_page.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Social"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.leaderboard),
                text: "Ranking",
              ),
              Tab(
                icon: Icon(Icons.group),
                text: "Friends",
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 슬라이드 금지
          children: const [
            RankingPage(), // 랭킹 페이지
            RegistrateFriend(), // 친구 관리 페이지
          ],
        ),
      ),
    );
  }
}
