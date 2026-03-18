import 'package:flutter/material.dart';
import 'package:slu_scav_hunt/models/hunt.dart';

class HuntDetailScreen extends StatelessWidget {
  final Hunt hunt;

  const HuntDetailScreen({super.key, required this.hunt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(hunt.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hunt.title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      hunt.rating.toStringAsFixed(1),
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Creator and Difficulty
            Row(
              children: [
                Text(
                  'Created by ${hunt.creatorName}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                _buildDifficultyChip(hunt.difficulty),
              ],
            ),
            const Divider(height: 32),

            // Description Section
            Text(
              'Description',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              hunt.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Riddle Section (Preview)
            Card(
              color: theme.colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'The Riddle',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hunt.riddle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hunt gameplay will be implemented in Phase 4!')),
                  );
                },
                child: const Text(
                  'START HUNT',
                  style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Stores difficulty color selections
  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        chipColor = Colors.green;
        break;
      case 'hard':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.orange;
    }


    return Chip(
      label: Text(
        difficulty.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
