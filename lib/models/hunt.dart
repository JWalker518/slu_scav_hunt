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

  /// Create a Hunt object from a Firestore document
  factory Hunt.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    
    if (data == null) {
      throw Exception("Document data was null for Hunt ID: ${doc.id}");
    }

    return Hunt(
      id: doc.id,
      title: data['title']?.toString() ?? 'Untitled Hunt',
      description: data['description']?.toString() ?? 'No description available',
      creatorName: data['creatorName']?.toString() ?? 'Anonymous',
      difficulty: data['difficulty']?.toString() ?? 'Normal',
      rating: _toDouble(data['rating']),
      coordinates: data['coordinates'] is GeoPoint 
          ? data['coordinates'] as GeoPoint 
          : const GeoPoint(0, 0),
      riddle: data['riddle']?.toString() ?? 'No riddle provided',
    );
  }

  /// Helper to safely convert Firestore numbers (which might be int or double) to double
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0.0;
  }

  /// Convert a Hunt object into a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorName': creatorName,
      'difficulty': difficulty,
      'rating': rating,
      'coordinates': coordinates,
      'riddle': riddle,
    };
  }
}
