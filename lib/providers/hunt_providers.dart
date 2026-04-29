import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

/// A controller for handling hunt actions and managing their loading/error states.
final huntControllerProvider = StateNotifierProvider<HuntController, AsyncValue<void>>((ref) {
  return HuntController(ref.watch(huntServiceProvider));
});

class HuntController extends StateNotifier<AsyncValue<void>> {
  final HuntService _huntService;

  HuntController(this._huntService) : super(const AsyncData(null));

  Future<void> createHunt(Hunt hunt) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _huntService.createHunt(hunt));
  }
}

/// StreamProvider that exposes the list of hunts, automatically
/// filtering based on the current searchQueryProvider.
final huntsProvider = StreamProvider<List<Hunt>>((ref) {
  final huntService = ref.watch(huntServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  return huntService.searchHunts(searchQuery);
});

/// Provider for hunts that show exact distance.
final distanceShownHuntsProvider = Provider<AsyncValue<List<Hunt>>>((ref) {
  final huntsAsync = ref.watch(huntsProvider);
  return huntsAsync.whenData((hunts) => hunts.where((h) => h.showDistance).toList());
});

/// Provider for riddle-style hunts that hide exact distance.
final riddleHuntsProvider = Provider<AsyncValue<List<Hunt>>>((ref) {
  final huntsAsync = ref.watch(huntsProvider);
  return huntsAsync.whenData((hunts) => hunts.where((h) => !h.showDistance).toList());
});
