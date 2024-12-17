import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/level_data.dart';
import 'package:code_ground/src/utils/gettierimage.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class UserDetailPage {
  /// ignore_for_file: use_build_context_synchronously
  static void show(BuildContext context, String uid) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: Future.wait([
            userViewModel.fetchOtherUserData(uid),
            progressViewModel.fetchProgressData(uid),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = userViewModel.otherUserData;
            final progressData = progressViewModel.progressData;
            final levels = generateLevels();

            final currentLevel =
                getCurrentLevel(levels, progressData?.exp ?? 0);
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

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?.nickname ?? 'Guest',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(userData?.name ?? 'Enter your name'),
                            ],
                          ),

                          /// 티어 이미지와 정보
                          Column(
                            children: [
                              Image.asset(
                                getTierImage(progressData?.tier ?? 'Bronze'),
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

                      /// 경험치 바 및 정보
                      Column(
                        children: [
                          Text(
                            "Lv.${currentLevel.level} | ${progressData?.score ?? 0} score",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${progressData?.exp ?? 0} / ${nextLevel.requiredExp} EXP",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
