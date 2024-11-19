import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/add_question_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/add_question_widgets/title_input.dart';
import 'package:code_ground/src/components/add_question_widgets/description_input.dart';
import 'package:code_ground/src/components/add_question_widgets/category_input.dart';
import 'package:code_ground/src/components/add_question_widgets/question_type_input.dart';
import 'package:code_ground/src/components/add_question_widgets/language_input.dart'; // LanguageInput 추가
import 'package:code_ground/src/components/add_question_widgets/code_snippet_input.dart';
import 'package:code_ground/src/components/add_question_widgets/subjective_input.dart';
import 'package:code_ground/src/components/add_question_widgets/objective_answer_input.dart';
import 'package:code_ground/src/components/add_question_widgets/hint_input.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hintController = TextEditingController();
  final _codeSnippetController = TextEditingController();
  final _subjectiveAnswerController = TextEditingController();

  String _selectedCategory = 'Syntax';
  String _selectedType = 'Subjective'; // 주관식, 객관식, 순서 중 하나
  String _selectedLanguage = 'C'; // 선택된 언어
  final _codeSnippets = <String, String>{}; // Key값은 String
  final _answerChoices = <String>[];
  String? _selectedAnswer;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hintController.dispose();
    _codeSnippetController.dispose();
    _subjectiveAnswerController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    final user = Provider.of<UserViewModel>(context, listen: false).userData;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue.')),
      );
      return;
    }

    // Code Snippet 유효성 검사
    if (_codeSnippets.isEmpty ||
        !_codeSnippets.values.any((value) => value.isNotEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one valid Code Snippet.')),
      );
      return;
    }

    try {
      // Sequencing 카테고리의 경우 Key값을 숫자로 변환
      if (_selectedCategory == 'Sequencing') {
        final newCodeSnippets = <String, String>{};
        int index = 0;
        _codeSnippets.forEach((key, value) {
          if (value.isNotEmpty) {
            newCodeSnippets[index.toString()] = value;
            index++;
          }
        });
        _codeSnippets.clear();
        _codeSnippets.addAll(newCodeSnippets);
      }

      // CodeSnippet에서 언어 가져오기
      final selectedLanguage = _codeSnippets.keys.first;

      final question = prepareAddQuestionData(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        writerUid: user.userId,
        selectedCategory: _selectedCategory,
        selectedType: _selectedType,
        codeSnippets: _codeSnippets,
        selectedLanguage: selectedLanguage,
        title: _titleController.text,
        description: _descriptionController.text,
        hint: _hintController.text,
        answerChoices: _selectedType == 'Objective' ? _answerChoices : null,
        selectedAnswer: _selectedType == 'Objective' ? _selectedAnswer : null,
        subjectiveAnswer: _selectedType == 'Subjective'
            ? _subjectiveAnswerController.text
            : null,
      );

      await Provider.of<QuestionViewModel>(context, listen: false)
          .addQuestion(question);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully.')),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TitleInput(titleController: _titleController),
          DescriptionInput(descriptionController: _descriptionController),
          CategoryInput(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value!;
                _codeSnippets.clear();
                _answerChoices.clear();
                _selectedAnswer = null;

                // 카테고리 변경 시 질문 유형 강제 설정 및 필드 제어
                if (_selectedCategory == 'Blank') {
                  _selectedType = 'Objective';
                } else if (_selectedCategory == 'Output') {
                  _selectedType = 'Subjective';
                } else if (_selectedCategory == 'Sequencing') {
                  _selectedType = 'Sequencing';
                }
              });
            },
          ),
          QuestionTypeInput(
            selectedType: _selectedType,
            onTypeChanged: (value) => setState(() {
              _selectedType = value!;
            }),
          ),
          LanguageInput(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
          CodeSnippetInput(
            category: _selectedCategory,
            selectedLanguage: _selectedLanguage,
            codeSnippets: _codeSnippets,
            snippetController: _codeSnippetController,
            onAddSnippet: (key, snippet) {
              setState(() {
                if (_selectedCategory == 'Syntax') {
                  if (_codeSnippets.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Only one Code Snippet is allowed for Syntax.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  _codeSnippets[key] = snippet;
                } else if (_selectedCategory == 'Sequencing') {
                  // Sequencing 카테고리: Key값을 자동 증가
                  final index = _codeSnippets.length.toString();
                  _codeSnippets[index] = snippet;
                } else {
                  // 기타 카테고리: 언어를 키로 사용 (또는 다른 유니크 키 방식)
                  _codeSnippets[key] = snippet;
                }
              });
            },
            onDeleteSnippet: (key) {
              setState(() {
                _codeSnippets.remove(key);
              });
            },
          ),
          HintInput(hintController: _hintController),
          if (_selectedType == 'Subjective')
            SubjectiveAnswerInput(
                subjectiveAnswerController: _subjectiveAnswerController)
          else if (_selectedType == 'Objective')
            ObjectiveAnswerInput(
              answerChoices: _answerChoices,
              selectedAnswer: _selectedAnswer,
              onAddChoice: (choice) =>
                  setState(() => _answerChoices.add(choice)),
              onDeleteChoice: (choice) => setState(() {
                _answerChoices.remove(choice);
                if (_selectedAnswer == choice) _selectedAnswer = null;
              }),
              onSelectAnswer: (choice) =>
                  setState(() => _selectedAnswer = choice),
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _submitQuestion,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
