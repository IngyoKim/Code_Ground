import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/toast_message.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

import 'package:code_ground/src/components/add_question_widgets/header/title_input.dart';
import 'package:code_ground/src/components/add_question_widgets/header/description_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/category_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/tier_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/code_snippet_input.dart';
import 'package:code_ground/src/components/add_question_widgets/body/hint_input.dart';
import 'package:code_ground/src/components/add_question_widgets/footer/question_type_input.dart';
import 'package:code_ground/src/components/add_question_widgets/footer/subjective_input.dart';
import 'package:code_ground/src/components/add_question_widgets/footer/objective_answer_input.dart';

import 'package:code_ground/src/services/database/datas/tier_data.dart';

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

  String? _selectedCategory;
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

    setState(() {
      _isLoading = true;
    });

    try {
      // 기존 질문 데이터 초기화
      _titleController.text = question.title;
      _descriptionController.text = question.description;
      _hintController.text = question.hint;
      _selectedCategory = question.category;
      _selectedType = question.questionType;
      _selectedTier = Tier.getTierByName(question.tier) ?? tiers.first;
      _codeSnippets.addAll(question.codeSnippets);

      if (_selectedType == 'Subjective') {
        _subjectiveAnswerController.text = question.answer ?? '';
      } else if (_selectedType == 'Objective') {
        _answerChoices.addAll(question.answerList ?? []);
        _selectedAnswer = question.answer;
      }
    } catch (error) {
      ToastMessage.show("Error loading question: $error");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

    // 데이터 검증
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _codeSnippets.isEmpty ||
        (_selectedType == 'Objective' && _answerChoices.isEmpty) ||
        (_selectedType == 'Subjective' &&
            _subjectiveAnswerController.text.trim().isEmpty)) {
      ToastMessage.show("Please fill in all required fields.");
      return;
    }

    // 수정된 데이터로 새로운 QuestionData 생성
    final updatedQuestion = question.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      hint: _hintController.text.trim(),
      category: _selectedCategory,
      questionType: _selectedType,
      codeSnippets: _codeSnippets,
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
      Navigator.pop(context);
    } catch (error) {
      ToastMessage.show("Failed to update question: $error");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hintController.dispose();
    _codeSnippetController.dispose();
    _subjectiveAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveQuestion,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TitleInput(titleController: _titleController),
                DescriptionInput(descriptionController: _descriptionController),
                CategoryInput(
                  selectedCategory: _selectedCategory ?? '',
                  onCategoryChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                      _codeSnippets.clear();
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
                if (_selectedCategory == 'Syntax' ||
                    _selectedCategory == 'Debugging')
                  QuestionTypeInput(
                    selectedType: _selectedType ?? 'Subjective',
                    onTypeChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                CodeSnippetInput(
                  category: _selectedCategory ?? '',
                  selectedLanguage: _selectedLanguage,
                  codeSnippets: _codeSnippets,
                  snippetController: _codeSnippetController,
                  onAddSnippet: (key, snippet) {
                    setState(() {
                      _codeSnippets[key] = snippet;
                    });
                  },
                  onDeleteSnippet: (key) {
                    setState(() {
                      _codeSnippets.remove(key);
                    });
                  },
                ),
                if (_selectedType == 'Subjective')
                  SubjectiveAnswerInput(
                    subjectiveAnswerController: _subjectiveAnswerController,
                  )
                else if (_selectedType == 'Objective')
                  ObjectiveAnswerInput(
                    answerChoices: _answerChoices,
                    selectedAnswer: _selectedAnswer,
                    onAddChoice: (choice) {
                      setState(() {
                        _answerChoices.add(choice);
                      });
                    },
                    onDeleteChoice: (choice) {
                      setState(() {
                        _answerChoices.remove(choice);
                        if (_selectedAnswer == choice) _selectedAnswer = null;
                      });
                    },
                    onSelectAnswer: (choice) {
                      setState(() {
                        _selectedAnswer = choice!;
                      });
                    },
                  ),
                HintInput(hintController: _hintController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveQuestion,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
    );
  }
}