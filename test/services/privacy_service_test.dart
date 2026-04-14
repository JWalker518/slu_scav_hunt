import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slu_scav_hunt/services/privacy_service.dart';

void main() {
  group('PrivacyService Test', () {
    test('isLocationRestricted should return the zone name if location is restricted', () {
      // Restricted Area A is at (44.5912, -75.1667) with 100m radius
      const restrictedLocation = LatLng(44.5912, -75.1667);
      
      final result = PrivacyService.isLocationRestricted(restrictedLocation);
      
      expect(result, 'Restricted Area A');
    });

    test('isLocationRestricted should return null if location is not restricted', () {
      // Far away from any restricted zone
      const safeLocation = LatLng(45.0000, -76.0000);
      
      final result = PrivacyService.isLocationRestricted(safeLocation);
      
      expect(result, isNull);
    });

    test('isLocationRestricted should return the zone name if location is within radius', () {
      // Slightly offset but within 100m of Restricted Area A
      const restrictedLocation = LatLng(44.5915, -75.1667);
      
      final result = PrivacyService.isLocationRestricted(restrictedLocation);
      
      expect(result, 'Restricted Area A');
    });
  });
}
