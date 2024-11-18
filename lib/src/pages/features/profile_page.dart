import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/questions/add_question.dart';
import 'package:code_ground/src/pages/questions/question_list_page.dart';

import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.settings,
        'text': 'Setting',
        'onTap': () => context.read<ProgressViewModel>().addExp(10),
      },
      {
        'icon': Icons.info,
        'text': 'About',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionListPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.help,
        'text': 'Help',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddQuestionPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.question_answer,
        'text': 'FAQ',
        'onTap': () => progressViewModel.addScore(100),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('My Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              // 사용자 프로필 정보 및 로그아웃
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    leading: ClipOval(
                      child: userViewModel.userData?.profileImageUrl != null
                          ? Image.network(
                              userViewModel.userData!.profileImageUrl,
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
                    title: Text(
                      userViewModel.userData?.nickname != ''
                          ? userViewModel.userData!.nickname
                          : userViewModel.userData!.name,
                    ),
                    subtitle: Text(userViewModel.userData?.name ?? ''),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showLogoutDialog(context);
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ),
              ),
              // 진행 상태 카드 (레벨, 경험치, 티어, 등급, 점수)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Level: ${progressViewModel.progressData?.level ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: LinearProgressIndicator(
                          value: progressViewModel.progressData?.exp != null
                              ? (progressViewModel.progressData!.exp / 100)
                              : 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 8.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        progressViewModel.progressData?.exp != null
                            ? "EXP: ${progressViewModel.progressData!.exp}/100"
                            : "EXP: 0/100",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Tier: ${progressViewModel.progressData?.tier ?? 'Bronze'} ${progressViewModel.progressData?.grade ?? 'V'}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Score: ${progressViewModel.progressData?.score ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 50.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: 20.0,
              ),
              // 메뉴 아이템
              ...menuItems.map(
                (item) => Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        item['icon'],
                        color: Colors.black,
                      ),
                      title: Text(item['text']),
                      onTap: item['onTap'],
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                      height: 10.0,
                      color: Colors.grey,
                      thickness: 0.5,
                      endIndent: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
