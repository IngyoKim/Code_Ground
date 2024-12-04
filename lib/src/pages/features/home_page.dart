import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/utils/permission_utils.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/pages/questions/question_list_page.dart';
import 'package:code_ground/src/pages/questions/add_question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Syntax', 'icon': Icons.code},
    {'name': 'Debugging', 'icon': Icons.bug_report},
    {'name': 'Output', 'icon': Icons.print},
    {'name': 'Blank', 'icon': Icons.edit},
    {'name': 'Sequencing', 'icon': Icons.format_list_numbered},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/code_ground_logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'CODEGROUND',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // "Select a Category" with Fixed Add Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Select a Category',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // 고정된 크기의 버튼
                  Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      final role = userViewModel.currentUserData?.role ?? '';
                      return SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          icon: Icon(
                            RolePermissions.canPerformAction(role, 'create')
                                ? Icons.add_rounded
                                : null, // 기본 아이콘 제공
                          ),
                          onPressed:
                              RolePermissions.canPerformAction(role, 'create')
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddQuestionPage(),
                                        ),
                                      );
                                    }
                                  : null, // 관리자가 아닐 경우 비활성화
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Scrollable menu list
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final colors = [
                    Colors.orange.shade400,
                    Colors.pink.shade300,
                    Colors.red.shade400,
                    Colors.green.shade300,
                    Colors.blue.shade400,
                  ];

                  return GestureDetector(
                    onTap: () async {
                      final categoryViewModel = Provider.of<CategoryViewModel>(
                          context,
                          listen: false);
                      final questionViewModel = Provider.of<QuestionViewModel>(
                          context,
                          listen: false);

                      // 카테고리 선택 및 상태 초기화
                      categoryViewModel.selectCategory(
                          category['name'], questionViewModel);

                      // 새로운 질문 데이터를 로드
                      await questionViewModel.fetchQuestions(
                          category: category['name']);

                      // 질문 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionListPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 16.0, left: 16.0, right: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
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
                            category['icon'],
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              category['name'],
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
