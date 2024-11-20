import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

/// 로딩 스피너를 숨기는 유틸리티 함수
void hideLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

bool verifyAnswer(dynamic userAnswer, QuestionData question) {
  if (question.questionType != 'Sequencing') {
    return userAnswer.toString().trim() == question.answer.toString().trim();
  }
  // Sequencing의 경우 배열 비교
  final userAnswerList = userAnswer as List<int>;
  final correctAnswerList =
      question.codeSnippets.keys.map((key) => int.parse(key)).toList();

  // 디버깅용 출력
  debugPrint("User Answer: $userAnswerList");
  debugPrint("Correct Answer: $correctAnswerList");

  return ListEquality().equals(userAnswerList, correctAnswerList);
}

void showAnswerResult(BuildContext context, bool isCorrect) async {
  final progressViewModel =
      Provider.of<ProgressViewModel>(context, listen: false);
  final questionViewModel =
      Provider.of<QuestionViewModel>(context, listen: false);
  final question = questionViewModel.selectedQuestion;

  if (question == null) {
    Fluttertoast.showToast(
      msg: "Error: Question not found.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return;
  }

  showLoading(context);

  try {
    Fluttertoast.showToast(
      msg: isCorrect ? "Correct!" : "Wrong! Try Again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      textColor: Colors.white,
    );

    final bool isAlreadyAnswered =
        progressViewModel.progressData?.questionState[question.questionId] ??
            false;

    if (isCorrect && !isAlreadyAnswered) {
      final tier = Tier.getTierByName(question.tier!);

      progressViewModel.addExp(tier!.bonusExp);
      progressViewModel.addScore(tier.bonusScore);

      Fluttertoast.showToast(
        msg:
            "You've earned +${tier.bonusExp} EXP and +${tier.bonusScore} points!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      progressViewModel.updateQuestionState(question.questionId, true);
    } else if (isCorrect && isAlreadyAnswered) {
      debugPrint("Question ID: ${question.questionId} already answered.");
    } else {
      progressViewModel.updateQuestionState(question.questionId, false);
      debugPrint(
          "Updated question state to 'false' for Question ID: ${question.questionId}");
    }
  } finally {
    hideLoading(context);
  }
}
