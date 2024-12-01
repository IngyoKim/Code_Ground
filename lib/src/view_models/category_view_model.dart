import 'package:flutter/material.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class CategoryViewModel extends ChangeNotifier {
  String _selectedCategory = '';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category, QuestionViewModel questionViewModel) {
    if (_selectedCategory != category) {
      debugPrint(
        '[CategoryViewModel] category: $_selectedCategory -> $category',
      );

      _selectedCategory = category;

      questionViewModel.resetCategoryState(category);
      questionViewModel.clearQuestions();

      notifyListeners();
    }
  }
}
