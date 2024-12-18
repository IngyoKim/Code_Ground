import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/services/ads/rewarded_ad_service.dart';

class QuestionHeader extends StatefulWidget {
  final QuestionData question;
  final UserData? writer;

  const QuestionHeader({super.key, required this.question, this.writer});

  @override
  State<QuestionHeader> createState() => _QuestionHeaderState();
}

class _QuestionHeaderState extends State<QuestionHeader> {
  bool _isHintLoading = false;
  bool _hasWatchedAd = false;

  void _fetchHint(RewardedAdService rewardedAdService) async {
    if (_hasWatchedAd) return;

    setState(() => _isHintLoading = true);

    try {
      if (rewardedAdService.isAdReady) {
        rewardedAdService.showRewardedAd(onRewardEarned: () {
          setState(() => _hasWatchedAd = true);
          ToastMessage.show('광고 시청 완료! 힌트를 확인하세요.');
        });
      } else {
        ToastMessage.show('광고가 아직 준비되지 않았습니다.');
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastMessage.show('힌트를 가져오는 데 실패했습니다.');
    } finally {
      setState(() => _isHintLoading = false); // 로딩 종료
    }
  }

  void _showHintDialog(String hint) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('힌트'),
          content: Text(hint),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasHint =
        widget.question.hint != null && widget.question.hint!.isNotEmpty;

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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 날짜와 작성자
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(widget.question.updatedAt),
                    ),
                    Text(
                      widget.writer?.nickname ?? 'unknown',
                    ),
                  ],
                ),

                // 광고 보기 버튼
                if (hasHint)
                  ElevatedButton(
                    onPressed: _isHintLoading
                        ? null
                        : () {
                            if (_hasWatchedAd) {
                              _showHintDialog(widget.question.hint!);
                            } else {
                              _fetchHint(rewardedAdService);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    child: _isHintLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _hasWatchedAd ? '힌트 보기' : '광고 보고 힌트 보기',
                            style: const TextStyle(color: Colors.black),
                          ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              widget.question.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
          ],
        );
      },
    );
  }
}
