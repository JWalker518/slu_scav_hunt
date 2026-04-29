import 'package:flutter/material.dart';

class GameplayStatusCard extends StatelessWidget {
  final bool isCompleted;
  final double distance;
  final bool showDistance;
  final VoidCallback onBack;

  const GameplayStatusCard({
    super.key,
    required this.isCompleted,
    required this.distance,
    required this.showDistance,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNear = distance < 100;
    final isVeryNear = distance < 30;
    final isFar = distance > 500;

    String proximityText;
    if (isVeryNear) {
      proximityText = 'You are right on top of it!';
    } else if (isNear) {
      proximityText = 'You are very close!';
    } else if (isFar) {
      proximityText = 'Keep searching... it\'s still a bit far.';
    } else {
      proximityText = 'You\'re getting warmer!';
    }

    return Card(
      color: isCompleted ? Colors.green : (isNear ? Colors.orange : theme.cardColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted) ...[
              const Icon(Icons.check_circle, color: Colors.white, size: 48),
              const SizedBox(height: 8),
              const Text(
                'CORRECT! YOU FOUND IT!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onBack,
                child: const Text('Back to Discovery'),
              ),
            ] else ...[
              Text(
                showDistance ? (isNear ? 'You are very close!' : 'Keep searching...') : proximityText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isNear ? Colors.white : theme.textTheme.bodyLarge?.color,
                ),
              ),
              if (showDistance) ...[
                const SizedBox(height: 4),
                Text(
                  'Distance: ${distance.toInt()}m',
                  style: TextStyle(
                    color: isNear ? Colors.white70 : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
