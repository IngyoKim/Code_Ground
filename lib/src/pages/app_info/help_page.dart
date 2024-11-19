import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 제목
            const Text(
              'How can we assist you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 앱 사용법
            _buildHelpSection(
              context,
              title: 'How to use the app',
              subtitle: 'Learn how to use our app effectively with these tips.',
              onTap: () {
                // 앱 사용법 페이지로 이동
                // 예시로 다른 페이지로 이동하려면 Navigator.push() 사용
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('App Usage Guide'),
                    content:
                        Text('Here you can find useful tips and tutorials.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // 고객 지원
            _buildHelpSection(
              context,
              title: 'Customer Support',
              subtitle: 'Need assistance? Contact our support team.',
              onTap: () {
                // 고객 지원 페이지로 이동
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Contact Support'),
                    content: Text('You can reach us at support@example.com.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Feedback
            _buildHelpSection(
              context,
              title: 'Send Feedback',
              subtitle: 'We value your feedback to improve the app.',
              onTap: () {
                // 피드백 보내기 페이지로 이동
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Send Feedback'),
                    content: Text('Tell us how we can improve the app.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 도움말 섹션을 위한 헬퍼 함수
  Widget _buildHelpSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
