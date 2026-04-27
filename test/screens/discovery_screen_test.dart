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

  testWidgets('HuntDiscoveryScreen shows empty state', (WidgetTester tester) async {
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
    expect(find.text('No hunts found. Try a different search!'), findsOneWidget);
  });

  testWidgets('HuntDiscoveryScreen shows list of hunts', (WidgetTester tester) async {
    final mockHunts = [
      Hunt(
        id: '1',
        title: 'Hunt 1',
        description: 'Desc 1',
        creatorName: 'User 1',
        creatorId: 'id1',
        difficulty: 'Easy',
        rating: 4.5,
        coordinates: const GeoPoint(0, 0),
        riddle: 'Riddle 1',
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
    expect(find.text('Hunt 1'), findsOneWidget);
    expect(find.text('EASY'), findsOneWidget);
  });
}
