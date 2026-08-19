import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhagvat_geeta_app/core/constants/app_strings.dart';
import 'package:bhagvat_geeta_app/core/constants/chapter_metadata.dart';
import 'package:bhagvat_geeta_app/core/constants/rashi_data.dart';
import 'package:bhagvat_geeta_app/core/providers/language_provider.dart';
import 'package:bhagvat_geeta_app/core/services/location_service.dart';
import 'package:bhagvat_geeta_app/core/services/storage_service.dart';
import 'package:bhagvat_geeta_app/features/panchang/models/panchang_model.dart';
import 'package:bhagvat_geeta_app/features/panchang/repositories/panchang_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Language & Gujarati Localization Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService();
      storageService.initForTesting(prefs);
    });

    test('LanguageProvider toggles between Hindi and Gujarati and formats digits', () async {
      final langProvider = LanguageProvider(storageService: storageService);
      expect(langProvider.isHindi, true);
      expect(langProvider.isGujarati, false);
      expect(langProvider.formatNumber(18), '१८');

      await langProvider.setLanguage(AppLanguage.gujarati);
      expect(langProvider.isGujarati, true);
      expect(langProvider.isHindi, false);
      expect(langProvider.formatNumber(18), '૧૮');
      expect(langProvider.formatNumber(700), '૭૦૦');

      await langProvider.toggleLanguage();
      expect(langProvider.isHindi, true);
    });

    test('ChapterMetadata contains complete Gujarati chapter titles and summaries', () {
      expect(ChapterMetadata.chapters.length, 18);

      final ch1 = ChapterMetadata.getChapter(1);
      expect(ch1.nameGujarati, 'અર્જુનવિષાદયોગ');
      expect(ch1.summaryGujarati.contains('કુરુક્ષેત્ર'), true);

      final ch18 = ChapterMetadata.getChapter(18);
      expect(ch18.nameGujarati, 'મોક્ષસંન્યાસયોગ');
      expect(ch18.summaryGujarati.contains('ગીતા'), true);
    });

    test('RashiData contains complete Gujarati zodiac signs, planets, and elements', () {
      expect(RashiData.rashis.length, 12);

      final aries = RashiData.getRashiById(1);
      expect(aries.gujaratiName, 'મેષ');
      expect(aries.rulingPlanetGujarati, 'મંગળ (Mars)');
      expect(aries.elementGujarati, 'અગ્નિ (Fire)');

      final pisces = RashiData.getRashiById(12);
      expect(pisces.gujaratiName, 'મીન');
      expect(pisces.rulingPlanetGujarati, 'ગુરુ (Jupiter)');
    });

    test('Choghadiya and Baby Rashi generate authentic Gujarati values', () {
      final date = DateTime(2026, 8, 19, 10, 30);
      final city = LocationService.defaultCity;

      final choghadiya = PanchangRepository.calculateDayNightChoghadiya(date, city);
      expect(choghadiya.dayChoghadiya.length, 8);
      expect(choghadiya.dayChoghadiya.first.nameGujarati.isNotEmpty, true);
      expect(choghadiya.dayChoghadiya.first.qualityLabelGujarati.isNotEmpty, true);

      final babyRashi = PanchangRepository.calculateBabyBornRashi(date, city);
      expect(babyRashi.rashiGujarati.isNotEmpty, true);
      expect(babyRashi.nakshatraGujarati.isNotEmpty, true);
      expect(babyRashi.allPadaNamakshar.length, 4);
    });

    test('PanchangModel translates astronomical names to Gujarati dynamically', () {
      final panchang = PanchangModel(
        date: DateTime(2026, 8, 19),
        cityName: 'New Delhi',
        tithi: 'शुक्ल प्रतिपदा (Pratipada)',
        tithiPaksha: 'शुक्ल पक्ष (Shukla Paksha)',
        nakshatra: 'रोहिणी (Rohini)',
        yoga: 'सिद्धि (Siddhi)',
        karana: 'बव (Bava)',
        vaar: 'बुधवार (Wednesday)',
        sunrise: '05:52 AM',
        sunset: '06:55 PM',
        moonrise: '08:15 PM',
        moonset: '06:40 AM',
        lunarMonth: 'भाद्रपद',
        ritu: 'वर्षा ऋतु',
        vikramSamvat: '2083',
        shakaSamvat: '1948',
        rahuKaal: '12:00 PM – 01:30 PM',
        abhijitMuhurta: '11:58 AM – 12:48 PM',
        brahmaMuhurta: '04:15 AM – 05:03 AM',
        yamaganda: '07:30 AM – 09:00 AM',
        gulikaiKaal: '10:30 AM – 12:00 PM',
        ayana: 'दक्षिणायन (Dakshinayana)',
      );

      final tithiGu = panchang.getLocalizedTithi(AppLanguage.gujarati);
      expect(tithiGu.contains('શુક્લ') || tithiGu.contains('પ્રતિપદા'), true);

      final pakshaGu = panchang.getLocalizedPaksha(AppLanguage.gujarati);
      expect(pakshaGu.contains('સુદ'), true);

      final vaarGu = panchang.getLocalizedVaar(AppLanguage.gujarati);
      expect(vaarGu.contains('બુધવાર'), true);
    });

    test('AppStrings provides localized labels for both Hindi and Gujarati', () {
      expect(AppStrings.navGeeta(AppLanguage.hindi), 'गीता');
      expect(AppStrings.navGeeta(AppLanguage.gujarati), 'ગીતા');

      expect(AppStrings.navPanchang(AppLanguage.hindi), 'पञ्चाङ्ग');
      expect(AppStrings.navPanchang(AppLanguage.gujarati), 'પંચાંગ');

      expect(AppStrings.navRashi(AppLanguage.hindi), 'राशि');
      expect(AppStrings.navRashi(AppLanguage.gujarati), 'રાશિ');
    });
  });
}
