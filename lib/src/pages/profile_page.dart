import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

/// 프로필 페이지
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // 위쪽 정렬
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 5, 15), // 카드 내부 여백 설정
            child: ListTile(
              leading: ClipOval(
                child: loginViewModel.user?.photoURL != null
                    ? Image.network(
                        loginViewModel.user!.photoURL!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 50,
                      ),
              ),
              title: Text(loginViewModel.user?.displayName ?? ''),
              subtitle: loginViewModel.user?.email != null
                  ? Text(loginViewModel.user!.email!)
                  : null,
              trailing: ElevatedButton(
                onPressed: () async {
                  debugPrint("로그아웃 버튼 눌림");
                  await loginViewModel.logout();
                },
                child: const Text("로그아웃"),
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(15.0), // 카드 내부 여백 설정
            child: Column(
              children: <Widget>[
                const Text(
                  "EXP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0), // EXP 텍스트와 바 사이 간격 추가
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
                  child: LinearProgressIndicator(
                    value: 0.7, // 경험치 비율 (0.0 - 1.0)
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8.0, // 바의 높이
                  ),
                ),
                const SizedBox(height: 8.0), // 바와 퍼센트 텍스트 사이 간격 추가
                const Text(
                  "70%", // 경험치 퍼센트 표시 (실제로는 동적으로 계산해서 넣을 수 있음)
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
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
