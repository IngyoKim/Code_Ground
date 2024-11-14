import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardExpController = TextEditingController();
  final TextEditingController _answerSequenceController =
      TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  String _selectedCategory = 'Syntax';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardExpController.dispose();
    _answerSequenceController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  void _submitQuestion(BuildContext context) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final rewardExp = int.tryParse(_rewardExpController.text) ?? 0;
    final difficulty = _difficultyController.text;
    final answerSequence = _answerSequenceController.text.split(',');

    if (title.isNotEmpty && description.isNotEmpty && difficulty.isNotEmpty) {
      await Provider.of<QuestionViewModel>(context, listen: false).addQuestion(
        title: title,
        description: description,
        writer: 'Anonymous',
        category: _selectedCategory,
        rewardExp: rewardExp,
        difficulty: difficulty,
        answerSequence: _selectedCategory == 'Sequencing' ? answerSequence : [],
      );

      Fluttertoast.showToast(
        msg: "Question added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Widget _buildCategorySpecificFields() {
    switch (_selectedCategory) {
      case 'Sequencing':
        return TextField(
          controller: _answerSequenceController,
          decoration: const InputDecoration(
              labelText: 'Answer Sequence (comma-separated)'),
        );
      case 'Debugging':
        return const TextField(
          decoration: InputDecoration(labelText: 'Hint'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Question'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Syntax', 'Debugging', 'Output', 'Blank', 'Sequencing']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _rewardExpController,
                decoration: const InputDecoration(labelText: 'Reward Exp'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _difficultyController,
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),
              const SizedBox(height: 16),
              _buildCategorySpecificFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitQuestion(context),
                child: const Text('Submit Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
