import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Toast 패키지 추가
import 'package:provider/provider.dart';

import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';

import 'package:code_ground/src/components/add_question_widgets/header/title_input.dart';
import 'package:code_ground/src/components/add_question_widgets/header/description_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/category_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/tier_input.dart';
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
  Tier _selectedTier = tiers.first;
  final _codeSnippets = <String, String>{};
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
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);

    if (user == null) {
      _showToast('Please log in to continue.');
      return;
    }

    if (_codeSnippets.isEmpty ||
        !_codeSnippets.values.any((value) => value.isNotEmpty)) {
      _showToast('Please add at least one valid Code Snippet.');
      return;
    }

    if (_selectedType == 'Objective' && _selectedAnswer == null) {
      _showToast('Please select an answer before submitting.');
      return;
    }

    try {
      final questionData = QuestionData(
        questionId: '', // ViewModel에서 자동 생성
        title: _titleController.text,
        writer: user.userId,
        category: _selectedCategory,
        questionType: _selectedType,
        description: _descriptionController.text,
        codeSnippets: _codeSnippets,
        hint: _hintController.text.isNotEmpty
            ? _hintController.text
            : 'No hint provided',
        answer: _selectedType == 'Subjective'
            ? _subjectiveAnswerController.text
            : _selectedAnswer ?? '',
        answerChoices: _selectedType == 'Objective' ? _answerChoices : [],
        tier: _selectedTier.name,
        solvers: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await questionViewModel.addQuestion(questionData);

      if (mounted) {
        _showToast('Question added successfully.');
        Navigator.pop(context);
      }
    } catch (e) {
      _showToast('Error occurred: $e');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
            onTierChanged: (value) => setState(() => _selectedTier = value!),
          ),
          if (_selectedCategory == 'Syntax' || _selectedCategory == 'Debugging')
            QuestionTypeInput(
              selectedType: _selectedType,
              onTypeChanged: (value) => setState(() => _selectedType = value!),
            ),
          LanguageInput(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (value) =>
                setState(() => _selectedLanguage = value!),
          ),
          CodeSnippetInput(
            category: _selectedCategory,
            selectedLanguage: _selectedLanguage,
            codeSnippets: _codeSnippets,
            snippetController: _codeSnippetController,
            onAddSnippet: (key, snippet) {
              setState(() {
                if (_selectedCategory == 'Syntax' && _codeSnippets.isNotEmpty) {
                  _showToast('Only one Code Snippet is allowed for Syntax.');
                  return;
                }
                _codeSnippets[key] = snippet;
              });
            },
            onDeleteSnippet: (key) => setState(() => _codeSnippets.remove(key)),
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
