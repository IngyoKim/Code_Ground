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
          'settings의 Your Info 부분 안의 친구코드를 친구에게 공유하세요.\nSocial Page의 friend에서 친구 코드를 통해 친구를 추가할 수 있습니다.',
    },
    {
      'question': 'Admin 권한을 어떻게 요청하나요?',
      'answer': '/카페 링크 기입 예정\n 해당 카페에서 요청하실 수 있습니다.',
    },
    {
      'question': 'What is the app\'s privacy policy?',
      'answer':
          'Our privacy policy can be accessed through the "About" page in the app. It outlines how we handle your data and your privacy rights.',
    },
    {
      'question': '문제 추가하는 방법은 무엇인가요?',
      'answer':
          '문제를 추가하기 위해선 admin권한을 얻어야 합니다.\nadmin권한에 대한 자세한 내용은 Help에 기재되어 있습니다.',
    },
    {
      'question': 'How can I give feedback?',
      'answer':
          'To provide feedback, visit the "Help" page and click on "Send Feedback". You can submit suggestions or report issues directly through this feature.',
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
