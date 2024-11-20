import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/add_question_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/services/database/datas/tier_data.dart'; // Tier 데이터 import
import 'package:code_ground/src/components/add_question_widgets/header/title_input.dart';
import 'package:code_ground/src/components/add_question_widgets/header/description_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/category_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/tier_input.dart'; // TierInput 추가
import 'package:code_ground/src/components/add_question_widgets/footer/question_type_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/language_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/code_snippet_input.dart';
import 'package:code_ground/src/components/add_question_widgets/footer/subjective_input.dart';
import 'package:code_ground/src/components/add_question_widgets/footer/objective_answer_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/hint_input.dart';

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
  String _selectedType = 'Subjective';
  String _selectedLanguage = 'C';
  Tier _selectedTier = tiers.first; // Tier 초기값
  final _codeSnippets = <String, String>{};
  final _answerChoices = <String>[]; // 객관식 답변 선택지
  String? _selectedAnswer; // 선택된 답변 저장

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

    // 객관식 답변 선택 유효성 검사
    if (_selectedType == 'Objective' && _selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an answer before submitting.')),
      );
      return;
    }

    try {
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

      final question = prepareAddQuestionData(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        writerUid: user.userId,
        selectedCategory: _selectedCategory,
        selectedType: _selectedType,
        codeSnippets: _codeSnippets,
        title: _titleController.text,
        description: _descriptionController.text,
        tier: _selectedTier, // Tier 이름 전달
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
          TierInput(
            selectedTier: _selectedTier,
            onTierChanged: (value) {
              setState(() {
                _selectedTier = value!;
              });
            },
          ),
          if (_selectedCategory == 'Syntax' || _selectedCategory == 'Debugging')
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
                  final index = _codeSnippets.length.toString();
                  _codeSnippets[index] = snippet;
                } else {
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
