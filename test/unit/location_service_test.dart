import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/core/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    test('Preset cities include key pilgrimage and metro cities with coordinates', () {
      expect(LocationService.presetCities.length, greaterThanOrEqualTo(15));

      final kashi = LocationService.getCityByName('Varanasi (Kashi)');
      expect(kashi.isSacred, true);
      expect(kashi.latitude, closeTo(25.31, 0.1));
      expect(kashi.longitude, closeTo(82.97, 0.1));

      final delhi = LocationService.defaultCity;
      expect(delhi.name, 'New Delhi');
      expect(delhi.timezone, 5.5);

      final kathmandu = LocationService.getCityByName('Kathmandu');
      expect(kathmandu.isSacred, true);
      expect(kathmandu.timezone, 5.75);
    });
  });
}
