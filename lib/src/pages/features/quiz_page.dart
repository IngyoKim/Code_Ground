import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// List of programming languages with name, image path, and button color
    final List<Map<String, dynamic>> languages = [
      {
        'name': 'C/C++',
        'imagePath': 'assets/images/languages/c.png',
        'color': const Color(0xFF003366)
      },
      {
        'name': 'Java',
        'imagePath': 'assets/images/languages/java.png',
        'color': const Color(0xFFFFB84D)
      },
      {
        'name': 'Python',
        'imagePath': 'assets/images/languages/python.png',
        'color': const Color(0xFF4B8BBE)
      },
      {
        'name': 'HTML/CSS',
        'imagePath': 'assets/images/languages/htmlcss.png',
        'color': const Color(0xFFCC4400)
      },
      {
        'name': 'JavaScript',
        'imagePath': 'assets/images/languages/javascript.png',
        'color': const Color(0xFFFFE135)
      },
      {
        'name': 'Dart',
        'imagePath': 'assets/images/languages/dart.png',
        'color': const Color(0xFF01796F)
      },
      {
        'name': 'SQL',
        'imagePath': 'assets/images/languages/sql.png',
        'color': const Color(0xFFB85C38)
      },
      {
        'name': 'Ruby',
        'imagePath': 'assets/images/languages/ruby.png',
        'color': const Color(0xFF990000)
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Page'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            /// Items per row
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            return ElevatedButton(
              onPressed: () {},

              /// Button action
              style: ElevatedButton.styleFrom(
                backgroundColor: language['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(language['imagePath']),
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    language['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
