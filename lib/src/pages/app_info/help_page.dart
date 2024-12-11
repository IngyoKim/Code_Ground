import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
            /// Main title
            const Text(
              'How can we assist you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Help section for app usage
            _buildHelpSection(
              context,
              title: 'How to use the app',
              subtitle: 'Learn how to use our app effectively with these tips.',
              onTap: () {
                /// Navigate to the app usage guide or show dialog with tips
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

            /// Help section for customer support
            _buildHelpSection(
              context,
              title: 'Customer Support',
              subtitle: 'Need assistance? Contact our support team.',
              onTap: () {
                /// Show dialog with customer support contact information
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

            /// Help section for feedback
            _buildHelpSection(
              context,
              title: 'Send Feedback',
              subtitle: 'We value your feedback to improve the app.',
              onTap: () {
                /// Show dialog for sending feedback
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

  /// Helper function to build help section cards
  Widget _buildHelpSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      /// Trigger the onTap function when tapped
      child: Card(
        elevation: 3,

        /// Card shadow elevation
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title of the help section
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              /// Subtitle of the help section
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
