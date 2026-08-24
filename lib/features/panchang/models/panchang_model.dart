import '../../../core/providers/language_provider.dart';

class PanchangModel {
  final DateTime date;
  final String cityName;
  final String tithi;
  final String tithiPaksha;
  final String tithiStartTime;
  final String tithiEndTime;
  final String nextTithi;
  final String nextTithiGujarati;

  final String nakshatra;
  final String nakshatraStartTime;
  final String nakshatraEndTime;
  final String nextNakshatra;
  final String nextNakshatraGujarati;

  final String yoga;
  final String yogaStartTime;
  final String yogaEndTime;
  final String nextYoga;
  final String nextYogaGujarati;

  final String karana;
  final String karanaStartTime;
  final String karanaEndTime;
  final String nextKarana;
  final String nextKaranaGujarati;

  final String rashi;
  final String rashiGujarati;
  final String rashiStartTime;
  final String rashiEndTime;
  final String nextRashi;
  final String nextRashiGujarati;

  final String vaar;
  final String vaarStartTime;
  final String vaarEndTime;
  final String nextVaar;
  final String nextVaarGujarati;

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
    this.tithiStartTime = '',
    this.tithiEndTime = '',
    this.nextTithi = '',
    this.nextTithiGujarati = '',
    required this.nakshatra,
    this.nakshatraStartTime = '',
    this.nakshatraEndTime = '',
    this.nextNakshatra = '',
    this.nextNakshatraGujarati = '',
    required this.yoga,
    this.yogaStartTime = '',
    this.yogaEndTime = '',
    this.nextYoga = '',
    this.nextYogaGujarati = '',
    required this.karana,
    this.karanaStartTime = '',
    this.karanaEndTime = '',
    this.nextKarana = '',
    this.nextKaranaGujarati = '',
    this.rashi = 'धनु (Sagittarius)',
    this.rashiGujarati = 'ધન (Sagittarius)',
    this.rashiStartTime = '',
    this.rashiEndTime = '',
    this.nextRashi = 'मकर (Capricorn)',
    this.nextRashiGujarati = 'મકર (Capricorn)',
    required this.vaar,
    this.vaarStartTime = '',
    this.vaarEndTime = '',
    this.nextVaar = '',
    this.nextVaarGujarati = '',
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
      tithiStartTime: json['tithi_start_time']?.toString() ?? '',
      tithiEndTime: json['tithi_end_time']?.toString() ?? '',
      nextTithi: json['next_tithi']?.toString() ?? '',
      nextTithiGujarati: json['next_tithi_gu']?.toString() ?? '',
      nakshatra: extractName(nakshatraData, json['nakshatra_name']?.toString() ?? 'रोहिणी (Rohini)'),
      nakshatraStartTime: json['nakshatra_start_time']?.toString() ?? '',
      nakshatraEndTime: json['nakshatra_end_time']?.toString() ?? '',
      nextNakshatra: json['next_nakshatra']?.toString() ?? '',
      nextNakshatraGujarati: json['next_nakshatra_gu']?.toString() ?? '',
      yoga: extractName(yogaData, json['yoga_name']?.toString() ?? 'सिद्धि (Siddhi)'),
      yogaStartTime: json['yoga_start_time']?.toString() ?? '',
      yogaEndTime: json['yoga_end_time']?.toString() ?? '',
      nextYoga: json['next_yoga']?.toString() ?? '',
      nextYogaGujarati: json['next_yoga_gu']?.toString() ?? '',
      karana: extractName(karanaData, json['karana_name']?.toString() ?? 'बव (Bava)'),
      karanaStartTime: json['karana_start_time']?.toString() ?? '',
      karanaEndTime: json['karana_end_time']?.toString() ?? '',
      nextKarana: json['next_karana']?.toString() ?? '',
      nextKaranaGujarati: json['next_karana_gu']?.toString() ?? '',
      rashi: json['rashi']?.toString() ?? 'धनु (Sagittarius)',
      rashiGujarati: json['rashi_gu']?.toString() ?? 'ધન (Sagittarius)',
      rashiStartTime: json['rashi_start_time']?.toString() ?? '',
      rashiEndTime: json['rashi_end_time']?.toString() ?? '',
      nextRashi: json['next_rashi']?.toString() ?? 'मकर (Capricorn)',
      nextRashiGujarati: json['next_rashi_gu']?.toString() ?? 'મકર (Capricorn)',
      vaar: json['vaar']?.toString() ?? 'बुधवार (Wednesday)',
      vaarStartTime: json['vaar_start_time']?.toString() ?? '',
      vaarEndTime: json['vaar_end_time']?.toString() ?? '',
      nextVaar: json['next_vaar']?.toString() ?? '',
      nextVaarGujarati: json['next_vaar_gu']?.toString() ?? '',
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
      'tithi_start_time': tithiStartTime,
      'tithi_end_time': tithiEndTime,
      'next_tithi': nextTithi,
      'next_tithi_gu': nextTithiGujarati,
      'nakshatra': nakshatra,
      'nakshatra_start_time': nakshatraStartTime,
      'nakshatra_end_time': nakshatraEndTime,
      'next_nakshatra': nextNakshatra,
      'next_nakshatra_gu': nextNakshatraGujarati,
      'yoga': yoga,
      'yoga_start_time': yogaStartTime,
      'yoga_end_time': yogaEndTime,
      'next_yoga': nextYoga,
      'next_yoga_gu': nextYogaGujarati,
      'karana': karana,
      'karana_start_time': karanaStartTime,
      'karana_end_time': karanaEndTime,
      'next_karana': nextKarana,
      'next_karana_gu': nextKaranaGujarati,
      'rashi': rashi,
      'rashi_gu': rashiGujarati,
      'rashi_start_time': rashiStartTime,
      'rashi_end_time': rashiEndTime,
      'next_rashi': nextRashi,
      'next_rashi_gu': nextRashiGujarati,
      'vaar': vaar,
      'vaar_start_time': vaarStartTime,
      'vaar_end_time': vaarEndTime,
      'next_vaar': nextVaar,
      'next_vaar_gu': nextVaarGujarati,
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

