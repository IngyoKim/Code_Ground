import 'package:flutter/material.dart';
import 'package:oss_qbank/src/pages/base_page.dart';
import 'package:provider/provider.dart';

import '../view_models/login_page_model.dart';

/// 프로필 페이지
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            // leading: Consumer<LoginPageModel>(
            //   builder: (context, loginPageModel, child) {
            //     // 프로필 이미지 URL을 가져옴
            //     final profileImageUrl = loginPageModel
            //             .user?.kakaoAccount?.profile?.profileImageUrl ??
            //         '';

            //     return ClipOval(
            //       child: Image.network(
            //         profileImageUrl, // 프로필 이미지 URL, 프로필이 없으면 빈 문자열 사용
            //         width: 50, // 원하는 너비 설정
            //         height: 50, // 원하는 높이 설정
            //         cacheHeight: 50,
            //         cacheWidth: 50,
            //         fit: BoxFit.cover, // 이미지를 박스에 맞춰 잘라냄
            //       ),
            //     );
            //   },
            // ),
            // title: Consumer<LoginPageModel>(
            //   builder: (context, loginPageModel, child) {
            //     return Text(
            //         loginPageModel.user?.kakaoAccount?.profile?.nickname ?? '');
            //   },
            // ),
            // subtitle: Consumer<LoginPageModel>(
            //   builder: (context, loginPageModel, child) {
            //     return Text(loginPageModel.user?.kakaoAccount?.email ??
            //         'email is not found.');
            //   },
            // ),
            trailing: Consumer<LoginPageModel>(
              builder: (context, loginPageModel, child) {
                return ElevatedButton(
                  onPressed: () {
                    loginPageModel.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BasePage()),
                    );
                  },
                  child: const Text("로그아웃"),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.grey, // 구분선 색상
            thickness: 1, // 구분선 두께
            indent: 16.0, // 구분선 시작 지점 여백
            endIndent: 16.0, // 구분선 끝 지점 여백
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0), // 둥근 모서리 반경 설정
            child: Container(
              height: 200,
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Text(
                  "Tier", // 텍스트 내용
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
