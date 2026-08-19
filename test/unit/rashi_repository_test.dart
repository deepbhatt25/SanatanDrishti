import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/core/constants/rashi_data.dart';
import 'package:bhagvat_geeta_app/features/rashi/models/rashi_model.dart';

void main() {
  group('Rashi Bhavishya Tests', () {
    test('12 Rashis map accurately to API Ninjas zodiac params', () {
      expect(RashiData.rashis.length, 12);

      final mesha = RashiData.getRashiById(1);
      expect(mesha.zodiacParam, 'aries');
      expect(mesha.hindiName, 'मेष');
      expect(mesha.symbol, '♈');

      final meena = RashiData.getRashiById(12);
      expect(meena.zodiacParam, 'pisces');
      expect(meena.hindiName, 'मीन');
      expect(meena.symbol, '♓');

      final makara = RashiData.getRashiByParam('capricorn');
      expect(makara.hindiName, 'मकर');
      expect(makara.id, 10);
    });

    test('RashiReadingModel serialization and deserialization', () {
      final json = {
        'date': 'August 19, 2026',
        'zodiac_sign': 'leo',
        'horoscope': 'A radiant and productive day for creative endeavors.',
        'horoscope_hindi': 'आज का दिन अत्यंत शुभ और ऊर्जावान रहेगा।',
        'lucky_number': '1',
        'lucky_color': 'Gold',
        'compatibility': 'Sagittarius',
      };

      final reading = RashiReadingModel.fromJson(json);
      expect(reading.zodiacSign, 'leo');
      expect(reading.horoscopeText, contains('radiant'));
      expect(reading.rashiInfo.hindiName, 'सिंह');
      expect(reading.rashiInfo.symbol, '♌');
      expect(reading.toJson()['lucky_number'], '1');
    });
  });
}
