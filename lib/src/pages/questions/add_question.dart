import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/utils/add_question_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/add_question_widgets/text_field_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/dropdown_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/answer_choice_widget.dart';
import 'package:code_ground/src/components/add_question_widgets/code_snippet_widget.dart';

//문제 선택이 되도록 하기

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _subjectiveAnswerController =
      TextEditingController();
  final TextEditingController _codeSnippetController = TextEditingController();

  String _selectedCategory = 'Syntax';
  String _selectedType = 'Subjective';
  String _selectedLanguage = 'C';
  final Map<String, String> _codeSnippets = {};
  final List<String> _answerChoices = [];
  String? _selectedAnswer;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hintController.dispose();
    _subjectiveAnswerController.dispose();
    _codeSnippetController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (userViewModel.userData == null) {
      Fluttertoast.showToast(msg: 'User information is missing.');
      return;
    }

    if (!validateFields(
      title: _titleController.text,
      description: _descriptionController.text,
      selectedType: _selectedType,
      answerChoices: _answerChoices,
      selectedAnswer: _selectedAnswer,
      subjectiveAnswer: _subjectiveAnswerController.text,
    )) return;

    final questionId = DateTime.now().millisecondsSinceEpoch.toString();
    final writerUid = userViewModel.userData!.userId;

    try {
      final question = prepareQuestionData(
        questionId: questionId,
        writerUid: writerUid,
        selectedCategory: _selectedCategory,
        selectedType: _selectedType,
        codeSnippets: _codeSnippets,
        selectedLanguage: _selectedLanguage,
        title: _titleController.text,
        description: _descriptionController.text,
        hint: _hintController.text,
        selectedAnswer: _selectedAnswer,
        answerChoices: _answerChoices,
        subjectiveAnswer: _subjectiveAnswerController.text,
        snippetController: _codeSnippetController,
      );

      await Provider.of<QuestionViewModel>(context, listen: false)
          .addQuestion(question);

      Fluttertoast.showToast(msg: 'Question submitted successfully!');
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error submitting question: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFieldWidget(label: 'Title', controller: _titleController),
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
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _codeSnippets.clear();
                  _codeSnippetController.clear();
                });
              },
            ),
            DropdownWidget(
              label: 'Question Type',
              value: _selectedType,
              items: const ['Subjective', 'Objective'],
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            TextFieldWidget(
                label: 'Description', controller: _descriptionController),
            CodeSnippetWidget(
              selectedCategory: _selectedCategory,
              selectedLanguage: _selectedLanguage,
              codeSnippets: _codeSnippets,
              onAddSnippet: (lang, snippet) {
                if (_selectedCategory != 'Syntax') {
                  setState(() {
                    _codeSnippets[lang] = snippet;
                  });
                }
              },
              onDeleteSnippet: (lang) {
                setState(() {
                  _codeSnippets.remove(lang);
                });
              },
              onLanguageChange: (lang) {
                setState(() {
                  _selectedLanguage = lang;
                });
              },
              snippetController: _codeSnippetController,
              showAddButton: _selectedCategory != 'Syntax',
            ),
            TextFieldWidget(
                label: 'Hint (Optional)', controller: _hintController),
            if (_selectedType == 'Objective')
              AnswerChoiceWidget(
                answerChoices: _answerChoices,
                selectedAnswer: _selectedAnswer,
                onAddChoice: (choice) =>
                    setState(() => _answerChoices.add(choice)),
                onDeleteChoice: (choice) =>
                    setState(() => _answerChoices.remove(choice)),
                onSelectAnswer: (choice) =>
                    setState(() => _selectedAnswer = choice),
              ),
            if (_selectedType == 'Subjective')
              TextFieldWidget(
                label: 'Answer (Subjective)',
                controller: _subjectiveAnswerController,
              ),
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
