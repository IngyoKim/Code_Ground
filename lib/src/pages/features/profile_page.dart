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
  bool _isEditingNickname = false;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final userData = context.read<UserViewModel>().currentUserData;
    _nicknameController =
        TextEditingController(text: userData?.nickname ?? 'Guest');
  }

  /// Application Data를 표시하는 BottomSheet
  void _showApplicationData(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Application Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Setting'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(
                        initialNickname: '',
                        role: context
                                .read<UserViewModel>()
                                .currentUserData
                                ?.role ??
                            'member',
                        nickname: context
                                .read<UserViewModel>()
                                .currentUserData
                                ?.nickname ??
                            'Guest',
                        userData: context.read<UserViewModel>().currentUserData,
                        friendData: context
                                .read<UserViewModel>()
                                .currentUserData
                                ?.friendCode ??
                            '',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_answer),
                title: const Text('FAQ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FAQPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications Test'),
                onTap: () {
                  Navigator.pop(context);
                  FlutterLocalNotification.printCurrentTime();
                },
              ),
            ],
          ),
        );
      },
    );
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('My Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showApplicationData(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// User profile card
            /// User profile card
            Card(
              color: Colors.grey.shade100, // 밝은 회색 배경 설정
              elevation: 2,
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
                      : const Icon(Icons.person, color: Colors.grey, size: 50),
                ),
                title: _isEditingNickname
                    ? TextField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter new nickname',
                        ),
                      )
                    : Text(
                        userData?.nickname ?? 'Guest',
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                subtitle: Text(userData?.name ?? 'Enter your name'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isEditingNickname)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _nicknameController.text =
                                userData?.nickname ?? 'Guest'; // 현재 닉네임 설정
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
                                  content: Text('Nickname cannot be empty!')),
                            );
                            return;
                          }

                          await userViewModel
                              .updateNickname(_nicknameController.text);
                          setState(() {
                            _isEditingNickname = false;
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

            /// Progress card
            Card(
              color: Colors.grey.shade100,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Image.asset(
                      getTierImage(progressData?.tier),
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                        "${progressData?.tier ?? 'Bronze'} ${progressData?.grade ?? 'V'}"),
                    Text(
                        "Lv.${currentLevel.level} | ${progressData?.score ?? 0} score"),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: LinearProgressIndicator(
                        value: progress.toDouble(),
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 8.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text("${progressData?.exp ?? 0}/${nextLevel.requiredExp}"),
                  ],
                ),
              ),
            ),

            /// Learning menu items
            const SizedBox(height: 20),
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
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
