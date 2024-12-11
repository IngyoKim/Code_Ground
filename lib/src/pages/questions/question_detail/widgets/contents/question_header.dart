import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 추가

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/services/ads/rewarded_ad_service.dart';

class QuestionHeader extends StatefulWidget {
  final QuestionData question;
  final UserData? writer;

  const QuestionHeader({super.key, required this.question, this.writer});

  @override
  State<QuestionHeader> createState() => _QuestionHeaderState();
}

class _QuestionHeaderState extends State<QuestionHeader> {
  @override
  void dispose() {
    Provider.of<RewardedAdService>(context, listen: false).dispose();
    super.dispose();
  }

  void _showHintAd() {
    final rewardedAdService =
        Provider.of<RewardedAdService>(context, listen: false);
    if (rewardedAdService.isAdReady) {
      rewardedAdService.showRewardedAd(onRewardEarned: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('힌트가 지급되었습니다!')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('광고가 아직 준비되지 않았습니다. 잠시 후 다시 시도해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RewardedAdService>(
      builder: (context, rewardedAdService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.question.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: rewardedAdService.isAdReady ? _showHintAd : null,
                  child: rewardedAdService.isAdReady
                      ? const Text('힌트 보기')
                      : const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "${widget.writer?.nickname ?? 'unknown'} / ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.question.updatedAt)}",
            ),
            const SizedBox(height: 16),
            Text(
              widget.question.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}
