import 'package:flutter/material.dart';

class HintInput extends StatelessWidget {
  final TextEditingController hintController;

  const HintInput({
    super.key,
    required this.hintController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: hintController,
        decoration: const InputDecoration(
          labelText: 'Hint',
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
