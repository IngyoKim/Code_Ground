import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/pages/questions/question_list_page.dart';

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
        title: const Text(
          'Code Ground',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<CategoryViewModel>(context, listen: false)
                          .selectCategory(category);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionListPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
