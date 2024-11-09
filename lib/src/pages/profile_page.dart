import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/login_page_model.dart';

/// 프로필 페이지
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final loginPageModel = Provider.of<LoginPageModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // 위쪽 정렬
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: ClipOval(
            child: Image.network(
              loginPageModel.user?.photoURL ??
                  '', // 프로필 이미지 URL, 프로필이 없으면 빈 문자열 사용
              width: 50, // 원하는 너비 설정
              height: 50, // 원하는 높이 설정
              cacheHeight: 50,
              cacheWidth: 50,
              fit: BoxFit.cover, // 이미지를 박스에 맞춰 잘라냄
            ),
          ),
          title: Text(loginPageModel.user!.displayName ?? ''),
          subtitle: loginPageModel.user?.email != null
              ? Text(loginPageModel.user!.email!)
              : null,
          trailing: ElevatedButton(
            onPressed: () async {
              debugPrint("로그아웃 버튼 눌림");
              await loginPageModel.logout();
            },
            child: const Text("로그아웃"),
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
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                "Tier", // 텍스트 내용
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
