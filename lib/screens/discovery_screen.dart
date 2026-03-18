import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/widgets/hunt_card.dart';

class HuntDiscoveryScreen extends ConsumerWidget {
  const HuntDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final huntsAsync = ref.watch(huntsProvider);

    // The menu bar on the top of the screen
    return Scaffold(
      appBar: AppBar(
        // The 'Hunt' title
        title: const Text('Discover Hunts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // The Search Bar background text
              decoration: InputDecoration(
                hintText: 'Search hunts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).setQuery(value);
              },
            ),
          ),
        ),
      ),
      body: huntsAsync.when(
        data: (hunts) => _buildHuntList(hunts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }


  Widget _buildHuntList(List<Hunt> hunts) {

    // When searching, return a message if no hunts are found
    if (hunts.isEmpty) {
      return const Center(
        child: Text('No hunts found. Try a different search!'),
      );
    }

    // The list of hunts to be presented on the homepage
    return ListView.builder(
      itemCount: hunts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final hunt = hunts[index];

        // The card presenting the hunt on the homepage
        return HuntCard(
          hunt: hunt,
          onTap: () {
            // Navigation will be implemented in Step 2.7
          },
        );
      },
    );
  }
}
