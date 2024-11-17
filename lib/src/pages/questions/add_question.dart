import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/question_datas/syntax_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/debugging_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/output_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/blank_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/sequencing_question.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _hintController = TextEditingController();
  final _answerController = TextEditingController();
  final _codeSnippetController = TextEditingController();

  String _selectedCategory = 'Syntax';
  String _selectedLanguage = 'C';
  String _questionType = 'Subjective'; // 주관식/객관식 구분
  final Map<String, String> _codeSnippets = {};
  final List<String> _answers = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _difficultyController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    _codeSnippetController.dispose();
    super.dispose();
  }

  QuestionData _createQuestionData(String uid) {
    final baseData = {
      'questionId': '',
      'writer': uid,
      'category': _selectedCategory,
      'questionType': _questionType,
      'difficulty': _difficultyController.text,
      'updatedAt': DateTime.now().toIso8601String(),
      'title': _titleController.text,
      'description': _descriptionController.text,
      'codeSnippets': _codeSnippets,
      'languages': _codeSnippets.keys.toList(),
      'hint': _hintController.text.isEmpty
          ? 'No hint provided'
          : _hintController.text,
      'answers':
          _questionType == 'Objective' ? _answers : [_answerController.text],
    };

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

  void _submitQuestion() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _difficultyController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill in all required fields", gravity: ToastGravity.BOTTOM);
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

  void _addCodeSnippet() {
    if (_codeSnippetController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Code snippet cannot be empty!", gravity: ToastGravity.BOTTOM);
      return;
    }
    if (_codeSnippets.containsKey(_selectedLanguage)) {
      Fluttertoast.showToast(
          msg: "Code snippet for $_selectedLanguage already exists!",
          gravity: ToastGravity.BOTTOM);
      return;
    }
    setState(() {
      _codeSnippets[_selectedLanguage] = _codeSnippetController.text;
      _codeSnippetController.clear();
    });
  }

  void _deleteCodeSnippet(String language) {
    setState(() {
      _codeSnippets.remove(language);
    });
    Fluttertoast.showToast(
        msg: "Code snippet for $language removed!",
        gravity: ToastGravity.BOTTOM);
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
                  if (_selectedCategory == 'Syntax') {
                    _codeSnippets.clear();
                  }
                });
              },
            ),
            _buildTextField('Difficulty (Numeric)', _difficultyController,
                keyboardType: TextInputType.number),
            _buildDropdown(
              'Question Type',
              _questionType,
              ['Subjective', 'Objective'],
              (value) => setState(() {
                _questionType = value!;
                if (_questionType == 'Subjective') _answers.clear();
              }),
            ),
            _buildDropdown(
              'Language',
              _selectedLanguage,
              ['C', 'Python', 'Java', 'C++', 'Dart'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildMultilineTextField('Description', _descriptionController),
            _buildMultilineTextField('Code Snippet', _codeSnippetController),
            if (_selectedCategory != 'Syntax')
              ElevatedButton(
                onPressed: _addCodeSnippet,
                child: const Text('Add Code Snippet'),
              ),
            if (_codeSnippets.isNotEmpty) _buildCodeSnippetsList(),
            _buildTextField('Hint (Optional)', _hintController),
            const SizedBox(height: 20),
            _buildAnswerInput(),
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

  Widget _buildCodeSnippetsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Code Snippets:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ..._codeSnippets.entries.map((entry) => ListTile(
              title: Text('${entry.key}: ${entry.value}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteCodeSnippet(entry.key),
              ),
            )),
      ],
    );
  }

  Widget _buildAnswerInput() {
    if (_questionType == 'Subjective') {
      return _buildTextField('Answer', _answerController);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Answer', _answerController),
        ElevatedButton(
          onPressed: () {
            if (_answers.length >= 10) {
              Fluttertoast.showToast(
                  msg: "You can only add up to 10 answers!",
                  gravity: ToastGravity.BOTTOM);
              return;
            }
            if (_answerController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Answer cannot be empty!", gravity: ToastGravity.BOTTOM);
              return;
            }
            setState(() {
              _answers.add(_answerController.text);
              _answerController.clear();
            });
          },
          child: const Text('Add Answer'),
        ),
        if (_answers.isNotEmpty)
          ..._answers.map((answer) => ListTile(
                title: Text(answer),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => _answers.remove(answer)),
                ),
              )),
      ],
    );
  }
}
