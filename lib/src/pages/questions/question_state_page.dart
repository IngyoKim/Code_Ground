import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/pages/questions/question_detail/question_detail_page.dart';

class QuestionStatePage extends StatefulWidget {
  final String state; // 'successed' or 'failed'

  const QuestionStatePage({super.key, required this.state});

  @override
  State<QuestionStatePage> createState() => _QuestionStatePageState();
}

class _QuestionStatePageState extends State<QuestionStatePage> {
  bool _isLoading = true;
  bool _isAscending = true;

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
                _isAscending = !_isAscending;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          LoadingIndicator(isFetching: _isLoading),
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
                    final questionId = filteredQuestions[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 3),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            widget.state == 'successed'
                                ? Icons.check_circle
                                : Icons.error,
                            color: widget.state == 'successed'
                                ? Colors.green
                                : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            questionId,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final questionViewModel =
                            Provider.of<QuestionViewModel>(context,
                                listen: false);

                        await questionViewModel.fetchQuestionById(questionId);

                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionDetailPage(),
                          ),
                        );
                      },
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
