import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';
import 'package:slu_scav_hunt/providers/auth_providers.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/widgets/hunt_card.dart';
import 'package:slu_scav_hunt/screens/hunt_detail_screen.dart';
import 'package:slu_scav_hunt/screens/hunt_creation_screen.dart';

import 'package:slu_scav_hunt/providers/theme_provider.dart';

class HuntDiscoveryScreen extends ConsumerWidget {
  const HuntDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover Hunts'),
          actions: [
            IconButton(
              icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              tooltip: 'Toggle Theme',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
              },
              tooltip: 'Logout',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search hunts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).setQuery(value);
                    },
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Distance Shown', icon: Icon(Icons.straighten)),
                    Tab(text: 'Riddle Mode', icon: Icon(Icons.psychology)),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _HuntListTab(
              huntsAsync: ref.watch(distanceShownHuntsProvider),
              emptyMessage: 'No distance-based hunts found.',
            ),
            _HuntListTab(
              huntsAsync: ref.watch(riddleHuntsProvider),
              emptyMessage: 'No riddle-style hunts found.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HuntCreationScreen()),
            );
          },
          tooltip: 'Create New Hunt',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _HuntListTab extends StatelessWidget {
  final AsyncValue<List<Hunt>> huntsAsync;
  final String emptyMessage;

  const _HuntListTab({
    required this.huntsAsync,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return huntsAsync.when(
      data: (hunts) => _buildHuntList(context, hunts),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildHuntList(BuildContext context, List<Hunt> hunts) {
    if (hunts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(emptyMessage, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView.builder(
      itemCount: hunts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final hunt = hunts[index];
        return HuntCard(
          hunt: hunt,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HuntDetailScreen(hunt: hunt),
              ),
            );
          },
        );
      },
    );
  }
}
