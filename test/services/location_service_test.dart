import 'package:flutter_test/flutter_test.dart';
import 'package:slu_scav_hunt/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    test('calculateDistance returns correct distance between two points', () {
      // Points in Canton, NY (SLU)
      const lat1 = 44.5912;
      const lon1 = -75.1667;
      
      const lat2 = 44.5915;
      const lon2 = -75.1667;

      final distance = locationService.calculateDistance(lat1, lon1, lat2, lon2);
      
      // Approximately 33 meters
      expect(distance, closeTo(33.3, 1.0));
    });
  });
}
