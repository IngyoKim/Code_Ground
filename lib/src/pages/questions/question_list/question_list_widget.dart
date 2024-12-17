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
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상태 아이콘
              Icon(
                leadingIcon,
                color: iconColor,
                size: 32,
              ),
              const SizedBox(width: 16),

              // 제목과 언어 목록
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.languages.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),

              // 티어 이미지 (배경 제거)
              Image.asset(
                _getTierImagePath(question.tier),
                width: 36,
                height: 36,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 36,
                    color: Colors.grey,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
