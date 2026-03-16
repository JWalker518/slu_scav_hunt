import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/services/hunt_service.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';

void main() {
  group('Hunt Providers Test', () {
    late FakeFirebaseFirestore fakeFirestore;
    late HuntService mockHuntService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockHuntService = HuntService(firestore: fakeFirestore);
    });

    test('huntsProvider should provide hunts from the service', () async {
      // 1. Setup mock data BEFORE creating the container
      await fakeFirestore.collection('hunts').add({
        'title': 'Test Hunt',
        'description': 'Desc',
        'creatorName': 'Creator',
        'difficulty': 'Easy',
        'rating': 4.0,
        'coordinates': const GeoPoint(0, 0),
        'riddle': 'Riddle',
      });

      // 2. Setup ProviderContainer
      final container = ProviderContainer(
        overrides: [
          huntServiceProvider.overrideWithValue(mockHuntService),
        ],
      );
      addTearDown(container.dispose);

      // 3. Wait for the provider to emit data
      // We use a listener to ensure the provider stays alive and we can capture the data
      List<Hunt>? results;
      container.listen<AsyncValue<List<Hunt>>>(
        huntsProvider,
        (previous, next) {
          next.whenData((value) => results = value);
        },
        fireImmediately: true,
      );

      // Give it a few microtasks to resolve
      await Future.microtask(() {});
      await Future.microtask(() {});

      // 4. Verify data
      expect(results, isNotNull, reason: 'Provider should have emitted data');
      expect(results!.length, 1);
      expect(results![0].title, 'Test Hunt');
    });

    test('huntsProvider should react to searchQueryProvider changes', () async {
      await fakeFirestore.collection('hunts').add({
        'title': 'Alpha Hunt',
        'description': 'Desc',
        'creatorName': 'Creator',
        'difficulty': 'Easy',
        'rating': 4.0,
        'coordinates': const GeoPoint(0, 0),
        'riddle': 'Riddle',
      });
      await fakeFirestore.collection('hunts').add({
        'title': 'Beta Hunt',
        'description': 'Desc',
        'creatorName': 'Creator',
        'difficulty': 'Hard',
        'rating': 5.0,
        'coordinates': const GeoPoint(0, 0),
        'riddle': 'Riddle',
      });

      final container = ProviderContainer(
        overrides: [
          huntServiceProvider.overrideWithValue(mockHuntService),
        ],
      );
      addTearDown(container.dispose);

      List<Hunt>? results;
      container.listen<AsyncValue<List<Hunt>>>(
        huntsProvider,
        (previous, next) {
          next.whenData((value) => results = value);
        },
        fireImmediately: true,
      );

      // Set search query to 'Alpha'
      container.read(searchQueryProvider.notifier).setQuery('Alpha');

      // Wait for the stream to update - use a slightly longer delay for Firestore fake
      await Future.delayed(const Duration(milliseconds: 100));
      await Future.microtask(() {});

      expect(results, isNotNull, reason: 'Provider should have emitted filtered results');
      expect(results!.length, 1);
      expect(results![0].title, 'Alpha Hunt');
    });
  });
}
