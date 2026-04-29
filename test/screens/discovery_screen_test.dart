import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/screens/discovery_screen.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';
import 'package:slu_scav_hunt/providers/theme_provider.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getInt(any())).thenReturn(null);
  });

  testWidgets('HuntDiscoveryScreen shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          huntsProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(
          home: HuntDiscoveryScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HuntDiscoveryScreen shows empty state in tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          huntsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          home: HuntDiscoveryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No distance-based hunts found.'), findsOneWidget);
    
    // Tap the second tab
    await tester.tap(find.text('Riddle Mode'));
    await tester.pumpAndSettle();
    expect(find.text('No riddle-style hunts found.'), findsOneWidget);
  });

  testWidgets('HuntDiscoveryScreen shows filtered hunts in respective tabs', (WidgetTester tester) async {
    final mockHunts = [
      Hunt(
        id: '1',
        title: 'Distance Hunt',
        description: 'Desc 1',
        creatorName: 'User 1',
        creatorId: 'id1',
        difficulty: 'Easy',
        rating: 4.5,
        coordinates: const GeoPoint(0, 0),
        riddle: 'Riddle 1',
        showDistance: true,
      ),
      Hunt(
        id: '2',
        title: 'Riddle Hunt',
        description: 'Desc 2',
        creatorName: 'User 2',
        creatorId: 'id2',
        difficulty: 'Hard',
        rating: 5.0,
        coordinates: const GeoPoint(0, 0),
        riddle: 'Riddle 2',
        showDistance: false,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          huntsProvider.overrideWith((ref) => Stream.value(mockHunts)),
        ],
        child: const MaterialApp(
          home: HuntDiscoveryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    // In "Distance Shown" tab
    expect(find.text('Distance Hunt'), findsOneWidget);
    expect(find.text('Riddle Hunt'), findsNothing);

    // Switch to "Riddle Mode" tab
    await tester.tap(find.text('Riddle Mode'));
    await tester.pumpAndSettle();
    expect(find.text('Distance Hunt'), findsNothing);
    expect(find.text('Riddle Hunt'), findsOneWidget);
  });
}
