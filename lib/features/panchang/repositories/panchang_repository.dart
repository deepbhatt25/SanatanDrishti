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
    final nextSunTimes = _calculateSunTimes(date.add(const Duration(days: 1)), city);
    final moonTimes = _calculateMoonTimes(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes);

    final refLocalTime = DateTime(
      date.year,
      date.month,
      date.day,
      sunTimes.sunriseMinutes ~/ 60,
      sunTimes.sunriseMinutes % 60,
    );

    final angles = _calculateAnglesAt(refLocalTime);
    final tithiIndex = (angles.tithiAngle / 12.0).floor() % 30;
    final tithiSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 12.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );
    final nextTithiIdx = (tithiIndex + 1) % 30;

    final nakshatraIdx = (angles.nakshatraAngle / (360.0 / 27.0)).floor() % 27;
    final nakshatraSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 360.0 / 27.0,
      angleGetter: (t) => _calculateAnglesAt(t).nakshatraAngle,
    );
    final nextNakshatraIdx = (nakshatraIdx + 1) % 27;

    final yogaIdx = (angles.yogaAngle / (360.0 / 27.0)).floor() % 27;
    final yogaSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 360.0 / 27.0,
      angleGetter: (t) => _calculateAnglesAt(t).yogaAngle,
    );
    final nextYogaIdx = (yogaIdx + 1) % 27;

    final karanaFullIdx = (angles.tithiAngle / 6.0).floor() % 60;
    final nextKarana = _getKaranaName(karanaFullIdx + 1);
    final karanaSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 6.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );

    final rashiIdx = (angles.rashiAngle / 30.0).floor() % 12;
    final rashiSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 30.0,
      angleGetter: (t) => _calculateAnglesAt(t).rashiAngle,
      maxBack: const Duration(hours: 60),
      maxForward: const Duration(hours: 60),
    );
    final nextRashiIdx = (rashiIdx + 1) % 12;
    final nextWeekday = (date.weekday % 7) + 1;

    return PanchangModel(
      date: date,
      cityName: city.name,
      tithi: tithiName,
      tithiPaksha: data['paksha']?.toString() ?? 'शुक्ल पक्ष (Shukla Paksha)',
      tithiStartTime: _formatSpanDateTime(tithiSpan.startTime),
      tithiEndTime: _formatSpanDateTime(tithiSpan.endTime),
      nextTithi: _tithiNamesHi[nextTithiIdx],
      nextTithiGujarati: _tithiNamesGu[nextTithiIdx],
      nakshatra: nakshatraName,
      nakshatraStartTime: _formatSpanDateTime(nakshatraSpan.startTime),
      nakshatraEndTime: _formatSpanDateTime(nakshatraSpan.endTime),
      nextNakshatra: _nakshatraNamesHi[nextNakshatraIdx],
      nextNakshatraGujarati: _nakshatraNamesGu[nextNakshatraIdx],
      yoga: yogaName,
      yogaStartTime: _formatSpanDateTime(yogaSpan.startTime),
      yogaEndTime: _formatSpanDateTime(yogaSpan.endTime),
      nextYoga: _yogaNamesHi[nextYogaIdx],
      nextYogaGujarati: _yogaNamesGu[nextYogaIdx],
      karana: karanaName,
      karanaStartTime: _formatSpanDateTime(karanaSpan.startTime),
      karanaEndTime: _formatSpanDateTime(karanaSpan.endTime),
      nextKarana: nextKarana.hi,
      nextKaranaGujarati: nextKarana.gu,
      rashi: _rashiNamesHi[rashiIdx],
      rashiGujarati: _rashiNamesGu[rashiIdx],
      rashiStartTime: _formatSpanDateTime(rashiSpan.startTime),
      rashiEndTime: _formatSpanDateTime(rashiSpan.endTime),
      nextRashi: _rashiNamesHi[nextRashiIdx],
      nextRashiGujarati: _rashiNamesGu[nextRashiIdx],
      vaar: _getVaar(date.weekday),
      vaarStartTime: sunTimes.sunrise,
      vaarEndTime: nextSunTimes.sunrise,
      nextVaar: _getVaar(nextWeekday),
      nextVaarGujarati: _getVaarGu(nextWeekday),
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
  static ({
    int tithiIndex,
    int tithiNumberInPaksha,
    bool isShukla,
    int lunarMonthId,
    String lunarMonthHi,
    String lunarMonthGu,
    String tithiNameHi,
    String tithiNameGu,
    String shortTithiHi,
    String shortTithiGu,
    String pakshaLabelHi,
    String pakshaLabelGu,
  }) calculateVedicTithi(DateTime date) {
    // Days since J2000 epoch at local Sunrise (06:00 AM IST = 00:30 UTC)
    final utcSunrise = DateTime.utc(date.year, date.month, date.day, 0, 30);
    final d = utcSunrise.difference(DateTime.utc(2000, 1, 1, 12, 0)).inSeconds / 86400.0;

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

    // 2. Amanta Lunar Month Calculation (1 = Chaitra, ..., 6 = Bhadrapada, 7 = Ashvina, 8 = Kartika, ..., 12 = Phalguna)
    // In the Amanta system (Gujarat, Maharashtra, etc.), the month begins at Shukla Pratipada (following Amavasya).
    // The month is determined by the Sidereal Sign of the Sun at the preceding New Moon (Amavasya).
    // Days since last New Moon = (tithiIndex * 0.9856) days of Sun motion
    final sunLongAtNewMoon = (siderealSunLong - (tithiIndex * 0.9856) + 360) % 360;
    final sunRashiAtNewMoon = (sunLongAtNewMoon / 30.0).floor() % 12 + 1; // 1=Mesha, ..., 6=Kanya, 7=Tula, ..., 12=Meena
    // If Sun was in Meena (12) at New Moon -> Chaitra (1). If in Kanya (6) -> Ashvina (7). If in Tula (7) -> Kartika (8).
    final lunarMonthId = (sunRashiAtNewMoon % 12) + 1;

    const lunarMonthsHi = [
      'चैत्र', 'वैशाख', 'ज्येष्ठ', 'आषाढ़', 'श्रावण', 'भाद्रपद',
      'आश्विन', 'कार्तिक', 'मार्गशीर्ष', 'पौष', 'माघ', 'फाल्गुन'
    ];
    const lunarMonthsGu = [
      'ચૈત્ર', 'વૈશાખ', 'જેઠ', 'અષાઢ', 'શ્રાવણ', 'ભાદરવો',
      'આસો', 'કારતક', 'માગશર', 'પોષ', 'મહા', 'ફાગણ'
    ];

    final lunarMonthHi = lunarMonthsHi[lunarMonthId - 1];
    final lunarMonthGu = lunarMonthsGu[lunarMonthId - 1];

    const tithiNamesHi = [
      'प्रतिपदा', 'द्वितीया', 'तृतीया', 'चतुर्थी', 'पञ्चमी',
      'षष्ठी', 'सप्तमी', 'अष्टमी', 'नवमी', 'दशमी',
      'एकादशी', 'द्वादशी', 'त्रयोदशी', 'चतुर्दशी', 'पूर्णिमा',
    ];
    const tithiNamesGu = [
      'પડવો', 'બીજ', 'ત્રીજ', 'ચોથ', 'પાંચમ',
      'છઠ', 'સાતમ', 'આઠમ', 'નોમ', 'દસમ',
      'અગિયારસ', 'બારસ', 'તેરસ', 'ચૌદશ', 'પૂનમ',
    ];

    String tithiNameHi;
    String tithiNameGu;
    String shortTithiHi;
    String shortTithiGu;

    const devanagariDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    const gujaratiDigits = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
    String toDevanagari(int n) => n.toString().split('').map((c) => devanagariDigits[int.parse(c)]).join();
    String toGujarati(int n) => n.toString().split('').map((c) => gujaratiDigits[int.parse(c)]).join();

    final hiNum = toDevanagari(tithiNumberInPaksha);
    final guNum = toGujarati(tithiNumberInPaksha);

    if (tithiIndex == 14) {
      tithiNameHi = 'पूर्णिमा';
      tithiNameGu = 'પૂનમ';
      shortTithiHi = 'पूर्णिमा';
      shortTithiGu = 'પૂનમ';
    } else if (tithiIndex == 29) {
      tithiNameHi = 'अमावस्या';
      tithiNameGu = 'અમાસ';
      shortTithiHi = 'अमावस्या';
      shortTithiGu = 'અમાસ';
    } else if (tithiNumberInPaksha == 11) {
      tithiNameHi = isShukla ? 'शुक्ल एकादशी' : 'कृष्ण एकादशी';
      tithiNameGu = isShukla ? 'સુદ અગિયારસ' : 'વદ અગિયારસ';
      shortTithiHi = isShukla ? 'शु. ११' : 'कृ. ११';
      shortTithiGu = isShukla ? 'સુદ ૧૧' : 'વદ ૧૧';
    } else {
      final pakshaPrefixHi = isShukla ? 'शुक्ल' : 'कृष्ण';
      final pakshaPrefixGu = isShukla ? 'સુદ' : 'વદ';
      final shortPakshaHi = isShukla ? 'शु.' : 'कृ.';
      final shortPakshaGu = isShukla ? 'સુદ' : 'વદ';

      final tNameHi = tithiNamesHi[tithiNumberInPaksha - 1];
      final tNameGu = tithiNamesGu[tithiNumberInPaksha - 1];

      tithiNameHi = '$pakshaPrefixHi $tNameHi';
      tithiNameGu = '$pakshaPrefixGu $tNameGu';
      shortTithiHi = '$shortPakshaHi $hiNum';
      shortTithiGu = '$shortPakshaGu $guNum';
    }

    return (
      tithiIndex: tithiIndex,
      tithiNumberInPaksha: tithiNumberInPaksha,
      isShukla: isShukla,
      lunarMonthId: lunarMonthId,
      lunarMonthHi: lunarMonthHi,
      lunarMonthGu: lunarMonthGu,
      tithiNameHi: tithiNameHi,
      tithiNameGu: tithiNameGu,
      shortTithiHi: shortTithiHi,
      shortTithiGu: shortTithiGu,
      pakshaLabelHi: isShukla ? 'शुक्ल पक्ष' : 'कृष्ण पक्ष',
      pakshaLabelGu: isShukla ? 'સુદ પક્ષ' : 'વદ પક્ષ',
    );
  }

  static String _formatSpanDateTime(DateTime dt) {
    return DateFormat('dd MMM, hh:mm a').format(dt.toLocal());
  }

  static ({
    double sunLong,
    double moonLong,
    double tithiAngle,
    double nakshatraAngle,
    double yogaAngle,
    double rashiAngle,
  }) _calculateAnglesAt(DateTime dt) {
    final utc = dt.isUtc ? dt : dt.toUtc();
    final d = utc.difference(DateTime.utc(2000, 1, 1, 12, 0)).inSeconds / 86400.0;

    // Mean Sun Longitude
    final sunMeanLong = (280.460 + 0.9856474 * d) % 360;
    final sunMeanAnomaly = (357.528 + 0.9856003 * d) * (math.pi / 180);
    final sunEclipticLong = (sunMeanLong + 1.915 * math.sin(sunMeanAnomaly) + 0.020 * math.sin(2 * sunMeanAnomaly)) % 360;

    // Mean Moon Longitude
    final moonMeanLong = (218.316 + 13.176396 * d) % 360;
    final moonMeanAnomaly = (134.963 + 13.064993 * d) * (math.pi / 180);
    final moonEclipticLong = (moonMeanLong + 6.289 * math.sin(moonMeanAnomaly)) % 360;

    // Lahiri Ayanamsha
    final yearsSince2000 = (dt.year - 2000) + (dt.month - 1) / 12.0 + (dt.day - 1) / 365.25;
    final ayanamsha = 23.85 + 0.01397 * yearsSince2000;

    // Sidereal Positions
    final siderealSunLong = (sunEclipticLong - ayanamsha + 360) % 360;
    final siderealMoonLong = (moonEclipticLong - ayanamsha + 360) % 360;

    final tithiAngle = (siderealMoonLong - siderealSunLong + 360) % 360;
    final nakshatraAngle = siderealMoonLong;
    final yogaAngle = (siderealSunLong + siderealMoonLong) % 360;
    final rashiAngle = siderealMoonLong;

    return (
      sunLong: siderealSunLong,
      moonLong: siderealMoonLong,
      tithiAngle: tithiAngle,
      nakshatraAngle: nakshatraAngle,
      yogaAngle: yogaAngle,
      rashiAngle: rashiAngle,
    );
  }

  static ({DateTime startTime, DateTime endTime}) _calculateSpanForAngle({
    required DateTime refDateTime,
    required double stepDegrees,
    required double Function(DateTime) angleGetter,
    Duration maxBack = const Duration(hours: 36),
    Duration maxForward = const Duration(hours: 36),
  }) {
    final curAngle = angleGetter(refDateTime);
    final curIndex = (curAngle / stepDegrees).floor();
    final startTarget = (curIndex * stepDegrees) % 360;
    final endTarget = ((curIndex + 1) * stepDegrees) % 360;

    double getUnwrappedAngle(DateTime t) {
      final a = angleGetter(t);
      double delta = a - curAngle;
      while (delta > 180) {
        delta -= 360;
      }
      while (delta < -180) {
        delta += 360;
      }
      return curAngle + delta;
    }

    double getTargetUnwrapped(double target) {
      double delta = target - curAngle;
      while (delta > 180) {
        delta -= 360;
      }
      while (delta < -180) {
        delta += 360;
      }
      return curAngle + delta;
    }

    final unwrappedStartTarget = getTargetUnwrapped(startTarget);
    final unwrappedEndTarget = getTargetUnwrapped(endTarget);

    DateTime lowStart = refDateTime.subtract(maxBack);
    DateTime highStart = refDateTime;
    for (int i = 0; i < 18; i++) {
      final midMillis = (lowStart.millisecondsSinceEpoch + highStart.millisecondsSinceEpoch) ~/ 2;
      final mid = DateTime.fromMillisecondsSinceEpoch(midMillis, isUtc: refDateTime.isUtc);
      final a = getUnwrappedAngle(mid);
      if (a < unwrappedStartTarget) {
        lowStart = mid;
      } else {
        highStart = mid;
      }
    }
    final startTime = highStart;

    DateTime lowEnd = refDateTime;
    DateTime highEnd = refDateTime.add(maxForward);
    for (int i = 0; i < 18; i++) {
      final midMillis = (lowEnd.millisecondsSinceEpoch + highEnd.millisecondsSinceEpoch) ~/ 2;
      final mid = DateTime.fromMillisecondsSinceEpoch(midMillis, isUtc: refDateTime.isUtc);
      final a = getUnwrappedAngle(mid);
      if (a < unwrappedEndTarget) {
        lowEnd = mid;
      } else {
        highEnd = mid;
      }
    }
    final endTime = lowEnd;

    return (startTime: startTime, endTime: endTime);
  }

  static const List<String> _tithiNamesHi = [
    'शुक्ल प्रतिपदा (Pratipada)', 'शुक्ल द्वितीया (Dwitiya)', 'शुक्ल तृतीया (Tritiya)', 'शुक्ल चतुर्थी (Chaturthi)',
    'शुक्ल पञ्चमी (Panchami)', 'शुक्ल षष्ठी (Shashthi)', 'शुक्ल सप्तमी (Saptami)', 'शुक्ल अष्टमी (Ashtami)',
    'शुक्ल नवमी (Navami)', 'शुक्ल दशमी (Dashami)', 'शुक्ल एकादशी (Ekadashi)', 'शुक्ल द्वादशी (Dwadashi)',
    'शुक्ल त्रयोदशी (Trayodashi)', 'शुक्ल चतुर्दशी (Chaturdashi)', 'पूर्णिमा (Purnima)',
    'कृष्ण प्रतिपदा (Pratipada)', 'कृष्ण द्वितीया (Dwitiya)', 'कृष्ण तृतीया (Tritiya)', 'कृष्ण चतुर्थी (Chaturthi)',
    'कृष्ण पञ्चमी (Panchami)', 'कृष्ण षष्ठी (Shashthi)', 'कृष्ण सप्तमी (Saptami)', 'कृष्ण अष्टमी (Ashtami)',
    'कृष्ण नवमी (Navami)', 'कृष्ण दशमी (Dashami)', 'कृष्ण एकादशी (Ekadashi)', 'कृष्ण द्वादशी (Dwadashi)',
    'कृष्ण त्रयोदशी (Trayodashi)', 'कृष्ण चतुर्दशी (Chaturdashi)', 'अमावस्या (Amavasya)',
  ];

  static const List<String> _tithiNamesGu = [
    'સુદ પડવો (Pratipada)', 'સુદ બીજ (Dwitiya)', 'સુદ ત્રીજ (Tritiya)', 'સુદ ચોથ (Chaturthi)',
    'સુદ પાંચમ (Panchami)', 'સુદ છઠ (Shashthi)', 'સુદ સાતમ (Saptami)', 'સુદ આઠમ (Ashtami)',
    'સુદ નોમ (Navami)', 'સુદ દસમ (Dashami)', 'સુદ અગિયારસ (Ekadashi)', 'સુદ બારસ (Dwadashi)',
    'સુદ તેરસ (Trayodashi)', 'સુદ ચૌદશ (Chaturdashi)', 'પૂનમ (Purnima)',
    'વદ પડવો (Pratipada)', 'વદ બીજ (Dwitiya)', 'વદ ત્રીજ (Tritiya)', 'વદ ચોથ (Chaturthi)',
    'વદ પાંચમ (Panchami)', 'વદ છઠ (Shashthi)', 'વદ સાતમ (Saptami)', 'વદ આઠમ (Ashtami)',
    'વદ નોમ (Navami)', 'વદ દસમ (Dashami)', 'વદ અગિયારસ (Ekadashi)', 'વદ બારસ (Dwadashi)',
    'વદ તેરસ (Trayodashi)', 'વદ ચૌદશ (Chaturdashi)', 'અમાસ (Amavasya)',
  ];

  static const List<String> _nakshatraNamesHi = [
    'अश्विनी (Ashwini)', 'भरणी (Bharani)', 'कृत्तिका (Krittika)', 'रोहिणी (Rohini)',
    'मृगशिरा (Mrigashira)', 'आर्द्रा (Ardra)', 'पुनर्वसु (Punarvasu)', 'पुष्य (Pushya)',
    'आश्लेषा (Ashlesha)', 'मघा (Magha)', 'पूर्वाफाल्गुनी (Purva Phalguni)', 'उत्तराफाल्गुनी (Uttara Phalguni)',
    'हस्त (Hasta)', 'चित्रा (Chitra)', 'स्वाति (Swati)', 'विशाखा (Vishakha)',
    'अनुराधा (Anuradha)', 'ज्येष्ठा (Jyeshtha)', 'मूल (Mula)', 'पूर्वाषाढ़ा (Purva Ashadha)',
    'उत्तराषाढ़ा (Uttara Ashadha)', 'श्रवण (Shravana)', 'धनिष्ठा (Dhanishta)', 'शतभिषा (Shatabhisha)',
    'पूर्वाभाद्रपद (Purva Bhadrapada)', 'उत्तराभाद्रपद (Uttara Bhadrapada)', 'रेवती (Revati)',
  ];

  static const List<String> _nakshatraNamesGu = [
    'અશ્વિની (Ashwini)', 'ભરણી (Bharani)', 'કૃત્તિકા (Krittika)', 'રોહિણી (Rohini)',
    'મૃગશીર્ષ (Mrigashira)', 'આર્દ્રા (Ardra)', 'પુનર્વસુ (Punarvasu)', 'પુષ્ય (Pushya)',
    'આશ્લેષા (Ashlesha)', 'મઘા (Magha)', 'પૂર્વા ફાલ્ગુની (Purva Phalguni)', 'ઉત્તરા ફાલ્ગુની (Uttara Phalguni)',
    'હસ્ત (Hasta)', 'ચિત્રા (Chitra)', 'સ્વાતિ (Swati)', 'વિશાખા (Vishakha)',
    'અનુરાધા (Anuradha)', 'જ્યેષ્ઠા (Jyeshtha)', 'મૂળ (Mula)', 'પૂર્વાષાઢા (Purva Ashadha)',
    'ઉત્તરાષાઢા (Uttara Ashadha)', 'શ્રવણ (Shravana)', 'ધનિષ્ઠા (Dhanishta)', 'શતભિષા (Shatabhisha)',
    'પૂર્વા ભાદ્રપદ (Purva Bhadrapada)', 'ઉત્તરા ભાદ્રપદ (Uttara Bhadrapada)', 'રેવતી (Revati)',
  ];

  static const List<String> _yogaNamesHi = [
    'विष्कुम्भ (Vishkambha)', 'प्रीति (Priti)', 'आयुष्मान (Ayushman)', 'सौभाग्य (Saubhagya)',
    'शोभन (Shobhana)', 'अतिगण्ड (Atiganda)', 'सुकर्मा (Sukarma)', 'धृति (Dhriti)',
    'शूल (Shula)', 'गण्ड (Ganda)', 'वृद्धि (Vriddhi)', 'ध्रुव (Dhruva)', 'व्याघात (Vyaghata)',
    'हर्षण (Harshana)', 'वज्र (Vajra)', 'सिद्धि (Siddhi)', 'व्यतीपात (Vyatipata)',
    'वरीयान (Variyana)', 'परिघ (Parigha)', 'शिव (Shiva)', 'सिद्ध (Siddha)',
    'साध्य (Sadhya)', 'शुभ (Shubha)', 'शुक्ल (Shukla)', 'ब्रह्म (Brahma)',
    'इन्द्र (Indra)', 'वैधृति (Vaidhriti)'
  ];

  static const List<String> _yogaNamesGu = [
    'વિષ્કુંભ (Vishkambha)', 'પ્રીતિ (Priti)', 'આયુષ્માન (Ayushman)', 'સૌભાગ્ય (Saubhagya)',
    'શોભન (Shobhana)', 'અતિગંડ (Atiganda)', 'સુકર્મા (Sukarma)', 'ધૃતિ (Dhriti)',
    'શૂલ (Shula)', 'ગંડ (Ganda)', 'વૃદ્ધિ (Vriddhi)', 'ધ્રુવ (Dhruva)', 'વ્યાઘાત (Vyaghata)',
    'હર્ષણ (Harshana)', 'વજ્ર (Vajra)', 'સિદ્ધિ (Siddhi)', 'વ્યતીપાત (Vyatipata)',
    'વરીયાન (Variyana)', 'પરિઘ (Parigha)', 'શિવ (Shiva)', 'સિદ્ધ (Siddha)',
    'સાધ્ય (Sadhya)', 'શુભ (Shubha)', 'શુક્લ (Shukla)', 'બ્રહ્મ (Brahma)',
    'ઇન્દ્ર (Indra)', 'વૈધૃતિ (Vaidhriti)'
  ];

  static const List<String> _rashiNamesHi = [
    'मेष (Aries)', 'वृषभ (Taurus)', 'मिथुन (Gemini)', 'कर्क (Cancer)',
    'सिंह (Leo)', 'कन्या (Virgo)', 'तुला (Libra)', 'वृश्चिक (Scorpio)',
    'धनु (Sagittarius)', 'मकर (Capricorn)', 'कुम्भ (Aquarius)', 'मीन (Pisces)'
  ];

  static const List<String> _rashiNamesGu = [
    'મેષ (Aries)', 'વૃષભ (Taurus)', 'મિથુન (Gemini)', 'કર્ક (Cancer)',
    'સિંહ (Leo)', 'કન્યા (Virgo)', 'તુલા (Libra)', 'વૃશ્ચિક (Scorpio)',
    'ધન (Sagittarius)', 'મકર (Capricorn)', 'કુંભ (Aquarius)', 'મીન (Pisces)'
  ];

  static ({String hi, String gu}) _getKaranaName(int karanaIndex) {
    final idx = (karanaIndex % 60 + 60) % 60;
    if (idx == 0) return (hi: 'किंस्तुघ्न (Kinstughna)', gu: 'કિંસ્તુઘ્ન (Kinstughna)');
    if (idx == 57) return (hi: 'शकुनि (Shakuni)', gu: 'શકુનિ (Shakuni)');
    if (idx == 58) return (hi: 'चतुष्पाद (Chatushpada)', gu: 'ચતુષ્પાદ (Chatushpada)');
    if (idx == 59) return (hi: 'नाग (Naga)', gu: 'નાગ (Naga)');

    const movableHi = [
      'बव (Bava)', 'बालव (Balava)', 'कौलव (Kaulava)', 'तैतिल (Taitila)',
      'गर (Gara)', 'वणिज (Vanija)', 'विष्टि/भद्रा (Vishti)'
    ];
    const movableGu = [
      'બવ (Bava)', 'બાલવ (Balava)', 'કૌલવ (Kaulava)', 'તૈતિલ (Taitila)',
      'ગર (Gara)', 'વણિજ (Vanija)', 'વિષ્ટિ/ભદ્રા (Vishti)'
    ];
    final mIdx = (idx - 1) % 7;
    return (hi: movableHi[mIdx], gu: movableGu[mIdx]);
  }

  static String _getVaarGu(int weekday) {
    switch (weekday) {
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

  static PanchangModel calculateVedicPanchang(DateTime date, CityLocation city) {
    final sunTimes = _calculateSunTimes(date, city);
    final nextSunTimes = _calculateSunTimes(date.add(const Duration(days: 1)), city);

    final refLocalTime = DateTime(
      date.year,
      date.month,
      date.day,
      sunTimes.sunriseMinutes ~/ 60,
      sunTimes.sunriseMinutes % 60,
    );

    final angles = _calculateAnglesAt(refLocalTime);
    final tithiAngle = angles.tithiAngle;

    // 1. Tithi Calculation & Timing Spans
    final tithiIndex = (tithiAngle / 12.0).floor() % 30;
    final isShukla = tithiIndex < 15;
    final displayTithi = _tithiNamesHi[tithiIndex];
    final tithiSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 12.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );
    final nextTithiIdx = (tithiIndex + 1) % 30;

    // 2. Nakshatra Calculation & Timing Spans
    final nakshatraIdx = (angles.nakshatraAngle / (360.0 / 27.0)).floor() % 27;
    final nakshatraSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 360.0 / 27.0,
      angleGetter: (t) => _calculateAnglesAt(t).nakshatraAngle,
    );
    final nextNakshatraIdx = (nakshatraIdx + 1) % 27;

    // 3. Yoga Calculation & Timing Spans
    final yogaIdx = (angles.yogaAngle / (360.0 / 27.0)).floor() % 27;
    final yogaSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 360.0 / 27.0,
      angleGetter: (t) => _calculateAnglesAt(t).yogaAngle,
    );
    final nextYogaIdx = (yogaIdx + 1) % 27;

    // 4. Karana Calculation & Timing Spans
    final karanaFullIdx = (tithiAngle / 6.0).floor() % 60;
    final curKarana = _getKaranaName(karanaFullIdx);
    final nextKarana = _getKaranaName(karanaFullIdx + 1);
    final karanaSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 6.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );

    // 5. Chandra Rashi (Moon Sign) & Timing Spans
    final rashiIdx = (angles.rashiAngle / 30.0).floor() % 12;
    final rashiSpan = _calculateSpanForAngle(
      refDateTime: refLocalTime,
      stepDegrees: 30.0,
      angleGetter: (t) => _calculateAnglesAt(t).rashiAngle,
      maxBack: const Duration(hours: 60),
      maxForward: const Duration(hours: 60),
    );
    final nextRashiIdx = (rashiIdx + 1) % 12;

    // 6. Vaar Timing (Sunrise to Next Sunrise)
    final nextWeekday = (date.weekday % 7) + 1;

    // 7. Dynamic Sun & Moon Times
    final moonTimes = _calculateMoonTimes(date, sunTimes.sunriseMinutes, sunTimes.sunsetMinutes, tithiAngle);

    return PanchangModel(
      date: date,
      cityName: city.name,
      tithi: displayTithi,
      tithiPaksha: isShukla ? 'शुक्ल पक्ष (Shukla Paksha)' : 'कृष्ण पक्ष (Krishna Paksha)',
      tithiStartTime: _formatSpanDateTime(tithiSpan.startTime),
      tithiEndTime: _formatSpanDateTime(tithiSpan.endTime),
      nextTithi: _tithiNamesHi[nextTithiIdx],
      nextTithiGujarati: _tithiNamesGu[nextTithiIdx],
      nakshatra: _nakshatraNamesHi[nakshatraIdx],
      nakshatraStartTime: _formatSpanDateTime(nakshatraSpan.startTime),
      nakshatraEndTime: _formatSpanDateTime(nakshatraSpan.endTime),
      nextNakshatra: _nakshatraNamesHi[nextNakshatraIdx],
      nextNakshatraGujarati: _nakshatraNamesGu[nextNakshatraIdx],
      yoga: _yogaNamesHi[yogaIdx],
      yogaStartTime: _formatSpanDateTime(yogaSpan.startTime),
      yogaEndTime: _formatSpanDateTime(yogaSpan.endTime),
      nextYoga: _yogaNamesHi[nextYogaIdx],
      nextYogaGujarati: _yogaNamesGu[nextYogaIdx],
      karana: curKarana.hi,
      karanaStartTime: _formatSpanDateTime(karanaSpan.startTime),
      karanaEndTime: _formatSpanDateTime(karanaSpan.endTime),
      nextKarana: nextKarana.hi,
      nextKaranaGujarati: nextKarana.gu,
      rashi: _rashiNamesHi[rashiIdx],
      rashiGujarati: _rashiNamesGu[rashiIdx],
      rashiStartTime: _formatSpanDateTime(rashiSpan.startTime),
      rashiEndTime: _formatSpanDateTime(rashiSpan.endTime),
      nextRashi: _rashiNamesHi[nextRashiIdx],
      nextRashiGujarati: _rashiNamesGu[nextRashiIdx],
      vaar: _getVaar(date.weekday),
      vaarStartTime: sunTimes.sunrise,
      vaarEndTime: nextSunTimes.sunrise,
      nextVaar: _getVaar(nextWeekday),
      nextVaarGujarati: _getVaarGu(nextWeekday),
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
    final angles = _calculateAnglesAt(birthDateTime);
    final siderealMoonLong = angles.moonLong;
    final tithiAngle = angles.tithiAngle;

    // 1. Janma Rashi (0 to 11) & Timing Spans
    final rashiIdx = (siderealMoonLong / 30.0).floor() % 12;
    final rashiSpan = _calculateSpanForAngle(
      refDateTime: birthDateTime,
      stepDegrees: 30.0,
      angleGetter: (t) => _calculateAnglesAt(t).rashiAngle,
      maxBack: const Duration(hours: 60),
      maxForward: const Duration(hours: 60),
    );
    final nextRashiIdx = (rashiIdx + 1) % 12;

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
    final nextRInfo = rashiData[nextRashiIdx];

    // 2. Janma Nakshatra (0 to 26) & Pada (1 to 4) & Timing Spans
    final nakshatraDeg = 360.0 / 27.0; // 13.3333°
    final nakshatraIdx = (siderealMoonLong / nakshatraDeg).floor() % 27;
    final padaDeg = nakshatraDeg / 4.0; // 3.3333°
    final pada = ((siderealMoonLong % nakshatraDeg) / padaDeg).floor() + 1;
    final nakshatraSpan = _calculateSpanForAngle(
      refDateTime: birthDateTime,
      stepDegrees: nakshatraDeg,
      angleGetter: (t) => _calculateAnglesAt(t).nakshatraAngle,
    );
    final nextNakshatraIdx = (nakshatraIdx + 1) % 27;

    // 3. Tithi at Birth Time
    final tithiIndex = (tithiAngle / 12.0).floor() % 30;
    final tithiSpan = _calculateSpanForAngle(
      refDateTime: birthDateTime,
      stepDegrees: 12.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );
    final nextTithiIdx = (tithiIndex + 1) % 30;

    // 4. Yoga at Birth Time
    final yogaIdx = (angles.yogaAngle / (360.0 / 27.0)).floor() % 27;
    final yogaSpan = _calculateSpanForAngle(
      refDateTime: birthDateTime,
      stepDegrees: 360.0 / 27.0,
      angleGetter: (t) => _calculateAnglesAt(t).yogaAngle,
    );
    final nextYogaIdx = (yogaIdx + 1) % 27;

    // 5. Karana at Birth Time
    final karanaFullIdx = (tithiAngle / 6.0).floor() % 60;
    final curKarana = _getKaranaName(karanaFullIdx);
    final nextKarana = _getKaranaName(karanaFullIdx + 1);
    final karanaSpan = _calculateSpanForAngle(
      refDateTime: birthDateTime,
      stepDegrees: 6.0,
      angleGetter: (t) => _calculateAnglesAt(t).tithiAngle,
    );

    // 6. Vaar at Birth Time
    final sunTimes = _calculateSunTimes(birthDateTime, city);
    final nextSunTimes = _calculateSunTimes(birthDateTime.add(const Duration(days: 1)), city);
    final nextWeekday = (birthDateTime.weekday % 7) + 1;

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
      rashiStartTime: _formatSpanDateTime(rashiSpan.startTime),
      rashiEndTime: _formatSpanDateTime(rashiSpan.endTime),
      nextRashiHindi: nextRInfo.$1,
      nextRashiGujarati: nextRInfo.$2,
      nextRashiEn: nextRInfo.$3,
      nakshatraHindi: _nakshatraNamesHi[nakshatraIdx],
      nakshatraGujarati: _nakshatraNamesGu[nakshatraIdx],
      pada: pada,
      nakshatraStartTime: _formatSpanDateTime(nakshatraSpan.startTime),
      nakshatraEndTime: _formatSpanDateTime(nakshatraSpan.endTime),
      nextNakshatraHindi: _nakshatraNamesHi[nextNakshatraIdx],
      nextNakshatraGujarati: _nakshatraNamesGu[nextNakshatraIdx],
      tithiHindi: _tithiNamesHi[tithiIndex],
      tithiGujarati: _tithiNamesGu[tithiIndex],
      tithiStartTime: _formatSpanDateTime(tithiSpan.startTime),
      tithiEndTime: _formatSpanDateTime(tithiSpan.endTime),
      nextTithiHindi: _tithiNamesHi[nextTithiIdx],
      nextTithiGujarati: _tithiNamesGu[nextTithiIdx],
      yogaHindi: _yogaNamesHi[yogaIdx],
      yogaGujarati: _yogaNamesGu[yogaIdx],
      yogaStartTime: _formatSpanDateTime(yogaSpan.startTime),
      yogaEndTime: _formatSpanDateTime(yogaSpan.endTime),
      nextYogaHindi: _yogaNamesHi[nextYogaIdx],
      nextYogaGujarati: _yogaNamesGu[nextYogaIdx],
      karanaHindi: curKarana.hi,
      karanaGujarati: curKarana.gu,
      karanaStartTime: _formatSpanDateTime(karanaSpan.startTime),
      karanaEndTime: _formatSpanDateTime(karanaSpan.endTime),
      nextKaranaHindi: nextKarana.hi,
      nextKaranaGujarati: nextKarana.gu,
      vaarHindi: _getVaar(birthDateTime.weekday),
      vaarGujarati: _getVaarGu(birthDateTime.weekday),
      vaarStartTime: sunTimes.sunrise,
      vaarEndTime: nextSunTimes.sunrise,
      nextVaarHindi: _getVaar(nextWeekday),
      nextVaarGujarati: _getVaarGu(nextWeekday),
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
