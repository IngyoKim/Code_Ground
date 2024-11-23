import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionListWidget extends StatelessWidget {
  final QuestionData question;
  final bool? questionState;
  final VoidCallback onTap;

  const QuestionListWidget({
    super.key,
    required this.question,
    required this.questionState,
    required this.onTap,
  });

  IconData? _getLeadingIcon(bool? state) {
    if (state == true) return Icons.check_circle;
    if (state == false) return Icons.cancel;
    return null;
  }

  Color? _getIconColor(bool? state) {
    if (state == true) return Colors.green;
    if (state == false) return Colors.red;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final leadingIcon = _getLeadingIcon(questionState);
    final iconColor = _getIconColor(questionState);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading:
            leadingIcon != null ? Icon(leadingIcon, color: iconColor) : null,
        tileColor: Colors.blueGrey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          question.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          question.languages.join(', '),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: Text(question.tier),
        onTap: onTap,
      ),
    );
  }
}
