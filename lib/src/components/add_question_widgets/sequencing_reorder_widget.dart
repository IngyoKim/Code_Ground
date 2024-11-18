import 'package:flutter/material.dart';

class SequencingReorderWidget extends StatelessWidget {
  final Map<int, String> items;
  final VoidCallback onAddStep;
  final ValueChanged<int> onRemoveStep;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int key, String value) onUpdateCode;

  const SequencingReorderWidget({
    super.key,
    required this.items,
    required this.onAddStep,
    required this.onRemoveStep,
    required this.onReorder,
    required this.onUpdateCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Reorder the steps and add code:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: onReorder,
          children: [
            for (var entry in items.entries)
              ListTile(
                key: ValueKey(entry.key),
                title: TextField(
                  decoration:
                      InputDecoration(labelText: 'Step ${entry.key + 1}'),
                  onChanged: (value) => onUpdateCode(entry.key, value),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemoveStep(entry.key),
                ),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: onAddStep,
          child: const Text('Add Step'),
        ),
      ],
    );
  }
}
