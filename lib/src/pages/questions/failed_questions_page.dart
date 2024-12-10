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
    final questionState = progressViewModel.questionState;

    setState(() {
      // 로그 추가: questionState 상태 확인
      print('Current questionState: $questionState');

      // allQuestions가 null일 경우 빈 리스트를 사용
      _failedQuestions = (progressViewModel.allQuestions ?? [])
          .cast<QuestionData>() // dynamic -> QuestionData로 변환
          .where((question) {
        // 로그 추가: 각 문제의 상태 확인
        print(
            'Checking question ${question.questionId} state: ${questionState[question.questionId]}');
        return questionState[question.questionId] == 'failed';
      }).toList();

      // 로그 추가: 최종 필터된 결과 확인
      print('Filtered failed questions: $_failedQuestions');
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
                    leading: const Icon(Icons.error, color: Colors.red),
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
                      // 탭 이벤트
                      debugPrint('Tapped on question: ${question.title}');
                    },
                  );
                },
              ),
      ),
    );
  }
}
