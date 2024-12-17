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

  @override
  Widget build(BuildContext context) {
    final questionState = context
        .read<ProgressViewModel>()
        .progressData
        ?.questionState[question.questionId];

    final leadingIcon = _getLeadingIcon(questionState);
    final iconColor = _getIconColor(questionState);

    return Column(
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

              // 티어 배지
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  question.tier,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1), // 하단 구분선
      ],
    );
  }
}
