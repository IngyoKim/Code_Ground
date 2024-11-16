import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  String _selectedCategory = '';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
