import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/add_question.dart';
import 'package:code_ground/src/pages/question_list_page.dart';

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
              builder: (context) => QuestionListPage(),
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
              builder: (context) => AddQuestion(),
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
              // 기존 UI의 프로필 정보 및 로그아웃 버튼
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                    title: Text(userViewModel.userData?.name ?? ''),
                    subtitle: userViewModel.userData?.email != null &&
                            userViewModel.userData?.email != ''
                        ? Text(userViewModel.userData!.email)
                        : null,
                    trailing: ElevatedButton(
                      onPressed: () {
                        showLogoutDialog(context);
                      },
                      child: const Text("로그아웃"),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${progressViewModel.progressData?.level ?? 0}",
                        style: TextStyle(
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
                            ? "${((progressViewModel.progressData!.exp / 100) * 100).toInt()}%"
                            : "0%",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
