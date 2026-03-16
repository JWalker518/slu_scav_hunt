import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/screens/discovery_screen.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  testWidgets('HuntDiscoveryScreen shows loading indicator', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          huntsProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(home: HuntDiscoveryScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HuntDiscoveryScreen shows empty message when no hunts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          huntsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(home: HuntDiscoveryScreen()),
      ),
    );

    await tester.pump(); // Start the stream
    await tester.pump(); // Build with data

    expect(find.text('No hunts found. Try a different search!'), findsOneWidget);
  });

  testWidgets('HuntDiscoveryScreen displays hunt list', (tester) async {
    final mockHunt = Hunt(
      id: '1',
      title: 'Amazing Hunt',
      description: 'A great description',
      creatorName: 'James',
      difficulty: 'Easy',
      rating: 4.5,
      coordinates: const GeoPoint(0, 0),
      riddle: 'Test Riddle',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          huntsProvider.overrideWith((ref) => Stream.value([mockHunt])),
        ],
        child: const MaterialApp(home: HuntDiscoveryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Amazing Hunt'), findsOneWidget);
    expect(find.text('A great description'), findsOneWidget);
  });
}
