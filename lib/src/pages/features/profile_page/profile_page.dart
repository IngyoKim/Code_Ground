import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/level_data.dart';
import 'package:code_ground/src/utils/gettierimage.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

import 'package:code_ground/src/pages/questions/question_state_page.dart';
import 'package:code_ground/src/pages/features/profile_page/open_app_info.dart';

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
              openAppInfo(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (userData?.photoUrl != null &&
                      userData!.photoUrl.isNotEmpty)
                    Image.network(
                      userData.photoUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: Colors.blue.shade100),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Center(
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
                ],
              ),
            ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                            hintText: '새로운 닉네임',
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              12,
                                            ),
                                          ],
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
                      '문제 풀이 현황',
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
                                '푼 문제',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                                '실패한 문제',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
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
