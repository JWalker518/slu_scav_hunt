import 'package:cloud_firestore/cloud_firestore.dart';

class Hunt {
  final String id;
  final String title;
  final String description;
  final String creatorName;
  final String difficulty;
  final double rating;
  final GeoPoint coordinates;
  final String riddle;

  Hunt({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorName,
    required this.difficulty,
    required this.rating,
    required this.coordinates,
    required this.riddle,
  });
}
