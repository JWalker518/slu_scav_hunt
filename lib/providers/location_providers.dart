import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final currentPositionProvider = FutureProvider<Position?>((ref) async {
  final service = ref.watch(locationServiceProvider);
  final hasPermission = await service.handleLocationPermission();
  if (hasPermission) {
    return await service.getCurrentPosition();
  }
  return null;
});

final positionStreamProvider = StreamProvider<Position>((ref) async* {
  final service = ref.watch(locationServiceProvider);
  final hasPermission = await service.handleLocationPermission();
  
  if (hasPermission) {
    yield* service.getPositionStream();
  } else {
    // Optionally throw or handle as needed
    throw Exception('Location permission not granted');
  }
});
