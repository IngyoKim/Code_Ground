import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class QuestionIdInput extends StatefulWidget {
  final TextEditingController controller;
  final String categoryPrefix;

  const QuestionIdInput(
      {super.key, required this.controller, required this.categoryPrefix});

  @override
  State<QuestionIdInput> createState() => _QuestionIdInputState();
}

class _QuestionIdInputState extends State<QuestionIdInput> {
  int _sequenceNumber = 1; // 순차적으로 증가할 번호
  bool _isChecking = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.controller.text = '${widget.categoryPrefix}001';
  }

  Future<void> _validateAndGenerateId(String input) async {
    setState(() {
      _errorMessage = '';
      _isChecking = true;
    });

    String baseId = widget.categoryPrefix + input.padRight(3, '0');

    // 중복 확인 및 새로운 ID 생성
    while (await Provider.of<QuestionViewModel>(context, listen: false)
        .doesQuestionIdExist(baseId)) {
      _sequenceNumber++;
      baseId =
          widget.categoryPrefix + _sequenceNumber.toString().padLeft(5, '0');
    }

    setState(() {
      widget.controller.text = baseId;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
            LengthLimitingTextInputFormatter(6), // 최대 6자리 입력
          ],
          decoration: const InputDecoration(
            labelText: 'Question ID (optional)',
            hintText: 'Enter up to 5 digits (prefix auto-added)',
          ),
          onChanged: (value) {
            if (value.length <= 5) {
              _validateAndGenerateId(value);
            } else {
              setState(() {
                _errorMessage = 'ID cannot exceed 6 digits';
              });
            }
          },
        ),
        if (_isChecking)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CircularProgressIndicator(),
          ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
