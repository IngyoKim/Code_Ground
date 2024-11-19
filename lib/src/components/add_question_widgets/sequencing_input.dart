import 'package:flutter/material.dart';

class SequencingInput extends StatelessWidget {
  final Map<int, String> steps;
  final VoidCallback onAddStep;
  final ValueChanged<int> onRemoveStep;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int key, String value) onUpdateStep;

  const SequencingInput({
    super.key,
    required this.steps,
    required this.onAddStep,
    required this.onRemoveStep,
    required this.onReorder,
    required this.onUpdateStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add and Reorder Steps:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: onReorder,
          children: steps.entries.map((entry) {
            return ListTile(
              key: ValueKey(entry.key),
              title: TextField(
                decoration: InputDecoration(
                  labelText: 'Step ${entry.key + 1}',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => onUpdateStep(entry.key, value),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemoveStep(entry.key),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onAddStep,
          child: const Text('Add Step'),
        ),
      ],
    );
  }
}
