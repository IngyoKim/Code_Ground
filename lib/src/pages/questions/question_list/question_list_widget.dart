import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class QuestionListWidget extends StatelessWidget {
  final QuestionData question;
  final VoidCallback onTap;

  const QuestionListWidget({
    super.key,
    required this.question,
    required this.onTap,
  });

  IconData? _getLeadingIcon(String? state) {
    if (state == 'successed') return Icons.check_circle;
    if (state == 'failed') return Icons.cancel;
    return Icons.help_outline; // 디폴트 아이콘
  }

  Color _getIconColor(String? state) {
    if (state == 'successed') return Colors.green;
    if (state == 'failed') return Colors.red;
    return Colors.grey;
  }

  String _getTierImagePath(String tier) {
    if (tier == 'Diamond') {
      return 'assets/images/Dia.png';
    }
    return 'assets/images/$tier.png';
  }

  @override
  Widget build(BuildContext context) {
    final questionState = context
        .read<ProgressViewModel>()
        .progressData
        ?.questionState[question.questionId];

    final leadingIcon = _getLeadingIcon(questionState);
    final iconColor = _getIconColor(questionState);

    return GestureDetector(
      onTap: onTap, // 페이지 이동 기능
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1), // 상단 구분선
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.transparent, // 배경 없애기
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 상태 아이콘
                Icon(
                  leadingIcon,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 12),

                // 제목과 언어 목록
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        question.languages.join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // 티어 이미지
                Image.asset(
                  _getTierImagePath(question.tier),
                  width: 32, // 이미지 너비
                  height: 32, // 이미지 높이
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 32,
                      color: Colors.grey,
                    ); // 이미지가 없을 경우 대체 아이콘 표시
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1), // 하단 구분선
        ],
      ),
    );
  }
}
