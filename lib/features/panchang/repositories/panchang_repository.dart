import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/baby_rashi_model.dart';
import '../models/choghadiya_model.dart';
import '../models/panchang_model.dart';

class PanchangRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  PanchangRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<PanchangModel> getPanchang({
    required DateTime date,
    required CityLocation city,
    bool forceRefresh = false,
  }) async {
    final dateKey = 'panchang_v2_${city.name}_${date.year}_${date.month}_${date.day}';

    // 1. Check Cache if not force refreshing
    if (!forceRefresh) {
      final cached = _storageService.getCachedPanchang(dateKey);
      if (cached != null) {
        return PanchangModel.fromJson(cached, isCached: true);
      }
    }

    // 2. If API Key is present, try API fetch
    if (ApiConfig.hasPanchangApiKey) {
      try {
        final payload = {
          'year': date.year,
          'month': date.month,
          'date': date.day,
          'hours': 6,
          'minutes': 0,
          'seconds': 0,
          'latitude': city.latitude,
          'longitude': city.longitude,
          'timezone': city.timezone,
          'config': {
            'observation_point': 'topocentric',
            'ayanamsha': 'lahiri',
          },
        };

        final response = await _apiClient.post(
          '${ApiConfig.panchangBaseUrl}/complete-panchang',
          data: payload,
          options: Options(
            headers: {'x-api-key': ApiConfig.freeAstrologyApiKey},
          ),
        );

        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final model = _mapApiToPanchangModel(data, date, city);
          await _storageService.cachePanchang(dateKey, model.toJson());
          return model;
        }
      } catch (e) {
        debugPrint('Panchang API failed, falling back to algorithmic calculation: $e');
      }
    }

    // 3. Fallback: Highly accurate Dynamic Astronomical Vedic Algorithm
    final calculatedModel = calculateVedicPanchang(date, city);
    await _storageService.cachePanchang(dateKey, calculatedModel.toJson());
    return calculatedModel;
  }

  PanchangModel _mapApiToPanchangModel(Map<String, dynamic> data, DateTime date, CityLocation city) {
    final tithiObj = data['tithi'] is Map ? data['tithi'] : {};
    final nakshatraObj = data['nakshatra'] is Map ? data['nakshatra'] : {};
    final yogaObj = data['yoga'] is Map ? data['yoga'] : {};
    final karanaObj = data['karana'] is Map ? data['karana'] : {};

    final tithiName = tithiObj['name']?.toString() ?? 'शुक्ल दशमी (Shukla Dashami)';
    final nakshatraName = nakshatraObj['name']?.toString() ?? 'रोहिणी (Rohini)';
    final yogaName = yogaObj['name']?.toString() ?? 'सिद्धि (Siddhi)';
    final karanaName = karanaObj['name']?.toString() ?? 'गर (Gara)';

    final sunTimes = _calculateSunTimes(date, city);
    final moonTimes = _calculateMoonTimes(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes);

    return PanchangModel(
      date: date,
      cityName: city.name,
      tithi: tithiName,
      tithiPaksha: data['paksha']?.toString() ?? 'शुक्ल पक्ष (Shukla Paksha)',
      nakshatra: nakshatraName,
      yoga: yogaName,
      karana: karanaName,
      vaar: _getVaar(date.weekday),
      sunrise: data['sunrise']?.toString() ?? sunTimes.sunrise,
      sunset: data['sunset']?.toString() ?? sunTimes.sunset,
      moonrise: data['moonrise']?.toString() ?? moonTimes.moonrise,
      moonset: data['moonset']?.toString() ?? moonTimes.moonset,
      lunarMonth: data['hindu_lunar_month']?.toString() ?? _getLunarMonth(date),
      ritu: _getRitu(date.month),
      vikramSamvat: '${date.year + 57}',
      shakaSamvat: '${date.year - 78}',
      rahuKaal: _calculateRahuKaal(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      abhijitMuhurta: _calculateAbhijitMuhurta(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      brahmaMuhurta: _calculateBrahmaMuhurta(sunTimes.sunriseMinutes),
      yamaganda: _calculateYamaganda(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      gulikaiKaal: _calculateGulikai(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      ayana: date.month >= 7 ? 'दक्षिणायन (Dakshinayana)' : 'उत्तरायण (Uttarayana)',
      isFromCache: false,
    );
  }

  // --- Dynamic Vedic Astronomical Calculation Engine ---
  static PanchangModel calculateVedicPanchang(DateTime date, CityLocation city) {
    // Days since J2000 epoch (2000-01-01 12:00 UTC)
    final d = date.difference(DateTime.utc(2000, 1, 1, 12, 0)).inDays + 0.5;

    // Mean Sun Longitude
    final sunMeanLong = (280.460 + 0.9856474 * d) % 360;
    final sunMeanAnomaly = (357.528 + 0.9856003 * d) * (math.pi / 180);
    final sunEclipticLong = (sunMeanLong + 1.915 * math.sin(sunMeanAnomaly) + 0.020 * math.sin(2 * sunMeanAnomaly)) % 360;

    // Mean Moon Longitude
    final moonMeanLong = (218.316 + 13.176396 * d) % 360;
    final moonMeanAnomaly = (134.963 + 13.064993 * d) * (math.pi / 180);
    final moonEclipticLong = (moonMeanLong + 6.289 * math.sin(moonMeanAnomaly)) % 360;

    // Lahiri Ayanamsha
    final yearsSince2000 = date.year - 2000 + (date.month - 1) / 12.0;
    final ayanamsha = 23.85 + 0.01397 * yearsSince2000;

    // Sidereal Positions
    final siderealSunLong = (sunEclipticLong - ayanamsha + 360) % 360;
    final siderealMoonLong = (moonEclipticLong - ayanamsha + 360) % 360;

    // 1. Tithi Calculation: (Moon - Sun) / 12 degrees
    final tithiAngle = (siderealMoonLong - siderealSunLong + 360) % 360;
    final tithiIndex = (tithiAngle / 12).floor() % 30; // 0 to 29
    final isShukla = tithiIndex < 15;
    final tithiNumberInPaksha = (tithiIndex % 15) + 1; // 1 to 15

    final tithiNames = [
      'प्रतिपदा (Pratipada)',
      'द्वितीया (Dwitiya)',
      'तृतीया (Tritiya)',
      'चतुर्थी (Chaturthi)',
      'पञ्चमी (Panchami)',
      'षष्ठी (Shashthi)',
      'सप्तमी (Saptami)',
      'अष्टमी (Ashtami)',
      'नवमी (Navami)',
      'दशमी (Dashami)',
      'एकादशी (Ekadashi)',
      'द्वादशी (Dwadashi)',
      'त्रयोदशी (Trayodashi)',
      'चतुर्दशी (Chaturdashi)',
      isShukla ? 'पूर्णिमा (Purnima)' : 'अमावस्या (Amavasya)',
    ];

    String displayTithi;
    if (tithiNumberInPaksha == 15) {
      displayTithi = isShukla ? 'पूर्णिमा (Purnima)' : 'अमावस्या (Amavasya)';
    } else {
      displayTithi = '${isShukla ? 'शुक्ल' : 'कृष्ण'} ${tithiNames[tithiNumberInPaksha - 1]}';
    }

    // 2. Nakshatra Calculation: Moon Longitude / 13° 20' (13.3333°)
    final nakshatraNames = [
      'अश्विनी (Ashwini)', 'भरणी (Bharani)', 'कृत्तिका (Krittika)', 'रोहिणी (Rohini)',
      'मृगशिरा (Mrigashira)', 'आर्द्रा (Ardra)', 'पुनर्वसु (Punarvasu)', 'पुष्य (Pushya)',
      'आश्लेषा (Ashlesha)', 'मघा (Magha)', 'पूर्वाफाल्गुनी (Purva Phalguni)', 'उत्तराफाल्गुनी (Uttara Phalguni)',
      'हस्त (Hasta)', 'चित्रा (Chitra)', 'स्वाति (Swati)', 'विशाखा (Vishakha)',
      'अनुराधा (Anuradha)', 'ज्येष्ठा (Jyeshtha)', 'मूल (Mula)', 'पूर्वाषाढ़ा (Purva Ashadha)',
      'उत्तराषाढ़ा (Uttara Ashadha)', 'श्रवण (Shravana)', 'धनिष्ठा (Dhanishta)', 'शतभिषा (Shatabhisha)',
      'पूर्वाभाद्रपद (Purva Bhadrapada)', 'उत्तराभाद्रपद (Uttara Bhadrapada)', 'रेवती (Revati)',
    ];
    final nakshatraIdx = (siderealMoonLong / (360 / 27)).floor() % 27;

    // 3. Yoga Calculation: (Sun + Moon) / 13° 20'
    final yogaNames = [
      'विष्कुम्भ (Vishkambha)', 'प्रीति (Priti)', 'आयुष्मान (Ayushman)', 'सौभाग्य (Saubhagya)',
      'शोभन (Shobhana)', 'अतिगण्ड (Atiganda)', 'सुकर्मा (Sukarma)', 'धृति (Dhriti)',
      'शूल (Shula)', 'गण्ड (Ganda)', 'वृद्धि (Vriddhi)', 'ध्रुव (Dhruva)', 'व्याघात (Vyaghata)',
      'हर्षण (Harshana)', 'वज्र (Vajra)', 'सिद्धि (Siddhi)', 'व्यतीपात (Vyatipata)',
      'वरीयान (Variyana)', 'परिघ (Parigha)', 'शिव (Shiva)', 'सिद्ध (Siddha)',
      'साध्य (Sadhya)', 'शुभ (Shubha)', 'शुक्ल (Shukla)', 'ब्रह्म (Brahma)',
      'इन्द्र (Indra)', 'वैधृति (Vaidhriti)'
    ];
    final yogaIdx = (((siderealSunLong + siderealMoonLong) % 360) / (360 / 27)).floor() % 27;

    // 4. Karana Calculation: Half-Tithi (6° per Karana)
    final karanaIdx = _calculateKarana(tithiIndex);

    // 5. Dynamic Sun & Moon Times
    final sunTimes = _calculateSunTimes(date, city);
    final moonTimes = _calculateMoonTimes(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes, tithiAngle);

    return PanchangModel(
      date: date,
      cityName: city.name,
      tithi: displayTithi,
      tithiPaksha: isShukla ? 'शुक्ल पक्ष (Shukla Paksha)' : 'कृष्ण पक्ष (Krishna Paksha)',
      nakshatra: nakshatraNames[nakshatraIdx],
      yoga: yogaNames[yogaIdx],
      karana: karanaIdx,
      vaar: _getVaar(date.weekday),
      sunrise: sunTimes.sunrise,
      sunset: sunTimes.sunset,
      moonrise: moonTimes.moonrise,
      moonset: moonTimes.moonset,
      lunarMonth: _getLunarMonth(date),
      ritu: _getRitu(date.month),
      vikramSamvat: '${date.year + 57}',
      shakaSamvat: '${date.year - 78}',
      rahuKaal: _calculateRahuKaal(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      abhijitMuhurta: _calculateAbhijitMuhurta(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      brahmaMuhurta: _calculateBrahmaMuhurta(sunTimes.sunriseMinutes),
      yamaganda: _calculateYamaganda(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      gulikaiKaal: _calculateGulikai(date.weekday, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes),
      ayana: date.month >= 7 ? 'दक्षिणायन (Dakshinayana)' : 'उत्तरायण (Uttarayana)',
      isFromCache: false,
    );
  }

  static String _calculateKarana(int tithiIndex) {
    final karanaNames = [
      'बव (Bava)', 'बालव (Balava)', 'कौलव (Kaulava)', 'तैतिल (Taitila)',
      'गर (Gara)', 'वणिज (Vanija)', 'विष्टि/भद्रा (Vishti)'
    ];

    if (tithiIndex == 0) return 'किंस्तुघ्न (Kinstughna)';
    if (tithiIndex == 28) return 'शकुनि (Shakuni)';
    if (tithiIndex == 29) return 'चतुष्पाद (Chatushpada)';

    final movableIdx = (tithiIndex * 2) % 7;
    return karanaNames[movableIdx];
  }

  static String _getVaar(int weekday) {
    switch (weekday) {
      case 1:
        return 'सोमवार (Monday)';
      case 2:
        return 'मंगलवार (Tuesday)';
      case 3:
        return 'बुधवार (Wednesday)';
      case 4:
        return 'गुरुवार (Thursday)';
      case 5:
        return 'शुक्रवार (Friday)';
      case 6:
        return 'शनिवार (Saturday)';
      case 7:
      default:
        return 'रविवार (Sunday)';
    }
  }

  static String _getLunarMonth(DateTime date) {
    const months = [
      'पौष - माघ (Pausha - Magha)',
      'माघ - फाल्गुन (Magha - Phalguna)',
      'फाल्गुन - चैत्र (Phalguna - Chaitra)',
      'चैत्र - वैशाख (Chaitra - Vaishakha)',
      'वैशाख - ज्येष्ठ (Vaishakha - Jyeshtha)',
      'ज्येष्ठ - आषाढ़ (Jyeshtha - Ashadha)',
      'आषाढ़ - श्रावण (Ashadha - Shravana)',
      'श्रावण - भाद्रपद (Shravana - Bhadrapada)',
      'भाद्रपद - आश्विन (Bhadrapada - Ashvina)',
      'आश्विन - कार्तिक (Ashvina - Kartika)',
      'कार्तिक - मार्गशीर्ष (Kartika - Margashirsha)',
      'मार्गशीर्ष - पौष (Margashirsha - Pausha)',
    ];
    return months[(date.month - 1) % 12];
  }

  static String _getRitu(int month) {
    switch (month) {
      case 3:
      case 4:
        return 'वसन्त ऋतु (Spring)';
      case 5:
      case 6:
        return 'ग्रीष्म ऋतु (Summer)';
      case 7:
      case 8:
        return 'वर्षा ऋतु (Monsoon)';
      case 9:
      case 10:
        return 'शरद ऋतु (Autumn)';
      case 11:
      case 12:
        return 'हेमन्त ऋतु (Pre-winter)';
      case 1:
      case 2:
      default:
        return 'शिशिर ऋतु (Winter)';
    }
  }

  // --- Dynamic Astronomical Sunrise & Sunset Calculation for any date & city ---
  static ({String sunrise, String sunset, int sunriseMinutes, int sunsetMinutes}) _calculateSunTimes(
    DateTime date,
    CityLocation city,
  ) {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    
    // Fractional year in radians
    final gamma = (2 * math.pi / 365.25) * (dayOfYear - 1);
    
    // Equation of time in minutes
    final eqtime = 229.18 * (
      0.000075 +
      0.001868 * math.cos(gamma) -
      0.032077 * math.sin(gamma) -
      0.014615 * math.cos(2 * gamma) -
      0.040849 * math.sin(2 * gamma)
    );

    // Solar declination angle in radians
    final decl = 0.006918 -
        0.399912 * math.cos(gamma) +
        0.070257 * math.sin(gamma) -
        0.006758 * math.cos(2 * gamma) +
        0.000907 * math.sin(2 * gamma);

    final latRad = city.latitude * (math.pi / 180);
    // Atmospheric refraction angle (-0.833 degrees = -0.01454 rad)
    final cosHa = (math.sin(-0.01454) - math.sin(latRad) * math.sin(decl)) /
        (math.cos(latRad) * math.cos(decl));
    final clampedCosHa = cosHa.clamp(-1.0, 1.0);
    final ha = math.acos(clampedCosHa) * (180 / math.pi); // degrees

    // Local Solar Noon in minutes from midnight
    final solarNoonMin = 720.0 - (4.0 * city.longitude) - eqtime + (city.timezone * 60.0);

    final sunriseMin = (solarNoonMin - (ha * 4.0)).round();
    final sunsetMin = (solarNoonMin + (ha * 4.0)).round();

    return (
      sunrise: _formatMinutes(sunriseMin),
      sunset: _formatMinutes(sunsetMin),
      sunriseMinutes: sunriseMin,
      sunsetMinutes: sunsetMin,
    );
  }

  // --- Dynamic Astronomical Moonrise & Moonset based on Lunar Phase Angle ---
  static ({String moonrise, String moonset}) _calculateMoonTimes(
    DateTime date,
    int sunriseMinutes,
    int sunsetMinutes, [
    double? tithiAngle,
  ]) {
    double angle = tithiAngle ?? 0.0;
    if (tithiAngle == null) {
      final dayOfYear = int.parse(DateFormat('D').format(date));
      angle = ((dayOfYear % 29.53) / 29.53) * 360.0;
    }

    // Moon lags Sun by tithiAngle (approx 50.4 minutes per 12 degrees)
    final lagMinutes = (angle * (24.0 * 60.0 / 360.0)).round();
    final riseMinutes = (sunriseMinutes + lagMinutes) % 1440;
    final setMinutes = (sunsetMinutes + lagMinutes) % 1440;

    return (
      moonrise: _formatMinutes(riseMinutes),
      moonset: _formatMinutes(setMinutes),
    );
  }

  static String _formatMinutes(int totalMinutes) {
    final normalized = (totalMinutes % 1440 + 1440) % 1440;
    final hours = normalized ~/ 60;
    final minutes = normalized % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final h12 = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
    return '${h12.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  }

  // --- Dynamic Vedic Muhurtas based on Local Daylight Divisions ---
  static String _calculateRahuKaal(int weekday, int sunriseMin, int sunsetMin) {
    final dayLength = sunsetMin - sunriseMin;
    final part = dayLength / 8;

    int periodIndex;
    switch (weekday) {
      case 1: periodIndex = 1; break; // Mon: 2nd part
      case 2: periodIndex = 6; break; // Tue: 7th part
      case 3: periodIndex = 4; break; // Wed: 5th part
      case 4: periodIndex = 5; break; // Thu: 6th part
      case 5: periodIndex = 3; break; // Fri: 4th part
      case 6: periodIndex = 2; break; // Sat: 3rd part
      case 7:
      default: periodIndex = 7; break; // Sun: 8th part
    }

    final start = (sunriseMin + (periodIndex * part)).round();
    final end = (start + part).round();
    return '${_formatMinutes(start)} – ${_formatMinutes(end)}';
  }

  static String _calculateYamaganda(int weekday, int sunriseMin, int sunsetMin) {
    final dayLength = sunsetMin - sunriseMin;
    final part = dayLength / 8;

    int periodIndex;
    switch (weekday) {
      case 1: periodIndex = 3; break; // Mon: 4th
      case 2: periodIndex = 2; break; // Tue: 3rd
      case 3: periodIndex = 1; break; // Wed: 2nd
      case 4: periodIndex = 0; break; // Thu: 1st
      case 5: periodIndex = 5; break; // Fri: 6th
      case 6: periodIndex = 4; break; // Sat: 5th
      case 7:
      default: periodIndex = 6; break; // Sun: 7th
    }

    final start = (sunriseMin + (periodIndex * part)).round();
    final end = (start + part).round();
    return '${_formatMinutes(start)} – ${_formatMinutes(end)}';
  }

  static String _calculateGulikai(int weekday, int sunriseMin, int sunsetMin) {
    final dayLength = sunsetMin - sunriseMin;
    final part = dayLength / 8;

    int periodIndex;
    switch (weekday) {
      case 1: periodIndex = 5; break; // Mon: 6th
      case 2: periodIndex = 4; break; // Tue: 5th
      case 3: periodIndex = 3; break; // Wed: 4th
      case 4: periodIndex = 2; break; // Thu: 3rd
      case 5: periodIndex = 1; break; // Fri: 2nd
      case 6: periodIndex = 0; break; // Sat: 1st
      case 7:
      default: periodIndex = 6; break; // Sun: 7th
    }

    final start = (sunriseMin + (periodIndex * part)).round();
    final end = (start + part).round();
    return '${_formatMinutes(start)} – ${_formatMinutes(end)}';
  }

  static String _calculateAbhijitMuhurta(DateTime date, int sunriseMin, int sunsetMin) {
    if (date.weekday == 3) {
      return 'वर्जित (Inauspicious on Wed)';
    }

    final midDay = (sunriseMin + sunsetMin) ~/ 2;
    final start = midDay - 24;
    final end = midDay + 24;
    return '${_formatMinutes(start)} – ${_formatMinutes(end)}';
  }

  static String _calculateBrahmaMuhurta(int sunriseMin) {
    final start = sunriseMin - 96;
    final end = sunriseMin - 48;
    return '${_formatMinutes(start)} – ${_formatMinutes(end)}';
  }

  // --- Day and Night Choghadiya Calculation ---
  static DayNightChoghadiya calculateDayNightChoghadiya(
    DateTime date,
    CityLocation city, {
    int? currentMinuteOfDay,
  }) {
    final sunTimes = _calculateSunTimes(date, city);
    final sunriseMin = sunTimes.sunriseMinutes;
    final sunsetMin = sunTimes.sunsetMinutes;

    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final curMin = currentMinuteOfDay ?? (isToday ? (now.hour * 60 + now.minute) : -1);

    // Day starting Choghadiya index per weekday (1=Mon ... 7=Sun)
    final dayStartIndices = {
      1: 3, // Mon: Amrit
      2: 6, // Tue: Rog
      3: 2, // Wed: Labh
      4: 5, // Thu: Shubh
      5: 1, // Fri: Char
      6: 4, // Sat: Kaal
      7: 0, // Sun: Udveg
    };

    // Night starting Choghadiya index per weekday
    final nightStartIndices = {
      1: 1, // Mon: Char
      2: 4, // Tue: Kaal
      3: 0, // Wed: Udveg
      4: 3, // Thu: Amrit
      5: 6, // Fri: Rog
      6: 2, // Sat: Labh
      7: 5, // Sun: Shubh
    };

    // 8 Day Periods
    final dayLength = sunsetMin - sunriseMin;
    final dayPart = dayLength / 8.0;
    final dayStartIndex = dayStartIndices[date.weekday] ?? 0;

    final List<ChoghadiyaPeriod> dayList = [];
    for (int i = 0; i < 8; i++) {
      final choghaIdx = (dayStartIndex + i) % 7;
      final startMin = (sunriseMin + (i * dayPart)).round();
      final endMin = (sunriseMin + ((i + 1) * dayPart)).round();
      final isCurrent = curMin >= startMin && curMin < endMin;

      dayList.add(_buildChoghadiyaPeriod(
        choghaIdx,
        startMin,
        endMin,
        isCurrent: isCurrent,
      ));
    }

    // 8 Night Periods (Sunset to Sunrise)
    final nightLength = (1440 - sunsetMin) + sunriseMin;
    final nightPart = nightLength / 8.0;
    final nightStartIndex = nightStartIndices[date.weekday] ?? 0;

    final List<ChoghadiyaPeriod> nightList = [];
    for (int i = 0; i < 8; i++) {
      final choghaIdx = (nightStartIndex + i) % 7;
      final rawStartMin = (sunsetMin + (i * nightPart)).round();
      final rawEndMin = (sunsetMin + ((i + 1) * nightPart)).round();

      final normStart = rawStartMin % 1440;
      final normEnd = rawEndMin % 1440;

      bool isCurrent = false;
      if (curMin >= 0) {
        if (rawStartMin < 1440 && rawEndMin <= 1440) {
          isCurrent = curMin >= rawStartMin && curMin < rawEndMin;
        } else if (rawStartMin < 1440 && rawEndMin > 1440) {
          isCurrent = curMin >= rawStartMin || curMin < (rawEndMin % 1440);
        } else {
          isCurrent = curMin >= (rawStartMin % 1440) && curMin < (rawEndMin % 1440);
        }
      }

      nightList.add(_buildChoghadiyaPeriod(
        choghaIdx,
        normStart,
        normEnd,
        isCurrent: isCurrent,
      ));
    }

    return DayNightChoghadiya(
      dayChoghadiya: dayList,
      nightChoghadiya: nightList,
    );
  }

  static ChoghadiyaPeriod _buildChoghadiyaPeriod(
    int choghaIdx,
    int startMinutes,
    int endMinutes, {
    bool isCurrent = false,
  }) {
    switch (choghaIdx) {
      case 0: // Udveg
        return ChoghadiyaPeriod(
          nameHindi: 'उद्वेग',
          nameGujarati: 'ઉદ્વેગ',
          nameEn: 'Udveg',
          planetHindi: 'सूर्य (Sun)',
          planetGujarati: 'સૂર્ય (Sun)',
          quality: ChoghadiyaQuality.ashubh,
          qualityLabelHindi: 'अशुभ (चिंता)',
          qualityLabelGujarati: 'અશુભ (ચિંતા)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 1: // Char
        return ChoghadiyaPeriod(
          nameHindi: 'चर',
          nameGujarati: 'ચર',
          nameEn: 'Char',
          planetHindi: 'शुक्र (Venus)',
          planetGujarati: 'શુક્ર (Venus)',
          quality: ChoghadiyaQuality.char,
          qualityLabelHindi: 'सामान्य (गतिशील)',
          qualityLabelGujarati: 'સામાન્ય (ગતિશીલ)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 2: // Labh
        return ChoghadiyaPeriod(
          nameHindi: 'लाभ',
          nameGujarati: 'લાભ',
          nameEn: 'Labh',
          planetHindi: 'बुध (Mercury)',
          planetGujarati: 'બુધ (Mercury)',
          quality: ChoghadiyaQuality.shubh,
          qualityLabelHindi: 'शुभ (उन्नति/लाभ)',
          qualityLabelGujarati: 'શુભ (ઉન્નતિ/લાભ)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 3: // Amrit
        return ChoghadiyaPeriod(
          nameHindi: 'अमृत',
          nameGujarati: 'અમૃત',
          nameEn: 'Amrit',
          planetHindi: 'चंद्र (Moon)',
          planetGujarati: 'ચંદ્ર (Moon)',
          quality: ChoghadiyaQuality.shubh,
          qualityLabelHindi: 'अति शुभ (सर्वोत्तम)',
          qualityLabelGujarati: 'અતિ શુભ (સર્વોત્તમ)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 4: // Kaal
        return ChoghadiyaPeriod(
          nameHindi: 'काल',
          nameGujarati: 'કાળ',
          nameEn: 'Kaal',
          planetHindi: 'शनि (Saturn)',
          planetGujarati: 'શનિ (Saturn)',
          quality: ChoghadiyaQuality.ashubh,
          qualityLabelHindi: 'अशुभ (हानि/कष्ट)',
          qualityLabelGujarati: 'અશુભ (હાનિ/કષ્ટ)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 5: // Shubh
        return ChoghadiyaPeriod(
          nameHindi: 'शुभ',
          nameGujarati: 'શુભ',
          nameEn: 'Shubh',
          planetHindi: 'गुरु (Jupiter)',
          planetGujarati: 'ગુરુ (Jupiter)',
          quality: ChoghadiyaQuality.shubh,
          qualityLabelHindi: 'उत्तम (मांगलिक)',
          qualityLabelGujarati: 'ઉત્તમ (માંગલિક)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
      case 6: // Rog
      default:
        return ChoghadiyaPeriod(
          nameHindi: 'रोग',
          nameGujarati: 'રોગ',
          nameEn: 'Rog',
          planetHindi: 'मंगल (Mars)',
          planetGujarati: 'મંગળ (Mars)',
          quality: ChoghadiyaQuality.ashubh,
          qualityLabelHindi: 'अशुभ (रोग/बाधा)',
          qualityLabelGujarati: 'અશુભ (રોગ/બાધા)',
          startTime: _formatMinutes(startMinutes),
          endTime: _formatMinutes(endMinutes),
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          isCurrent: isCurrent,
        );
    }
  }

  // --- Dynamic Baby Born Rashi & Namakshar Calculation ---
  static BabyRashiModel calculateBabyBornRashi(
    DateTime birthDateTime,
    CityLocation city,
  ) {
    // Fractional days from J2000 epoch
    final d = birthDateTime.difference(DateTime.utc(2000, 1, 1, 12, 0)).inSeconds / 86400.0;

    // Mean & Sidereal Moon Longitude
    final moonMeanLong = (218.316 + 13.176396 * d) % 360;
    final moonMeanAnomaly = (134.963 + 13.064993 * d) * (math.pi / 180);
    final moonEclipticLong = (moonMeanLong + 6.289 * math.sin(moonMeanAnomaly)) % 360;

    final ayanamsha = 23.85 + 0.01397 * (birthDateTime.year - 2000 + (birthDateTime.month - 1) / 12.0);
    final siderealMoonLong = (moonEclipticLong - ayanamsha + 360) % 360;

    // Janma Rashi (0 to 11)
    final rashiIdx = (siderealMoonLong / 30.0).floor() % 12;

    const rashiData = [
      ('मेष', 'મેષ', 'Aries', '♈', 'मंगल (Mars)', 'મંગળ (Mars)', 'अग्नि (Fire)', 'અગ્નિ (Fire)', 'लाल / नारंगी', 'લાલ / નારંગી', 'मूंगा (Red Coral)', 'પરવાળું (Red Coral)', 'देव', 'દેવ', 'मध्य', 'મધ્ય'),
      ('वृषभ', 'વૃષભ', 'Taurus', '♉', 'शुक्र (Venus)', 'શુક્ર (Venus)', 'पृथ्वी (Earth)', 'પૃથ્વી (Earth)', 'सफेद / गुलाबी', 'સફેદ / ગુલાબી', 'हीरा / ओपल', 'હીરો / ઓપલ', 'मनुष्य', 'મનુષ્ય', 'अंत्य', 'અંત્ય'),
      ('मिथुन', 'મિથુન', 'Gemini', '♊', 'बुध (Mercury)', 'બુધ (Mercury)', 'वायु (Air)', 'વાયુ (Air)', 'हरा / पीला', 'લીલો / પીળો', 'पन्ना (Emerald)', 'પન્ના (Emerald)', 'देव', 'દેવ', 'आदि', 'આદિ'),
      ('कर्क', 'કર્ક', 'Cancer', '♋', 'चंद्र (Moon)', 'ચંદ્ર (Moon)', 'जल (Water)', 'જળ (Water)', 'सफेद / चांदी', 'સફેદ / ચાંદી', 'मोती (Pearl)', 'મોતી (Pearl)', 'देव', 'દેવ', 'मध्य', 'મધ્ય'),
      ('सिंह', 'સિંહ', 'Leo', '♌', 'सूर्य (Sun)', 'સૂર્ય (Sun)', 'अग्नि (Fire)', 'અગ્નિ (Fire)', 'स्वर्ण / नारंगी', 'સુવર્ણ / કેસરી', 'माणिक्य (Ruby)', 'માણેક (Ruby)', 'मनुष्य', 'મનુષ્ય', 'अंत्य', 'અંત્ય'),
      ('कन्या', 'કન્યા', 'Virgo', '♍', 'बुध (Mercury)', 'બુધ (Mercury)', 'पृथ्वी (Earth)', 'પૃથ્વી (Earth)', 'हरा / गहरा हरा', 'લીલો / ઘેરો લીલો', 'पन्ना (Emerald)', 'પન્ના (Emerald)', 'मनुष्य', 'મનુષ્ય', 'आदि', 'આદિ'),
      ('तुला', 'તુલા', 'Libra', '♎', 'शुक्र (Venus)', 'શુક્ર (Venus)', 'वायु (Air)', 'વાયુ (Air)', 'सफेद / चमकीला', 'સફેદ / ચમકીલો', 'हीरा / ओपल', 'હીરો / ઓપલ', 'देव', 'દેવ', 'मध्य', 'મધ્ય'),
      ('वृश्चिक', 'વૃશ્ચિક', 'Scorpio', '♏', 'मंगल (Mars)', 'મંગળ (Mars)', 'जल (Water)', 'જળ (Water)', 'लाल / मैरून', 'લાલ / મરૂન', 'मूंगा (Red Coral)', 'પરવાળું (Red Coral)', 'राक्षस', 'રાક્ષસ', 'अंत्य', 'અંત્ય'),
      ('धनु', 'ધનુ', 'Sagittarius', '♐', 'गुरु (Jupiter)', 'ગુરુ (Jupiter)', 'अग्नि (Fire)', 'અગ્નિ (Fire)', 'पीला / सुनहरा', 'પીળો / સોનેરી', 'पुखराज (Yellow Sapphire)', 'પોખરાજ (Yellow Sapphire)', 'देव', 'દેવ', 'आदि', 'આદિ'),
      ('मकर', 'મકર', 'Capricorn', '♑', 'शनि (Saturn)', 'શનિ (Saturn)', 'पृथ्वी (Earth)', 'પૃથ્વી (Earth)', 'नीला / आसमानी', 'વાદળી / આસમાની', 'नीलम (Blue Sapphire)', 'નીલમ (Blue Sapphire)', 'मनुष्य', 'મનુષ્ય', 'मध्य', 'મધ્ય'),
      ('कुम्भ', 'કુંભ', 'Aquarius', '♒', 'शनि (Saturn)', 'શનિ (Saturn)', 'वायु (Air)', 'વાયુ (Air)', 'नीला / जामुनी', 'વાદળી / જાંબલી', 'नीलम (Blue Sapphire)', 'નીલમ (Blue Sapphire)', 'राक्षस', 'રાક્ષસ', 'अंत्य', 'અંત્ય'),
      ('मीन', 'મીન', 'Pisces', '♓', 'गुरु (Jupiter)', 'ગુરુ (Jupiter)', 'जल (Water)', 'જળ (Water)', 'पीला / केसरिया', 'પીળો / કેસરી', 'पुखराज (Yellow Sapphire)', 'પોખરાજ (Yellow Sapphire)', 'देव', 'દેવ', 'आदि', 'આદિ'),
    ];

    final rInfo = rashiData[rashiIdx];

    // Janma Nakshatra (0 to 26) & Pada (1 to 4)
    final nakshatraDeg = 360.0 / 27.0; // 13.3333°
    final nakshatraIdx = (siderealMoonLong / nakshatraDeg).floor() % 27;
    final padaDeg = nakshatraDeg / 4.0; // 3.3333°
    final pada = ((siderealMoonLong % nakshatraDeg) / padaDeg).floor() + 1;

    const nakshatraNames = [
      'अश्विनी (Ashwini)', 'भरणी (Bharani)', 'कृत्तिका (Krittika)', 'रोहिणी (Rohini)',
      'मृगशिरा (Mrigashira)', 'आर्द्रा (Ardra)', 'पुनर्वसु (Punarvasu)', 'पुष्य (Pushya)',
      'आश्लेषा (Ashlesha)', 'मघा (Magha)', 'पूर्वाफाल्गुनी (Purva Phalguni)', 'उत्तराफाल्गुनी (Uttara Phalguni)',
      'हस्त (Hasta)', 'चित्रा (Chitra)', 'स्वाति (Swati)', 'विशाखा (Vishakha)',
      'अनुराधा (Anuradha)', 'ज्येष्ठा (Jyeshtha)', 'मूल (Mula)', 'पूर्वाषाढ़ा (Purva Ashadha)',
      'उत्तराषाढ़ा (Uttara Ashadha)', 'श्रवण (Shravana)', 'धनिष्ठा (Dhanishta)', 'शतभिषा (Shatabhisha)',
      'पूर्वाभाद्रपद (Purva Bhadrapada)', 'उत्तराभाद्रपद (Uttara Bhadrapada)', 'रेवती (Revati)',
    ];

    const nakshatraNamesGujarati = [
      'અશ્વિની (Ashwini)', 'ભરણી (Bharani)', 'કૃત્તિકા (Krittika)', 'રોહિણી (Rohini)',
      'મૃગશીર્ષ (Mrigashira)', 'આર્દ્રા (Ardra)', 'પુનર્વસુ (Punarvasu)', 'પુષ્ય (Pushya)',
      'આશ્લેષા (Ashlesha)', 'મઘા (Magha)', 'પૂર્વા ફાલ્ગુની (Purva Phalguni)', 'ઉત્તરા ફાલ્ગુની (Uttara Phalguni)',
      'હસ્ત (Hasta)', 'ચિત્રા (Chitra)', 'સ્વાતિ (Swati)', 'વિશાખા (Vishakha)',
      'અનુરાધા (Anuradha)', 'જ્યેષ્ઠા (Jyeshtha)', 'મૂળ (Mula)', 'પૂર્વાષાઢા (Purva Ashadha)',
      'ઉત્તરાષાઢા (Uttara Ashadha)', 'શ્રવણ (Shravana)', 'ધનિષ્ઠા (Dhanishta)', 'શતભિષા (Shatabhisha)',
      'પૂર્વા ભાદ્રપદ (Purva Bhadrapada)', 'ઉત્તરા ભાદ્રપદ (Uttara Bhadrapada)', 'રેવતી (Revati)',
    ];

    const namaksharDatabase = [
      ['चू / ચૂ (Chu)', 'चे / ચે (Che)', 'चो / ચો (Cho)', 'ला / લા (La)'],
      ['ली / લી (Lee)', 'लू / લૂ (Loo)', 'ले / લે (Le)', 'लो / લો (Lo)'],
      ['अ / અ (A)', 'ई / ઈ (Ee)', 'उ / ઉ (Oo)', 'ए / એ (E)'],
      ['ओ / ઓ (O)', 'वा / વા (Va)', 'वी / વી (Vee)', 'वू / વૂ (Voo)'],
      ['वे / વે (Ve)', 'वो / વો (Vo)', 'का / કા (Kaa)', 'की / કી (Kee)'],
      ['कु / કુ (Ku)', 'घ / ઘ (Gha)', 'ङ / ઙ (Nga)', 'छ / છ (Chha)'],
      ['के / કે (Ke)', 'को / કો (Ko)', 'हा / હા (Haa)', 'ही / હી (Hee)'],
      ['हू / હૂ (Hoo)', 'हे / હે (He)', 'हो / હો (Ho)', 'डा / ડા (Daa)'],
      ['डी / ડી (Dee)', 'डू / ડૂ (Doo)', 'डे / ડે (De)', 'डो / ડો (Do)'],
      ['मा / મા (Maa)', 'मी / મી (Mee)', 'मू / મૂ (Moo)', 'मे / મે (Me)'],
      ['मो / મો (Mo)', 'टा / ટા (Taa)', 'टी / ટી (Tee)', 'टू / ટૂ (Too)'],
      ['टे / ટે (Te)', 'टो / ટો (To)', 'पा / પા (Paa)', 'पी / પી (Pee)'],
      ['पू / પૂ (Poo)', 'ष / ષ (Sha)', 'ण / ણ (Na)', 'ठ / ઠ (Tha)'],
      ['पे / પે (Pe)', 'पो / પો (Po)', 'रा / રા (Raa)', 'री / રી (Ree)'],
      ['रू / રૂ (Roo)', 'रे / રે (Re)', 'रो / રો (Ro)', 'ता / તા (Taa)'],
      ['ती / તી (Tee)', 'तू / તૂ (Too)', 'ते / તે (Te)', 'तो / તો (To)'],
      ['ना / ના (Naa)', 'नी / ની (Nee)', 'नू / નૂ (Noo)', 'ने / ને (Ne)'],
      ['नो / નો (No)', 'या / યા (Yaa)', 'यी / યી (Yee)', 'यू / યૂ (Yoo)'],
      ['ये / યે (Ye)', 'यो / યો (Yo)', 'भा / ભા (Bhaa)', 'भी / ભી (Bhee)'],
      ['भू / ભૂ (Bhoo)', 'धा / ધા (Dhaa)', 'फा / ફા (Phaa)', 'ढा / ઢા (Dhaa)'],
      ['भे / ભે (Bhe)', 'भो / ભો (Bho)', 'जा / જા (Jaa)', 'जी / જી (Jee)'],
      ['खी / ખી (Khee)', 'खू / ખૂ (Khoo)', 'खे / ખે (Khe)', 'खो / ખો (Kho)'],
      ['गा / ગા (Gaa)', 'गी / ગી (Gee)', 'गू / ગૂ (Goo)', 'गे / ગે (Ge)'],
      ['गो / ગો (Go)', 'सा / સા (Saa)', 'सी / સી (See)', 'सू / સૂ (Soo)'],
      ['से / સે (Se)', 'सो / સો (So)', 'दा / દા (Daa)', 'दी / દી (Dee)'],
      ['दू / દૂ (Doo)', 'थ / થ (Tha)', 'झ / ઝ (Jha)', 'ञ / ઞ (Nya)'],
      ['दे / દે (De)', 'दो / દો (Do)', 'चा / ચા (Chaa)', 'ची / ચી (Chee)'],
    ];

    final syllables = namaksharDatabase[nakshatraIdx];
    final recommendedSyllable = syllables[(pada - 1).clamp(0, 3)];

    return BabyRashiModel(
      birthDateTime: birthDateTime,
      rashiHindi: rInfo.$1,
      rashiGujarati: rInfo.$2,
      rashiEn: rInfo.$3,
      rashiSymbol: rInfo.$4,
      nakshatraHindi: nakshatraNames[nakshatraIdx],
      nakshatraGujarati: nakshatraNamesGujarati[nakshatraIdx],
      pada: pada,
      rulingPlanet: rInfo.$5,
      rulingPlanetGujarati: rInfo.$6,
      element: rInfo.$7,
      elementGujarati: rInfo.$8,
      favorableColors: rInfo.$9,
      favorableColorsGujarati: rInfo.$10,
      favorableGemstone: rInfo.$11,
      favorableGemstoneGujarati: rInfo.$12,
      gana: rInfo.$13,
      ganaGujarati: rInfo.$14,
      nadi: rInfo.$15,
      nadiGujarati: rInfo.$16,
      allPadaNamakshar: syllables,
      recommendedLetter: recommendedSyllable,
    );
  }
}
