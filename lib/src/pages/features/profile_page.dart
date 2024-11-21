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
    final userViewModel = context.watch<UserViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();

    final userData = userViewModel.userData;
    final progressData = progressViewModel.progressData;

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
              /// User profile card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    leading: ClipOval(
                      child: (userData?.photoUrl != null &&
                              userData!.photoUrl.isNotEmpty)
                          ? Image.network(
                              userData.photoUrl,
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
                      userData?.nickname.isNotEmpty == true
                          ? userData!.nickname
                          : userData?.name ?? 'Guest',
                    ),
                    subtitle: Text(userData?.email ?? 'No email available'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showLogoutDialog(context);
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ),
              ),

              /// Progress card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Level: ${progressData?.level ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: LinearProgressIndicator(
                          value: progressData?.exp != null
                              ? (progressData!.exp / 100)
                              : 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 8.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        progressData != null
                            ? "EXP: ${progressData.exp}/100"
                            : "EXP: 0/100",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Tier: ${progressData?.tier ?? 'Bronze'} ${progressData?.grade ?? 'V'}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Score: ${progressData?.score ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Learning menu items
              const Divider(
                height: 50.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Learning Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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

              /// Application menu items
              const Divider(
                height: 50.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Application Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
