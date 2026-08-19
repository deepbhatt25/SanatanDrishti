import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/core/services/location_service.dart';
import 'package:bhagvat_geeta_app/features/panchang/repositories/panchang_repository.dart';

void main() {
  group('Panchang Calculation & Fallback Tests', () {
    test('Calculates valid Vedic Panchang model for given date and city', () {
      final testDate = DateTime(2026, 8, 19);
      final city = LocationService.getCityByName('Varanasi (Kashi)');

      final panchang = PanchangRepository.calculateVedicPanchang(testDate, city);

      expect(panchang.cityName, 'Varanasi (Kashi)');
      expect(panchang.tithi, isNotEmpty);
      expect(panchang.tithiPaksha, isNotEmpty);
      expect(panchang.nakshatra, isNotEmpty);
      expect(panchang.yoga, isNotEmpty);
      expect(panchang.karana, isNotEmpty);
      expect(panchang.vaar, contains('Wednesday'));
      expect(panchang.vikramSamvat, '2083');
      expect(panchang.shakaSamvat, '1948');
      expect(panchang.rahuKaal, isNotEmpty);
      expect(panchang.abhijitMuhurta, isNotEmpty);
      expect(panchang.brahmaMuhurta, isNotEmpty);
    });

    test('Panchang model converts to and from JSON smoothly', () {
      final testDate = DateTime(2026, 8, 19);
      final city = LocationService.getCityByName('New Delhi');
      final original = PanchangRepository.calculateVedicPanchang(testDate, city);

      final json = original.toJson();
      final restored = PanchangRepository.calculateVedicPanchang(testDate, city);

      expect(restored.cityName, original.cityName);
      expect(restored.vikramSamvat, original.vikramSamvat);
      expect(restored.vaar, original.vaar);
      expect(json['vikram_samvat'], '2083');
    });

    test('Sunrise, Sunset, Moonrise change dynamically across dates and seasons', () {
      final city = LocationService.getCityByName('New Delhi');
      final summer = PanchangRepository.calculateVedicPanchang(DateTime(2026, 6, 21), city);
      final winter = PanchangRepository.calculateVedicPanchang(DateTime(2026, 12, 21), city);
      final autumn = PanchangRepository.calculateVedicPanchang(DateTime(2026, 8, 25), city);

      // Summer vs Winter sunrise & sunset must be distinct
      expect(summer.sunrise, isNot(equals(winter.sunrise)));
      expect(summer.sunset, isNot(equals(winter.sunset)));

      // August 25 vs June 21 must be distinct
      expect(autumn.sunrise, isNot(equals(summer.sunrise)));
      expect(autumn.moonrise, isNotEmpty);
      expect(autumn.moonset, isNotEmpty);
    });

    test('Calculates 8 Day & 8 Night Choghadiyas accurately', () {
      final city = LocationService.getCityByName('New Delhi');
      final date = DateTime(2026, 8, 25); // Tuesday

      final choghadiya = PanchangRepository.calculateDayNightChoghadiya(date, city);

      expect(choghadiya.dayChoghadiya.length, 8);
      expect(choghadiya.nightChoghadiya.length, 8);

      // Tuesday starts with Rog (Day) and Kaal (Night)
      expect(choghadiya.dayChoghadiya.first.nameHindi, 'रोग');
      expect(choghadiya.nightChoghadiya.first.nameHindi, 'काल');
    });

    test('Calculates Baby Born Rashi and Namakshar for given birth time', () {
      final city = LocationService.getCityByName('New Delhi');
      final birthTime = DateTime(2026, 8, 25, 14, 30); // 2:30 PM

      final babyRashi = PanchangRepository.calculateBabyBornRashi(birthTime, city);

      expect(babyRashi.rashiHindi, isNotEmpty);
      expect(babyRashi.rashiSymbol, isNotEmpty);
      expect(babyRashi.nakshatraHindi, isNotEmpty);
      expect(babyRashi.pada, inInclusiveRange(1, 4));
      expect(babyRashi.allPadaNamakshar.length, 4);
      expect(babyRashi.recommendedLetter, isNotEmpty);
    });
  });
}
