import 'package:code_ground/src/pages/questions/question_state_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/app_info/setting_page.dart';
import 'package:code_ground/src/pages/app_info/about_page.dart';
import 'package:code_ground/src/pages/app_info/help_page.dart';
import 'package:code_ground/src/pages/app_info/faq_page.dart';

import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    final List<Map<String, dynamic>> learningMenuItems = [
      {
        'icon': Icons.check_circle,
        'text': 'Solved Questions',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionStatePage(),
            ),
          );
        },
      },
      {
        'icon': Icons.error,
        'text': 'Failed Questions',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionStatePage(),
            ),
          );
        },
      },
    ];

    /// Menu items for the profile page
    final List<Map<String, dynamic>> appMenuItems = [
      {
        'icon': Icons.settings,
        'text': 'Setting',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPage(
                nickname:
                    userViewModel.userData?.nickname ?? 'Guest', //이부분 확인해야함.
                isAdmin: userViewModel.userData?.isAdmin ?? false,
                initialNickname: '',
              ),
            ),
          );
        },
      },
      {
        'icon': Icons.info,
        'text': 'About',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutPage(),
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
              builder: (context) => const HelpPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.question_answer,
        'text': 'FAQ',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FAQPage(),
            ),
          );
        },
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
              /// User profile card with logout button
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
                      userViewModel.userData != null
                          ? (userViewModel.userData!.nickname.isNotEmpty
                              ? userViewModel.userData!.nickname
                              : userViewModel.userData!.name)
                          : 'Guest', // userData가 null일 경우 대체 텍스트
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

              /// Progress card showing level, experience, tier, and score
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
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: progressViewModel.progressData?.exp != null
                                ? (progressViewModel.progressData!.exp / 100)
                                : 0.0,
                          ),
                          duration:
                              const Duration(milliseconds: 500), // 애니메이션 지속 시간
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value, // 애니메이션 적용된 값
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              minHeight: 8.0,
                            );
                          },
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
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Learning Data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              ...learningMenuItems.map(
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

              const Divider(
                height: 50.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Application Data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              ...appMenuItems.map(
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
