import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slu_scav_hunt/models/hunt.dart';

void main() {
  group('Hunt Model Test', () {
    test('Hunt object should be correctly instantiated', () {
      const id = 'test_id';
      const title = 'Test Hunt';
      const description = 'Test Description';
      const creatorName = 'Test Creator';
      const difficulty = 'Easy';
      const rating = 4.5;
      const coordinates = GeoPoint(44.5912, -75.1667); // SLU
      const riddle = 'Test Riddle';

      final hunt = Hunt(
        id: id,
        title: title,
        description: description,
        creatorName: creatorName,
        difficulty: difficulty,
        rating: rating,
        coordinates: coordinates,
        riddle: riddle,
      );

      expect(hunt.id, id);
      expect(hunt.title, title);
      expect(hunt.description, description);
      expect(hunt.creatorName, creatorName);
      expect(hunt.difficulty, difficulty);
      expect(hunt.rating, rating);
      expect(hunt.coordinates, coordinates);
      expect(hunt.riddle, riddle);
    });

    test('toMap should return a correct map representation', () {
      final hunt = Hunt(
        id: 'test_id',
        title: 'Test Hunt',
        description: 'Test Description',
        creatorName: 'Test Creator',
        difficulty: 'Easy',
        rating: 4.5,
        coordinates: const GeoPoint(44.5912, -75.1667),
        riddle: 'Test Riddle',
      );

      final map = hunt.toMap();

      expect(map['title'], 'Test Hunt');
      expect(map['description'], 'Test Description');
      expect(map['creatorName'], 'Test Creator');
      expect(map['difficulty'], 'Easy');
      expect(map['rating'], 4.5);
      expect(map['coordinates'], const GeoPoint(44.5912, -75.1667));
      expect(map['riddle'], 'Test Riddle');
    });
  });
}
