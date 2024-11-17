import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/question_datas/syntax_question.dart';
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

    final questionData = SyntaxQuestion(
      questionId: '', // ID는 QuestionOperation에서 생성
      writer: uid, // 유저 UID를 writer로 설정
      category: _selectedCategory,
      questionType: _questionType,
      difficulty: _difficultyController.text,
      updatedAt: DateTime.now(),
      title: _titleController.text,
      description: _descriptionController.text,
      codeSnippets: Map.from(_codeSnippets),
      languages: _codeSnippets.keys.toList(),
      hint: _hintController.text.isEmpty
          ? 'No hint provided'
          : _hintController.text,
    );

    await Provider.of<QuestionViewModel>(context, listen: false)
        .addQuestion(questionData);

    Fluttertoast.showToast(
        msg: "Question added successfully!", gravity: ToastGravity.BOTTOM);
    Navigator.pop(context);
  }

  void _addCodeSnippet() {
    if (_codeSnippets.containsKey(_selectedLanguage)) {
      Fluttertoast.showToast(
          msg: "Code snippet for $_selectedLanguage already exists!",
          gravity: ToastGravity.BOTTOM);
      return;
    }
    if (_codeSnippetController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Code snippet cannot be empty!", gravity: ToastGravity.BOTTOM);
      return;
    }
    _codeSnippets[_selectedLanguage] = _codeSnippetController.text;
    _codeSnippetController.clear();
    setState(() {});
  }

  void _deleteCodeSnippet(String language) {
    _codeSnippets.remove(language);
    Fluttertoast.showToast(
        msg: "Code snippet for $language removed!",
        gravity: ToastGravity.BOTTOM);
    setState(() {});
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
              (value) => setState(() => _selectedCategory = value!),
            ),
            _buildTextField('Difficulty (Numeric)', _difficultyController,
                keyboardType: TextInputType.number),
            _buildDropdown(
              'Question Type',
              _questionType,
              ['Subjective', 'Objective'],
              (value) {
                setState(() {
                  _questionType = value!;
                  if (_questionType == 'Subjective') {
                    _answers.clear(); // 주관식 선택 시 답 초기화
                  }
                });
              },
            ),
            _buildDropdown(
              'Language',
              _selectedLanguage,
              ['C', 'Python', 'Java', 'C++', 'Dart'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildTextField('Description', _descriptionController, maxLines: 3),
            _buildTextField('Code Snippet', _codeSnippetController,
                maxLines: 3),
            ElevatedButton(
              onPressed: _addCodeSnippet,
              child: const Text('Add Code Snippet'),
            ),
            if (_codeSnippets.isNotEmpty) _buildCodeSnippetsList(),
            _buildTextField('Hint (Optional)', _hintController),
            const SizedBox(height: 20),
            _buildTextField('Answer', _answerController),
            if (_questionType == 'Objective') ...[
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
                        msg: "Answer cannot be empty!",
                        gravity: ToastGravity.BOTTOM);
                    return;
                  }
                  _answers.add(_answerController.text);
                  _answerController.clear();
                  setState(() {});
                },
                child: const Text('Add Answer'),
              ),
              if (_answers.isNotEmpty) _buildAnswersList(),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: keyboardType,
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
        const Text(
          'Code Snippets:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ..._codeSnippets.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCodeSnippet(entry.key),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildAnswersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Answers:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ..._answers.map((answer) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(answer, style: const TextStyle(fontSize: 14)),
            )),
      ],
    );
  }
}
