import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check and request location permissions (Foreground)
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    // Note: On web, this can sometimes be unreliable or throw.
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the 
        // App to enable the location services.
        return false;
      }
    } catch (e) {
      // If it throws on web, we assume it might be working or we let the permission check handle it
      if (!kIsWeb) return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  /// Check and request background location permission
  Future<bool> handleBackgroundLocationPermission() async {
    if (kIsWeb) return false;

    // Background location is only available if foreground is already granted
    final hasForeground = await handleLocationPermission();
    if (!hasForeground) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    
    // On Android 10+, background location is a separate permission
    if (Platform.isAndroid) {
      if (permission != LocationPermission.always) {
        // Requesting 'always' permission triggers the system background prompt
        permission = await Geolocator.requestPermission();
        return permission == LocationPermission.always;
      }
    } else if (Platform.isIOS) {
      // iOS handling is slightly different but geolocator abstracts it
      if (permission != LocationPermission.always) {
        permission = await Geolocator.requestPermission();
        return permission == LocationPermission.always;
      }
    }

    return permission == LocationPermission.always;
  }

  /// Get current position
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Get position stream for geofencing
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// Calculate distance between two points in meters
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
