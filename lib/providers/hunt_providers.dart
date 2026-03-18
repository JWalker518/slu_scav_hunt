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
  
  return huntService.searchHunts(searchQuery);
});
