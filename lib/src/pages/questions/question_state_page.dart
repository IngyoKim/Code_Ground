//import 'package:code_ground/src/pages/questions/failed_questions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/components/loading_indicator.dart'; // LoadingIndicator 임포트

class QuestionStatePage extends StatefulWidget {
  final String state; // 'successed' or 'failed'

  const QuestionStatePage({super.key, required this.state});

  @override
  State<QuestionStatePage> createState() => _QuestionStatePageState();
}

class _QuestionStatePageState extends State<QuestionStatePage> {
  bool _isLoading = true;
  bool _isAscending = true; // 정렬 순서를 관리하는 상태 변수

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<ProgressViewModel>(context, listen: false)
        .fetchProgressData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.state == 'successed'
            ? 'Solved Questions'
            : 'Failed Questions'),
        actions: [
          IconButton(
            icon:
                Icon(_isAscending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending; // 정렬 순서 변경
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          LoadingIndicator(isFetching: _isLoading), // LoadingIndicator 사용
          Expanded(
            child: Consumer<ProgressViewModel>(
              builder: (context, progressViewModel, child) {
                if (_isLoading) return const SizedBox.shrink();

                final progressData = progressViewModel.progressData;

                if (progressData == null ||
                    progressData.questionState.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${widget.state} questions found.',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final filteredQuestions = progressData.questionState.entries
                    .where((entry) => widget.state == 'successed'
                        ? entry.value == 'successed'
                        : entry.value != 'successed')
                    .map((entry) => entry.key)
                    .toList();

                // 정렬: questionId를 기준으로 정렬 (오름차순 또는 내림차순)
                filteredQuestions.sort(
                    (a, b) => _isAscending ? a.compareTo(b) : b.compareTo(a));

                if (filteredQuestions.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${widget.state} questions found.',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredQuestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredQuestions[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
