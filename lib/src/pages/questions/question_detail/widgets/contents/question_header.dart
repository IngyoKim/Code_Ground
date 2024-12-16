import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/services/ads/rewarded_ad_service.dart';
import 'package:code_ground/src/utils/toast_message.dart'; // ToastMessage 임포트

class QuestionHeader extends StatefulWidget {
  final QuestionData question;
  final UserData? writer;

  const QuestionHeader({super.key, required this.question, this.writer});

  @override
  State<QuestionHeader> createState() => _QuestionHeaderState();
}

class _QuestionHeaderState extends State<QuestionHeader> {
  bool _isHintLoading = false; // 버튼 로딩 상태
  bool _hasWatchedAd = false; // 광고 시청 상태

  void _fetchHint(RewardedAdService rewardedAdService) async {
    if (_hasWatchedAd) {
      // 이미 광고를 본 상태라면 바로 힌트 표시
      ToastMessage.show('힌트를 확인하세요!');
      return;
    }

    setState(() => _isHintLoading = true); // 로딩 시작

    try {
      if (rewardedAdService.isAdReady) {
        rewardedAdService.showRewardedAd(onRewardEarned: () {
          setState(() => _hasWatchedAd = true); // 광고 시청 완료 상태 설정
          ToastMessage.show('힌트를 확인하세요!');
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
                if (hasHint)
                  ElevatedButton(
                    onPressed: _isHintLoading
                        ? null
                        : () => _fetchHint(rewardedAdService),
                    child: _isHintLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_hasWatchedAd ? '힌트 보기' : '광고 보고 힌트 보기'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(widget.question.updatedAt),
            ),
            Text(
              widget.writer?.nickname ?? 'unknown',
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
