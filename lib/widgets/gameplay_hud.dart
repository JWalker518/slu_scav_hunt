import 'package:flutter/material.dart';

class GameplayHUD extends StatelessWidget {
  final String riddle;
  final int revealedHints;
  final int totalHints;
  final bool hasImage;
  final VoidCallback onShowHint;
  final VoidCallback onShowImage;

  const GameplayHUD({
    super.key,
    required this.riddle,
    required this.revealedHints,
    required this.totalHints,
    required this.hasImage,
    required this.onShowHint,
    required this.onShowImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: Colors.white.withAlpha(240),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The Riddle',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  riddle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (totalHints > 0)
              ElevatedButton.icon(
                onPressed: onShowHint,
                icon: const Icon(Icons.lightbulb),
                label: Text('Hint ($revealedHints/$totalHints)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[100],
                  foregroundColor: Colors.amber[900],
                ),
              ),
            if (hasImage) ...[
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: onShowImage,
                icon: const Icon(Icons.image),
                label: const Text('View Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[900],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
