import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/pages/question_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> categories = [
    'Syntax',
    'Debugging',
    'Output',
    'Blank',
    'Sequencing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Ground'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 두 개의 카테고리
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // CategoryViewModel에 선택한 카테고리를 설정
                Provider.of<CategoryViewModel>(context, listen: false)
                    .selectCategory(category);

                // QuestionListPage로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionListPage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
