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

      // 이미 성공한 문제라면 바로 리턴
      if (currentState == 'successed') {
        Fluttertoast.showToast(
          msg: "You already solved this question.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        return;
      }

      // 경험치 및 스코어 계산
      int expGain = tier.bonusExp;
      int scoreGain = tier.bonusScore;

      // Syntax 카테고리 조건 적용
      if (question.category == 'syntax') {
        expGain *= 2; // 경험치 2배 증가
        scoreGain = 0; // Syntax는 스코어 추가 없음
      }

      if (isCorrect) {
        // 맞췄을 때
        updates['exp'] = progressData.exp + expGain;
        updates['score'] = progressData.score + scoreGain;
        updates['questionState'] = {
          ...progressData.questionState,
          questionId: 'successed',
        };

        Fluttertoast.showToast(
          msg: question.category == 'syntax'
              ? "Correct! Gained $expGain EXP."
              : "Correct! Gained $expGain EXP and $scoreGain scores.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (!question.solvers.contains(uid)) {
          final updatedSolvers = List<String>.from(question.solvers)..add(uid);
          final updatedQuestion = question.copyWith(solvers: updatedSolvers);
          await questionViewModel.updateQuestion(updatedQuestion);
        }
      } else {
        int scorePenalty = 0;

        if (question.category != 'syntax') {
          scorePenalty = (scoreGain * 2 / 5).floor();
          int newScore = progressData.score - scorePenalty;
          updates['score'] = newScore > 0 ? newScore : 0;
        }

        updates['questionState'] = {
          ...progressData.questionState,
          questionId: 'failed',
        };

        Fluttertoast.showToast(
          msg: question.category == 'syntax'
              ? "Wrong!"
              : "Wrong! Lost $scorePenalty scores.",
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
