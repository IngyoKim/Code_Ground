import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:collection/collection.dart'; // ListEquality 사용을 위한 import

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

void showAnswerResult(BuildContext context, bool isCorrect) {
  final progressViewModel =
      Provider.of<ProgressViewModel>(context, listen: false);
  final questionViewModel =
      Provider.of<QuestionViewModel>(context, listen: false);
  final question = questionViewModel.selectedQuestion;

  // 정답 여부 표시
  Fluttertoast.showToast(
    msg: isCorrect ? "Correct!" : "Wrong! Try Again.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isCorrect ? Colors.green : Colors.red,
    textColor: Colors.white,
  );

  // 디버깅 메시지: 문제 상태 확인
  final bool isAlreadyAnswered =
      progressViewModel.progressData?.questionState[question?.questionId] ??
          false;
  debugPrint("Question ID: ${question!.questionId}");
  debugPrint("Is Already Answered: $isAlreadyAnswered");
  debugPrint("Question Tier: ${question.tier}");

  if (isCorrect && !isAlreadyAnswered) {
    // 점수 및 경험치 추가

    final tier = Tier.getTierByName(question.tier!);

    progressViewModel.addExp(tier!.bonusExp);
    progressViewModel.addScore(tier.bonusScore);

    // 경험치와 점수 상승치를 표시
    Fluttertoast.showToast(
      msg:
          "You've earned +${tier.bonusExp} EXP and +${tier.bonusScore} points!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    debugPrint(
        "Added ${tier.bonusExp} EXP and ${tier.bonusScore} points for question ID: ${question.questionId}");
    progressViewModel.updateQuestionState(question.questionId, true);
  } else if (isCorrect && isAlreadyAnswered) {
    // 이미 정답 처리된 경우 디버깅 메시지 출력
    debugPrint(
        "Question ID: ${question.questionId} has already been answered correctly.");
  } else {
    // 틀린 경우 상태 업데이트
    progressViewModel.updateQuestionState(question.questionId, false);
    debugPrint(
        "Updated question state to 'false' for Question ID: ${question.questionId}");
  }
}
