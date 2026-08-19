import '../../../core/providers/language_provider.dart';

class PanchangModel {
  final DateTime date;
  final String cityName;
  final String tithi;
  final String tithiPaksha;
  final String nakshatra;
  final String yoga;
  final String karana;
  final String vaar;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String lunarMonth;
  final String ritu;
  final String vikramSamvat;
  final String shakaSamvat;
  final String rahuKaal;
  final String abhijitMuhurta;
  final String brahmaMuhurta;
  final String yamaganda;
  final String gulikaiKaal;
  final String ayana;
  final bool isFromCache;

  const PanchangModel({
    required this.date,
    required this.cityName,
    required this.tithi,
    required this.tithiPaksha,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.vaar,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.lunarMonth,
    required this.ritu,
    required this.vikramSamvat,
    required this.shakaSamvat,
    required this.rahuKaal,
    required this.abhijitMuhurta,
    required this.brahmaMuhurta,
    required this.yamaganda,
    required this.gulikaiKaal,
    required this.ayana,
    this.isFromCache = false,
  });

  factory PanchangModel.fromJson(Map<String, dynamic> json, {bool isCached = false}) {
    final tithiData = json['tithi'];
    final nakshatraData = json['nakshatra'];
    final yogaData = json['yoga'];
    final karanaData = json['karana'];

    String extractName(dynamic val, String fallback) {
      if (val is String) return val;
      if (val is Map && val.containsKey('name')) return val['name'].toString();
      if (val is Map && val.containsKey('tithi_name')) return val['tithi_name'].toString();
      return fallback;
    }

    return PanchangModel(
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now() : DateTime.now(),
      cityName: json['city_name']?.toString() ?? 'Selected Location',
      tithi: extractName(tithiData, json['tithi_name']?.toString() ?? 'प्रतिपदा (Pratipada)'),
      tithiPaksha: json['paksha']?.toString() ?? json['tithi_paksha']?.toString() ?? 'शुक्ल पक्ष (Shukla Paksha)',
      nakshatra: extractName(nakshatraData, json['nakshatra_name']?.toString() ?? 'रोहिणी (Rohini)'),
      yoga: extractName(yogaData, json['yoga_name']?.toString() ?? 'सिद्धि (Siddhi)'),
      karana: extractName(karanaData, json['karana_name']?.toString() ?? 'बव (Bava)'),
      vaar: json['vaar']?.toString() ?? 'बुधवार (Wednesday)',
      sunrise: json['sunrise']?.toString() ?? '05:52 AM',
      sunset: json['sunset']?.toString() ?? '06:55 PM',
      moonrise: json['moonrise']?.toString() ?? '08:15 PM',
      moonset: json['moonset']?.toString() ?? '06:40 AM',
      lunarMonth: json['lunar_month']?.toString() ?? json['month']?.toString() ?? 'भाद्रपद (Bhadrapada)',
      ritu: json['ritu']?.toString() ?? 'वर्षा ऋतु (Monsoon)',
      vikramSamvat: json['vikram_samvat']?.toString() ?? '2083',
      shakaSamvat: json['shaka_samvat']?.toString() ?? '1948',
      rahuKaal: json['rahu_kaal']?.toString() ?? '12:20 PM – 01:55 PM',
      abhijitMuhurta: json['abhijit_muhurta']?.toString() ?? '11:58 AM – 12:48 PM',
      brahmaMuhurta: json['brahma_muhurta']?.toString() ?? '04:15 AM – 05:03 AM',
      yamaganda: json['yamaganda']?.toString() ?? '07:30 AM – 09:05 AM',
      gulikaiKaal: json['gulikai_kaal']?.toString() ?? '10:45 AM – 12:20 PM',
      ayana: json['ayana']?.toString() ?? 'दक्षिणायन (Dakshinayana)',
      isFromCache: isCached,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'city_name': cityName,
      'tithi': tithi,
      'tithi_paksha': tithiPaksha,
      'nakshatra': nakshatra,
      'yoga': yoga,
      'karana': karana,
      'vaar': vaar,
      'sunrise': sunrise,
      'sunset': sunset,
      'moonrise': moonrise,
      'moonset': moonset,
      'lunar_month': lunarMonth,
      'ritu': ritu,
      'vikram_samvat': vikramSamvat,
      'shaka_samvat': shakaSamvat,
      'rahu_kaal': rahuKaal,
      'abhijit_muhurta': abhijitMuhurta,
      'brahma_muhurta': brahmaMuhurta,
      'yamaganda': yamaganda,
      'gulikai_kaal': gulikaiKaal,
      'ayana': ayana,
    };
  }

  // --- Dynamic Gujarati & Hindi Localization Helpers ---
  String getLocalizedTithi(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return tithi;
    return _convertToGujarati(tithi);
  }

  String getLocalizedPaksha(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return tithiPaksha;
    if (tithiPaksha.contains('शुक्ल') || tithiPaksha.contains('Shukla')) {
      return 'સુદ પક્ષ (શુક્લ)';
    }
    return 'વદ પક્ષ (કૃષ્ણ)';
  }

  String getLocalizedNakshatra(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return nakshatra;
    return _convertToGujarati(nakshatra);
  }

  String getLocalizedYoga(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return yoga;
    return _convertToGujarati(yoga);
  }

  String getLocalizedKarana(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return karana;
    return _convertToGujarati(karana);
  }

  String getLocalizedVaar(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return vaar;
    switch (date.weekday) {
      case 1: return 'સોમવાર (Monday)';
      case 2: return 'મંગળવાર (Tuesday)';
      case 3: return 'બુધવાર (Wednesday)';
      case 4: return 'ગુરુવાર (Thursday)';
      case 5: return 'શુક્રવાર (Friday)';
      case 6: return 'શનિવાર (Saturday)';
      case 7:
      default: return 'રવિવાર (Sunday)';
    }
  }

  String getLocalizedRitu(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return ritu;
    return _convertToGujarati(ritu);
  }

  String getLocalizedAyana(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return ayana;
    if (ayana.contains('दक्षिणायन')) {
      return 'દક્ષિણાયન (Dakshinayana)';
    }
    return 'ઉત્તરાયણ (Uttarayana)';
  }

  static String _convertToGujarati(String devanagariText) {
    // Converts Devanagari Unicode (0x0900–0x097F) to Gujarati Unicode (0x0A80–0x0AFF)
    final buffer = StringBuffer();
    for (int i = 0; i < devanagariText.length; i++) {
      final code = devanagariText.codeUnitAt(i);
      if (code >= 0x0900 && code <= 0x097F) {
        // Gujarati block is offset by +0x0180 (384) from Devanagari
        final gujCode = code + 0x0180;
        buffer.writeCharCode(gujCode);
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }
}
