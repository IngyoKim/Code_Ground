import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/pages/app_info/setting_page.dart';
import 'package:code_ground/src/pages/app_info/about_page.dart';
import 'package:code_ground/src/pages/app_info/help_page.dart';
import 'package:code_ground/src/pages/app_info/faq_page.dart';
import 'package:code_ground/src/pages/questions/question_state_page.dart';

import 'package:code_ground/src/models/level_data.dart';
import 'package:code_ground/src/utils/gettierimage.dart';
import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/services/messaging/notifications.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 닉네임 수정 상태를 관리할 변수
  bool _isEditingNickname = false;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final userData = context.read<UserViewModel>().currentUserData;
    _nicknameController =
        TextEditingController(text: userData?.nickname ?? 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();

    final userData = userViewModel.currentUserData;
    final progressData = progressViewModel.progressData;
    final levels = generateLevels();

    final currentLevel = getCurrentLevel(levels, progressData?.exp ?? 0);
    final nextLevel = getNextLevel(levels, progressData?.exp ?? 0);

    final progress = progressData != null
        ? (progressData.exp - currentLevel.requiredExp) /
            (nextLevel.requiredExp - currentLevel.requiredExp)
                .clamp(1, double.infinity)
        : 0;
    final List<Map<String, dynamic>> learningMenuItems = [
      {
        'icon': Icons.check_circle,
        'iconColor': Colors.green.shade500,
        'text': 'Solved Questions',
        'color': Colors.grey.shade300,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionStatePage(state: 'successed'),
            ),
          );
        },
      },
      {
        'icon': Icons.error,
        'iconColor': Colors.red,
        'text': 'Failed Questions',
        'color': Colors.grey.shade300,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionStatePage(state: 'failed'),
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
                initialNickname: '',
                role: userData?.role ?? 'member',
                nickname: userData?.nickname ?? 'Guest',
                userData: userData,
                friendData: userData?.friendCode ?? '',
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
      {
        'icon': Icons.notifications,
        'text': 'Notifications Test',
        'onTap': () {
          FlutterLocalNotification.printCurrentTime();
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
                    title: _isEditingNickname
                        ? TextField(
                            controller: _nicknameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter new nickname',
                            ),
                          )
                        : Text(
                            userData?.nickname.isNotEmpty == true
                                ? userData!.nickname
                                : userData?.name ?? 'Guest',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    subtitle: Text(userData?.name ?? 'enter your name'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isEditingNickname)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditingNickname = true;
                              });
                            },
                          ),
                        if (_isEditingNickname)
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () async {
                              if (_nicknameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Nickname cannot be empty!')),
                                );
                                return;
                              }

                              // 닉네임 업데이트
                              await userViewModel
                                  .updateNickname(_nicknameController.text);

                              // 닉네임 변경 후 상태 갱신
                              setState(() {
                                _isEditingNickname = false;
                                _nicknameController.text =
                                    userViewModel.currentUserData?.nickname ??
                                        'Guest';
                              });
                            },
                          ),
                        ElevatedButton(
                          onPressed: () {
                            showLogoutDialog(context);
                          },
                          child: const Text("Logout"),
                        ),
                      ],
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Tier에 따라 다른 이미지 표시
                      Image.asset(
                        getTierImage(progressData?.tier),
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 8.0),
                      // Tier
                      Text(
                        "${progressData?.tier ?? 'Bronze'} ${progressData?.grade ?? 'V'}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      Text(
                        "Lv.${currentLevel.level} | ${progressData?.score ?? 0} score",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: LinearProgressIndicator(
                              value: progress.toDouble(),
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              minHeight: 8.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            progressData != null
                                ? "${progressData.exp}/${nextLevel.requiredExp}"
                                : "0/100",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      /// Learning menu items
                      const Divider(
                        height: 50.0,
                        color: Colors.grey,
                        thickness: 0.5,
                        endIndent: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: const Text(
                          "Learning Data",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...learningMenuItems.map(
                        (item) => Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: item['color'],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                              onPressed: item['onTap'],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item['icon'], color: item['iconColor']),
                                  const SizedBox(width: 10),
                                  Text(
                                    item['text'],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }
}
