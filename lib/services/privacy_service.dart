import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PrivacyZone {
  final String name;
  final LatLng center;
  final double radius; // in meters

  PrivacyZone({required this.name, required this.center, required this.radius});
}

class PrivacyService {
  // Define some example restricted zones (e.g., near residential areas or sensitive campus spots)
  static final List<PrivacyZone> restrictedZones = [
    PrivacyZone(
      name: 'Restricted Area A',
      center: const LatLng(44.5912, -75.1667), // Example coordinate
      radius: 100,
    ),
    PrivacyZone(
      name: 'Restricted Area B',
      center: const LatLng(44.5950, -75.1700), // Another example
      radius: 50,
    ),
  ];

  /// Checks if a location is within any restricted privacy zone.
  /// Returns the name of the zone if restricted, otherwise null.
  static String? isLocationRestricted(LatLng location) {
    for (var zone in restrictedZones) {
      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        zone.center.latitude,
        zone.center.longitude,
      );
      if (distance <= zone.radius) {
        return zone.name;
      }
    }
    return null;
  }
}
