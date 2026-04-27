import 'package:flutter/material.dart';

class HuntDetailHeader extends StatelessWidget {
  final String title;
  final double rating;
  final String creatorName;
  final Widget difficultyChip;

  const HuntDetailHeader({
    super.key,
    required this.title,
    required this.rating,
    required this.creatorName,
    required this.difficultyChip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
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
                  rating.toStringAsFixed(1),
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Created by $creatorName',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            difficultyChip,
          ],
        ),
      ],
    );
  }
}
