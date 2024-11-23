import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'CBNU Department of Computer Engineering, 2024',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
