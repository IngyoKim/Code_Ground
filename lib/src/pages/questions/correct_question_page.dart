import 'package:code_ground/src/components/common_list_tile.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CorrectQuestionsPage extends StatefulWidget {
  const CorrectQuestionsPage({super.key});

  @override
  State<CorrectQuestionsPage> createState() => _CorrectQuestionsPageState();
}

class _CorrectQuestionsPageState extends State<CorrectQuestionsPage> {
  late List<QuestionData> _correctQuestions;

  @override
  void initState() {
    super.initState();
    _correctQuestions = [];
    _filterCorrectQuestions(); // 초기 필터링
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterCorrectQuestions(); // 상태가 변경될 때마다 필터링
  }

//여기로 돌아오기
  void _filterCorrectQuestions() {
    final progressViewModel = context.read<ProgressViewModel>();
    final questionState = progressViewModel.progressData?.questionState ?? {};

    setState(() {
      // allQuestions가 null일 경우 빈 리스트를 사용
      _correctQuestions = (progressViewModel.allQuestions ?? [])
          .cast<QuestionData>() // dynamic -> QuestionData로 변환
          .where((question) {
        return questionState[question.questionId] == 'correct';
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
          title: const Text('Correct Questions'),
        ),
        body: _correctQuestions.isEmpty
            ? const Center(
                child: Text(
                  'No correct questions yet.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _correctQuestions.length,
                itemBuilder: (context, index) {
                  final question = _correctQuestions[index];
                  return CommonListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.green),
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
