import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slu_scav_hunt/models/hunt.dart';
import 'package:slu_scav_hunt/services/hunt_service.dart';

/// Provider for the HuntService
final huntServiceProvider = Provider<HuntService>((ref) {
  return HuntService();
});

/// Notifier for the search query
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

/// Provider for the current search query
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// StreamProvider that exposes the list of hunts, automatically
/// filtering based on the current searchQueryProvider.
final huntsProvider = StreamProvider<List<Hunt>>((ref) {
  final huntService = ref.watch(huntServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  

  // Had some trouble connecting to Firebase, so this was a test in the console so that I could see if it was a code error 
  // or a firebase error
  // Adding a timeout ensures that if Firestore hangs, we see an error instead of a freeze.
  return huntService.searchHunts(searchQuery).timeout(
    const Duration(seconds: 10),
    onTimeout: (sink) {
      print('huntsProvider: Stream timed out after 10 seconds');
      sink.addError('Connection timed out. Please check your Firestore setup and internet connection.');
    },
  );
});
