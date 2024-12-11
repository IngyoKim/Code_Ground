import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:code_ground/src/services/database/question_manager.dart';

class QuestionIdInput extends StatefulWidget {
  final TextEditingController controller;
  final String category;

  const QuestionIdInput({
    super.key,
    required this.controller,
    required this.category,
  });

  @override
  State<QuestionIdInput> createState() => _QuestionIdInputState();
}

class _QuestionIdInputState extends State<QuestionIdInput> {
  late String _categoryPrefix;

  @override
  void initState() {
    super.initState();
    _setCategoryPrefix();
  }

  @override
  void didUpdateWidget(covariant QuestionIdInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      _setCategoryPrefix();
      widget.controller.clear();
    }
  }

  void _setCategoryPrefix() {
    _categoryPrefix = QuestionManager.getPrefix(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5), // 최대 5자리 입력 제한
      ],
      decoration: InputDecoration(
        labelText: 'Question ID (optional)',
        hintText: 'Enter up to 5 digits (prefix: $_categoryPrefix)',
        prefixText: _categoryPrefix,
      ),
    );
  }
}
