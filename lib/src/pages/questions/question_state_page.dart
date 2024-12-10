import 'package:code_ground/src/pages/questions/failed_questions_page.dart';
import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/questions/correct_question_page.dart';

class QuestionStatePage extends StatefulWidget {
  const QuestionStatePage({super.key});

  @override
  State<QuestionStatePage> createState() => _QuestionStatePageState();
}

class _QuestionStatePageState extends State<QuestionStatePage> {
  String? signal;
  bool _signalHandled = false; // signal 처리 여부를 추적

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ModalRoute.of(context)에서 signal 값을 가져옴
    signal = ModalRoute.of(context)?.settings.arguments as String?;
    _handleSignal(); // signal을 받으면 처리
  }

  void _handleSignal() {
    // signal이 null이 아니고, signal이 아직 처리되지 않은 경우에만 처리
    if (signal != null && !_signalHandled) {
      if (signal == 'Correct') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const CorrectQuestionsPage()),
          );
        });
      } else if (signal == 'Failed') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    const FailedQuestionsPage()), // Failed로 이동
          );
        });
      }

      // signal이 처리되었음을 표시
      _signalHandled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question State Page'),
      ),
      body: const Center(
        child: Text(
          'Waiting for signal...',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
