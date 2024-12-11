import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // FAQ 질문 및 답변 목록
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'To reset your password, go to the settings page and select "Reset Password". You will receive an email with a link to reset your password.',
    },
    {
      'question': 'How can I contact support?',
      'answer':
          'You can contact support through the "Help" section in the app. Simply click on the "Contact Support" button.',
    },
    {
      'question': 'What is the app\'s privacy policy?',
      'answer':
          'Our privacy policy can be accessed through the "About" page in the app. It outlines how we handle your data and your privacy rights.',
    },
    {
      'question': 'How do I update the app?',
      'answer':
          'App updates are available through your device\'s app store (Google Play or Apple App Store). Make sure to enable automatic updates or check for updates manually.',
    },
    {
      'question': 'How can I give feedback?',
      'answer':
          'To provide feedback, visit the "Help" page and click on "Send Feedback". You can submit suggestions or report issues directly through this feature.',
    },
  ];

  // Track selection status for FAQ lists
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
                      // Adjust text width for remaining space
                      child: Text(
                        faq['question']!,
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                initiallyExpanded: _isExpanded[
                    index], // Set Open/Close to Existing Status Values
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpanded[index] = expanded; // Update Open/Closed Status
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
