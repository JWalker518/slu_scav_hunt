import 'package:flutter/material.dart';

class HintInputList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAddHint;
  final Function(int) onRemoveHint;

  const HintInputList({
    super.key,
    required this.controllers,
    required this.onAddHint,
    required this.onRemoveHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hints',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...controllers.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Hint ${idx + 1}'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => onRemoveHint(idx),
              ),
            ],
          );
        }),
        TextButton.icon(
          onPressed: onAddHint,
          icon: const Icon(Icons.add),
          label: const Text('ADD HINT'),
        ),
      ],
    );
  }
}
