import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/pages/features/social_page/friends_page.dart';
import 'package:code_ground/src/pages/features/social_page/ranking/ranking_page.dart';
import 'package:code_ground/src/services/messaging/custom_url.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/services/messaging/kakao_messaging.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final KakaoMessaging kakaoMessaging = KakaoMessaging();
    final userViewModel = context.watch<UserViewModel>();
    final userData = userViewModel.currentUserData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("소셜"),
        actions: [
          if (_tabController.index == 1)

            /// Friends 탭이 선택되었을 때만 아이콘 표시
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                /// 여기에 버튼 동작을 추가
                final inviteUrl = await createCustomLink(userData!.uid);
                await kakaoMessaging.shareContent(
                    userData.nickname, inviteUrl, userData.friendCode);
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "랭킹"),
            Tab(text: "친구"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          RankingPage(),
          RegistrateFriends(),
        ],
      ),
    );
  }
}
