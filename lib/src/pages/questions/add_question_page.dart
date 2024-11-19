import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:code_ground/src/components/add_question_widgets/sequencing_reorder_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/text_field_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/dropdown_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/code_snippet_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/answer_choice_widget.dart';

import 'package:code_ground/src/utils/add_question_utils.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

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

  String _selectedCategory = 'Syntax',
      _selectedType = 'Subjective',
      _selectedLanguage = 'C';
  final _steps = <int, String>{}, _codeSnippets = <String, String>{};
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
      Fluttertoast.showToast(msg: 'Please log in to continue.');
      return;
    }

    // 필드 검증
    if (!validateFields(
      context: context,
      title: _titleController.text,
      description: _descriptionController.text,
      selectedCategory: _selectedCategory,
      selectedType: _selectedType,
      answerChoices: _selectedType == 'Objective' ? _answerChoices : null,
      selectedAnswer: _selectedType == 'Objective' ? _selectedAnswer : null,
      subjectiveAnswer: _selectedType == 'Subjective'
          ? _subjectiveAnswerController.text
          : null,
      sequencingSteps: _selectedCategory == 'Sequencing' ? _steps : null,
    )) return;

    try {
      // Sequencing의 경우 steps를 codeSnippets로 변환
      if (_selectedCategory == 'Sequencing') {
        _codeSnippets.clear();
        _steps.forEach((key, value) {
          if (value.isNotEmpty) {
            _codeSnippets[key.toString()] = value; // key를 문자열로 변환하여 저장
          }
        });
      }

      final question = prepareAddQuestionData(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        writerUid: user.userId,
        selectedCategory: _selectedCategory,
        selectedType: _selectedType,
        codeSnippets: _codeSnippets,
        selectedLanguage: _selectedLanguage,
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
      Fluttertoast.showToast(msg: 'Question added.');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
  }

  Widget _setTypeToObjective() {
    _selectedType = 'Objective';
    return const SizedBox.shrink();
  }

  Widget _setTypeToSubjective() {
    _selectedType = 'Subjective';
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFieldWidget(label: 'Description', controller: _titleController),
            DropdownWidget(
              label: 'Category',
              value: _selectedCategory,
              items: const [
                'Syntax',
                'Debugging',
                'Output',
                'Blank',
                'Sequencing'
              ],
              onChanged: (value) => setState(() {
                _selectedCategory = value!;
                _codeSnippets.clear();
                _steps.clear();
                _codeSnippetController.clear();
                _subjectiveAnswerController.clear();
                _answerChoices.clear();
                _selectedAnswer = null;
              }),
            ),
            if (_selectedCategory == 'Sequencing') ...[
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'C', child: Text('C')),
                  DropdownMenuItem(value: 'Python', child: Text('Python')),
                  DropdownMenuItem(value: 'Java', child: Text('Java')),
                  DropdownMenuItem(value: 'C++', child: Text('C++')),
                  DropdownMenuItem(value: 'Dart', child: Text('Dart')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Language'),
              ),
              SequencingReorderWidget(
                items: _steps,
                onAddStep: () => setState(() {
                  _steps[_steps.isNotEmpty ? _steps.keys.last + 1 : 0] = '';
                }),
                onRemoveStep: (key) => setState(() => _steps.remove(key)),
                onReorder: (oldIndex, newIndex) => setState(() {
                  final step = _steps.remove(oldIndex)!;
                  _steps[newIndex > oldIndex ? newIndex - 1 : newIndex] = step;
                }),
                onUpdateCode: (key, value) =>
                    setState(() => _steps[key] = value),
              ),
            ] else ...[
              if (_selectedCategory != 'Blank' && _selectedCategory != 'Output')
                DropdownWidget(
                  label: 'Question Type',
                  value: _selectedType,
                  items: const ['Subjective', 'Objective'],
                  onChanged: (value) => setState(() {
                    _selectedType = value!;
                    if (_selectedType == 'Objective') {
                      _answerChoices.clear();
                      _selectedAnswer = null;
                    }
                  }),
                ),
              if (_selectedCategory == 'Blank') _setTypeToObjective(),
              if (_selectedCategory == 'Output') _setTypeToSubjective(),
              CodeSnippetWidget(
                selectedCategory: _selectedCategory,
                selectedLanguage: _selectedLanguage,
                codeSnippets: _codeSnippets,
                snippetController: _codeSnippetController,
                onAddSnippet: (lang, snippet) =>
                    setState(() => _codeSnippets[lang] = snippet),
                onDeleteSnippet: (lang) =>
                    setState(() => _codeSnippets.remove(lang)),
                onLanguageChange: (lang) =>
                    setState(() => _selectedLanguage = lang),
                showAddButton: _selectedCategory != 'Syntax',
                showDeleteButton: _selectedCategory != 'Syntax',
              ),
              TextFieldWidget(label: 'Hint', controller: _hintController),
              if (_selectedType == 'Subjective')
                TextFieldWidget(
                  label: 'Answer (Subjective)',
                  controller: _subjectiveAnswerController,
                ),
              if (_selectedType == 'Objective')
                AnswerChoiceWidget(
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
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submitQuestion,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}