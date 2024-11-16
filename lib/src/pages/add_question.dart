import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String _selectedCategory = 'Syntax';
  String _selectedLanguage = 'C';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _difficultyController.dispose();
    _hintController.dispose();
    _answerController.dispose();
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

    final questionData = SyntaxQuestion(
      questionId: '', // ID는 QuestionOperation에서 생성
      writer: 'Anonymous',
      category: _selectedCategory,
      questionType: 'Subjective',
      difficulty: _difficultyController.text,
      updatedAt: DateTime.now(),
      title: _titleController.text,
      description: _descriptionController.text,
      languages: [_selectedLanguage],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Title', _titleController),
            _buildTextField('Description', _descriptionController, maxLines: 3),
            _buildDropdown(
              'Category',
              _selectedCategory,
              ['Syntax', 'Debugging', 'Output', 'Blank', 'Sequencing'], // 수정
              (value) => setState(() => _selectedCategory = value!),
            ),
            _buildDropdown(
              'Language',
              _selectedLanguage,
              ['C', 'Python', 'Java', 'C++', 'Dart'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildTextField('Difficulty (Numeric)', _difficultyController,
                keyboardType: TextInputType.number),
            _buildTextField('Answer', _answerController),
            _buildTextField('Hint (Optional)', _hintController),
            const SizedBox(height: 20),
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
}
