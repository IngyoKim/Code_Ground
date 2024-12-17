import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  /// FAQ Questions and Answers List
  final List<Map<String, String>> faqs = [
    {
      'question': '친구 추가는 어떻게 하나요?',
      'answer':
          'settings의 나의 정보 부분 안의 친구코드를 친구에게 공유하세요.\n소셜의 친구에서 친구 코드를 통해 친구를 추가할 수 있습니다.',
    },
    {
      'question': '문제 추가하는 방법은 무엇인가요?',
      'answer':
          '문제를 추가하기 위해선 Operator이상의 역할을 얻어야 합니다.\n역할에 대한 자세한 내용은 Help에 기재되어 있습니다.',
    },
    {
      'question': 'Operator, Master 역할을 어떻게 요청하나요?',
      'answer': '/https://cafe.naver.com/cbnucodeground\n 해당 카페에서 요청하실 수 있습니다.',
    },
    {
      'question': '문제는 어떻게 해결하나요?',
      'answer':
          'sequencing문제를 제외한 모든 문제들은 객관식과 주관식 문제들로 나뉘어 있습니다.\n객관식 문제들은 주어진 선지들 중 옳은 선지를 구하는 문제입니다. 주관식 문제는 문제 생성자가 요구한 답과 동일한 답을 작성하여 제출하여야 하는 문제입니다.\nsequencing문제는 주어진 선지들의 순서를 드래그를 통해 바꾸는 문제입니다. 옳은 순서를 맞춘다면 정답처리됩니다.',
    },
    {
      'question': '피드백을 어떻게 제공할 수 있나요?',
      'answer':
          '피드백을 제공하려면 카페에 방문하고 글을 작성해주세요. \n이 기능을 통해 제안을 제출하거나 문제를 직접 보고할 수 있습니다.',
    },
  ];

  /// Track selection status for FAQ lists
  final List<bool> _isExpanded = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ExpansionTile(
                title: Row(
                  children: [
                    const Icon(Icons.question_answer),
                    const SizedBox(width: 8.0),
                    Flexible(
                      /// Adjust text width for remaining space
                      child: Text(
                        faq['question']!,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                initiallyExpanded: _isExpanded[index],

                /// Set Open/Close to Existing Status Values
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded[index] = expanded;

                    /// Update Open/Closed Status
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
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
