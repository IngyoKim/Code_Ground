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
        appBar: AppBar(
          title: const Text("Social"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Ranking",
              ),
              Tab(
                text: "Friends",
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 슬라이드 금지
          children: const [
            RankingPage(), // 랭킹 페이지
            RegistrateFriends(), // 친구 관리 페이지
          ],
        ),
      ),
    );
  }
}
