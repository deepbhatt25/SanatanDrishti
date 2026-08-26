import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/features/kundali/models/kundali_model.dart';
import 'package:bhagvat_geeta_app/features/kundali/services/kundali_calculator.dart';

void main() {
  group('Vedic Kundali Calculator Tests', () {
    test('Calculates authentic Kundali for given birth details', () {
      final profile = KundaliProfile(
        id: 'test_1',
        name: 'Arjun',
        gender: Gender.male,
        dateOfBirth: DateTime(1995, 8, 15),
        birthTimeHour: 10,
        birthTimeMinute: 30,
        cityName: 'Ahmedabad',
        latitude: 23.0225,
        longitude: 72.5714,
        timezone: 5.5,
        createdAt: DateTime.now(),
      );

      final kundali = KundaliCalculator.calculateVedicKundali(profile);

      // Lagna verification (1-12)
      expect(kundali.lagnaRashiId >= 1 && kundali.lagnaRashiId <= 12, true);
      expect(kundali.lagnaDegree >= 0.0 && kundali.lagnaDegree <= 30.0, true);

      // 12 Planets (9 Vedic Grahas + Uranus, Neptune, Pluto) verification
      expect(kundali.planets.length, 12);
      expect(kundali.planets.any((p) => p.nameEn == 'Pluto'), true);
      expect(kundali.planets.any((p) => p.nameEn == 'Neptune'), true);
      expect(kundali.planets.any((p) => p.nameEn == 'Uranus'), true);
      for (final p in kundali.planets) {
        expect(p.rashiId >= 1 && p.rashiId <= 12, true);
        expect(p.degree >= 0.0 && p.degree <= 30.0, true);
        expect(p.houseNumber >= 1 && p.houseNumber <= 12, true);
        expect(p.navamshaRashiId >= 1 && p.navamshaRashiId <= 12, true);
        expect(p.nameHi.isNotEmpty, true);
        expect(p.nameGu.isNotEmpty, true);
      }

      // Moon and Sun sign verification
      expect(kundali.moonRashiId >= 1 && kundali.moonRashiId <= 12, true);
      expect(kundali.sunRashiId >= 1 && kundali.sunRashiId <= 12, true);

      // Nakshatra and Charan
      expect(kundali.nakshatraHi.isNotEmpty, true);
      expect(kundali.nakshatraGu.isNotEmpty, true);
      expect(kundali.charan >= 1 && kundali.charan <= 4, true);

      // Avakahada elements
      expect(kundali.ganaHi.isNotEmpty, true);
      expect(kundali.nadiHi.isNotEmpty, true);
      expect(kundali.yoniHi.isNotEmpty, true);
      expect(kundali.varnaHi.isNotEmpty, true);
      expect(kundali.luckyGemstoneHi.isNotEmpty, true);
      expect(kundali.luckyGemstoneGu.isNotEmpty, true);

      // Mangal Dosha result
      expect(kundali.mangalDosha.doshaTypeHi.isNotEmpty, true);
      expect(kundali.mangalDosha.doshaTypeGu.isNotEmpty, true);

      // Vimshottari Dashas (9 full cycle periods)
      expect(kundali.dashas.length, 9);
      expect(kundali.dashas.first.planetNameHi.isNotEmpty, true);

      // 12 House interpretations
      expect(kundali.bhavas.length, 12);
      expect(kundali.bhavas.first.titleHi.isNotEmpty, true);
      expect(kundali.bhavas.first.titleGu.isNotEmpty, true);

      // Life Predictions
      expect(kundali.lifePrediction.physicalAppearance.descriptionHi.isNotEmpty, true);
      expect(kundali.lifePrediction.physicalAppearance.descriptionGu.isNotEmpty, true);
      expect(kundali.lifePrediction.personalitySwabhav.descriptionHi.isNotEmpty, true);
      expect(kundali.lifePrediction.personalitySwabhav.descriptionGu.isNotEmpty, true);
      expect(kundali.lifePrediction.marriagePrediction.timingOrAge != null, true);
      expect(kundali.lifePrediction.careerBhagyodaya.timingOrAge != null, true);
      expect(kundali.lifePrediction.rajaYogasHi.isNotEmpty, true);
      expect(kundali.lifePrediction.rajaYogasGu.isNotEmpty, true);
      expect(kundali.lifePrediction.ishtaDevataHi.isNotEmpty, true);
      expect(kundali.lifePrediction.ishtaDevataGu.isNotEmpty, true);
      expect(kundali.lifePrediction.sacredMantraHi.isNotEmpty, true);
      expect(kundali.lifePrediction.sacredMantraGu.isNotEmpty, true);
    });

    test('House and Navamsha chart maps construct properly', () {
      final profile = KundaliProfile(
        id: 'test_2',
        name: 'Pooja',
        gender: Gender.female,
        dateOfBirth: DateTime(2000, 1, 1),
        birthTimeHour: 6,
        birthTimeMinute: 0,
        cityName: 'New Delhi',
        latitude: 28.6139,
        longitude: 77.2090,
        timezone: 5.5,
        createdAt: DateTime.now(),
      );

      final kundali = KundaliCalculator.calculateVedicKundali(profile);
      final houseSignMap = kundali.houseSignMap;
      expect(houseSignMap.length, 12);
      expect(houseSignMap[1], kundali.lagnaRashiId);

      final housePlanets = kundali.housePlanetsMap;
      expect(housePlanets.length, 12);

      final navamshaPlanets = kundali.navamshaHousePlanetsMap;
      expect(navamshaPlanets.length, 12);
    });

    test('Calculates authentic Non-Manglik Kundali for 15 Jan 1997 (Mahuva)', () {
      final profile = KundaliProfile(
        id: 'dipesh_test',
        name: 'Dipesh Pankajbhai bhatt',
        gender: Gender.male,
        dateOfBirth: DateTime(1997, 1, 15),
        birthTimeHour: 4,
        birthTimeMinute: 25,
        cityName: 'Mahuva (Bhavnagar)',
        latitude: 21.0914,
        longitude: 71.7633,
        timezone: 5.5,
        createdAt: DateTime.now(),
      );

      final kundali = KundaliCalculator.calculateVedicKundali(profile);

      // Moon in Pisces (Meen Rashi = 12)
      expect(kundali.moonRashiId, 12);
      expect(kundali.nakshatraGu, 'રેવતી');

      // Mars in House 9 (Virgo) from Capricorn Lagna -> NON-MANGLIK
      expect(kundali.mangalDosha.hasDosha, false);
      expect(kundali.mangalDosha.doshaTypeGu.contains('દોષ મુક્ત'), true);

      // Predictions non-empty
      expect(kundali.lifePrediction.physicalAppearance.descriptionGu.isNotEmpty, true);
      expect(kundali.lifePrediction.personalitySwabhav.descriptionGu.isNotEmpty, true);
      expect(kundali.lifePrediction.marriagePrediction.descriptionGu.isNotEmpty, true);
      expect(kundali.lifePrediction.careerBhagyodaya.descriptionGu.isNotEmpty, true);

      // Dosha Analysis (Kaal Sarp & Shani Sade Sati 2nd Charan & Powerful Gemstones)
      final doshaAnalysis = KundaliCalculator.calculateDoshaAnalysis(
        planets: kundali.planets,
        moonRashiId: kundali.moonRashiId,
        lagnaRashiId: kundali.lagnaRashiId,
      );

      // Kaal Sarp Yog active (Vasuki Kaal Sarp / Hemmed on Rahu-Ketu axis)
      expect(doshaAnalysis.hasKaalSarp, true);
      expect(doshaAnalysis.kaalSarpNameGu.contains('કાળસર્પ'), true);

      // Sade Sati 2nd Charan for Pisces Moon in 2026
      expect(doshaAnalysis.shaniStatusGu.contains('દ્વિતીય ચરણ'), true);

      // Powerful and Avoid Gemstones
      expect(doshaAnalysis.powerfulGemstoneGu.isNotEmpty, true);
      expect(doshaAnalysis.avoidGemstoneGu.isNotEmpty, true);
    });
  });
}
