import 'package:flutter/material.dart';

class DescriptionInput extends StatelessWidget {
  final TextEditingController descriptionController;

  const DescriptionInput({
    super.key,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
