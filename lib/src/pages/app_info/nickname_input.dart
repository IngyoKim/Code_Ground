import 'package:flutter/material.dart';

class NicknameInput extends StatelessWidget {
  final TextEditingController nicknameController;

  const NicknameInput({
    super.key,
    required this.nicknameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: nicknameController,
        decoration: const InputDecoration(
          labelText: 'Nickname',
          hintText: 'Enter your nickname',
        ),
        maxLines: 1,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
