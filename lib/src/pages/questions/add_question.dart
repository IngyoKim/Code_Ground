import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/question_datas/syntax_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/debugging_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/output_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/blank_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/sequencing_question.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  /// Text editing controllers for user input fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hintController = TextEditingController();
  final _codeSnippetController = TextEditingController();
  final _answerChoiceController = TextEditingController();

  /// State variables for dropdowns and input
  String _selectedCategory = 'Syntax';
  String _selectedLanguage = 'C';
  String _questionType = 'Subjective';
  String? _selectedAnswer; // 객관식 정답
  final Map<String, String> _codeSnippets = {};
  final List<String> _answerChoices = [];

  @override
  void dispose() {
    /// Dispose controllers to prevent memory leaks
    _titleController.dispose();
    _descriptionController.dispose();
    _hintController.dispose();
    _codeSnippetController.dispose();
    _answerChoiceController.dispose();
    super.dispose();
  }

  /// Creates a QuestionData object based on the input fields
  QuestionData _createQuestionData(String uid) {
    final baseData = {
      'questionId': '',
      'writer': uid,
      'category': _selectedCategory,
      'questionType': _questionType,
      'updatedAt': DateTime.now().toIso8601String(),
      'title': _titleController.text,
      'description': _descriptionController.text,
      'codeSnippets': _selectedCategory == 'Syntax'
          ? {_selectedLanguage: _codeSnippetController.text}
          : _codeSnippets,
      'languages': _selectedCategory == 'Syntax'
          ? [_selectedLanguage]
          : _codeSnippets.keys.toList(),
      'hint': _hintController.text.isEmpty
          ? 'No hint provided'
          : _hintController.text,
      // 주관식: 단일 정답, 객관식: 선택된 정답
      'answer': _questionType == 'Subjective'
          ? (_answerChoiceController.text.isNotEmpty
              ? _answerChoiceController.text
              : null)
          : _selectedAnswer,
      'answerChoices': _questionType == 'Objective' && _answerChoices.isNotEmpty
          ? _answerChoices
          : null,
    };

    /// Return appropriate QuestionData subtype based on selected category
    switch (_selectedCategory) {
      case 'Debugging':
        return DebuggingQuestion.fromMap(baseData);
      case 'Output':
        return OutputQuestion.fromMap(baseData);
      case 'Blank':
        return BlankQuestion.fromMap(baseData);
      case 'Sequencing':
        return SequencingQuestion.fromMap(baseData);
      default:
        return SyntaxQuestion.fromMap(baseData);
    }
  }

  /// Submits the question to the database
  void _submitQuestion() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill in all required fields", gravity: ToastGravity.BOTTOM);
      return;
    }

    if (_questionType == 'Objective' &&
        (_answerChoices.isEmpty || _selectedAnswer == null)) {
      Fluttertoast.showToast(
          msg: "Add answer choices and select a correct answer!",
          gravity: ToastGravity.BOTTOM);
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid ?? 'Anonymous';

    final questionData = _createQuestionData(uid);

    await Provider.of<QuestionViewModel>(context, listen: false)
        .addQuestion(questionData);

    Fluttertoast.showToast(
        msg: "Question added successfully!", gravity: ToastGravity.BOTTOM);
    Navigator.pop(context);
  }

  /// Adds an answer choice to the list
  void _addAnswerChoice() {
    if (_answerChoiceController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Answer choice cannot be empty!", gravity: ToastGravity.BOTTOM);
      return;
    }
    setState(() {
      _answerChoices.add(_answerChoiceController.text);
      _answerChoiceController.clear();
    });
  }

  /// Deletes a selected answer choice
  void _deleteAnswerChoice(String choice) {
    setState(() {
      _answerChoices.remove(choice);
      if (_selectedAnswer == choice) {
        _selectedAnswer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Title', _titleController),
            _buildDropdown(
              'Category',
              _selectedCategory,
              ['Syntax', 'Debugging', 'Output', 'Blank', 'Sequencing'],
              (value) {
                setState(() {
                  _selectedCategory = value!;
                  _codeSnippets.clear();
                });
              },
            ),
            _buildDropdown(
              'Question Type',
              _questionType,
              ['Subjective', 'Objective'],
              (value) => setState(() {
                _questionType = value!;
                _answerChoices.clear();
                _selectedAnswer = null;
              }),
            ),
            _buildDropdown(
              'Language',
              _selectedLanguage,
              ['C', 'Python', 'Java', 'C++', 'Dart'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildMultilineTextField('Description', _descriptionController),
            if (_selectedCategory == 'Syntax')
              _buildMultilineTextField('Code Snippet', _codeSnippetController),
            if (_selectedCategory != 'Syntax') _buildCodeSnippetControls(),
            _buildTextField('Hint (Optional)', _hintController),
            if (_questionType == 'Objective') _buildAnswerChoiceControls(),
            if (_questionType == 'Subjective')
              _buildTextField('Answer (Subjective)', _answerChoiceController),
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

  /// Builds a text field with a label
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
      ),
    );
  }

  /// Builds a multi-line text field
  Widget _buildMultilineTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  /// Builds a dropdown menu for selecting a value
  Widget _buildDropdown(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// Controls for code snippets
  Widget _buildCodeSnippetControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMultilineTextField('Code Snippet', _codeSnippetController),
      ],
    );
  }

  /// Controls for adding and managing answer choices
  Widget _buildAnswerChoiceControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Answer Choices:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ..._answerChoices.map((choice) => ListTile(
              title: Text(choice),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: choice,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAnswerChoice(choice),
                  ),
                ],
              ),
            )),
        Row(
          children: [
            Expanded(
              child: _buildTextField('Answer Choice', _answerChoiceController),
            ),
            ElevatedButton(
              onPressed: _addAnswerChoice,
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
