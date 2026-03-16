import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slu_scav_hunt/services/hunt_service.dart';

void main() {
  group('HuntService Test', () {
    late FakeFirebaseFirestore fakeFirestore;
    late HuntService huntService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      huntService = HuntService(firestore: fakeFirestore);
    });

    test('getHunts should return a stream of hunts from Firestore', () async {
      // 1. Add some mock data to the fake firestore
      await fakeFirestore.collection('hunts').add({
        'title': 'Test Hunt 1',
        'description': 'Description 1',
        'creatorName': 'Creator 1',
        'difficulty': 'Easy',
        'rating': 4.0,
        'coordinates': const GeoPoint(44.5912, -75.1667),
        'riddle': 'Riddle 1',
      });

      await fakeFirestore.collection('hunts').add({
        'title': 'Test Hunt 2',
        'description': 'Description 2',
        'creatorName': 'Creator 2',
        'difficulty': 'Hard',
        'rating': 5.0,
        'coordinates': const GeoPoint(44.0, -75.0),
        'riddle': 'Riddle 2',
      });

      // 2. Get the stream from the service
      final huntsStream = huntService.getHunts();

      // 3. Verify the stream emits the correct data
      final huntsList = await huntsStream.first;

      expect(huntsList.length, 2);
      expect(huntsList[0].title, anyOf('Test Hunt 1', 'Test Hunt 2'));
      expect(huntsList[1].title, anyOf('Test Hunt 1', 'Test Hunt 2'));
    });

    test('searchHunts should return filtered hunts based on the query', () async {
       await fakeFirestore.collection('hunts').add({
        'title': 'Alpha Hunt',
        'description': 'Description A',
        'creatorName': 'Creator A',
        'difficulty': 'Easy',
        'rating': 4.0,
        'coordinates': const GeoPoint(44.5912, -75.1667),
        'riddle': 'Riddle A',
      });

      await fakeFirestore.collection('hunts').add({
        'title': 'Beta Hunt',
        'description': 'Description B',
        'creatorName': 'Creator B',
        'difficulty': 'Hard',
        'rating': 5.0,
        'coordinates': const GeoPoint(44.0, -75.0),
        'riddle': 'Riddle B',
      });

      final filteredStream = huntService.searchHunts('Alpha');
      final filteredList = await filteredStream.first;

      expect(filteredList.length, 1);
      expect(filteredList[0].title, 'Alpha Hunt');
    });
  });
}
