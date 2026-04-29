import 'package:cloud_firestore/cloud_firestore.dart';

class Hunt {
  final String id;
  final String title;
  final String description;
  final String creatorName;
  final String creatorId; // Added for ownership and security
  final String difficulty;
  final double rating;
  final GeoPoint coordinates;
  final String riddle;
  final List<String> hints; // New field for hints
  final String? imageUrl; // New optional field for media support
  final bool showDistance; // Whether to show exact distance or proximity clues

  // Initialize the instance data
  Hunt({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorName,
    required this.creatorId,
    required this.difficulty,
    required this.rating,
    required this.coordinates,
    required this.riddle,
    this.hints = const [], // Default to empty list
    this.imageUrl,
    this.showDistance = true,
  });

  // Create a Hunt object from a Firestore document
  factory Hunt.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    
    // If nothing was entered
    if (data == null) {
      throw Exception("Document data was null for Hunt ID: ${doc.id}");
    }

    // Convert entered data into the hunt model to be used
    return Hunt(
      id: doc.id,
      title: data['title']?.toString() ?? 'Untitled Hunt',
      description: data['description']?.toString() ?? 'No description available',
      creatorName: data['creatorName']?.toString() ?? 'Anonymous',
      creatorId: data['creatorId']?.toString() ?? '',
      difficulty: data['difficulty']?.toString() ?? 'Normal',
      rating: _toDouble(data['rating']),
      coordinates: data['coordinates'] is GeoPoint 
          ? data['coordinates'] as GeoPoint 
          : const GeoPoint(0, 0),
      riddle: data['riddle']?.toString() ?? 'No riddle provided',
      hints: _toStringList(data['hints']),
      imageUrl: data['imageUrl']?.toString(),
      showDistance: data['showDistance'] is bool ? data['showDistance'] as bool : true,
    );
  }

  // Helper to safely convert Firestore numbers (which might be int or double) to double
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0.0;
  }

  // Helper to safely convert Firestore data to a List<String>
  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  // Convert a Hunt object into a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorName': creatorName,
      'creatorId': creatorId,
      'difficulty': difficulty,
      'rating': rating,
      'coordinates': coordinates,
      'riddle': riddle,
      'hints': hints,
      'imageUrl': imageUrl,
      'showDistance': showDistance,
    };
  }
}
