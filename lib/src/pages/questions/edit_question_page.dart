import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/models/tier_data.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/question_form_widgets/header/title_input.dart';
import 'package:code_ground/src/components/question_form_widgets/header/description_input.dart';
import 'package:code_ground/src/components/question_form_widgets/body/tier_input.dart';
import 'package:code_ground/src/components/question_form_widgets/body/language_input.dart';
import 'package:code_ground/src/components/question_form_widgets/body/code_snippet_input.dart';
import 'package:code_ground/src/components/question_form_widgets/body/hint_input.dart';
import 'package:code_ground/src/components/question_form_widgets/footer/question_type_input.dart';
import 'package:code_ground/src/components/question_form_widgets/footer/subjective_input.dart';
import 'package:code_ground/src/components/question_form_widgets/footer/objective_answer_input.dart';

class EditQuestionPage extends StatefulWidget {
  const EditQuestionPage({super.key});

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hintController = TextEditingController();
  final _codeSnippetController = TextEditingController();
  final _subjectiveAnswerController = TextEditingController();

  String? _selectedType;
  String _selectedLanguage = 'C';
  Tier _selectedTier = tiers.first;
  final Map<String, String> _codeSnippets = {};
  final List<String> _answerChoices = [];
  String? _selectedAnswer;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      ToastMessage.show("No question found to edit.");
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      _initializeFields(question);
    } catch (error) {
      ToastMessage.show("Error loading question: $error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _initializeFields(dynamic question) {
    _titleController.text = question.title;
    _descriptionController.text = question.description;
    _hintController.text = question.hint ?? '';
    _selectedType = question.questionType;
    _selectedTier = Tier.getTierByName(question.tier) ?? tiers.first;
    _codeSnippets.addAll(question.codeSnippets);

    if (_selectedType == 'Subjective') {
      _subjectiveAnswerController.text = question.answer ?? '';
    } else if (_selectedType == 'Objective') {
      _answerChoices.addAll(question.answerList ?? []);
      _selectedAnswer = question.answer;
    } else if (question.category == 'Sequencing') {
      _selectedLanguage =
          question.languages.isNotEmpty ? question.languages.first : 'C';
    }
  }

  Future<void> _saveQuestion() async {
    final questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      ToastMessage.show("No question found to edit.");
      return;
    }

    if (!_validateInputs()) {
      ToastMessage.show("Please fill in all required fields.");
      return;
    }

    final updatedQuestion = question.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      hint: _hintController.text.trim(),
      questionType: _selectedType,
      codeSnippets: _prepareCodeSnippets(question),
      answer: _selectedType == 'Subjective'
          ? _subjectiveAnswerController.text.trim()
          : _selectedAnswer,
      answerList: _selectedType == 'Objective' ? _answerChoices : null,
      tier: _selectedTier.name,
      updatedAt: DateTime.now(),
    );

    try {
      await questionViewModel.updateQuestion(updatedQuestion);
      ToastMessage.show("Question updated successfully.");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (error) {
      ToastMessage.show("Failed to update question: $error");
    }
  }

  bool _validateInputs() {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _codeSnippets.isNotEmpty &&
        (_selectedType != 'Objective' || _answerChoices.isNotEmpty) &&
        (_selectedType != 'Subjective' ||
            _subjectiveAnswerController.text.trim().isNotEmpty);
  }

  Map<String, String> _prepareCodeSnippets(dynamic question) {
    if (question.category == 'Sequencing') {
      final validatedSnippets = <String, String>{};
      int index = 1;
      for (final snippet in _codeSnippets.values) {
        validatedSnippets['i$index'] = snippet;
        index++;
      }
      return validatedSnippets;
    }
    return {..._codeSnippets};
  }

  Widget _buildBody(dynamic question) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TitleInput(titleController: _titleController),
        DescriptionInput(descriptionController: _descriptionController),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            initialValue: question.category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
        ),
        TierInput(
          selectedTier: _selectedTier,
          onTierChanged: (value) => setState(() => _selectedTier = value!),
        ),
        if (question.category == 'Syntax' || question.category == 'Debugging')
          QuestionTypeInput(
            selectedType: _selectedType ?? 'Subjective',
            onTypeChanged: (value) => setState(() => _selectedType = value!),
          ),
        if (question.category == 'Sequencing')
          LanguageInput(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (value) =>
                setState(() => _selectedLanguage = value!),
          ),
        CodeSnippetInput(
          category: question.category,
          selectedLanguage: _selectedLanguage,
          codeSnippets: _codeSnippets,
          snippetController: _codeSnippetController,
          onAddSnippet: (key, snippet) =>
              setState(() => _codeSnippets[key] = snippet),
          onDeleteSnippet: (key) => setState(() => _codeSnippets.remove(key)),
        ),
        if (_selectedType == 'Subjective')
          SubjectiveAnswerInput(
            subjectiveAnswerController: _subjectiveAnswerController,
          )
        else if (_selectedType == 'Objective')
          ObjectiveAnswerInput(
            answerChoices: _answerChoices,
            selectedAnswer: _selectedAnswer,
            onAddChoice: (choice) => setState(() => _answerChoices.add(choice)),
            onDeleteChoice: (choice) => setState(() {
              _answerChoices.remove(choice);
              if (_selectedAnswer == choice) _selectedAnswer = null;
            }),
            onSelectAnswer: (choice) =>
                setState(() => _selectedAnswer = choice),
          ),
        HintInput(hintController: _hintController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveQuestion,
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final question = questionViewModel.selectedQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text(question?.questionId ?? 'Edit Question'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveQuestion,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(question),
    );
  }
}
