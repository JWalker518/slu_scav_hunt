import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/screens/hunt_gameplay_screen.dart';
import 'package:slu_scav_hunt/widgets/location_rationale_dialog.dart';
import 'package:slu_scav_hunt/providers/location_providers.dart';
import 'package:slu_scav_hunt/widgets/hunt_detail_header.dart';

class HuntDetailScreen extends ConsumerWidget {
  final Hunt hunt;

  const HuntDetailScreen({super.key, required this.hunt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(hunt.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.report_problem, color: Colors.orange),
            onPressed: () => _showReportDialog(context),
            tooltip: 'Report Hunt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HuntDetailHeader(
              title: hunt.title,
              rating: hunt.rating,
              creatorName: hunt.creatorName,
              difficultyChip: _buildDifficultyChip(hunt.difficulty),
            ),
            const Divider(height: 32),

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

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _handleStartHunt(context, ref),
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

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Hunt'),
        content: const Text('Are you sure you want to report this hunt for inappropriate content?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hunt reported. Thank you.')),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartHunt(BuildContext context, WidgetRef ref) async {
    final locationService = ref.read(locationServiceProvider);
    
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => const LocationRationaleDialog(),
    );

    if (proceed == true) {
      final hasPermission = await locationService.handleLocationPermission();
      if (hasPermission) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HuntGameplayScreen(hunt: hunt),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required to play.')),
          );
        }
      }
    }
  }

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
