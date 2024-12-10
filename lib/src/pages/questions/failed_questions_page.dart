import 'package:code_ground/src/components/common_list_tile.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FailedQuestionsPage extends StatefulWidget {
  const FailedQuestionsPage({super.key});

  @override
  State<FailedQuestionsPage> createState() => _FailedQuestionsPageState();
}

class _FailedQuestionsPageState extends State<FailedQuestionsPage> {
  late List<QuestionData> _failedQuestions;

  @override
  void initState() {
    super.initState();
    _failedQuestions = [];
    _filterFailedQuestions(); // 초기 필터링
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterFailedQuestions(); // 상태가 변경될 때마다 필터링
  }

  void _filterFailedQuestions() {
    final progressViewModel = context.read<ProgressViewModel>();
    final questionState = progressViewModel.progressData?.questionState ?? {};

    setState(() {
      // allQuestions가 null일 경우 빈 리스트를 사용
      _failedQuestions = (progressViewModel.allQuestions ?? [])
          .cast<QuestionData>()
          .where((question) {
        return questionState[question.questionId] == 'failed'; // 실패한 문제만 필터링
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기 버튼을 눌렀을 때 실행될 코드
        Navigator.pop(context); // 현재 페이지를 뒤로 가기
        return true; // 기본 동작을 허용
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Failed Questions'),
        ),
        body: _failedQuestions.isEmpty
            ? const Center(
                child: Text(
                  'No failed questions yet.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _failedQuestions.length,
                itemBuilder: (context, index) {
                  final question = _failedQuestions[index];
                  return CommonListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: question.title,
                    subtitle: question.languages.join(', '),
                    trailing: Text(
                      question.tier,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      debugPrint('Tapped on question: ${question.title}');
                    },
                  );
                },
              ),
      ),
    );
  }
}
