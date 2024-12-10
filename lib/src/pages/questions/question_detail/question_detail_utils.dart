import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:code_ground/src/models/tier_data.dart';
import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class QuestionDetailUtil {
  static bool verifyAnswer(dynamic userAnswer, QuestionData question) {
    if (question.questionType != 'Sequencing') {
      return userAnswer.toString().trim() == question.answer?.toString().trim();
    }

    final userAnswerList = userAnswer as List<String>;

    final correctAnswerList = question.codeSnippets.keys.toList()..sort();

    debugPrint("User Answer: $userAnswerList");
    debugPrint("Correct Answer: $correctAnswerList");

    return ListEquality().equals(userAnswerList, correctAnswerList);
  }

  /// 답변 결과 표시 및 Progress 업데이트
  static Future<void> showAnswerResult(
    BuildContext context,
    bool isCorrect,
  ) async {
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    final question = questionViewModel.selectedQuestion;
    final uid = progressViewModel.progressData?.uid;

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

    if (uid == null) {
      Fluttertoast.showToast(
        msg: "Error: User not found.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      await progressViewModel.fetchProgressData();
      final progressData = progressViewModel.progressData;

      if (progressData == null) {
        Fluttertoast.showToast(
          msg: "Error: Progress data not found.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final tier = Tier.getTierByName(question.tier);
      if (tier == null) {
        Fluttertoast.showToast(
          msg: "Error: Invalid tier in question.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final questionId = question.questionId;
      final currentState = progressData.questionState[questionId] ?? '';
      final updates = <String, dynamic>{};

      if (currentState == 'correct') {
        Fluttertoast.showToast(
          msg: "You already solved this question.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        return;
      }

      if (isCorrect) {
        final expGain = tier.bonusExp;
        final scoreGain = tier.bonusScore;

        updates['exp'] = progressData.exp + expGain;
        updates['score'] = progressData.score + scoreGain;
        updates['questionState'] = {
          ...progressData.questionState,
          questionId: 'successed',
        };

        Fluttertoast.showToast(
          msg: "Correct! Gained $expGain EXP and $scoreGain points.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // 유저가 이미 solvers에 없으면 추가
        if (!question.solvers.contains(uid)) {
          final updatedSolvers = List<String>.from(question.solvers)..add(uid);
          final updatedQuestion = question.copyWith(solvers: updatedSolvers);
          await questionViewModel.updateQuestion(updatedQuestion);
        }
      } else {
        updates['questionState'] = {
          ...progressData.questionState,
          questionId: 'failed',
        };

        Fluttertoast.showToast(
          msg: "Wrong! Try Again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      if (updates.isNotEmpty) {
        await progressViewModel.updateProgressData(updates);
      }
    } catch (error) {
      debugPrint("Error updating progress: $error");
      Fluttertoast.showToast(
        msg: "Error updating progress.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
