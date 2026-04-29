import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/services/hunt_service.dart';
import 'package:slu_scav_hunt/providers/hunt_providers.dart';

void main() {
  group('Filtered Hunts Providers Test', () {
    late FakeFirebaseFirestore fakeFirestore;
    late HuntService mockHuntService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockHuntService = HuntService(firestore: fakeFirestore);
    });

    test('distanceShownHuntsProvider and riddleHuntsProvider should filter correctly', () async {
      // Add one hunt with distance shown
      await fakeFirestore.collection('hunts').add({
        'title': 'Distance Hunt',
        'description': 'Desc',
        'creatorName': 'Creator',
        'difficulty': 'Easy',
        'rating': 4.0,
        'coordinates': const GeoPoint(0, 0),
        'riddle': 'Riddle',
        'showDistance': true,
      });

      // Add one hunt with riddle mode (distance hidden)
      await fakeFirestore.collection('hunts').add({
        'title': 'Riddle Hunt',
        'description': 'Desc',
        'creatorName': 'Creator',
        'difficulty': 'Hard',
        'rating': 5.0,
        'coordinates': const GeoPoint(0, 0),
        'riddle': 'Riddle',
        'showDistance': false,
      });

      final container = ProviderContainer(
        overrides: [
          huntServiceProvider.overrideWithValue(mockHuntService),
        ],
      );
      addTearDown(container.dispose);

      // Listen to providers to keep them active
      List<Hunt>? distanceHunts;
      container.listen<AsyncValue<List<Hunt>>>(
        distanceShownHuntsProvider,
        (previous, next) => next.whenData((value) => distanceHunts = value),
        fireImmediately: true,
      );

      List<Hunt>? riddleHunts;
      container.listen<AsyncValue<List<Hunt>>>(
        riddleHuntsProvider,
        (previous, next) => next.whenData((value) => riddleHunts = value),
        fireImmediately: true,
      );

      // Give it time to resolve
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify Distance Shown Hunts
      expect(distanceHunts, isNotNull);
      expect(distanceHunts!.length, 1);
      expect(distanceHunts![0].title, 'Distance Hunt');
      expect(distanceHunts![0].showDistance, isTrue);

      // Verify Riddle Hunts
      expect(riddleHunts, isNotNull);
      expect(riddleHunts!.length, 1);
      expect(riddleHunts![0].title, 'Riddle Hunt');
      expect(riddleHunts![0].showDistance, isFalse);
    });
  });
}
