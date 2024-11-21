import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // 5명의 개발자 정보를 리스트로 관리
  final List<Map<String, String>> developers = [
    {
      'name': '김인교',
      'email': 'a58276976@gmail.com',
    },
    {
      'name': '신지안',
      'email': 'tlswldks12345@gmail.com',
    },
    {
      'name': '장윤호',
      'email': 'yunho2066@gmail.com',
    },
    {
      'name': '전상민',
      'email': 'jeonsm0404@gmail.com',
    },
    {
      'name': '최희진',
      'email': 'osisland2918@gmail.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Name',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // 여백 줄임
            const Text(
              'Code Ground',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16), // 여백 줄임
            const Divider(),
            const SizedBox(height: 8), // 여백 줄임
            const Text(
              'Developer Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // 여백 줄임
            // 5명의 개발자 정보를 ListView로 표시
            ListView.builder(
              shrinkWrap: true, // 리스트뷰가 부모 위젯의 크기만큼만 차지하도록 설정
              itemCount: developers.length,
              itemBuilder: (context, index) {
                final developer = developers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // 여백 줄임
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developer: ${developer['name']}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Email: ${developer['email']}'),
                      const SizedBox(height: 8), // 여백 줄임
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8), // 여백 줄임
            const Text(
              'Version Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // 여백 줄임
            const Text(
              'Version: 1.0.0\n'
              'Build: 100',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16), // 여백 줄임
            ElevatedButton(
              onPressed: () {
                // SnackBar를 ScaffoldMessenger를 통해 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Open in browser functionality can be added.'),
                  ),
                );
              },
              child: const Text('Visit Website'),
            ),
          ],
        ),
      ),
    );
  }
}
