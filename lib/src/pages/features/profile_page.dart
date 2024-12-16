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
              ListTile(
                leading: const Icon(Icons.power_off),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showLogoutDialog(context);
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

    double safeProgress(double value) {
      if (value.isNaN || value.isInfinite) {
        return 0.0;
      }
      return value;
    }

    final progress = safeProgress(progressData != null &&
            nextLevel.requiredExp != currentLevel.requiredExp
        ? (progressData.exp - currentLevel.requiredExp) /
            (nextLevel.requiredExp - currentLevel.requiredExp)
        : 0);

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
        child: Column(
          children: [
            // 파란색 상단 영역
            Container(
              color: Colors.blue.shade100,
              height: 200,
              child: Center(
                child: ClipOval(
                  child: userData?.photoUrl != null &&
                          userData!.photoUrl.isNotEmpty
                      ? Image.network(
                          userData.photoUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person,
                          size: 100, color: Colors.white),
                ),
              ),
            ),

            // 하얀색 카드 영역
            Card(
              margin: const EdgeInsets.all(16.0),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 닉네임과 티어 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 닉네임과 수정 버튼
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _isEditingNickname
                                    ? SizedBox(
                                        width: 150,
                                        child: TextField(
                                          controller: _nicknameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter new nickname',
                                          ),
                                        ),
                                      )
                                    : Text(
                                        userData?.nickname ?? 'Guest',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                const SizedBox(width: 8), // 간격 추가
                                if (!_isEditingNickname)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        _nicknameController.text =
                                            userData?.nickname ?? 'Guest';
                                        _isEditingNickname = true;
                                      });
                                    },
                                  ),
                                if (_isEditingNickname)
                                  IconButton(
                                    icon: const Icon(Icons.check),
                                    onPressed: () async {
                                      if (_nicknameController.text.isNotEmpty) {
                                        await userViewModel.updateNickname(
                                            _nicknameController.text);
                                        setState(
                                            () => _isEditingNickname = false);
                                      }
                                    },
                                  ),
                              ],
                            ),
                            Text(userData?.name ?? 'Enter your name'),
                          ],
                        ),

                        // 티어 이미지와 정보
                        Column(
                          children: [
                            Image.asset(
                              getTierImage(progressData?.tier),
                              width: 80,
                              height: 80,
                            ),
                            Text(
                                "${progressData?.tier ?? 'Bronze'} ${progressData?.grade ?? 'V'}"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 레벨, 스코어, 진행 상태바
                    Column(
                      children: [
                        Text(
                            "Lv.${currentLevel.level} | ${progressData?.score ?? 0} score"),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress.toDouble(),
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "${progressData?.exp ?? 0}/${nextLevel.requiredExp} EXP"),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Questions Status',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QuestionStatePage(
                                      state: 'successed'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle,
                                color: Colors.green),
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Solved Questions',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // 버튼 사이 간격
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const QuestionStatePage(state: 'failed'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.error, color: Colors.red),
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Failed Questions',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
