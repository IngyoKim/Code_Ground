import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/components/common_list_tile.dart';
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
    return null;
  }

  Color? _getIconColor(String? state) {
    if (state == 'successed') return Colors.green;
    if (state == 'failed') return Colors.red;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final questionState = context
        .read<ProgressViewModel>()
        .progressData
        ?.questionState[question.questionId];

    final leadingIcon = _getLeadingIcon(questionState);
    final iconColor = _getIconColor(questionState);

    return CommonListTile(
      leading: leadingIcon != null
          ? Icon(leadingIcon, color: iconColor)
          : const SizedBox.shrink(),
      title: question.title,
      subtitle: question.languages.join(', '),
      trailing: Text(
        question.tier,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
