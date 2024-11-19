import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  final TextEditingController titleController;

  const TitleInput({
    super.key,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
        maxLines: 1,
      ),
    );
  }
}
