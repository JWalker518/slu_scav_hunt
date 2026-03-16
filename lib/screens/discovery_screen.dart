import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hunt_providers.dart';
import '../models/hunt.dart';

class HuntDiscoveryScreen extends ConsumerWidget {
  const HuntDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final huntsAsync = ref.watch(huntsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Hunts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
    if (hunts.isEmpty) {
      return const Center(
        child: Text('No hunts found. Try a different search!'),
      );
    }

    return ListView.builder(
      itemCount: hunts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final hunt = hunts[index];
        // Note: For now we use a simple ListTile. 
        // Step 2.6 will involve creating a custom HuntCard widget.
        return Card(
          child: ListTile(
            title: Text(hunt.title),
            subtitle: Text(hunt.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(hunt.rating.toString()),
              ],
            ),
            onTap: () {
              // Navigation will be implemented in Step 2.7
            },
          ),
        );
      },
    );
  }
}
