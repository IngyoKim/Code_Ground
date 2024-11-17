import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/quiz_pages/grammer_page.dart'; // Grammer 페이지 import (위 코드를 별도 파일로 만든 경우)

class QuizType extends StatelessWidget {
  const QuizType({super.key});

  @override
  Widget build(BuildContext context) {
    print('This is type');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Type'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.code, color: Colors.black),
            title: const Text('문법'),
            onTap: () {
              // 문법 탭 클릭 시 Grammer 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Grammer()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
          const Divider(
            height: 10.0,
            color: Colors.grey,
            thickness: 0.5,
            endIndent: 20.0,
          ),
          ListTile(
            leading: const Icon(Icons.error, color: Colors.black),
            title: const Text('에러'),
            onTap: () {
              // 클릭 시 동작
              print('에러 tapped');
            },
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
          const Divider(
            height: 10.0,
            color: Colors.grey,
            thickness: 0.5,
            endIndent: 20.0,
          ),
          ListTile(
            leading: const Icon(Icons.print, color: Colors.black),
            title: const Text('출력'),
            onTap: () {
              // 클릭 시 동작
              print('출력 tapped');
            },
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
          const Divider(
            height: 10.0,
            color: Colors.grey,
            thickness: 0.5,
            endIndent: 20.0,
          ),
          ListTile(
            leading: const Icon(Icons.text_fields, color: Colors.black),
            title: const Text('빈칸'),
            onTap: () {
              // 클릭 시 동작
              print('빈칸 tapped');
            },
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
          const Divider(
            height: 10.0,
            color: Colors.grey,
            thickness: 0.5,
            endIndent: 20.0,
          ),
          ListTile(
            leading: const Icon(Icons.sort, color: Colors.black),
            title: const Text('순서'),
            onTap: () {
              // 클릭 시 동작
              print('순서 tapped');
            },
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
          const Divider(
            height: 10.0,
            color: Colors.grey,
            thickness: 0.5,
            endIndent: 20.0,
          ),
        ],
      ),
    );
  }
}
