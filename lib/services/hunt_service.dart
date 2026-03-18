import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slu_scav_hunt/models/hunt.dart';

class HuntService {
  final FirebaseFirestore _firestore;

  HuntService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns a stream of all hunts in the 'hunts' collection
  Stream<List<Hunt>> getHunts() {
    print('HuntService: Requesting hunts stream...');
    return _firestore
        .collection('hunts')
        .snapshots()
        .map((snapshot) {
          print('HuntService: Received snapshot with ${snapshot.docs.length} documents');
          return snapshot.docs.map((doc) {
            try {
              return Hunt.fromFirestore(doc);
            } catch (e) {
              print('HuntService: Error parsing document ${doc.id}: $e');
              rethrow;
            }
          }).toList();
        });
  }

  /// Optional: Fetch hunts filtered by a query (e.g., for search)
  /// This will be useful for Step 2.4
  Stream<List<Hunt>> searchHunts(String query) {
    if (query.isEmpty) return getHunts();
    
    // Note: Firestore doesn't support full-text search natively without third-party services,
    // but we can do a simple prefix match for now or filter in the provider.
    return _firestore
        .collection('hunts')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Hunt.fromFirestore(doc)).toList();
        });
  }
}