  String getLocalizedNextTithi(AppLanguage lang) {
    if (nextTithiGujarati.isNotEmpty && lang == AppLanguage.gujarati) return nextTithiGujarati;
    if (lang == AppLanguage.hindi) return nextTithi;
    return _convertToGujarati(nextTithi);
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

  String getLocalizedNextNakshatra(AppLanguage lang) {
    if (nextNakshatraGujarati.isNotEmpty && lang == AppLanguage.gujarati) return nextNakshatraGujarati;
    if (lang == AppLanguage.hindi) return nextNakshatra;
    return _convertToGujarati(nextNakshatra);
  }

  String getLocalizedYoga(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return yoga;
    return _convertToGujarati(yoga);
  }

  String getLocalizedNextYoga(AppLanguage lang) {
    if (nextYogaGujarati.isNotEmpty && lang == AppLanguage.gujarati) return nextYogaGujarati;
    if (lang == AppLanguage.hindi) return nextYoga;
    return _convertToGujarati(nextYoga);
  }

  String getLocalizedKarana(AppLanguage lang) {
    if (lang == AppLanguage.hindi) return karana;
    return _convertToGujarati(karana);
  }

  String getLocalizedNextKarana(AppLanguage lang) {
    if (nextKaranaGujarati.isNotEmpty && lang == AppLanguage.gujarati) return nextKaranaGujarati;
    if (lang == AppLanguage.hindi) return nextKarana;
    return _convertToGujarati(nextKarana);
  }

  String getLocalizedRashi(AppLanguage lang) {
    if (lang == AppLanguage.gujarati && rashiGujarati.isNotEmpty) return rashiGujarati;
    return rashi;
  }

  String getLocalizedNextRashi(AppLanguage lang) {
    if (lang == AppLanguage.gujarati && nextRashiGujarati.isNotEmpty) return nextRashiGujarati;
    return nextRashi;
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

  String getLocalizedNextVaar(AppLanguage lang) {
    if (nextVaarGujarati.isNotEmpty && lang == AppLanguage.gujarati) return nextVaarGujarati;
    if (nextVaar.isNotEmpty && lang == AppLanguage.hindi) return nextVaar;
    final nextDay = (date.weekday % 7) + 1;
    if (lang == AppLanguage.hindi) {
      switch (nextDay) {
        case 1: return 'सोमवार (Monday)';
        case 2: return 'मंगलवार (Tuesday)';
        case 3: return 'बुधवार (Wednesday)';
        case 4: return 'गुरुवार (Thursday)';
        case 5: return 'शुक्रवार (Friday)';
        case 6: return 'शनिवार (Saturday)';
        case 7:
        default: return 'रविवार (Sunday)';
      }
    } else {
      switch (nextDay) {
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
