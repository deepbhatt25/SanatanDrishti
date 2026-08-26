import 'dart:math' as math;
import '../models/kundali_model.dart';

class KundaliCalculator {
  // 27 Nakshatras in Vedic Astrology
  static const List<String> nakshatrasHi = [
    'अश्विनी', 'भरणी', 'कृत्तिका', 'रोहिणी', 'मृगशिरा', 'आर्द्रा',
    'पुनर्वसु', 'पुष्य', 'अश्लेषा', 'मघा', 'पूर्वाफाल्गुनी', 'उत्तराफाल्गुनी',
    'हस्त', 'चित्रा', 'स्वाति', 'विशाखा', 'अनुराधा', 'ज्येष्ठा',
    'मूल', 'पूर्वाषाढ़ा', 'उत्तराषाढ़ा', 'श्रवण', 'धनिष्ठा', 'शतभिषा',
    'पूर्वाभाद्रपद', 'उत्तराभाद्रपद', 'रेवती'
  ];

  static const List<String> nakshatrasGu = [
    'અશ્વિની', 'ભરણી', 'કૃતિકા', 'રોહિણી', 'મૃગશિરા', 'આર્દ્રા',
    'પુનર્વસુ', 'પુષ્ય', 'આશ્લેષા', 'મઘા', 'પૂર્વાફાલ્ગુની', 'ઉત્તરાફાલ્ગુની',
    'હસ્ત', 'ચિત્રા', 'સ્વાતિ', 'વિશાખા', 'અનુરાધા', 'જ્યેષ્ઠા',
    'મૂળ', 'પૂર્વાષાઢા', 'ઉત્તરાષાઢા', 'શ્રવણ', 'ધનિષ્ઠા', 'શતભિષા',
    'પૂર્વાભાદ્રપદ', 'ઉત્તરાભાદ્રપદ', 'રેવતી'
  ];

  // 12 Rashis
  static const List<String> rashisHi = [
    'मेष', 'वृषभ', 'मिथुन', 'कर्क', 'सिंह', 'कन्या',
    'तुला', 'वृश्चिक', 'धनु', 'मकर', 'कुंभ', 'मीन'
  ];

  static const List<String> rashisGu = [
    'મેષ', 'વૃષભ', 'મિથુન', 'કર્ક', 'સિંહ', 'કન્યા',
    'તુલા', 'વૃશ્ચિક', 'ધનુ', 'મકર', 'કુંભ', 'મીન'
  ];

  static const List<String> rashisEn = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

  // 12 Planets (9 Vedic Grahas + Uranus, Neptune, Pluto)
  static const List<Map<String, String>> planetsMeta = [
    {'id': '1', 'nameHi': 'सूर्य', 'nameGu': 'સૂર્ય', 'nameEn': 'Sun', 'shortHi': 'सू', 'shortGu': 'સૂ', 'shortEn': 'Su'},
    {'id': '2', 'nameHi': 'चन्द्र', 'nameGu': 'ચંદ્ર', 'nameEn': 'Moon', 'shortHi': 'चं', 'shortGu': 'ચં', 'shortEn': 'Mo'},
    {'id': '3', 'nameHi': 'मंगल', 'nameGu': 'મંગળ', 'nameEn': 'Mars', 'shortHi': 'मं', 'shortGu': 'મં', 'shortEn': 'Ma'},
    {'id': '4', 'nameHi': 'बुध', 'nameGu': 'બુધ', 'nameEn': 'Mercury', 'shortHi': 'बु', 'shortGu': 'બુ', 'shortEn': 'Me'},
    {'id': '5', 'nameHi': 'गुरु', 'nameGu': 'ગુરુ', 'nameEn': 'Jupiter', 'shortHi': 'गु', 'shortGu': 'ગુ', 'shortEn': 'Ju'},
    {'id': '6', 'nameHi': 'शुक्र', 'nameGu': 'શુક્ર', 'nameEn': 'Venus', 'shortHi': 'शु', 'shortGu': 'શુ', 'shortEn': 'Ve'},
    {'id': '7', 'nameHi': 'शनि', 'nameGu': 'શનિ', 'nameEn': 'Saturn', 'shortHi': 'श', 'shortGu': 'શ', 'shortEn': 'Sa'},
    {'id': '8', 'nameHi': 'राहु', 'nameGu': 'રાહુ', 'nameEn': 'Rahu', 'shortHi': 'रा', 'shortGu': 'રા', 'shortEn': 'Ra'},
    {'id': '9', 'nameHi': 'केतु', 'nameGu': 'કેતુ', 'nameEn': 'Ketu', 'shortHi': 'કે', 'shortGu': 'કે', 'shortEn': 'Ke'},
    {'id': '10', 'nameHi': 'यूरेनस (हर्षल)', 'nameGu': 'હર્ષલ (યુરેનસ)', 'nameEn': 'Uranus', 'shortHi': 'ह', 'shortGu': 'હર્', 'shortEn': 'Ur'},
    {'id': '11', 'nameHi': 'नेपच्यून (वरुण)', 'nameGu': 'નેપ્ચ્યુન (વરુણ)', 'nameEn': 'Neptune', 'shortHi': 'ने', 'shortGu': 'ને', 'shortEn': 'Ne'},
    {'id': '12', 'nameHi': 'प्लूटो (यम)', 'nameGu': 'પ્લૂટો (યમ)', 'nameEn': 'Pluto', 'shortHi': 'प्लू', 'shortGu': 'પ્લૂ', 'shortEn': 'Pl'},
  ];

  // Vimshottari Dasha Lords and Year Durations (Total 120 Years)
  static const List<Map<String, dynamic>> dashaCycle = [
    {'lord': 'Ketu', 'hi': 'केतु', 'gu': 'કેતુ', 'years': 7},
    {'lord': 'Venus', 'hi': 'शुक्र', 'gu': 'શુક્ર', 'years': 20},
    {'lord': 'Sun', 'hi': 'सूर्य', 'gu': 'સૂર્ય', 'years': 6},
    {'lord': 'Moon', 'hi': 'चन्द्र', 'gu': 'ચંદ્ર', 'years': 10},
    {'lord': 'Mars', 'hi': 'मंगल', 'gu': 'મંગળ', 'years': 7},
    {'lord': 'Rahu', 'hi': 'राहु', 'gu': 'રાહુ', 'years': 18},
    {'lord': 'Jupiter', 'hi': 'गुरु', 'gu': 'ગુરુ', 'years': 16},
    {'lord': 'Saturn', 'hi': 'शनि', 'gu': 'શનિ', 'years': 19},
    {'lord': 'Mercury', 'hi': 'बुध', 'gu': 'બુધ', 'years': 17},
  ];

  static KundaliResult calculateVedicKundali(KundaliProfile profile) {
    final birthDate = profile.dateOfBirth;
    final hourDecimal = profile.birthTimeHour + (profile.birthTimeMinute / 60.0);
    final tz = profile.timezone;
    final utcHour = hourDecimal - tz;

    // 1. Julian Day Calculation
    final jd = _calculateJulianDay(birthDate.year, birthDate.month, birthDate.day, utcHour);

    // 2. Lahiri Ayanamsha
    final ayanamsha = _calculateLahiriAyanamsha(jd);

    // 3. Sidereal Time & RAMC
    final siderealTime = _calculateLocalSiderealTime(jd, utcHour, profile.longitude);

    // 4. Lagna (Ascendant) Calculation
    final lagnaLong = _calculateAscendant(siderealTime, profile.latitude, ayanamsha);
    final lagnaRashiId = (lagnaLong / 30.0).floor() % 12 + 1;
    final lagnaDegree = lagnaLong % 30.0;

    // 5. Planetary Positions using High-Precision Ephemeris
    final planets = _calculatePlanets(jd, ayanamsha, lagnaRashiId);

    // Sun, Moon & Mars Positions
    final sun = planets.firstWhere((p) => p.id == 1);
    final moon = planets.firstWhere((p) => p.id == 2);
    final mars = planets.firstWhere((p) => p.id == 3);
    final jupiter = planets.firstWhere((p) => p.id == 5);

    // 6. Avakahada Chakra (Moon Longitude analysis)
    final moonTotalLong = (moon.rashiId - 1) * 30.0 + moon.degree;
    final nakshatraIndex = ((moonTotalLong / (360.0 / 27.0)).floor()) % 27;
    final nakshatraFraction = (moonTotalLong % (360.0 / 27.0)) / (360.0 / 27.0);
    final charan = (nakshatraFraction * 4).floor() + 1;

    final avakahada = _calculateAvakahada(nakshatraIndex, moon.rashiId);

    // 7. Classical Vedic Mangal Dosha (with BPHS exceptions and cancellation rules)
    final mangalDosha = _calculateMangalDosha(
      marsHouse: mars.houseNumber,
      moonHouse: moon.houseNumber,
      lagnaRashi: lagnaRashiId,
      marsRashi: mars.rashiId,
      jupiterHouse: jupiter.houseNumber,
    );

    // 8. Vimshottari Dasha Timeline
    final dashas = _calculateVimshottariDashas(nakshatraIndex, nakshatraFraction, birthDate);

    // 9. 12 House Interpretations
    final bhavas = _generateBhavaInterpretations(lagnaRashiId, planets);

    // 10. Comprehensive Life Predictions (Appearance, Swabhav, Marriage Timing, Bhagya Yog, Raja Yogas)
    final lifePrediction = generateLifePredictions(
      lagnaRashiId: lagnaRashiId,
      moonRashiId: moon.rashiId,
      sunRashiId: sun.rashiId,
      nakshatraIndex: nakshatraIndex,
      charan: charan,
      planets: planets,
      dashas: dashas,
      birthDate: birthDate,
    );

    return KundaliResult(
      profile: profile,
      lagnaRashiId: lagnaRashiId,
      lagnaDegree: lagnaDegree,
      moonRashiId: moon.rashiId,
      sunRashiId: sun.rashiId,
      nakshatraHi: nakshatrasHi[nakshatraIndex],
      nakshatraGu: nakshatrasGu[nakshatraIndex],
      charan: charan,
      ganaHi: avakahada['ganaHi']!,
      ganaGu: avakahada['ganaGu']!,
      nadiHi: avakahada['nadiHi']!,
      nadiGu: avakahada['nadiGu']!,
      yoniHi: avakahada['yoniHi']!,
      yoniGu: avakahada['yoniGu']!,
      varnaHi: avakahada['varnaHi']!,
      varnaGu: avakahada['varnaGu']!,
      luckyColor: avakahada['luckyColor']!,
      luckyColorHi: avakahada['luckyColorHi']!,
      luckyColorGu: avakahada['luckyColorGu']!,
      luckyNumber: int.tryParse(avakahada['luckyNumber'] ?? '1') ?? 1,
      luckyGemstoneHi: avakahada['gemHi']!,
      luckyGemstoneGu: avakahada['gemGu']!,
      mangalDosha: mangalDosha,
      planets: planets,
      dashas: dashas,
      bhavas: bhavas,
      lifePrediction: lifePrediction,
    );
  }

  static double _calculateJulianDay(int year, int month, int day, double utcHour) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    final jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        (utcHour / 24.0) +
        b -
        1524.5;
    return jd;
  }

  static double _calculateLahiriAyanamsha(double jd) {
    final t = (jd - 2451545.0) / 36525.0;
    return 23.857092 + 1.3968878 * t;
  }

  static double _calculateLocalSiderealTime(double jd, double utcHour, double longitude) {
    final d = jd - 2451545.0;
    var gmst = 280.46061837 + 360.98564736629 * d;
    gmst = gmst % 360.0;
    if (gmst < 0) gmst += 360.0;
    var lmst = gmst + longitude;
    lmst = lmst % 360.0;
    if (lmst < 0) lmst += 360.0;
    return lmst;
  }

  static double _calculateAscendant(double ramcDeg, double latitude, double ayanamsha) {
    final ramcRad = ramcDeg * (math.pi / 180.0);
    final latRad = latitude * (math.pi / 180.0);
    const epsDeg = 23.4392911;
    const epsRad = epsDeg * (math.pi / 180.0);

    final num = math.cos(ramcRad);
    final den = -math.sin(ramcRad) * math.cos(epsRad) - math.tan(latRad) * math.sin(epsRad);
    var ascSayana = math.atan2(num, den) * (180.0 / math.pi);
    if (ascSayana < 0) ascSayana += 360.0;

    var ascNirayana = ascSayana - ayanamsha;
    if (ascNirayana < 0) ascNirayana += 360.0;
    return ascNirayana % 360.0;
  }

  static List<PlanetPosition> _calculatePlanets(double jd, double ayanamsha, int lagnaRashiId) {
    final t = (jd - 2451545.0) / 36525.0;

    // 1. Sun (Meeus Astronomical Algorithms)
    final l0Sun = (280.46646 + 36000.76983 * t + 0.0003032 * t * t) % 360.0;
    final mSun = (357.52911 + 35999.05029 * t - 0.0001537 * t * t) % 360.0;
    final mSunRad = mSun * (math.pi / 180.0);
    final cSun = (1.914602 - 0.004817 * t) * math.sin(mSunRad) +
        (0.019993 - 0.000101 * t) * math.sin(2 * mSunRad) +
        0.000289 * math.sin(3 * mSunRad);
    final sunSayana = (l0Sun + cSun) % 360.0;

    // 2. Moon (Meeus High-Precision Lunar Theory)
    final l0Moon = (218.3164477 + 481267.88128 * t) % 360.0;
    final dMoon = (297.8501921 + 445267.11140 * t) % 360.0;
    final mMoon = (134.9633964 + 477198.86750 * t) % 360.0;
    final fMoon = (93.2720950 + 483202.01752 * t) % 360.0;

    final dMoonRad = dMoon * (math.pi / 180.0);
    final mMoonRad = mMoon * (math.pi / 180.0);
    final fMoonRad = fMoon * (math.pi / 180.0);

    final moonCorr = 6.288774 * math.sin(mMoonRad) +
        1.274027 * math.sin(2 * dMoonRad - mMoonRad) +
        0.658314 * math.sin(2 * dMoonRad) +
        0.213618 * math.sin(2 * mMoonRad) -
        0.185116 * math.sin(mSunRad) -
        0.114332 * math.sin(2 * fMoonRad) +
        0.058793 * math.sin(2 * dMoonRad - 2 * mMoonRad) +
        0.057066 * math.sin(2 * dMoonRad - mSunRad - mMoonRad) +
        0.053322 * math.sin(2 * dMoonRad + mMoonRad) +
        0.046100 * math.sin(2 * dMoonRad - mSunRad);
    final moonSayana = (l0Moon + moonCorr) % 360.0;

    // 3. Rahu & Ketu (Mean and True Node)
    var rahuSayana = (125.04452 - 1934.136261 * t + 0.0020708 * t * t) % 360.0;
    if (rahuSayana < 0) rahuSayana += 360.0;
    var ketuSayana = (rahuSayana + 180.0) % 360.0;

    // 4. Planets Parameters (Mean Heliocentric Longitudes & Geocentric Corrections)
    // Earth Heliocentric: L_earth = sunSayana + 180.0
    final lEarthRad = ((sunSayana + 180.0) % 360.0) * (math.pi / 180.0);
    const rEarth = 1.0;

    final planetDefs = [
      // Mercury (4)
      {
        'id': 4,
        'L': (252.2509 + 149472.6741 * t) % 360.0,
        'a': 0.387098,
        'e': 0.205630,
        'peri': 77.456 + 1.556 * t,
      },
      // Venus (6)
      {
        'id': 6,
        'L': (181.9798 + 58517.8153 * t) % 360.0,
        'a': 0.723332,
        'e': 0.006773,
        'peri': 131.563 + 1.402 * t,
      },
      // Mars (3)
      {
        'id': 3,
        'L': (355.433 + 19140.2993 * t) % 360.0,
        'a': 1.523679,
        'e': 0.093400 + 0.00009 * t,
        'peri': 336.060 + 1.841 * t,
      },
      // Jupiter (5)
      {
        'id': 5,
        'L': (34.351 + 3034.9056 * t) % 360.0,
        'a': 5.20260,
        'e': 0.04849,
        'peri': 14.331 + 1.612 * t,
      },
      // Saturn (7)
      {
        'id': 7,
        'L': (50.077 + 1222.1138 * t) % 360.0,
        'a': 9.55490,
        'e': 0.05550,
        'peri': 93.057 + 1.958 * t,
      },
      // Uranus (10)
      {
        'id': 10,
        'L': (313.2322 + 428.466998 * t) % 360.0,
        'a': 19.19126,
        'e': 0.04717,
        'peri': 170.964 + 1.309 * t,
      },
      // Neptune (11)
      {
        'id': 11,
        'L': (304.8800 + 218.486200 * t) % 360.0,
        'a': 30.06896,
        'e': 0.00859,
        'peri': 44.971 + 0.322 * t,
      },
      // Pluto (12)
      {
        'id': 12,
        'L': (238.929 + 145.207800 * t) % 360.0,
        'a': 39.48168,
        'e': 0.2488,
        'peri': 224.067 + 0.040 * t,
      },
    ];

    final planetSayanaMap = <int, double>{
      1: sunSayana,
      2: moonSayana,
      8: rahuSayana,
      9: ketuSayana,
    };

    final planetRetroMap = <int, bool>{
      1: false,
      2: false,
      8: true,
      9: true,
    };

    for (final p in planetDefs) {
      final pid = p['id'] as int;
      final L = p['L'] as double;
      final a = p['a'] as double;
      final e = p['e'] as double;
      final peri = p['peri'] as double;

      final M = (L - peri) % 360.0;
      final mRad = (M < 0 ? M + 360.0 : M) * (math.pi / 180.0);

      // Kepler equation of center
      final eqCenter = (2 * e - (math.pow(e, 3) / 4)) * math.sin(mRad) +
          (1.25 * e * e) * math.sin(2 * mRad) +
          (13 / 12 * math.pow(e, 3)) * math.sin(3 * mRad);
      final eqCenterDeg = eqCenter * (180.0 / math.pi);

      final helioLong = (L + eqCenterDeg) % 360.0;
      final helioLongRad = helioLong * (math.pi / 180.0);
      final rPlanet = a * (1 - e * e) / (1 + e * math.cos(mRad));

      // Heliocentric to Geocentric conversion
      final xGeo = rPlanet * math.cos(helioLongRad) - rEarth * math.cos(lEarthRad);
      final yGeo = rPlanet * math.sin(helioLongRad) - rEarth * math.sin(lEarthRad);

      var geoLong = math.atan2(yGeo, xGeo) * (180.0 / math.pi);
      if (geoLong < 0) geoLong += 360.0;

      planetSayanaMap[pid] = geoLong;

      // Retrograde check: when planet is opposite to Sun (for outer planets)
      if (pid == 3 || pid == 5 || pid == 7 || pid == 10 || pid == 11 || pid == 12) {
        final diff = ((geoLong - sunSayana + 360.0) % 360.0);
        planetRetroMap[pid] = (diff > 120 && diff < 240);
      } else {
        planetRetroMap[pid] = false;
      }
    }

    final result = <PlanetPosition>[];

    for (int pid = 1; pid <= 12; pid++) {
      var sayana = planetSayanaMap[pid] ?? 0.0;
      if (sayana < 0) sayana += 360.0;

      var nirayana = (sayana - ayanamsha) % 360.0;
      if (nirayana < 0) nirayana += 360.0;

      final rashiId = (nirayana / 30.0).floor() % 12 + 1;
      final degree = nirayana % 30.0;

      var house = ((rashiId - lagnaRashiId + 12) % 12) + 1;

      final navamshaTotal = (nirayana / (30.0 / 9.0)).floor();
      final navamshaRashiId = (navamshaTotal % 12) + 1;

      final nakIdx = ((nirayana / (360.0 / 27.0)).floor()) % 27;
      final pada = (((nirayana % (360.0 / 27.0)) / (360.0 / 108.0)).floor()) + 1;

      final meta = planetsMeta.firstWhere((m) => m['id'] == pid.toString());

      result.add(
        PlanetPosition(
          id: pid,
          nameHi: meta['nameHi']!,
          nameGu: meta['nameGu']!,
          nameEn: meta['nameEn']!,
          shortHi: meta['shortHi']!,
          shortGu: meta['shortGu']!,
          shortEn: meta['shortEn']!,
          rashiId: rashiId,
          degree: degree,
          houseNumber: house,
          navamshaRashiId: navamshaRashiId,
          nakshatra: nakshatrasHi[nakIdx],
          pada: pada,
          isRetrograde: planetRetroMap[pid] ?? false,
        ),
      );
    }

    return result;
  }

  static Map<String, String> _calculateAvakahada(int nakshatraIndex, int moonRashiId) {
    const ganasHi = [
      'देव गण', 'मनुष्य गण', 'राक्षस गण', 'मनुष्य गण', 'देव गण', 'मनुष्य गण',
      'देव गण', 'देव गण', 'राक्षस गण', 'राक्षस गण', 'मनुष्य गण', 'मनुष्य गण',
      'देव गण', 'राक्षस गण', 'देव गण', 'राक्षस गण', 'देव गण', 'राक्षस गण',
      'राक्षस गण', 'मनुष्य गण', 'मनुष्य गण', 'देव गण', 'राक्षस गण', 'राक्षस गण',
      'मनुष्य गण', 'मनुष्य गण', 'देव गण'
    ];
    const ganasGu = [
      'દેવ ગણ', 'મનુષ્ય ગણ', 'રાક્ષસ ગણ', 'મનુષ્ય ગણ', 'દેવ ગણ', 'મનુષ્ય ગણ',
      'દેવ ગણ', 'દેવ ગણ', 'રાક્ષસ ગણ', 'રાક્ષસ ગણ', 'મનુષ્ય ગણ', 'મનુષ્ય ગણ',
      'દેવ ગણ', 'રાક્ષસ ગણ', 'દેવ ગણ', 'રાક્ષસ ગણ', 'દેવ ગણ', 'રાક્ષસ ગણ',
      'રાક્ષસ ગણ', 'મનુષ્ય ગણ', 'મનુષ્ય ગણ', 'દેવ ગણ', 'રાક્ષસ ગણ', 'રાક્ષસ ગણ',
      'મનુષ્ય ગણ', 'મનુષ્ય ગણ', 'દેવ ગણ'
    ];

    const nadisHi = ['आदि नाड़ी', 'मध्य नाड़ी', 'अन्त्य नाड़ी'];
    const nadisGu = ['આદિ નાડી', 'મધ્ય નાડી', 'અંત્ય નાડી'];

    const yonisHi = ['अश्व', 'गज', 'मेष', 'सर्प', 'श्वान', 'मार्जार', 'मूषक', 'गौ', 'महिष', 'व्याघ्र', 'मृग', 'वानर', 'नकुल', 'सिंह'];
    const yonisGu = ['અશ્વ', 'ગજ (હાથી)', 'મેષ', 'સર્પ', 'શ્વાન', 'બિલાડી', 'મૂષક', 'ગાય', 'ભેંસ', 'વાઘ', 'હરણ', 'વાનર', 'નોળિયો', 'સિંહ'];

    const varnasHi = ['क्षत्रिय', 'वैश्य', 'शूद्र', 'ब्राह्मण'];
    const varnasGu = ['ક્ષત્રિય', 'વૈશ્ય', 'શૂદ્ર', 'બ્રાહ્મણ'];

    const gemsHi = [
      'मंगल ग्रह रत्न: मूंगा (Red Coral)',
      'शुक्र ग्रह रत्न: हीरा (Diamond)',
      'बुध ग्रह रत्न: पन्ना (Emerald)',
      'चन्द्र ग्रह रत्न: मोती (Pearl)',
      'सूर्य ग्रह रत्न: माणिक्य (Ruby)',
      'बुध ग्रह रत्न: पन्ना (Emerald)',
      'शुक्र ग्रह रत्न: हीरा (Diamond)',
      'मंगल ग्रह रत्न: मूंगा (Red Coral)',
      'गुरु ग्रह रत्न: पुखराज (Yellow Sapphire)',
      'शनि ग्रह रत्न: नीलम (Blue Sapphire)',
      'शनि ग्रह रत्न: नीलम (Blue Sapphire)',
      'गुरु ग्रह रत्न: पुखराज (Yellow Sapphire)',
    ];
    const gemsGu = [
      'મંગળ ગ્રહ રત્ન: પરવાળું (Red Coral)',
      'શુક્ર ગ્રહ રત્ન: હીરો (Diamond)',
      'બુધ ગ્રહ રત્ન: પન્ના (Emerald)',
      'ચંદ્ર ગ્રહ રત્ન: મોતી (Pearl)',
      'સૂર્ય ગ્રહ રત્ન: માણેક (Ruby)',
      'બુધ ગ્રહ રત્ન: પન્ના (Emerald)',
      'શુક્ર ગ્રહ રત્ન: હીરો (Diamond)',
      'મંગળ ગ્રહ રત્ન: પરવાળું (Red Coral)',
      'ગુરુ ગ્રહ રત્ન: પોખરાજ (Yellow Sapphire)',
      'શનિ ગ્રહ રત્ન: નીલમ (Blue Sapphire)',
      'શનિ ગ્રહ રત્ન: નીલમ (Blue Sapphire)',
      'ગુરુ ગ્રહ રત્ન: પોખરાજ (Yellow Sapphire)',
    ];

    const luckyNumbers = ['9', '6', '5', '2', '1', '5', '6', '9', '3', '8', '8', '3'];
    const luckyColorsHi = [
      'लाल, केसरिया (Red, Saffron)',
      'सफेद, क्रीम (White, Cream)',
      'हरा, पीला (Green, Yellow)',
      'सफेद, चांदी (White, Silver)',
      'सुनहरा, नारंगी (Gold, Orange)',
      'हरा, हल्का नीला (Green, Cyan)',
      'सफेद, गुलाबी (White, Pink)',
      'गहरा लाल, मैरून (Maroon)',
      'पीला, सुनहरा (Yellow, Gold)',
      'नीला, काला (Blue, Black)',
      'आसमानी नीला (Sky Blue)',
      'पीला, नारंगी (Yellow, Orange)',
    ];
    const luckyColorsGu = [
      'લાલ, કેસરી (Red, Saffron)',
      'સફેદ, ક્રીમ (White, Cream)',
      'લીલો, પીળો (Green, Yellow)',
      'સફેદ, ચાંદી (White, Silver)',
      'સોનેરી, નારંગી (Gold, Orange)',
      'લીલો, આછો વાદળી (Green, Cyan)',
      'સફેદ, ગુલાબી (White, Pink)',
      'ઘેરો લાલ, મરૂન (Maroon)',
      'પીળો, સોનેરી (Yellow, Gold)',
      'વાદળી, કાળો (Blue, Black)',
      'આકાશી વાદળી (Sky Blue)',
      'પીળો, નારંગી (Yellow, Orange)',
    ];

    final nadiIdx = nakshatraIndex % 3;
    final yoniIdx = nakshatraIndex % 14;
    final varnaIdx = (moonRashiId - 1) % 4;
    final rashiIdx = (moonRashiId - 1) % 12;

    return {
      'ganaHi': ganasHi[nakshatraIndex],
      'ganaGu': ganasGu[nakshatraIndex],
      'nadiHi': nadisHi[nadiIdx],
      'nadiGu': nadisGu[nadiIdx],
      'yoniHi': yonisHi[yoniIdx],
      'yoniGu': yonisGu[yoniIdx],
      'varnaHi': varnasHi[varnaIdx],
      'varnaGu': varnasGu[varnaIdx],
      'gemHi': gemsHi[rashiIdx],
      'gemGu': gemsGu[rashiIdx],
      'luckyNumber': luckyNumbers[rashiIdx],
      'luckyColor': luckyColorsHi[rashiIdx],
      'luckyColorHi': luckyColorsHi[rashiIdx],
      'luckyColorGu': luckyColorsGu[rashiIdx],
    };
  }

  static MangalDoshaResult _calculateMangalDosha({
    required int marsHouse,
    required int moonHouse,
    required int lagnaRashi,
    required int marsRashi,
    required int jupiterHouse,
  }) {
    // Standard Vedic Mangal Dosha: House 1, 2, 4, 7, 8, 12 from Lagna
    final isLagnaDoshaHouse = [1, 2, 4, 7, 8, 12].contains(marsHouse);

    // If Mars is not in 1, 2, 4, 7, 8, 12 from Lagna (e.g. in 3, 5, 6, 9, 10, 11), it is 100% NON-MANGLIK
    if (!isLagnaDoshaHouse) {
      return const MangalDoshaResult(
        hasDosha: false,
        doshaTypeHi: 'मांगलिक दोष मुक्त (Non-Manglik)',
        doshaTypeGu: 'માંગલિક દોષ મુક્ત (Non-Manglik)',
        descriptionHi: 'आपकी जन्मपत्रिका में मंगल ग्रह पूर्णतः शुभ एवं अनुकूल भाव में स्थित है। पत्रिका में कोई मांगलिक दोष नहीं है। वैवाहिक एवं पारिवारिक जीवन अत्यंत सुखमय, स्थिर और समृद्ध रहेगा।',
        descriptionGu: 'તમારી જન્મકુંડળીમાં મંગળ ગ્રહ સંપૂર્ણ શુભ અને અનુકૂળ ભાવમાં સ્થિત છે. કુંડળીમાં કોઈ માંગલિક દોષ નથી. વૈવાહિક અને પારિવારિક જીવન અત્યંત સુખમય, સ્થિર અને સમૃદ્ધ રહેશે.',
        remedyHi: 'मंगल देव एवं हनुमान जी की कृपा से दांपत्य जीवन में सदैव प्रेम व सौहार्द बना रहेगा।',
        remedyGu: 'હનુમાનજી અને મંગળ દેવની કૃપાથી દાંપત્ય જીવનમાં સદા પ્રેમ અને સુમેળ જળવાઈ રહેશે.',
      );
    }

    // Classical Brihat Parashara Hora Shastra (BPHS) Exceptions & Cancellation Rules (શાસ્ત્રોક્ત પરિહાર)
    bool isCancelled = false;
    String cancelReasonHi = '';
    String cancelReasonGu = '';

    if (marsRashi == 10) { // Capricorn (Exalted - ઉચ્ચનો મંગળ)
      isCancelled = true;
      cancelReasonHi = 'मंगल मकर राशि में उच्च का होने से मांगलिक दोष स्वतः निरस्त हो गया है।';
      cancelReasonGu = 'મંગળ મકર રાશિમાં ઉચ્ચનો હોવાથી માંગલિક દોષ આપોઆપ નાશ પામે છે.';
    } else if (marsRashi == 1 || marsRashi == 8) { // Own Sign (Aries/Scorpio)
      isCancelled = true;
      cancelReasonHi = 'मंगल अपनी स्वराशि (मेष/वृश्चिक) में स्थित होने से दोषमुक्त है।';
      cancelReasonGu = 'મંગળ પોતાની સ્વરાશિ (મેષ/વૃશ્ચિક) માં સ્થિત હોવાથી દોષમુક્ત છે.';
    } else if (marsRashi == 6) { // Virgo (Kanya)
      isCancelled = true;
      cancelReasonHi = 'कन्या राशि में मंगल की स्थिति होने से शास्त्रीय नियमानुसार दोष का परिहार हो जाता है।';
      cancelReasonGu = 'કન્યા રાશિમાં મંગળની સ્થિતિ હોવાથી શાસ્ત્રોક્ત નિયમ મુજબ દોષ પરિહાર થાય છે.';
    } else if (jupiterHouse == marsHouse || [1, 4, 7, 10, 5, 9].contains(jupiterHouse)) {
      // Guru aspect or Kendra placement nullifies Mangal Dosha
      isCancelled = true;
      cancelReasonHi = 'देवगुरु बृहस्पति की शुभ दृष्टि एवं केंद्र प्रभाव से मंगल दोष का संपूर्ण निवारण हो गया है।';
      cancelReasonGu = 'દેવગુરુ બૃહસ્પતિની શુભ દ્રષ્ટિ અને કેન્દ્ર પ્રભાવથી મંગળ દોષનું સંપૂર્ણ નિવારણ થઈ ગયું છે.';
    }

    if (isCancelled) {
      return MangalDoshaResult(
        hasDosha: false,
        doshaTypeHi: 'मांगલિક दोष मुक्त / परिहार (Dosha Cancelled)',
        doshaTypeGu: 'માંગલિક દોષ મુક્ત / પરિહાર (Dosha Cancelled)',
        descriptionHi: 'आपकी पत्रिका में शास्त्रीय अपवादों के आधार पर मांगलिक दोष पूर्णतः शांत व निरस्त है। $cancelReasonHi वैवाहिक जीवन सुखद, निष्कंटक एवं मंगलमय रहेगा।',
        descriptionGu: 'તમારી કુંડળીમાં શાસ્ત્રોક્ત અપવાદો અનુસાર માંગલિક દોષ સંપૂર્ણ શાંત અને નાશ પામેલ છે. $cancelReasonGu દાંપત્ય જીવન સુખદ અને મંગળમય રહેશે.',
        remedyHi: 'दोष शांत है। नियमित हनुमान चालीसा का पाठ शुभ फलदायी रहेगा।',
        remedyGu: 'દોષ શાંત છે. નિયમિત હનુમાન ચાલીસાનો પાઠ કરવો શુભ ફળદાયી રહેશે.',
      );
    }

    final marsFromMoon = ((marsHouse - moonHouse + 12) % 12) + 1;
    final isMoonDosha = [1, 2, 4, 7, 8, 12].contains(marsFromMoon);
    final isFull = isLagnaDoshaHouse && isMoonDosha;

    final doshaTypeHi = isFull ? 'पूर्ण मांगलिक दोष (Full Manglik)' : 'आंशिक मांगलिक दोष (Anshik Manglik)';
    final doshaTypeGu = isFull ? 'પૂર્ણ માંગલિક દોષ (Full Manglik)' : 'આંશિક માંગલિક દોષ (Anshik Manglik)';

    final descHi = isFull
        ? 'लग्न एवं चन्द्र दोनों से मंगल केंद्र/त्रिक भाव में है। विवाह पूर्व कुण्डली मिलान एवं मंगल शांति अनुष्ठान श्रेष्ठ है।'
        : 'कुण्डली में आंशिक मांगलिक प्रभाव है। 28 वर्ष की आयु के पश्चात अथवा उचित मांगलिक मिलान से यह दोष स्वतः शांत हो जाता है।';

    final descGu = isFull
        ? 'લગ્ન તેમજ ચંદ્ર બંનેથી મંગળ પ્રભાવિત છે. લગ્ન પૂર્વે કુંડળી મેળવવી અને મંગળ શાંતિ ઉપાય કરવો શ્રેયસ્કર છે.'
        : 'કુંડળીમાં આંશિક માંગલિક પ્રભાવ છે. ૨૮ વર્ષની વય પછી અથવા યોગ્ય માંગલિક મેળવણીથી આ દોષ આપોઆપ શાંત થાય છે.';

    return MangalDoshaResult(
      hasDosha: true,
      doshaTypeHi: doshaTypeHi,
      doshaTypeGu: doshaTypeGu,
      descriptionHi: descHi,
      descriptionGu: descGu,
      remedyHi: 'प्रति मंगलवार सुंदरकांड का पाठ करें, लाल मसूर की दाल दान करें अथवा कुंभ विवाह अनुष्ठान कराएं।',
      remedyGu: 'દર મંગળવારે સુંદરકાંડનો પાઠ કરવો, લાલ મસૂરની દાળનું દાન કરવું અથવા કુંભ વિવાહ વિધિ કરવી.',
    );
  }

  static List<VimshottariDashaItem> _calculateVimshottariDashas(
    int nakshatraIndex,
    double nakshatraFraction,
    DateTime birthDate,
  ) {
    final startLordIdx = nakshatraIndex % 9;
    final firstLordYears = dashaCycle[startLordIdx]['years'] as int;
    final remainingFirstLordYears = firstLordYears * (1.0 - nakshatraFraction);

    final result = <VimshottariDashaItem>[];
    var currentStartDate = birthDate;
    final now = DateTime.now();

    final firstEndDays = (remainingFirstLordYears * 365.25).round();
    final firstEndDate = currentStartDate.add(Duration(days: firstEndDays));
    final firstLordMeta = dashaCycle[startLordIdx];

    // Calculate Antardashas for the 1st Mahadasha (from birth onward or full cycle)
    final firstAntardashas = _calculateAntardashasForMahadasha(
      mahaLordIdx: startLordIdx,
      mahaDurationYears: firstLordYears,
      mahaStartDate: birthDate.subtract(Duration(days: ((firstLordYears * nakshatraFraction) * 365.25).round())),
      now: now,
    );

    result.add(
      VimshottariDashaItem(
        planetNameHi: firstLordMeta['hi'] as String,
        planetNameGu: firstLordMeta['gu'] as String,
        startDate: currentStartDate,
        endDate: firstEndDate,
        durationYears: remainingFirstLordYears.round(),
        isCurrent: now.isAfter(currentStartDate) && now.isBefore(firstEndDate),
        antardashas: firstAntardashas,
      ),
    );

    currentStartDate = firstEndDate;

    for (int i = 1; i < 9; i++) {
      final lordIdx = (startLordIdx + i) % 9;
      final lordMeta = dashaCycle[lordIdx];
      final years = lordMeta['years'] as int;
      final days = (years * 365.25).round();
      final endDate = currentStartDate.add(Duration(days: days));

      final antardashas = _calculateAntardashasForMahadasha(
        mahaLordIdx: lordIdx,
        mahaDurationYears: years,
        mahaStartDate: currentStartDate,
        now: now,
      );

      result.add(
        VimshottariDashaItem(
          planetNameHi: lordMeta['hi'] as String,
          planetNameGu: lordMeta['gu'] as String,
          startDate: currentStartDate,
          endDate: endDate,
          durationYears: years,
          isCurrent: now.isAfter(currentStartDate) && now.isBefore(endDate),
          antardashas: antardashas,
        ),
      );

      currentStartDate = endDate;
    }

    return result;
  }

  static List<VimshottariAntardashaItem> _calculateAntardashasForMahadasha({
    required int mahaLordIdx,
    required int mahaDurationYears,
    required DateTime mahaStartDate,
    required DateTime now,
  }) {
    final list = <VimshottariAntardashaItem>[];
    var aStart = mahaStartDate;
    final mahaLordMeta = dashaCycle[mahaLordIdx];
    final mahaGu = mahaLordMeta['gu'] as String;
    final mahaHi = mahaLordMeta['hi'] as String;

    for (int j = 0; j < 9; j++) {
      final antarLordIdx = (mahaLordIdx + j) % 9;
      final antarMeta = dashaCycle[antarLordIdx];
      final antarYears = antarMeta['years'] as int;
      final antarGu = antarMeta['gu'] as String;
      final antarHi = antarMeta['hi'] as String;

      // Antardasha duration = (MahaYears * AntarYears / 120) * 365.25 days
      final antarDays = ((mahaDurationYears * antarYears / 120.0) * 365.25).round();
      final aEnd = aStart.add(Duration(days: antarDays));

      final fal = getAntardashaFal(mahaGu, antarGu);

      list.add(
        VimshottariAntardashaItem(
          planetNameHi: '$mahaHi - $antarHi',
          planetNameGu: '$mahaGu - $antarGu',
          startDate: aStart,
          endDate: aEnd,
          isCurrent: (now.isAfter(aStart) || now.isAtSameMomentAs(aStart)) && (now.isBefore(aEnd) || now.isAtSameMomentAs(aEnd)),
          antardashaFalHi: fal['hi']!,
          antardashaFalGu: fal['gu']!,
        ),
      );

      aStart = aEnd;
    }

    return list;
  }

  /// Calculates the 9 Antardashas on-demand for any Mahadasha item
  static List<VimshottariAntardashaItem> getAntardashasForDasha(
    String planetNameGuOrHi,
    DateTime startDate,
    DateTime endDate, {
    DateTime? now,
  }) {
    final curNow = now ?? DateTime.now();
    int mahaLordIdx = 0;
    for (int i = 0; i < dashaCycle.length; i++) {
      final gu = dashaCycle[i]['gu'] as String;
      final hi = dashaCycle[i]['hi'] as String;
      if (planetNameGuOrHi.contains(gu) || planetNameGuOrHi.contains(hi)) {
        mahaLordIdx = i;
        break;
      }
    }

    final durationYears = (dashaCycle[mahaLordIdx]['years'] as int);
    return _calculateAntardashasForMahadasha(
      mahaLordIdx: mahaLordIdx,
      mahaDurationYears: durationYears,
      mahaStartDate: startDate,
      now: curNow,
    );
  }

  static List<BhavaInterpretation> _generateBhavaInterpretations(int lagnaRashiId, List<PlanetPosition> planets) {
    const titlesHi = [
      'प्रथम भाव - लग्न (तनु भाव)',
      'द्वितीय भाव - धन एवं कुटुंब (धन भाव)',
      'तृतीय भाव - पराक्रम एवं भ्राता (सहज भाव)',
      'चतुर्थ भाव - सुख, माता एवं वाहन (सुख भाव)',
      'पंचम भाव - बुद्धि, विद्या एवं संतान (पुत्र भाव)',
      'षष्ठ भाव - शत्रु, रोग एवं ऋण (रिपु भाव)',
      'सप्तम भाव - विवाह एवं जीवनसाथी (जाया भाव)',
      'अष्टम भाव - आयु एवं गूढ़ ज्ञान (आयु भाव)',
      'नवम भाव - भाग्य, धर्म एवं पिता (धर्म भाव)',
      'दशम भाव - कर्म, व्यवसाय एवं यश (कर्म भाव)',
      'एकादश भाव - आय एवं लाभ (लाभ भाव)',
      'द्वादश भाव - व्यय एवं मोक्ष (व्यय भाव)',
    ];

    const titlesGu = [
      'પ્રથમ ભાવ - તનુ ભાવ (લગ્ન)',
      'દ્વિતીય ભાવ - ધન અને કુટુંબ ભાવ',
      'તૃતીય ભાવ - પરાક્રમ અને ભાઈ-બહેન ભાવ',
      'ચતુર્થ ભાવ - સુખ, માતા અને વાહન ભાવ',
      'પંચમ ભાવ - બુદ્ધિ, વિદ્યા અને સંતાન ભાવ',
      'ષષ્ઠ ભાવ - શત્રુ, રોગ અને સ્પર્ધા ભાવ',
      'સપ્તમ ભાવ - કલત્ર, વિવાહ અને ભાગીદારી ભાવ',
      'અષ્ટમ ભાવ - આયુષ્ય અને ગૂઢ રહસ્ય ભાવ',
      'નવમ ભાવ - ભાગ્ય, ધર્મ અને તીર્થ ભાવ',
      'દશમ ભાવ - કર્મ, પદવી અને કારકિર્દી ભાવ',
      'એકાદશ ભાવ - લાભ, આવક અને મિત્ર ભાવ',
      'દ્વાદશ ભાવ - વ્યય અને મોક્ષ ભાવ',
    ];

    const descHi = [
      'व्यक्तित्व, स्वास्थ्य, आत्मसम्मान एवं जीवन शक्ति का प्रतिनिधित्व करता है।',
      'संचित धन, पारिवारिक सुख, वाणी और संस्कारों का अवलोकन कराता है।',
      'साहस, पराक्रम, छोटे भाई-बहन और संचार कौशल की स्थिति बताता है।',
      'माता का स्नेह, गृह सुख, वाहन, भूमि एवं मानसिक शांति का केंद्र है।',
      'बुद्धि, उच्च शिक्षा, रचनात्मकता, पूर्व पुण्य और संतान सुख का भाव है।',
      'शत्रु दमन, स्वास्थ्य सुरक्षा, सेवा भाव और संघर्ष विजय का सूचक है।',
      'विवाह, जीवनसाथी, साझेदारी और सामाजिक संबंधों का परिचायक है।',
      'दीर्घायु, अनुसंधान, आकस्मिक लाभ और आध्यात्मिक अन्वेषण का भाव है।',
      'ईश्वर कृपा, उच्च ज्ञान, तीर्थाटन और भाग्य उन्नति का द्वार है।',
      'आजीविका, कर्मक्षेत्र, नेतृत्व, यश और सामाजिक प्रतिष्ठा का आधार है।',
      'इच्छा पूर्ति, आर्थिक लाभ, बड़े मित्रगण और आकांक्षाओं का भाव है।',
      'विदेश यात्रा, दान-धर्म, आत्मिक शांति और मोक्ष प्राप्ति का साधन है।',
    ];

    const descGu = [
      'વ્યક્તિત્વ, શારીરિક સ્વાસ્થ્ય, આત્મવિશ્વાસ અને જીવનશક્તિ દર્શાવે છે.',
      'સંચિત સંપત્તિ, વાણી, કૌટુંબિક સુખ અને સંસ્કારોનું પ્રતીક છે.',
      'સાહસ, આંતરિક પરાક્રમ, નાના ભાઈ-બહેન અને કૌશલ્યનો સૂચક છે.',
      'માતૃસુખ, જમીન-મકાન, વાહન, ભૌતિક સુખ-સગવડ અને માનસિક શાંતિ આપે છે.',
      'બુદ્ધિપ્રતિભા, ઉચ્ચ શિક્ષણ, પૂર્વ જન્મના પુણ્ય અને સંતાન સુખ દર્શાવે છે.',
      'રોગ-મુક્તિ, શત્રુવિજય, કર્મનિષ્ઠા અને પડકારો સામે જીતનો ભાવ છે.',
      'જીવનસાથી, સુખી લગ્નજીવન, વ્યવસાયિક ભાગીદારી અને સામાજિક પ્રતિષ્ઠા છે.',
      'આયુષ્ય, ગૂઢ વિદ્યાઓ, આધ્યાત્મિક સાધના અને આકસ્મિક ધનલાભનો ભાવ છે.',
      'ભાગ્યવૃદ્ધિ, ધાર્મિક આસ્થા, ગુરુકૃપા અને તીર્થયાત્રાઓનો આશીર્વાદ આપે છે.',
      'કારકિર્દી, વેપાર-નોકરી, નેતૃત્વ, માન-સન્માન અને પદવીની ઊંચાઈ નક્કી કરે છે.',
      'આર્થિક નફો, મહત્વાકાંક્ષાઓની પૂર્તિ અને જીવનમાં મહત્તમ લાભ દર્શાવે છે.',
      'પરદેશ ગમન, દાન-પુણ્ય, આધ્યાત્મિક મુક્તિ અને મોક્ષની યાત્રા સૂચવે છે.',
    ];

    final result = <BhavaInterpretation>[];

    for (int h = 1; h <= 12; h++) {
      final signId = (lagnaRashiId + h - 2) % 12 + 1;
      final housePlanets = planets.where((p) => p.houseNumber == h).map((p) => p.nameHi).toList();

      result.add(
        BhavaInterpretation(
          houseNumber: h,
          titleHi: titlesHi[h - 1],
          titleGu: titlesGu[h - 1],
          descriptionHi: descHi[h - 1],
          descriptionGu: descGu[h - 1],
          signId: signId,
          planetsPresent: housePlanets,
        ),
      );
    }

    return result;
  }

  static KundaliLifePrediction generateLifePredictions({
    required int lagnaRashiId,
    required int moonRashiId,
    required int sunRashiId,
    required int nakshatraIndex,
    required int charan,
    required List<PlanetPosition> planets,
    required List<VimshottariDashaItem> dashas,
    required DateTime birthDate,
  }) {
    // 1. Physical Appearance (શારીરિક સ્વરૂપ અને દેખાવ / शारीरिक रूप-रंग)
    final appearanceData = _getAppearanceData(lagnaRashiId);

    // 2. Swabhav & Behaviour (સ્વભાવ અને વ્યક્તિત્વ / स्वभाव एवं व्यवहार)
    final swabhavData = _getSwabhavData(moonRashiId, nakshatraIndex);

    // 3. Marriage Timing & Spouse (વિવાહ સમય, જીવનસાથી અને દાંપત્ય / विवाह एवं दांपत्य योग)
    final marriageData = _getMarriagePrediction(lagnaRashiId, planets, birthDate);

    // 4. Career, Bhagyodaya & Wealth (ભાગ્યોદય યોગ, કારકિર્દી અને ધન સંપત્તિ / भाग्योदय एवं करियर योग)
    final careerData = _getCareerBhagyodaya(lagnaRashiId, moonRashiId, planets, birthDate);

    // 5. Health & Precautions (આરોગ્ય અને સાવચેતી / स्वास्थ्य एवं सावधानियां)
    final healthData = _getHealthPrediction(lagnaRashiId);

    // 6. Astrological Yogas & Special Auspicious / Inauspicious Combinations (વિશેષ રાજયોગ અને દોષ)
    final rajaYogas = _detectRajaYogas(lagnaRashiId, moonRashiId, planets);

    // 7. Ishta Devata & Sacred Mantras
    final spiritualData = _getSpiritualRemedies(lagnaRashiId, moonRashiId);

    return KundaliLifePrediction(
      physicalAppearance: appearanceData,
      personalitySwabhav: swabhavData,
      marriagePrediction: marriageData,
      careerBhagyodaya: careerData,
      healthPrediction: healthData,
      rajaYogasHi: rajaYogas['hi'] as List<String>,
      rajaYogasGu: rajaYogas['gu'] as List<String>,
      yogas: rajaYogas['items'] as List<AstrologicalYogaItem>,
      luckyDirection: spiritualData['direction']!,
      ishtaDevataHi: spiritualData['ishtaHi']!,
      ishtaDevataGu: spiritualData['ishtaGu']!,
      sacredMantraHi: spiritualData['mantraHi']!,
      sacredMantraGu: spiritualData['mantraGu']!,
    );
  }

  static DoshaAnalysisResult calculateDoshaAnalysis({
    required List<PlanetPosition> planets,
    required int moonRashiId,
    required int lagnaRashiId,
  }) {
    // 1. Authentic Vedic Kaal Sarp Calculation
    PlanetPosition? rahu;
    PlanetPosition? ketu;
    for (final p in planets) {
      if (p.id == 8) rahu = p;
      if (p.id == 9) ketu = p;
    }

    final physicalPlanets = planets.where((p) => p.id >= 1 && p.id <= 7).toList();
    bool hasKaalSarp = false;
    String kaalSarpNameGu = 'કાળસર્પ દોષ મુક્ત (શુભ ગ્રહ સ્થિતિ)';
    String kaalSarpNameHi = 'कालसर्प दोष मुक्त (शुभ ग्रह स्थिति)';
    String kaalSarpDescGu = 'રાહુ-કેતુ અક્ષની બંને બાજુ ગ્રહો વિસ્તરેલા હોવાથી તમારી કુંડળી કાળસર્પ દોષથી મુક્ત છે. આર્થિક ઉતાર-ચઢાવથી બચવા અને સદા ઉન્નતિ માટે શિવ આરાધના શ્રેષ્ઠ છે.';
    String kaalSarpDescHi = 'राहु-केतु अक्ष के दोनों ओर ग्रह स्थित होने से आपकी कुंडली कालसर्प दोष से मुक्त है। नित्य शिव आराधना से जीवन में निरंतर प्रगति होगी।';

    if (rahu != null && ketu != null && physicalPlanets.isNotEmpty) {
      final rHouse = rahu.houseNumber;
      final kHouse = ketu.houseNumber;

      // Count planets on Semicircle 1 (Rahu to Ketu clockwise, inclusive of conjunctions)
      int side1Count = 0;
      int side2Count = 0;
      for (final p in physicalPlanets) {
        final pHouse = p.houseNumber;
        final diffFromRahu = (pHouse - rHouse + 12) % 12;
        if (diffFromRahu <= 6) {
          side1Count++;
        } else {
          side2Count++;
        }
      }

      const kaalSarpNamesGu = [
        'અનંત કાળસર્પ યોગ',
        'કુલિક કાળસર્પ યોગ',
        'વાસુકી કાળસર્પ યોગ',
        'શંખપાલ કાળસર્પ યોગ',
        'પદ્મ કાળસર્પ યોગ',
        'મહાપદ્મ કાળસર્પ યોગ',
        'તક્ષક કાળસર્પ યોગ',
        'કર્કોટક કાળસર્પ યોગ',
        'શંખચૂડ કાળસર્પ યોગ',
        'ઘાટક કાળસર્પ યોગ',
        'વિષધર કાળસર્પ યોગ',
        'શેષનાગ કાળસર્પ યોગ',
      ];
      const kaalSarpNamesHi = [
        'अनन्त कालसर्प योग',
        'कुलिक कालसर्प योग',
        'वासुकी कालसर्प योग',
        'शंखपाल कालसर्प योग',
        'पद्म कालसर्प योग',
        'महापद्म कालसर्प योग',
        'तक्षक कालसर्प योग',
        'कर्कोटक कालसर्प योग',
        'शंखचूड़ कालसर्प योग',
        'घातक कालसर्प योग',
        'विषधर कालसर्प योग',
        'शेषनाग कालसर्प योग',
      ];

      final idx = (rHouse - 1).clamp(0, 11);
      final rawNameGu = kaalSarpNamesGu[idx];
      final rawNameHi = kaalSarpNamesHi[idx];

      if (side1Count == physicalPlanets.length || side2Count == physicalPlanets.length) {
        // All 7 planets hemmed between Rahu-Ketu axis
        hasKaalSarp = true;
        kaalSarpNameGu = '$rawNameGu (પૂર્ણ સક્રિય)';
        kaalSarpNameHi = '$rawNameHi (पूर्ण सक्रिय)';
        kaalSarpDescGu = 'તમારી કુંડળીમાં રાહુ $rHouse મા ભાવમાં અને કેતુ $kHouse મા ભાવમાં હોવાથી $rawNameGu પૂર્ણપણે સક્રિય છે. તમામ ગ્રહો રાહુ-કેતુ અક્ષની અંદર સ્થિત હોવાથી જીવનમાં સંઘર્ષ પછી અસાધારણ સફળતા અને રાજયોગ પ્રાપ્ત થાય છે. શિવલિંગ પર જળાભિષેક અને મહામૃત્યુંજય જાપ કરવાથી આ દોષ ઉત્તમ પ્રગતિમાં પરિણમે છે.';
        kaalSarpDescHi = 'आपकी कुंडली में राहु $rHouse वें एवं केतु $kHouse वें भाव में होने से $rawNameHi पूर्ण रूप से सक्रिय है। समस्त ग्रह राहु-केतु अक्ष के अंतर्गत स्थित हैं। नित्य शिव आराधना एवं महामृत्युंजय जप से यह योग कल्याणकारी राजयोग में परिवर्तित होता है।';
      } else if (side1Count >= physicalPlanets.length - 1 || side2Count >= physicalPlanets.length - 1) {
        // 6 planets on one side, 1 planet outside -> Anshik Kaal Sarp
        hasKaalSarp = true;
        kaalSarpNameGu = 'આંશિક $rawNameGu (અર્ધ કાળસર્પ)';
        kaalSarpNameHi = 'आंशिक $rawNameHi (अर्ध कालसर्प)';
        kaalSarpDescGu = 'તમારી કુંડળીમાં રાહુ $rHouse મા ભાવમાં હોવાથી આંશિક $rawNameGu સક્રિય છે. એક ગ્રહ અક્ષથી બહાર હોવાથી દોષનો પ્રભાવ ઘણો ઓછો છે અને શિવ ઉપાસનાથી શુભ રાજયોગમાં પરિણમે છે.';
        kaalSarpDescHi = 'आपकी कुंडली में आंशिक $rawNameHi उपस्थित है। एक ग्रह अक्ष से बाहर होने से प्रभाव अल्प है और नित्य शिव पूजन से शुभ फल मिलते हैं।';
      }
    }

    // 2. Real-Time Dynamic Shani Sade Sati & Dhayya (Current Transit in Pisces 2025–2028)
    String shaniStatusGu;
    String shaniStatusHi;
    String shaniDescGu;
    String shaniDescHi;

    if (moonRashiId == 12) {
      // Meena (Pisces) - Saturn transiting directly over Moon
      shaniStatusGu = 'શનિ સાડાસાતીનું દ્વિતીય ચરણ (શિખર કાળ / મધ્ય ચરણ)';
      shaniStatusHi = 'शनि साढ़ेसाती का द्वितीय चरण (शिखर काल / मध्य चरण)';
      shaniDescGu = 'હાલમાં શનિદેવ તમારી જ જન્મ રાશિ (મીન) માં ગોચર કરી રહ્યા હોવાથી સાડાસાતીનું મુખ્ય દ્વિતીય ચરણ (શિખર કાળ) ચાલી રહ્યું છે. આ સમય પરિશ્રમ, આત્મનિરીક્ષણ અને કર્મ શુદ્ધિનો છે. નિયમિત હનુમાન ચાલીસા, શનિ મંત્ર અને શિવ આરાધના કરવાથી સર્વ કાર્યો નિર્વિઘ્ને સિદ્ધ થશે.';
      shaniDescHi = 'वर्तमान में शनिदेव आपकी ही जन्म राशि (मीन) में गोचर कर रहे हैं, अतः साढ़ेसाती का मुख्य द्वितीय चरण (शिखर काल) चल रहा है। कठोर परिश्रम, सत्यवादिता एवं नित्य हनुमान चालीसा / शिव पूजा से उत्तम प्रगति होगी।';
    } else if (moonRashiId == 11) {
      // Kumbha (Aquarius) - Saturn in 2nd from Moon
      shaniStatusGu = 'શનિ સાડાસાતીનું તૃતીય ચરણ (ઉતરતી સાડાસાતી / અસ્ત કાળ)';
      shaniStatusHi = 'शनि साढ़ेसाती का तृतीय चरण (उतरती साढ़ेसाती / अस्त काल)';
      shaniDescGu = 'હાલમાં તમારી રાશિથી ૨જા ભાવમાં શનિ હોવાથી સાડાસાતીનો અંતિમ તબક્કો છે. ભૂતકાળના સંઘર્ષોનો અંત આવશે અને નાણાકીય તેમજ પારિવારિક સ્થિરતા પ્રાપ્ત થશે.';
      shaniDescHi = 'आपकी राशि से द्वितीय भाव में शनि होने से साढ़ेसाती का अंतिम चरण है। संघर्षों का अंत होगा तथा आर्थिक व पारिवारिक स्थिरता मिलेगी।';
    } else if (moonRashiId == 1) {
      // Mesha (Aries) - Saturn in 12th from Moon
      shaniStatusGu = 'શનિ સાડાસાતીનું પ્રથમ ચરણ (ચડતી સાડાસાતી / ઉદય કાળ)';
      shaniStatusHi = 'शनि साढ़ेसाती का प्रथम चरण (चढ़ती साढ़ेसाती / उदय काल)';
      shaniDescGu = 'હાલમાં તમારી રાશિથી ૧૨મા ભાવમાં શનિ ભ્રમણ કરી રહ્યા હોવાથી સાડાસાતીનો પ્રથમ ચરણ સક્રિય છે. ખર્ચ પર સંયમ અને નવી યોજનાઓમાં ધીરજ રાખવી હિતકારી છે.';
      shaniDescHi = 'वर्तमान में शनि आपकी राशि से १२वें भाव में गोचरस्थ होने से साढ़ेसाती का प्रथम चरण चल रहा है। व्यय पर नियंत्रण एवं धैर्य रखें।';
    } else if (moonRashiId == 5) {
      // Simha (Leo) - Saturn in 8th from Moon
      shaniStatusGu = 'શનિની અષ્ટમ ઢૈય્યા (કંટક શનિ)';
      shaniStatusHi = 'शनि की अष्टम ढैया (कंटक शनि)';
      shaniDescGu = 'હાલમાં તમારી રાશિથી ૮મા ભાવમાં શનિનું ગોચર હોવાથી અષ્ટમ ઢૈય્યા ચાલી રહી છે. આરોગ્ય અને વાહન ચલાવવામાં સાવચેતી રાખવી.';
      shaniDescHi = 'आपकी राशि से ८वें भाव में शनि गोचर से अष्टम ढैया सक्रिय है। स्वास्थ्य एवं यात्रा में सावधानी बरतें।';
    } else if (moonRashiId == 9) {
      // Dhanu (Sagittarius) - Saturn in 4th from Moon
      shaniStatusGu = 'શનિની ચતુર્થ ઢૈય્યા (અર્ધ-કંટક શનિ)';
      shaniStatusHi = 'शनि की चतुर्थ ढैया (अर्ध-कंटक शनि)';
      shaniDescGu = 'હાલમાં તમારી રાશિથી ૪થા ભાવમાં શનિનું ગોચર હોવાથી ચતુર્થ ઢૈય્યા સક્રિય છે. માતાના સ્વાસ્થ્યની કાળજી લેવી અને શાંતિ જાળવવી.';
      shaniDescHi = 'आपकी राशि से ४थे भाव में शनि गोचर से चतुर्थ ढैया सक्रिय है। मानसिक शांति बनाए रखें।';
    } else if (moonRashiId == 10) {
      // Makara (Capricorn) - Saturn left Capricorn in early 2025
      shaniStatusGu = 'સાડાસાતી સંપૂર્ણ સમાપ્ત / મુક્ત (સુવર્ણ કાળ)';
      shaniStatusHi = 'साढ़ेसाती पूर्णतः समाप्त / मुक्त (स्वर्ण काल)';
      shaniDescGu = 'મકર રાશિ પરથી સાડાસાતી સંપૂર્ણપણે સમાપ્ત થઈ ગઈ છે. હવે પરિશ્રમનું શ્રેષ્ઠ ફળ અને ભાગ્યોદયનો સુવર્ણ કાળ શરૂ થયો છે.';
      shaniDescHi = 'मकर राशि से साढ़ेसाती पूर्णतः समाप्त हो चुकी है। अब जीवन में स्थिरता एवं भाग्योदय का समय है।';
    } else {
      shaniStatusGu = 'સાડાસાતી તેમજ ઢૈય્યાથી સંપૂર્ણ મુક્ત (અનુકૂળ સમય)';
      shaniStatusHi = 'साढ़ेसाती एवं ढैया से पूर्णतः मुक्त (अनुकूल समय)';
      shaniDescGu = 'હાલમાં તમારી ચંદ્ર રાશિ પર સાડાસાતી કે ઢૈય્યાનો કોઈ પ્રભાવ નથી. શનિદેવનું ગોચર અત્યંત શુભ અને લાભદાયી છે.';
      shaniDescHi = 'वर्तमान में आपकी राशि पर साढ़ेसाती या ढैया का कोई अशुभ प्रभाव नहीं है। गोचर अत्यंत अनुकूल है।';
    }

    // 3. Dynamic Vedic Mantra, Upay, Rudraksha, Powerful & Wearing Gemstones
    String mantraGu;
    String mantraHi;
    String upayGu;
    String upayHi;
    String rudrakshaGu;
    String rudrakshaHi;
    String gemstoneGu;
    String gemstoneHi;
    String powerfulGemstoneGu;
    String powerfulGemstoneHi;
    String avoidGemstoneGu;
    String avoidGemstoneHi;

    switch (lagnaRashiId) {
      case 1: // Aries (મેષ લગ્ન)
        mantraGu = '• મંત્ર: "ૐ હં હનુમતે નમઃ" અથવા "ૐ ક્રાં ક્રીં ક્રૌં સઃ ભૌમાય નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ हं हनुमते नमः" अथवा "ॐ क्रां क्रीं क्रौं सः भौमाय नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: મંગળવારે હનુમાન ચાલીસાનો પાઠ કરવો અને લાલ ચંદનનું તિલક લગાવવું.';
        upayHi = '• उपाय: मंगलवार को हनुमान चालीसा का पाठ करें एवं लाल चंदन का तिलक लगाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૩ મુખી રુદ્રાક્ષ ધારણ કરવો અત્યંત શુભ અને ઉર્જાવાન રહેશે.';
        rudrakshaHi = '• रुद्राक्ष: ३ मुखी रुद्राक्ष धारण करना अत्यंत शुभ एवं ऊर्जावान रहेगा।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: મંગળ ગ્રહ રત્ન પરવાળું (Red Coral) - અનામિકા આંગળીમાં સોના કે તાંબામાં મંગળવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: मंगल ग्रह रत्न मूंगा (Red Coral) - अनामिका अंगुली में सोने अथवा तांबे में मंगलवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: સૂર્યનું માણેક (Ruby - પંચમેશ) & ગુરુનું પોખરાજ (Yellow Sapphire - ભાગ્યેશ) સર્વોત્તમ ભાગ્યવર્ધક છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: सूर्य का माणिक्य (पंचमेश) एवं गुरु का पुखराज (भाग्येश) सर्वोत्तम भाग्योदयकारक है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શુક્રનો હીરો અને શનિનું નીલમ ક્યારેય ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शुक्र का हीरा एवं शनि का नीलम कदापि धारण न करें।';
        break;
      case 2: // Taurus (વૃષભ લગ્ન)
        mantraGu = '• મંત્ર: "ૐ શુક્રાય નમઃ" અથવા "ૐ શ્રીં મહાલક્ષ્મ્યૈ નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ शुक्राय नमः" अथवा "ॐ श्रीं महालक्ष्म्यै नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: શુક્રવારે ગાયને લીલું ઘાસ કે રોટલી ખવડાવવી અને સફેદ પુષ્પોથી પૂજા કરવી.';
        upayHi = '• उपाय: शुक्रवार को गाय को हरी घास या रोटी खिलाएं तथा श्वेत पुष्प अर्पित करें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૬ મુખી રુદ્રાક્ષ ધારણ કરવાથી સૌંદર્ય, સંપત્તિ અને આકર્ષણમાં વૃદ્ધિ થશે.';
        rudrakshaHi = '• रुद्राक्ष: ६ मुखी रुद्राक्ष धारण करने से सौंदर्य, समृद्धि एवं आकर्षण में वृद्धि होगी।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: શુક્ર ગ્રહ રત્ન હીરો અથવા ઓપલ (Diamond/Opal) - અનામિકા આંગળીમાં ચાંદી કે પ્લેટિનમમાં શુક્રવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: शुक्र ग्रह रत्न हीरा अथवा ओपल (Diamond/Opal) - अनामिका अंगुली में चांदी में शुक्रवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શનિનું નીલમ (Blue Sapphire - યોગકારક 9th & 10th Lord) & બુધનું પન્ના (Emerald) સર્વશ્રેષ્ઠ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शनि का नीलम (योगकारक) एवं बुध का पन्ना अत्यंत शुभ है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: ગુરુનું પોખરાજ અને સૂર્યનું માણેક ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: गुरु का पुखराज एवं सूर्य का माणिक्य धारण न करें।';
        break;
      case 3: // Gemini (મિથુન લગ્ન)
        mantraGu = '• મંત્ર: "ૐ બું બુધાય નમઃ" અથવા "ૐ નમો નારાયણાય" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ बुं बुधाय नमः" अथवा "ॐ नमो नारायणाय" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: બુધવારે પક્ષીઓને ચણ નાખવું અને તુલસી ક્યારે જળ અર્પણ કરી દીવો પ્રગટાવવો.';
        upayHi = '• उपाय: बुधवार को पक्षियों को दाना डालें एवं तुलसी जी में जल अर्पित कर दीपक जलाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૪ મુખી રુદ્રાક્ષ ધારણ કરવાથી બુદ્ધિપ્રતિભા અને વ્યવસાયમાં તેજી આવશે.';
        rudrakshaHi = '• रुद्राक्ष: ४ मुखी रुद्राक्ष धारण करने से कुशाग्र बुद्धि एवं व्यापार में उन्नति होगी।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: બુધ ગ્રહ રત્ન પન્ના (Emerald) - ટચલી આંગળી (કનિષ્ઠિકા) માં સોના કે ચાંદીમાં બુધવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: बुध ग्रह रत्न पन्ना (Emerald) - कनिष्ठिका अंगुली में सोने अथवा चांदी में बुधवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શુક્રનો હીરો (Diamond - પંચમેશ) & શનિનું નીલમ (Blue Sapphire - ભાગ્યેશ) ભાગ્યોદય માટે પાવરફુલ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शुक्र का हीरा एवं शनि का नीलम भाग्योदय हेतु शक्तिशाली है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: મંગળનું પરવાળું અને ગુરુનું પોખરાજ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: मंगल का मूंगा एवं गुरु का पुखराज धारण न करें।';
        break;
      case 4: // Cancer (કર્ક લગ્ન)
        mantraGu = '• મંત્ર: "ૐ નમઃ શિવાય" અથવા "ૐ સોં સોમાય નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ नमः शिवाय" अथवा "ॐ सों सोमाय नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: સોમવારે શિવલિંગ પર કાચું દૂધ અને જળ અર્પણ કરવું તેમજ માતાના આશીર્વાદ લેવા.';
        upayHi = '• उपाय: सोमवार को शिवलिंग पर कच्चा दूध एवं जल अर्पित करें तथा माता का आशीर्वाद लें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૨ મુખી રુદ્રાક્ષ ધારણ કરવાથી માનસિક શાંતિ અને પારિવારિક પ્રેમ વધશે.';
        rudrakshaHi = '• रुद्राक्ष: २ मुखी रुद्राक्ष धारण करने से मानसिक शांति एवं पारिवारिक सामंजस्य बढ़ेगा।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: ચંદ્ર ગ્રહ રત્ન મોતી (Pearl) - ટચલી આંગળી (કનિષ્ઠિકા) માં ચાંદીમાં સોમવારે સવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: चन्द्र ग्रह रत्न मोती (Pearl) - कनिष्ठिका अंगुली में चांदी में सोमवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: ગુરુ ગ્રહનું રત્ન પોખરાજ (Yellow Sapphire - ભાગ્યેશ 9th Lord) & મંગળનું પરવાળું (Red Coral - યોગકારક 5th & 10th Lord) જીવનમાં અખંડ રાજયોગ, યશ અને ધનવૃદ્ધિ આપે છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: गुरु ग्रह का पुखराज (भाग्येश - Yellow Sapphire) एवं मंगल का मूंगा (योगकारक - Red Coral) अखंड राजयोग व धनवृद्धि प्रदान करता है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શનિનું નીલમ (Blue Sapphire) અને શુક્રનો હીરો (Diamond) ક્યારેય ધારણ ન કરવો.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शनि का नीलम एवं शुक्र का हीरा कदापि धारण न करें।';
        break;
      case 5: // Leo (સિંહ લગ્ન)
        mantraGu = '• મંત્ર: "ૐ ઘૃણિઃ સૂર્યાય નમઃ" અથવા ગાયત્રી મંત્ર (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ घृणिः सूर्याय नमः" अथवा गायत्री मन्त्र (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: દરરોજ સવારે તાંબાના લોટાથી સૂર્યદેવને જળનો અર્ઘ્ય આપવો અને પિતાનું સન્માન કરવું.';
        upayHi = '• उपाय: प्रतिदिन तांबे के लोटे से सूर्यदेव को अर्घ्य दें एवं पिता का सम्मान करें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૧ મુખી અથવા ૧૨ મુખી રુદ્રાક્ષ ધારણ કરવાથી યશ, કીર્તિ અને આત્મવિશ્વાસ વધશે.';
        rudrakshaHi = '• रुद्राक्ष: १ मुखी अथवा १२ मुखी रुद्राक्ष धारण करने से यश, कीर्ति एवं आत्मविश्वास बढ़ेगा।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: સૂર્ય ગ્રહ રત્ન માણેક (Ruby) - અનામિકા આંગળીમાં સોના કે તાંબામાં રવિવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: सूर्य ग्रह रत्न माणिक्य (Ruby) - अनामिका अंगुली में सोने अथवा तांबे में रविवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: મંગળનું પરવાળું (Red Coral - યોગકારક 4th & 9th Lord) & ગુરુનું પોખરાજ (Yellow Sapphire - પંચમેશ) અદ્ભુત પાવરફુલ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: मंगल का मूंगा (योगकारक) एवं गुरु का पुखराज अत्यंत कल्याणकारी है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શનિનું નીલમ અને શુક્રનો હીરો ક્યારેય ધારણ ન કરવો.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शनि का नीलम एवं शुक्र का हीरा कदापि धारण न करें।';
        break;
      case 6: // Virgo (કન્યા લગ્ન)
        mantraGu = '• મંત્ર: "ૐ બું બુધાય નમઃ" અથવા "ૐ નમો નારાયણાય" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ बुं बुधाय नमः" अथवा "ॐ नमो नारायणाय" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: બુધવારે લીલી મગની દાળ પલાળી ગાયને ખવડાવવી.';
        upayHi = '• उपाय: बुधवार को हरी मूंग गाय को खिलाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૪ મુખી રુદ્રાક્ષ ધારણ કરવો શુભ રહેશે.';
        rudrakshaHi = '• रुद्राक्ष: ४ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: બુધ ગ્રહ રત્ન પન્ના (Emerald) - ટચલી આંગળીમાં સોના કે ચાંદીમાં બુધવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: बुध ग्रह रत्न पन्ना (Emerald) - कनिष्ठिका अंगुली में सोने/चांदी में बुधवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શુક્રનો હીરો (Diamond - ભાગ્યેશ 9th Lord) & શનિનું નીલમ (Blue Sapphire - પંચમેશ) સર્વોચ્ચ ઉન્નતિ આપે છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शुक्र का हीरा (भाग्येश) एवं शनि का नीलम (पंचमेश) सर्वोच्च उन्नति देता है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: મંગળનું પરવાળું અને ગુરુનું પોખરાજ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: मंगल का मूंगा एवं गुरु का पुखराज धारण न करें।';
        break;
      case 7: // Libra (તુલા લગ્ન)
        mantraGu = '• મંત્ર: "ૐ શ્રીં મહાલક્ષ્મ્યૈ નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ श्रीं महालक्ष्म्यै नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: શુક્રવારે કન્યાઓને ખીર ખવડાવવી.';
        upayHi = '• उपाय: शुक्रवार को कन्याओं को खीर खिलाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૬ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ६ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: શુક્ર ગ્રહ રત્ન હીરો અથવા ઓપલ (Diamond/Opal) - અનામિકા આંગળીમાં ચાંદીમાં શુક્રવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: शुक्र ग्रह रत्न हीरा अथवा ओपल (Diamond/Opal) - अनामिका अंगुली में शुक्रवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શનિનું નીલમ (Blue Sapphire - યોગકારક 4th & 5th Lord) & બુધનું પન્ના (ભાગ્યેશ) મહાભાગ્યશાળી છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शनि का नीलम (योगकारक) एवं बुध का पन्ना (भाग्येश) अत्यंत शुभ है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: સૂર્યનું માણેક અને ગુરુનું પોખરાજ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: सूर्य का माणिक्य एवं गुरु का पुखराज धारण न करें।';
        break;
      case 8: // Scorpio (વૃશ્ચિક લગ્ન)
        mantraGu = '• મંત્ર: "ૐ હં હનુમતે નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ हं हनुमते नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: મંગળવારે હનુમાનજીને સિંદૂર અર્પણ કરવું.';
        upayHi = '• उपाय: मंगलवार को हनुमान जी को सिंदूर अर्पित करें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૩ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ३ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: મંગળ ગ્રહ રત્ન પરવાળું (Red Coral) - અનામિકા આંગળીમાં સોના કે તાંબામાં મંગળવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: मंगल ग्रह रत्न मूंगा (Red Coral) - अनामिका अंगुली में मंगलवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: ગુરુનું પોખરાજ (Yellow Sapphire - પંચમેશ) & ચંદ્રનું મોતી (Pearl - ભાગ્યેશ 9th Lord) સર્વશ્રેષ્ઠ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: गुरु का पुखराज (पंचमेश) एवं चन्द्र का मोती (भाग्येश) सर्वोत्तम है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શુક્રનો હીરો અને શનિનું નીલમ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शुक्र का हीरा एवं शनि का नीलम धारण न करें।';
        break;
      case 9: // Sagittarius (ધન લગ્ન)
        mantraGu = '• મંત્ર: "ૐ બૃં બૃહસ્પતયે નમઃ" અથવા "ૐ નમો ભગવતે વાસુદેવાય" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ बृं बृहस्पतये नमः" अथवा "ॐ नमो भगवते वासुदेवाय" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: ગુરુવારે ચણાની દાળનું દાન કરવું અને કેસરનું તિલક કરવું.';
        upayHi = '• उपाय: गुरुवार को चने की दाल का दान करें एवं केसर का तिलक लगाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૫ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ५ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: ગુરુ ગ્રહ રત્ન પોખરાજ (Yellow Sapphire) - તર્જની આંગળીમાં સોના કે પંચધાતુમાં ગુરુવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: गुरु ग्रह रत्न पुखराज (Yellow Sapphire) - तर्जनी अंगुली में गुरुवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: સૂર્યનું માણેક (Ruby - ભાગ્યેશ 9th Lord) & મંગળનું પરવાળું (Red Coral - પંચમેશ) ભાગ્ય ચમકાવે છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: सूर्य का माणिक्य (भाग्येश) एवं मंगल का मूंगा (पंचमेश) भाग्योदय कारक है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શુક્રનો હીરો અને બુધનું પન્ના ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शुक्र का हीरा एवं बुध का पन्ना धारण न करें।';
        break;
      case 10: // Capricorn (મકર લગ્ન)
        mantraGu = '• મંત્ર: "ૐ શં શનૈશ્ચરાય નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ शं शनैश्चराय नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: શનિવારે સરસવના તેલનો દીવો પ્રગટાવવો.';
        upayHi = '• उपाय: शनिवार को सरसों के तेल का दीपक जलाएं।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૭ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ७ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: શનિ ગ્રહ રત્ન નીલમ (Blue Sapphire) - મધ્યમા આંગળીમાં પંચધાતુ કે ચાંદીમાં શનિવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: शनि ग्रह रत्न नीलम (Blue Sapphire) - मध्यमा अंगुली में शनिवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શુક્રનો હીરો (Diamond - યોગકારક 5th & 10th Lord) & બુધનું પન્ના (ભાગ્યેશ 9th Lord) અતિ પાવરફુલ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शुक्र का हीरा (योगकारक) एवं बुध का पन्ना (भाग्येश) अति शक्तिशाली है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: સૂર્યનું માણેક અને મંગળનું પરવાળું ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: सूर्य का माणिक्य एवं मंगल का मूंगा धारण न करें।';
        break;
      case 11: // Aquarius (કુંભ લગ્ન)
        mantraGu = '• મંત્ર: "ૐ શં શનૈશ્ચરાય નમઃ" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ शं शनैश्चराय नमः" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: શનિવારે પીપળાના વૃક્ષની પ્રદક્ષિણા કરવી.';
        upayHi = '• उपाय: शनिवार को पीपल वृक्ष की परिक्रमा करें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૭ મુખી અથવા ૧૪ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ७ मुखी अथवा १४ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: શનિ ગ્રહ રત્ન નીલમ (Blue Sapphire) - મધ્યમા આંગળીમાં પંચધાતુ કે ચાંદીમાં શનિવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: शनि ग्रह रत्न नीलम (Blue Sapphire) - मध्यमा अंगुली में शनिवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: શુક્રનો હીરો (Diamond - યોગકારક 4th & 9th Lord) & બુધનું પન્ના (પંચમેશ) સર્વશ્રેષ્ઠ છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: शुक्र का हीरा (योगकारक) एवं बुध का पन्ना (पंचमेश) सर्वोत्तम है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: સૂર્યનું માણેક અને ગુરુનું પોખરાજ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: सूर्य का माणिक्य एवं गुरु का पुखराज धारण न करें।';
        break;
      case 12: // Pisces (મીન લગ્ન)
      default:
        mantraGu = '• મંત્ર: "ૐ બૃં બૃહસ્પતયે નમઃ" અથવા "ૐ નમો નારાયણાય" (દરરોજ ૧૧ વાર જાપ કરવો)';
        mantraHi = '• मन्त्र: "ॐ बृं बृहस्पतये नमः" अथवा "ॐ नमो नारायणाय" (नित्य ११ बार जप करें)';
        upayGu = '• ઉપાય: ગુરુવારે કેળાંના વૃક્ષનું પૂજન કરવું.';
        upayHi = '• उपाय: गुरुवार को केले के वृक्ष का पूजन करें।';
        rudrakshaGu = '• રુદ્રાક્ષ: ૫ મુખી રુદ્રાક્ષ ધારણ કરવો.';
        rudrakshaHi = '• रुद्राक्ष: ५ मुखी रुद्राक्ष धारण करें।';
        gemstoneGu = '• ધારણ કરવા યોગ્ય રત્ન: ગુરુ ગ્રહ રત્ન પોખરાજ (Yellow Sapphire) - તર્જની આંગળીમાં સોના કે પંચધાતુમાં ગુરુવારે ધારણ કરવું.';
        gemstoneHi = '• धारण योग्य रत्न: गुरु ग्रह रत्न पुखराज (Yellow Sapphire) - तर्जनी अंगुली में गुरुवार को धारण करें।';
        powerfulGemstoneGu = '• સૌથી પાવરફુલ કારક રત્ન: મંગળનું પરવાળું (Red Coral - ભાગ્યેશ 9th Lord) & ચંદ્રનું મોતી (Pearl - પંચમેશ) પરમ કલ્યાણકારી છે.';
        powerfulGemstoneHi = '• सर्वाधिक शक्तिशाली कारक रत्न: मंगल का मूंगा (भाग्येश) एवं चन्द्र का मोती (पंचमेश) परम कल्याणकारी है।';
        avoidGemstoneGu = '• વર્જ્ય/નિષેધ રત્ન: શુક્રનો હીરો અને શનિનું નીલમ ધારણ ન કરવું.';
        avoidGemstoneHi = '• वर्ज्य/निषेध रत्न: शुक्र का हीरा एवं शनि का नीलम धारण न करें।';
        break;
    }

    return DoshaAnalysisResult(
      hasKaalSarp: hasKaalSarp,
      kaalSarpNameGu: kaalSarpNameGu,
      kaalSarpNameHi: kaalSarpNameHi,
      kaalSarpDescGu: kaalSarpDescGu,
      kaalSarpDescHi: kaalSarpDescHi,
      shaniStatusGu: shaniStatusGu,
      shaniStatusHi: shaniStatusHi,
      shaniDescGu: shaniDescGu,
      shaniDescHi: shaniDescHi,
      vedicMantraGu: mantraGu,
      vedicMantraHi: mantraHi,
      upayGu: upayGu,
      upayHi: upayHi,
      rudrakshaGu: rudrakshaGu,
      rudrakshaHi: rudrakshaHi,
      gemstoneGu: gemstoneGu,
      gemstoneHi: gemstoneHi,
      powerfulGemstoneGu: powerfulGemstoneGu,
      powerfulGemstoneHi: powerfulGemstoneHi,
      avoidGemstoneGu: avoidGemstoneGu,
      avoidGemstoneHi: avoidGemstoneHi,
    );
  }

  static LifeAspectPrediction _getAppearanceData(int lagna) {
    const appearances = [
      // 1: Aries
      {
        'hi': 'मध्यम से लंबा कद, आकर्षक तेजस्वी मुखमंडल, तीक्ष्ण आंखें और फुर्तीला सुगठित शरीर। चेहरे पर स्वाभाविक ओज, आत्मविश्वास और युवावस्था का तेज सदैव झलकता है। चाल में तेजी और नेतृत्व की छाप स्पष्ट दिखाई देती है।',
        'gu': 'મધ્યમથી ઊંચું કદ, આકર્ષક તેજસ્વી ચહેરો, તીક્ષ્ણ આંખો અને ચપળ સુગઠિત શરીર. ચહેરા પર આત્મવિશ્વાસનું તેજ અને યુવાવસ્થા જેવી ઉર્જા સદા રહે છે. ચાલમાં ઝડપ અને નેતૃત્વની છાપ સ્પષ્ટ વર્તાય છે.',
        'hlHi': ['तीक्ष्ण एवं ओजस्वी नेत्र', 'सुगठित फुर्तीला शरीर', 'तेजस्वी मुखमंडल', 'आत्मविश्वास से भरी चाल'],
        'hlGu': ['તીક્ષ્ણ અને તેજસ્વી આંખો', 'ચપળ સુગઠિત શરીર', 'તેજસ્વી ચહેરો', 'આત્મવિશ્વાસથી ભરેલી ચાલ'],
      },
      // 2: Taurus
      {
        'hi': 'सुडौल और सुंदर काया, चमकदार सम्मोहक आंखें, मनमोहक मुस्कान और भव्य मुखाकृति। वाणी में सहज मिठास, घने सुंदर बाल और चाल में शालीन गरिमा होती है। सौंदर्य और सुरुचिपूर्ण परिधान इनकी पहचान है।',
        'gu': 'સપ્રમાણ અને સુંદર શરીર, ચમકતી મોહક આંખો, મધુર સ્મિત અને આકર્ષક ગૌરવર્ણ ચહેરો. અવાજમાં મીઠાશ, ઘટ્ટ સુંદર વાળ અને ચાલમાં શાલીનતા રહે છે. સૌંદર્ય અને સુંદર પહેરવેશ તેમની ઓળખ છે.',
        'hlHi': ['मनमोहक मुस्कान', 'घने सुंदर केश', 'मधुर एवं प्रभावशाली वाणी', 'आकर्षक सौम्य व्यक्तित्व'],
        'hlGu': ['મોહક સ્મિત', 'ઘટ્ટ સુંદર વાળ', 'મધુર અને પ્રભાવશાળી વાણી', 'આકર્ષક સૌમ્ય વ્યક્તિત્વ'],
      },
      // 3: Gemini
      {
        'hi': 'लंबा और छरहरा शरीर, अंडाकार उज्ज्वल चेहरा, भावपूर्ण एवं चंचल आंखें। अभिव्यक्ति में हाथों का सुंदर प्रयोग और बातचीत में त्वरित गति होती है। अपनी वास्तविक उम्र से सदैव अधिक युवा दिखाई पड़ते हैं।',
        'gu': 'પાતળું અને ઊંચું શરીર, લંબગોળ તેજસ્વી ચહેરો, બોલકી અને ચંચળ આંખો. વાતચીતમાં હાથની સુંદર મુદ્રાઓ અને ઝડપી પ્રતિભાવ હોય છે. વાસ્તવિક ઉંમર કરતાં હંમેશા વધુ યુવાન દેખાય છે.',
        'hlHi': ['सदाबहार युवा रूप', 'भावपूर्ण चंचल नेत्र', 'त्वरित एवं फुर्तीली गति', 'स्पष्ट एवं रोचक संवाद शैली'],
        'hlGu': ['સદા યુવાન લુક', 'બોલકી ચંચળ આંખો', 'ચપળ હલનચલન', 'રસપ્રદ વાર્તાલાપ શૈલી'],
      },
      // 4: Cancer
      {
        'hi': 'गोल और अत्यंत कोमल मुखमंडल, चंद्रमा जैसी शीतल सौम्य आभा, गहरी भावुक आंखें और सुंदर मुस्कान। शरीर में स्वाभाविक नजाकत और चेहरे पर वात्सल्य एवं अपनापन सदैव झलकता है।',
        'gu': 'ગોળ અને અત્યંત નમણો ચહેરો, ચંદ્ર જેવી શીતળ સૌમ્ય આભા, ઊંડી સ્નેહાળ આંખો અને મૃદુ સ્મિત. શરીરમાં કુદરતી નજાકત અને ચહેરા પર સ્નેહ તેમજ આત્મીયતા સદા છલકાય છે.',
        'hlHi': ['चंद्रमा समान शीतल मुख', 'गहरी स्नेहमयी आंखें', 'सौम्य एवं कोमल छवि', 'वात्सल्यपूर्ण आकर्षण'],
        'hlGu': ['ચંદ્ર સમાન શીતળ મુખ', 'ઊંડી સ્નેહાળ આંખો', 'સૌમ્ય અને નમણી છબી', 'વાત્સલ્યપૂર્ણ આકર્ષણ'],
      },
      // 5: Leo
      {
        'hi': 'चौड़े मजबूत कंधे, उन्नत वक्षस्थल, सिंह जैसी गरिमामयी और निर्भीक चाल। घने रेशमी बाल, बड़ी तेजस्वी आंखें और राजसी व्यक्तित्व। जनसमूह में भी अपनी विशिष्ट भव्य उपस्थिति दर्ज कराने वाला स्वरूप।',
        'gu': 'પહોળા મજબૂત ખભા, ઊંચી છાતી, સિંહ જેવી ગર્વીલી અને નિર્ભય ચાલ. ઘટ્ટ રેશમી વાળ, મોટી તેજસ્વી આંખો અને રાજવી વ્યક્તિત્વ. ભીડમાં પણ પોતાની ભવ્ય ઓળખ ઉભી કરતો પ્રભાવશાળી લુક.',
        'hlHi': ['राजसी भव्य स्वरूप', 'चौड़े एवं मजबूत कंधे', 'गंभीर प्रभावशाली दृष्टि', 'गर्वयुक्त आकर्षक चाल'],
        'hlGu': ['રાજવી ભવ્ય દેખાવ', 'પહોળા અને મજબૂત ખભા', 'ગંભીર પ્રભાવશાળી નજર', 'ગર્વીલી આકર્ષક ચાલ'],
      },
      // 6: Virgo
      {
        'hi': 'सुव्यवस्थित, संतुलित और आकर्षक काया। गंभीर, सूक्ष्म और बुद्धिमत्तापूर्ण आंखें। चेहरे पर सादगी के साथ गजब का आकर्षण और स्वच्छता होती है। सुरुचिपूर्ण और शिष्ट स्वरूप।',
        'gu': 'સુઘડ, સપ્રમાણ અને આકર્ષક શરીર. ગંભીર, ઝીણવટભરી અને બુદ્ધિશાળી આંખો. ચહેરા પર સાદગીની સાથે ગજબનું આકર્ષણ અને સ્વચ્છતા રહે છે. અત્યંત શિષ્ટ અને વ્યવસ્થિત વ્યક્તિત્વ.',
        'hlHi': ['संतुलित एवं सुडौल काया', 'बुद्धिमत्तापूर्ण दृष्टि', 'सादगीपूर्ण आकर्षण', 'स्वच्छ एवं सुरुचिपूर्ण छवि'],
        'hlGu': ['સપ્રમાણ અને સુઘડ કાયા', 'બુદ્ધિશાળી નજર', 'સાદગીપૂર્ણ આકર્ષણ', 'સ્વચ્છ અને શિષ્ટ છબી'],
      },
      // 7: Libra
      {
        'hi': 'सममित और सुंदर नाक-नक्शा, मनमोहक मुस्कान, चमकदार सम्मोहक आंखें और अत्यंत सुरुचिपूर्ण चाल-ढाल। वस्त्रों और सौंदर्य में उत्कृष्ट कलात्मक रुचि होती है। आकर्षक एवं चुंबकीय आभा।',
        'gu': 'સમપ્રમાણ અને સુંદર નાક-નકશા, મોહક સ્મિત, ચમકતી સંમોહક આંખો અને અત્યંત સ્ટાઇલિશ અંદાજ. કપડાં અને શૃંગારમાં ઉત્તમ કલાત્મક રુચિ હોય છે. મોહક અને ચુંબકીય આભા.',
        'hlHi': ['सुंदर सममित मुखाकृति', 'मनमोहक मुस्कान', 'उत्कृष्ट परिधान शैली', 'चुंबकीय सम्मोहन'],
        'hlGu': ['સુંદર સમપ્રમાણ ચહેરો', 'મોહક સ્મિત', 'ઉત્તમ સ્ટાઇલ સેન્સ', 'ચુંબકીય આકર્ષણ'],
      },
      // 8: Scorpio
      {
        'hi': 'मजबूत और सुदृढ़ शारीरिक गठन, अत्यंत तीक्ष्ण, गहरी और सम्मोहक आंखें जो मन के रहस्यों को भांप लेती हैं। चेहरे पर रहस्यमयी गंभीरता, ओजपूर्ण आवाज और अदम्य आंतरिक शक्ति का आभास।',
        'gu': 'મજબૂત અને સુદ્રઢ શારીરિક બાંધો, અત્યંત તીક્ષ્ણ, ઊંડી અને સંમોહક આંખો જે મનના રહસ્યો જાણી લે છે. ચહેરા પર રહસ્યમય ગંભીરતા, પ્રભાવશાળી અવાજ અને અદમ્ય આંતરિક શક્તિનો આભાસ.',
        'hlHi': ['तीक्ष्ण सम्मोहक आंखें', 'मजबूत सुदृढ़ शरीर', 'रहस्यमयी प्रभावशाली आभा', 'गंभीर ओजस्वी वाणी'],
        'hlGu': ['તીક્ષ્ણ સંમોહક આંખો', 'મજબૂત સુદ્રઢ શરીર', 'રહસ્યમય પ્રભાવશાળી આભા', 'ગંભીર તેજસ્વી વાણી'],
      },
      // 9: Sagittarius
      {
        'hi': 'लंबा और उन्नत कद, चौड़ा ललाट, खिला हुआ हंसमुख चेहरा और बादामी चमकदार आंखें। शरीर में एथलेटिक ऊर्जा और चेहरे पर दार्शनिक ज्ञान एवं आशावाद का तेज रहता है।',
        'gu': 'ઊંચું અને સુદ્રઢ કદ, પહોળું કપાળ, ખુલ્લો હસમુખો ચહેરો અને બદામી ચમકતી આંખો. શરીરમાં સ્પોર્ટી ઉર્જા અને ચહેરા પર દાર્શનિક જ્ઞાન તેમજ આશાવાદનું તેજ છલકાય છે.',
        'hlHi': ['लंबा एवं उन्नत कद', 'चौड़ा तेजस्वी ललाट', 'हंसमुख खिला हुआ मुख', 'ऊर्जावान एवं दार्शनिक छवि'],
        'hlGu': ['ઊંચું અને સુદ્રઢ કદ', 'પહોળું તેજસ્વી કપાળ', 'હસમુખો ખીલેલો ચહેરો', 'ઉર્જાવાન અને દાર્શનિક છબી'],
      },
      // 10: Capricorn
      {
        'hi': 'मध्यम से लंबा कद, सुस्पष्ट और सुगठित अस्थि ढांचा, गंभीर विचारमग्न आंखें और सुडौल नासिका। आयु बढ़ने के साथ चेहरे पर और अधिक निखार, गंभीरता एवं राजसी गरिमा प्रकट होती है।',
        'gu': 'મધ્યમથી ઊંચું કદ, સુરેખ હાડકાંનો બાંધો, ગંભીર વિચારશીલ આંખો અને સુરેખ નાક. ઉંમર વધવાની સાથે ચહેરા પર વધુ તેજ, ગંભીરતા અને પરિપક્વ રાજવી ગરિમા પ્રગટ થાય છે.',
        'hlHi': ['પરિપક્વ રાજવી ગરિમા', 'વિચારશીલ ગંભીર આંખો', 'સુરેખ મજબૂત બાંધો', 'ઉંમર સાથે વધતો નિખાર'],
        'hlGu': ['પરિપક્વ રાજવી ગરિમા', 'વિચારશીલ ગંભીર આંખો', 'સુરેખ મજબૂત બાંધો', 'ઉંમર સાથે વધતો નિખાર'],
      },
      // 11: Aquarius
      {
        'hi': 'लंबा, सुडौल और आकर्षक कद, गहरी विचारपूर्ण आंखें, सौम्य मुस्कान और अद्वितीय आधुनिक शैली। स्वरूप में एक विशेष बौद्धिक और मानवीय आभा होती है जो सबसे अलग बनाती है।',
        'gu': 'ઊંચું, સુડોળ અને આકર્ષક કદ, ઊંડી વિચારવંત આંખો, સૌમ્ય સ્મિત અને અનોખી આધુનિક શૈલી. દેખાવમાં એક વિશેષ બૌદ્ધિક અને માનવતાવાદી આભા હોય છે જે અન્યોથી અલગ પાડે છે.',
        'hlHi': ['अद्वितीय आधुनिक शैली', 'बौद्धिक एवं विचारपूर्ण आंखें', 'लंबा एवं सुडौल कद', 'शांत मानवीय आभा'],
        'hlGu': ['અનોખી આધુનિક સ્ટાઇલ', 'બૌદ્ધિક અને વિચારશીલ આંખો', 'ઊંચું અને સુડોળ કદ', 'શાંત માનવતાવાદી આભા'],
      },
      // 12: Pisces
      {
        'hi': 'कोमल सुंदर त्वचा, बड़ी स्वप्निल और करुणामयी आंखें, सौम्य गोल मुखमंडल और शांत आध्यात्मिक आभा। स्वरूप में सहज निर्दोषता, सौम्यता और शांति का संचार होता है।',
        'gu': 'કોમળ સુંદર ત્વચા, મોટી સ્વપ્નિલ અને કરુણામય આંખો, સૌમ્ય ગોળાકાર ચહેરો અને શાંત આધ્યાત્મિક આભા. દેખાવમાં સાહજિક નિર્દોષતા, નમ્રતા અને શાંતિનો સંચાર થાય છે.',
        'hlHi': ['स्वप्निल करुणामयी आंखें', 'शांत आध्यात्मिक आभा', 'सौम्य कोमल मुखमंडल', 'सहज निर्दोष आकर्षण'],
        'hlGu': ['સ્વપ્નિલ કરુણામય આંખો', 'શાંત આધ્યાત્મિક આભા', 'સૌમ્ય કોમળ મુખ', 'સાહજિક નિર્દોષ આકર્ષણ'],
      },
    ];

    final idx = (lagna - 1).clamp(0, 11);
    final data = appearances[idx];

    return LifeAspectPrediction(
      titleHi: 'शारीरिक रूप-रंग एवं व्यक्तित्व स्वरूप',
      titleGu: 'શારીરિક દેખાવ અને વ્યક્તિત્વ સ્વરૂપ',
      descriptionHi: data['hi'] as String,
      descriptionGu: data['gu'] as String,
      highlightsHi: List<String>.from(data['hlHi'] as List),
      highlightsGu: List<String>.from(data['hlGu'] as List),
      iconName: 'face',
    );
  }

  static LifeAspectPrediction _getSwabhavData(int moonRashi, int nakshatraIndex) {
    const swabhavList = [
      // 1: Aries Moon
      {
        'hi': 'उत्साही, निडर, स्पष्टवादी और अत्यधिक ऊर्जावान स्वभाव। किसी भी कार्य में पहल करने की अद्भुत क्षमता है। आत्मसम्मान प्रिय, न्यायप्रिय और नेतृत्व करने में अग्रणी होते हैं। मन में जो है वही जुबान पर होता है।',
        'gu': 'ઉત્સાહી, નીડર, સ્પષ્ટવક્તા અને અત્યંત ઉર્જાવાન સ્વભાવ. કોઈપણ કાર્યની શરૂઆત કરવાની અદભુત ક્ષમતા છે. સ્વાભિમાની, ન્યાયપ્રિય અને નેતૃત્વ કરવામાં અગ્રેસર રહે છે. મનમાં જે હોય તે જ મુખ પર બોલે છે.',
        'hlHi': ['साहसी एवं निडर सोच', 'निर्णय लेने में त्वरित', 'स्पष्टवादी एवं ईमानदार', 'आत्मसम्मान प्रिय'],
        'hlGu': ['સાહસી અને નીડર વિચારસરણી', 'ઝડપી નિર્ણયશક્તિ', 'સ્પષ્ટવક્તા અને પ્રમાણિક', 'સ્વાભિમાની વ્યક્તિત્વ'],
      },
      // 2: Taurus Moon
      {
        'hi': 'धैर्यवान, शांत, व्यवहारकुशल और अत्यंत निष्ठावान स्वभाव। कला, सौंदर्य और सुख-सुविधाओं के प्रेमी होते हैं। वचन के पक्के और परिवार के प्रति समर्पित होते हैं। किसी भी कार्य को स्थिरता से पूरा करते हैं।',
        'gu': 'ધીરજવાન, શાંત, વ્યવહારકુશળ અને અત્યંત વફાદાર સ્વભાવ. કલા, સૌંદર્ય અને ભૌતિક સુખોના શોખીન હોય છે. વચનના પાકા અને પરિવાર પ્રત્યે સમર્પિત રહે છે. કોઈપણ કાર્યને સ્થિરતાપૂર્વક પૂરું કરે છે.',
        'hlHi': ['धैर्यवान एवं स्थिर बुद्धि', 'परिवार के प्रति समर्पण', 'कला एवं सौंदर्य प्रेमी', 'व्यवहार में मधुरता'],
        'hlGu': ['ધીરજવાન અને સ્થિર બુદ્ધિ', 'પરિવાર પ્રત્યે પૂર્ણ સમર્પણ', 'કલા અને સૌંદર્ય પ્રેમી', 'વ્યવહારમાં મીઠાશ'],
      },
      // 3: Gemini Moon
      {
        'hi': 'बुद्धिमान, हाजिरजवाब, बहुमुखी प्रतिभा के धनी और जिज्ञासु स्वभाव। सीखने और नए विचार जानने की तीव्र ललक रहती है। मिलनसार, सामाजिक और बातचीत में अत्यंत कुशल होते हैं।',
        'gu': 'બુદ્ધિશાળી, હાજરજવાબી, બહુમુખી પ્રતિભા ધરાવનાર અને જિજ્ઞાસુ સ્વભાવ. સતત નવું શીખવાની અને જાણવાની તીવ્ર લગન હોય છે. મળતાવડા, સામાજિક અને વાતચીતમાં અત્યંત કુશળ હોય છે.',
        'hlHi': ['कुशाग्र बुद्धिमत्ता', 'उत्कृष्ट वाकपटुता', 'बहुमुखी प्रतिभा', 'मिलनसार एवं सामाजिक'],
        'hlGu': ['તીક્ષ્ણ બુદ્ધિપ્રતિભા', 'ઉત્તમ વાકચાતુર્ય', 'બહુમુખી આવડત', 'મળતાવડો સામાજિક સ્વભાવ'],
      },
      // 4: Cancer Moon
      {
        'hi': 'अत्यंत संवेदनशील, भावुक, दयालु और दूसरों की भावनाओं का आदर करने वाले। परिवार और मित्रों के लिए कुछ भी कर गुजरने को तत्पर रहते हैं। अंतर्ज्ञान बहुत तीव्र होता है और मन बहुत पवित्र रहता है।',
        'gu': 'અત્યંત સંવેદનશીલ, લાગણીશીલ, દયાળુ અને અન્યોની ભાવનાઓનું સન્માન કરનારા. પરિવાર અને મિત્રો માટે કંઈપણ કરવા તત્પર રહે છે. આંતરજ્ઞાન (Intuition) ખૂબ તીવ્ર હોય છે અને મન નિર્મળ રહે છે.',
        'hlHi': ['गहरी संवेदनशीलता', 'तीव्र अंतर्ज्ञान शक्ति', 'दयालु एवं परोपकारी', 'अपनों के प्रति अगाध प्रेम'],
        'hlGu': ['ઊંડી સંવેદનશીલતા', 'તીવ્ર આંતરજ્ઞાન શક્તિ', 'દયાળુ અને પરોપકારી', 'સ્નેહીજનો પ્રત્યે અતૂટ પ્રેમ'],
      },
      // 5: Leo Moon
      {
        'hi': 'उदार हृदय, आत्मविश्वासी, स्वाभिमानी और स्वाभाविक रूप से नेतृत्वकर्ता। मित्रों की सहायता में सदैव आगे रहते हैं। उच्च आदर्श, कर्तव्यनिष्ठा और महान कार्यों की ओर सहज आकर्षण रहता है।',
        'gu': 'ઉદાર હૃદય, આત્મવિશ્વાસુ, ખુદ્દાર અને કુદરતી રીતે નેતૃત્વ કરનારા. મિત્રોની મદદ માટે સદા અગ્રેસર રહે છે. ઉચ્ચ આદર્શો, કર્તવ્યનિષ્ઠા અને મહાન કાર્યો તરફ સાહજિક આકર્ષણ ધરાવે છે.',
        'hlHi': ['स्वाभाविक नेतृत्व क्षमता', 'उदार एवं विशाल हृदय', 'कर्तव्यनिष्ठ एवं निष्ठावान', 'अद्वितीय आत्मगौरव'],
        'hlGu': ['કુદરતી નેતૃત્વ ક્ષમતા', 'ઉદાર અને વિશાળ હૃદય', 'કર્તવ્યનિષ્ઠ અને વફાદાર', 'અદભુત આત્મગૌરવ'],
      },
      // 6: Virgo Moon
      {
        'hi': 'विश्लेषणात्मक, बुद्धिमान, अनुशासित और व्यावहारिक स्वभाव। हर काम को पूरी बारीकी और परफेक्शन के साथ करना पसंद करते हैं। सेवाभावी, समय के पाबंद और समस्या समाधान में माहिर होते हैं।',
        'gu': 'વિશ્લેષણાત્મક, બુદ્ધિશાળી, શિસ્તબદ્ધ અને વ્યવહારુ સ્વભાવ. દરેક કામને સંપૂર્ણ ઝીણવટ અને પરફેક્શન સાથે કરવાનું પસંદ કરે છે. સેવાભાવી, સમયપાલક અને મુશ્કેલીઓનો સચોટ ઉકેલ લાવવામાં માહેર હોય છે.',
        'hlHi': ['परफेक्शनिस्ट सोच', 'सूक्ष्म विश्लेषक बुद्धि', 'अनुशासित एवं समयनिष्ठ', 'मददगार एवं सेवाभावी'],
        'hlGu': ['પરફેક્શનિસ્ટ વિચારસરણી', 'ઝીણવટભરી વિશ્લેષક બુદ્ધિ', 'શિસ્તબદ્ધ અને સમયપાલક', 'મદદગાર અને સેવાભાવી'],
      },
      // 7: Libra Moon
      {
        'hi': 'संतुलित, न्यायप्रिय, शांतिप्रिय और कूटनीतिज्ञ स्वभाव। विवादों को बातचीत से सुलझाने में पारंगत होते हैं। सौंदर्य, संगीत, मधुर संबंध और सामाजिक प्रतिष्ठा के प्रेमी होते हैं।',
        'gu': 'સંતુલિત, ન્યાયપ્રિય, શાંતિપ્રિય અને વ્યવહારકુશળ સ્વભાવ. વિવાદોને પ્રેમપૂર્વક ઉકેલવામાં પારંગત હોય છે. સૌંદર્ય, સંગીત, મધુર સંબંધો અને સામાજિક પ્રતિષ્ઠાના શોખીન હોય છે.',
        'hlHi': ['संतुलित एवं न्यायप्रिय', 'शांति एवं सौहार्द के पक्षधर', 'उत्कृष्ट सामंजस्य क्षमता', 'कला एवं सौंदर्य अनुरागी'],
        'hlGu': ['સંતુલિત અને ન્યાયપ્રિય', 'શાંતિ અને સદ્ભાવનાના પક્ષધર', 'ઉત્તમ તાલમેલ ક્ષમતા', 'કલા અને સૌંદર્ય પ્રેમી'],
      },
      // 8: Scorpio Moon
      {
        'hi': 'दृढ़निश्चयी, गूढ़, निष्ठावान और असीम मानसिक शक्ति के स्वामी। रहस्यमयी विद्याओं और गहरी खोज में रुचि रहती है। एक बार जो संकल्प ले लें उसे पूरा करके ही दम लेते हैं। सच्चे मित्र और वफादार साथी।',
        'gu': 'દ્રઢનિશ્ચયી, ગૂઢ, અત્યંત વફાદાર અને અપાર માનસિક શક્તિના સ્વામી. રહસ્યમય બાબતો અને ઊંડા સંશોધનમાં રુચિ હોય છે. એકવાર જે સંકલ્પ કરે તે પૂરો કરીને જ જંપે છે. સાચા મિત્ર અને વફાદાર સાથી.',
        'hlHi': ['अदम्य मानसिक शक्ति', 'दृढ़ संकल्प एवं एकाग्रता', 'अटूट निष्ठा एवं वफादारी', 'गूढ़ विषयों में रुचि'],
        'hlGu': ['અદમ્ય માનસિક શક્તિ', 'દ્રઢ સંકલ્પ અને એકાગ્રતા', 'અતૂટ નિષ્ઠા અને વફાદારી', 'ગૂઢ વિષયોમાં રુચિ'],
      },
      // 9: Sagittarius Moon
      {
        'hi': 'आशावादी, दार्शनिक, ज्ञानपिपासु, धर्मपरायण और स्पष्टवादी। जीवन को एक यात्रा मानते हैं और सदैव ज्ञानार्जन तथा यात्राओं के प्रेमी रहते हैं। खुले विचार, उदारता और सकारात्मक दृष्टिकोण इनकी पहचान है।',
        'gu': 'આશાવાદી, દાર્શનિક, જ્ઞાનપિપાસુ, ધર્મપરાયણ અને સ્પષ્ટવક્તા. જીવનને એક યાત્રા માને છે અને સદા જ્ઞાનપ્રાપ્તિ તેમજ મુસાફરીના શોખીન રહે છે. ખુલ્લા વિચારો, ઉદારતા અને સકારાત્મક અભિગમ તેમની ઓળખ છે.',
        'hlHi': ['सदा सकारात्मक सोच', 'उच्च दार्शनिक ज्ञान', 'ज्ञान एवं यात्रा प्रेमी', 'सत्य एवं धर्मनिष्ठ'],
        'hlGu': ['સદા સકારાત્મક વિચારસરણી', 'ઉચ્ચ દાર્શનિક જ્ઞાન', 'જ્ઞાન અને પ્રવાસ પ્રેમી', 'સત્ય અને ધર્મનિષ્ઠ'],
      },
      // 10: Capricorn Moon
      {
        'hi': 'मेहनती, व्यावहारिक, महत्वाकांक्षी, गंभीर और लक्ष्य-उन्मुख। जीवन में धीरे-धीरे किंतु अत्यंत ठोस सफलता प्राप्त करते हैं। उत्तरदायित्वों को पूरी निष्ठा से निभाते हैं और विपरीत परिस्थितियों में अडिग रहते हैं।',
        'gu': 'મહેનતુ, વ્યવહારુ, મહત્વાકાંક્ષી, ગંભીર અને લક્ષ્ય-કેન્દ્રિત. જીવનમાં ધીમે-ધીમે પરંતુ અત્યંત મજબૂત સફળતા મેળવે છે. જવાબદારીઓને પૂર્ણ નિષ્ઠાથી નિભાવે છે અને વિષમ પરિસ્થિતિઓમાં અડગ રહે છે.',
        'hlHi': ['अथक परिश्रमी स्वभाव', 'अत्यंत गंभीर एवं जिम्मेदार', 'दृढ़ लक्ष्य-केंद्रित दृष्टि', 'धैर्यपूर्वक विजय प्राप्ति'],
        'hlGu': ['અથાક મહેનતુ સ્વભાવ', 'અત્યંત ગંભીર અને જવાબદાર', 'દ્રઢ લક્ષ્ય-કેન્દ્રિત દ્રષ્ટિ', 'ધીરજપૂર્વક વિજય પ્રાપ્તિ'],
      },
      // 11: Aquarius Moon
      {
        'hi': 'मानवतावादी, आधुनिक, मौलिक विचारक, स्वतंत्र और दूरदर्शी। समाज कल्याण और नई तकनीकों में गहरी रुचि रहती है। भेदभाव से दूर, मित्रता निभाने वाले और अद्वितीय बौद्धिक क्षमता के धनी।',
        'gu': 'માનવતાવાદી, આધુનિક, મૌલિક વિચારક, સ્વતંત્ર અને દીર્ઘદ્રષ્ટા. સમાજ કલ્યાણ અને નવી ટેકનોલોજીમાં ઊંડો રસ હોય છે. ભેદભાવથી પર, મિત્રતા નિભાવનારા અને અદભુત બૌદ્ધિક ક્ષમતા ધરાવનાર.',
        'hlHi': ['दूरदर्शी एवं मौलिक सोच', 'मानवता एवं समाज हितैषी', 'स्वतंत्र विचार शैली', 'सच्ची मित्रता के प्रतीक'],
        'hlGu': ['દીર્ઘદ્રષ્ટા અને મૌલિક વિચાર', 'માનવતા અને સમાજ હિતેચ્છુ', 'સ્વતંત્ર વિચારશૈલી', 'સાચી મિત્રતાના પ્રતીક'],
      },
      // 12: Pisces Moon
      {
        'hi': 'अत्यंत दयालु, शांत, कल्पनाशील, परोपकारी और आध्यात्मिक। दूसरों के दुख को अपना समझकर सहायता करते हैं। रचनात्मक कलाओं, संगीत, ध्यान और ईश्वर भक्ति में गहरा आनंद मिलता है। शांत एवं निर्मल हृदय।',
        'gu': 'અત્યંત દયાળુ, શાંત, કલ્પનાશીલ, પરોપકારી અને આધ્યાત્મિક. અન્યોના દુઃખને પોતાનું સમજીને સહાય કરે છે. રચનાત્મક કલાઓ, સંગીત, ધ્યાન અને ઈશ્વર ભક્તિમાં ઊંડો આનંદ મેળવે છે. શાંત અને નિર્મળ હૃદય.',
        'hlHi': ['असीम दया एवं करुणा', 'आध्यात्मिक एवं शांत मन', 'उत्कृष्ट रचनात्मक कल्पना', 'ईश्वर पर अगाध विश्वास'],
        'hlGu': ['અપાર દયા અને કરુણા', 'આધ્યાત્મિક અને શાંત મન', 'ઉત્તમ રચનાત્મક કલ્પના', 'ઈશ્વર પર અડગ વિશ્વાસ'],
      },
    ];

    final idx = (moonRashi - 1).clamp(0, 11);
    final data = swabhavList[idx];

    return LifeAspectPrediction(
      titleHi: 'स्वभाव, व्यवहार एवं व्यक्तित्व',
      titleGu: 'સ્વભાવ, આચરણ અને વ્યક્તિત્વ',
      descriptionHi: data['hi'] as String,
      descriptionGu: data['gu'] as String,
      highlightsHi: List<String>.from(data['hlHi'] as List),
      highlightsGu: List<String>.from(data['hlGu'] as List),
      iconName: 'psychology',
    );
  }

  static LifeAspectPrediction _getMarriagePrediction(int lagna, List<PlanetPosition> planets, DateTime birthDate) {
    // 7th House Sign (1-12)
    final seventhSign = ((lagna + 5) % 12) + 1;
    final seventhSignGu = rashisGu[seventhSign - 1];
    final seventhSignHi = rashisHi[seventhSign - 1];

    // 7th Lord lookup
    int seventhLordId = 1;
    switch (seventhSign) {
      case 1:
      case 8:
        seventhLordId = 3; // Mars
        break;
      case 2:
      case 7:
        seventhLordId = 6; // Venus
        break;
      case 3:
      case 6:
        seventhLordId = 4; // Mercury
        break;
      case 4:
        seventhLordId = 2; // Moon
        break;
      case 5:
        seventhLordId = 1; // Sun
        break;
      case 9:
      case 12:
        seventhLordId = 5; // Jupiter
        break;
      case 10:
      case 11:
        seventhLordId = 7; // Saturn
        break;
    }

    final seventhLordPlanet = planets.firstWhere((p) => p.id == seventhLordId, orElse: () => planets.first);
    final planetsIn7 = planets.where((p) => p.houseNumber == 7).toList();

    // 1. Dynamic Marriage Age Window
    String timingAgeHi;
    String timingAgeGu;
    switch (seventhLordId) {
      case 6: // Venus
        timingAgeHi = '23 से 26 वर्ष की आयु (शीघ्र एवं शुभ विवाह योग)';
        timingAgeGu = '૨૩ થી ૨૬ વર્ષની વય (ઝડપી અને શુભ લગ્ન યોગ)';
        break;
      case 4: // Moon / Mercury
      case 2:
        timingAgeHi = '24 से 27 वर्ष की आयु (उत्तम अनुकूल विवाह काल)';
        timingAgeGu = '૨૪ થી ૨૭ વર્ષની વય (ઉત્તમ અનુકૂળ લગ્ન સમય)';
        break;
      case 5: // Jupiter
      case 1: // Sun
        timingAgeHi = '25 से 28 वर्ष की आयु (प्रतिष्ठित एवं श्रेष्ठ विवाह योग)';
        timingAgeGu = '૨૫ થી ૨૮ વર્ષની વય (પ્રતિષ્ઠિત અને શ્રેષ્ઠ લગ્ન યોગ)';
        break;
      case 3: // Mars
        timingAgeHi = '25 से 28 वर्ष की आयु (ऊर्जावान एवं स्थिर दांपत्य योग)';
        timingAgeGu = '૨૫ થી ૨૮ વર્ષની વય (ઉર્જાવાન અને સ્થિર દાંપત્ય યોગ)';
        break;
      case 7: // Saturn
      default:
        timingAgeHi = '27 से 30 वर्ष की आयु (परिपक्व एवं सुदृढ़ दांपत्य योग)';
        timingAgeGu = '૨૭ થી ૩૦ વર્ષની વય (પરિપક્વ અને સુદ્રઢ દાંપત્ય યોગ)';
        break;
    }

    // 2. Dynamic Direction of Marriage
    String directionGu;
    String directionHi;
    if ([1, 5, 9].contains(seventhSign)) {
      directionGu = 'પૂર્વ અથવા ઉત્તર-પૂર્વ દિશા';
      directionHi = 'पूर्व अथवा उत्तर-पूर्व दिशा';
    } else if ([2, 6, 10].contains(seventhSign)) {
      directionGu = 'દક્ષિણ અથવા દક્ષિણ-પશ્ચિમ દિશા';
      directionHi = 'दक्षिण अथवा दक्षिण-पश्चिम दिशा';
    } else if ([3, 7, 11].contains(seventhSign)) {
      directionGu = 'પશ્ચિમ અથવા ઉત્તર-પશ્ચિમ દિશા';
      directionHi = 'पश्चिम अथवा उत्तर-पश्चिम दिशा';
    } else {
      directionGu = 'ઉત્તર અથવા ઈશાન દિશા';
      directionHi = 'उत्तर अथवा ईशान दिशा';
    }

    // 3. Dynamic Core Description based on 7th House Sign and 7th Lord
    String baseDescGu;
    String baseDescHi;
    String spouseNatureGu;
    String spouseNatureHi;

    switch (seventhLordId) {
      case 6: // Venus (Aries/Scorpio 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના અધિપતિ સૌંદર્ય અને પ્રેમકારક શુક્રદેવ છે ($seventhSignGu રાશિ). તમારા જીવનસાથી અત્યંત આકર્ષક, કલાપ્રેમી, સ્નેહાળ અને સુંદર રુચિવાળા હશે. કપડાં, શૃંગાર અને સુખ-સુવિધાઓ પ્રત્યે તેમનો લગાવ રહેશે. લગ્ન પછી તમારી ભૌતિક સંપત્તિ, વાહન સુખ અને ભાગ્યોદયમાં મોટો ઉછાળો આવશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी सौंदर्य एवं ऐश्वर्य कारक शुक्र देव हैं ($seventhSignHi राशि)। आपका जीवनसाथी अत्यंत आकर्षक, कलाप्रेमी, स्नेही एवं सुरुचिपूर्ण व्यक्तित्व वाला होगा। विवाह के पश्चात आपकी भौतिक सुख-सुविधाओं, वाहन एवं भाग्योदय में तीव्र वृद्धि होगी।';
        spouseNatureGu = 'રૂપવાન, કલાત્મક રુચિવાળા અને સ્નેહાળ જીવનસાથી';
        spouseNatureHi = 'रूपवान, कलाप्रेमी एवं स्नेहमयी जीवनसाथी';
        break;
      case 3: // Mars (Taurus/Libra 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના સ્વામી પરાક્રમી મંગળદેવ છે ($seventhSignGu રાશિ). તમારા જીવનસાથી આત્મવિશ્વાસુ, નીડર, સાહસિક, નિર્ણયશક્તિમાં તેજ અને ઉર્જાવાન વ્યક્તિત્વ ધરાવનારા હશે. તેઓ સ્પષ્ટવક્તા અને સંઘર્ષો સામે અડગ રહેનારા હશે. લગ્ન પછી તમારા સાહસ, સ્થાવર મિલકત અને વ્યવસાયમાં વિશેષ વૃદ્ધિ થશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी पराक्रमी मंगल देव हैं ($seventhSignHi राशि)। आपका जीवनसाथी आत्मविश्वासी, साहसी, स्पष्टवादी एवं ऊर्जावान व्यक्तित्व वाला होगा। विवाह के पश्चात आपकी अचल संपत्ति, पराक्रम एवं प्रतिष्ठा में वृद्धि होगी।';
        spouseNatureGu = 'સાહસિક, આત્મવિશ્વાસુ અને નીડર જીવનસાથી';
        spouseNatureHi = 'साहसी, आत्मविश्वासी एवं ओजस्वी जीवनसाथी';
        break;
      case 5: // Jupiter (Gemini/Virgo 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના સ્વામી દેવગુરુ બૃહસ્પતિ છે ($seventhSignGu રાશિ). તમારા જીવનસાથી ઉચ્ચ સંસ્કારી, ધર્મનિષ્ઠ, જ્ઞાની, બુદ્ધિશાળી અને આદર્શવાદી પરિવારમાંથી આવશે. તેમનું માર્ગદર્શન તમારા જીવનમાં વરદાનરૂપ સાબિત થશે. લગ્ન પછી તમારા ઘરમાં આધ્યાત્મિક ઉન્નતિ, સંતાન સુખ અને અપરંપાર યશ-કીર્તિમાં વધારો થશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी देवगुरु बृहस्पति हैं ($seventhSignHi राशि)। आपका जीवनसाथी उच्च संस्कारी, धर्मपरायण, विदुषी/विद्वान एवं विवेकशील परिवार से होगा। विवाह के पश्चात आपके घर में आध्यात्मिक उन्नति, ज्ञान एवं सामाजिक मान-प्रतिष्ठा का विस्तार होगा।';
        spouseNatureGu = 'જ્ઞાની, ઉચ્ચ સંસ્કારી અને ધર્મનિષ્ઠ જીવનસાથી';
        spouseNatureHi = 'विद्वान, सुसंस्कृत एवं धर्मनिष्ठ जीवनसाथी';
        break;
      case 7: // Saturn (Cancer/Leo 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના અધિપતિ ન્યાયપ્રિય શનિદેવ છે ($seventhSignGu રાશિ). તમારા જીવનસાથી ગંભીર, પરિપક્વ, અથાક મહેનતુ, વ્યવહારુ અને જીવનની જવાબદારીઓ પ્રત્યે અત્યંત વફાદાર રહેશે. તેઓ વડીલોનું સન્માન કરનારા અને શાંત મગજના હશે. લગ્ન પછી તમારી આર્થિક સ્થિતિમાં મજબૂત સ્થિરતા આવશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी न्यायप्रिय शनि देव हैं ($seventhSignHi राशि)। आपका जीवनसाथी गंभीर, परिपक्व, परिश्रमी एवं पारिवारिक कर्तव्यों के प्रति पूर्ण निष्ठावान होगा। विवाह के पश्चात आपके जीवन में आर्थिक व सामाजिक स्थिरता आएगी।';
        spouseNatureGu = 'પરિપક્વ, ગંભીર અને અત્યંત વફાદાર જીવનસાથી';
        spouseNatureHi = 'परिपक्व, कर्तव्यनिष्ठ एवं निष्ठावान जीवनसाथी';
        break;
      case 1: // Sun (Aquarius 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના સ્વામી સૂર્યદેવ છે (સિંહ રાશિ). તમારા જીવનસાથી રાજવી ઠાઠ, ખુદ્દાર વ્યક્તિત્વ, સમાજમાં ઉચ્ચ પ્રતિષ્ઠા અને આત્મગૌરવ ધરાવનારા હશે. તેઓ નેતૃત્વ ક્ષમતાવાળા અને પ્રતિષ્ઠિત કુળના હશે. લગ્ન પછી તમારી સામાજિક ઓળખ અને વહીવટી લાભોમાં વધારો થશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी सूर्य देव हैं (सिंह राशि)। आपका जीवनसाथी तेजस्वी, स्वाभिमानी, उच्च कुल का एवं नेतृत्व क्षमता से परिपूर्ण होगा। विवाह के उपरांत आपकी प्रशासनिक एवं सामाजिक प्रतिष्ठा में वृद्धि होगी।';
        spouseNatureGu = 'તેજસ્વી, રાજવી ગૌરવ અને નેતૃત્વવાળા જીવનસાથી';
        spouseNatureHi = 'तेजस्वी, स्वाभिमानी एवं नेतृत्व कुशल जीवनसाथी';
        break;
      case 2: // Moon (Capricorn 7th)
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના સ્વામી ચંદ્રદેવ છે (કર્ક રાશિ). તમારા જીવનસાથી અત્યંત સ્નેહાળ, ભાવુક, મૃદુભાષી, કૌટુંબિક સુખ આપનારા અને ચંદ્ર સમાન શીતળ સૌમ્ય આભા ધરાવનારા હશે. દાંપત્ય જીવનમાં સાચો પ્રેમ, સંવેદનશીલતા અને માનસિક સુખની પ્રાપ્તિ થશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी चन्द्र देव हैं (कर्क राशि)। आपका जीवनसाथी अत्यंत स्नेही, भावुक, मृदुभाषी एवं चंद्रमा समान सौम्य आभा वाला होगा। दांपत्य जीवन में गहरा आत्मीय प्रेम और मानसिक शांति रहेगी।';
        spouseNatureGu = 'સ્નેહાળ, મૃદુભાષી અને લાગણીશીલ જીવનસાથી';
        spouseNatureHi = 'स्नेहमयी, सौम्य एवं संवेदनशील जीवनसाथी';
        break;
      case 4: // Mercury (Sagittarius/Pisces 7th)
      default:
        baseDescGu = 'તમારી કુંડળીમાં સપ્તમ ભાવના સ્વામી બુદ્ધિના દાતા બુધદેવ છે ($seventhSignGu રાશિ). તમારા જીવનસાથી અત્યંત બુદ્ધિશાળી, વાકચતુર, હસમુખા, યુવાન વિચારસરણીવાળા અને વ્યાપારિક સૂઝ ધરાવનારા હશે. દાંપત્યમાં મિત્રતા અને જીવંત સંવાદ કાયમ રહેશે. લગ્ન પછી તમારી બૌદ્ધિક પ્રગતિ અને આર્થિક આવકમાં મોટો વધારો થશે.';
        baseDescHi = 'आपकी कुंडली में सप्तम भाव के स्वामी बुध देव हैं ($seventhSignHi राशि)। आपका जीवनसाथी अत्यंत कुशाग्र बुद्धि, वाकपटु, प्रसन्नचित्त एवं व्यावहारिक सोच वाला होगा। दांपत्य में मित्रता का भाव रहेगा और विवाह के बाद आय में वृद्धि होगी।';
        spouseNatureGu = 'બુદ્ધિશાળી, વાકચતુર અને હસમુખા જીવનસાથી';
        spouseNatureHi = 'बुद्धिमान, वाकपटु एवं व्यावहारिक जीवनसाथी';
        break;
    }

    // 4. Presence of Planets in 7th House
    String planetIn7DescGu = '';
    String planetIn7DescHi = '';
    if (planetsIn7.isNotEmpty) {
      final namesGu = planetsIn7.map((p) => p.nameGu).join(', ');
      final namesHi = planetsIn7.map((p) => p.nameHi).join(', ');
      planetIn7DescGu = ' સપ્તમ ભાવમાં $namesGu ગ્રહની સ્થિતિ દાંપત્યજીવનને વધુ પ્રભાવશાળી અને વિશિષ્ટ બનાવે છે.';
      planetIn7DescHi = ' सप्तम भाव में $namesHi ग्रह की स्थिति दांपत्य जीवन को अधिक प्रभावशाली एवं विशिष्ट बनाती है।';
    }

    final fullDescGu = '$baseDescGu$planetIn7DescGu સપ્તમેશ ${seventhLordPlanet.nameGu} ${seventhLordPlanet.houseNumber}મા ભાવમાં સ્થિત હોવાથી દાંપત્ય જીવનમાં પરસ્પર આદર અને સ્થિરતા જળવાઈ રહેશે.';
    final fullDescHi = '$baseDescHi$planetIn7DescHi सप्तमेश ${seventhLordPlanet.nameHi} ${seventhLordPlanet.houseNumber}वें भाव में स्थित होकर दांपत्य में स्थायित्व एवं समृद्धि प्रदान करते हैं।';

    final highlightsGu = [
      timingAgeGu,
      spouseNatureGu,
      '$directionGuમાંથી સંબંધ આવવાનો યોગ',
      'લગ્ન પછી આર્થિક સમૃદ્ધિ અને ભાગ્યોદય',
    ];

    final highlightsHi = [
      timingAgeHi,
      spouseNatureHi,
      '$directionHi से संबंध का शुभ योग',
      'विवाह के उपरांत तीव्र आर्थिक भाग्योदय',
    ];

    return LifeAspectPrediction(
      titleHi: 'विवाह समय एवं दांपत्य योग',
      titleGu: 'વિવાહ અને દાંપત્ય યોગ',
      descriptionHi: fullDescHi,
      descriptionGu: fullDescGu,
      highlightsHi: highlightsHi,
      highlightsGu: highlightsGu,
      timingOrAge: timingAgeGu,
      iconName: 'favorite',
    );
  }

  static LifeAspectPrediction _getCareerBhagyodaya(int lagna, int moonRashi, List<PlanetPosition> planets, DateTime birthDate) {
    // 10th House (Karma/Profession) Sign
    final tenthSign = ((lagna + 8) % 12) + 1;
    final tenthSignGu = rashisGu[tenthSign - 1];
    final tenthSignHi = rashisHi[tenthSign - 1];

    // 9th House (Bhagya/Fortune) Sign
    final ninthSign = ((lagna + 7) % 12) + 1;
    final ninthSignGu = rashisGu[ninthSign - 1];
    final ninthSignHi = rashisHi[ninthSign - 1];

    // 10th Lord ID lookup
    int tenthLordId = 1;
    switch (tenthSign) {
      case 1:
      case 8:
        tenthLordId = 3; // Mars
        break;
      case 2:
      case 7:
        tenthLordId = 6; // Venus
        break;
      case 3:
      case 6:
        tenthLordId = 4; // Mercury
        break;
      case 4:
        tenthLordId = 2; // Moon
        break;
      case 5:
        tenthLordId = 1; // Sun
        break;
      case 9:
      case 12:
        tenthLordId = 5; // Jupiter
        break;
      case 10:
      case 11:
        tenthLordId = 7; // Saturn
        break;
    }

    // 9th Lord ID lookup
    int ninthLordId = 1;
    switch (ninthSign) {
      case 1:
      case 8:
        ninthLordId = 3; // Mars
        break;
      case 2:
      case 7:
        ninthLordId = 6; // Venus
        break;
      case 3:
      case 6:
        ninthLordId = 4; // Mercury
        break;
      case 4:
        ninthLordId = 2; // Moon
        break;
      case 5:
        ninthLordId = 1; // Sun
        break;
      case 9:
      case 12:
        ninthLordId = 5; // Jupiter
        break;
      case 10:
      case 11:
        ninthLordId = 7; // Saturn
        break;
    }

    final tenthLordPlanet = planets.firstWhere((p) => p.id == tenthLordId, orElse: () => planets.first);
    final ninthLordPlanet = planets.firstWhere((p) => p.id == ninthLordId, orElse: () => planets.first);
    final planetsIn10 = planets.where((p) => p.houseNumber == 10).toList();
    final planetsIn9 = planets.where((p) => p.houseNumber == 9).toList();

    // 1. Classical Bhagyodaya Age based on 9th Lord
    String bhagyaYearHi;
    String bhagyaYearGu;
    switch (ninthLordId) {
      case 1: // Sun -> 22
        bhagyaYearHi = '22वें एवं 29वें वर्ष में प्रचंड भाग्योदय';
        bhagyaYearGu = '૨૨મા તેમજ ૨૯મા વર્ષે પ્રચંડ ભાગ્યોદય';
        break;
      case 2: // Moon -> 24
        bhagyaYearHi = '24वें एवं 28वें वर्ष में शुभ भाग્યોદય';
        bhagyaYearGu = '૨૪મા તેમજ ૨૮મા વર્ષે શુભ ભાગ્યોદય';
        break;
      case 3: // Mars -> 28
        bhagyaYearHi = '28वें एवं 34वें वर्ष में पराक्रम से भाग्योदय';
        bhagyaYearGu = '૨૮મા તેમજ ૩૪મા વર્ષે પરાક્રમથી ભાગ્યોદય';
        break;
      case 4: // Mercury -> 32
        bhagyaYearHi = '25वें एवं 32वें वर्ष में व्यावसायिक भाग्योदय';
        bhagyaYearGu = '૨૫મા તેમજ ૩૨મા વર્ષે વ્યાપારિક ભાગ્યોદય';
        break;
      case 5: // Jupiter -> 16, 22, 32
        bhagyaYearHi = '24वें, 32वें एवं 36वें वर्ष में गुरु कृपा से भाग्योदय';
        bhagyaYearGu = '૨૪મા, ૩૨મા તેમજ ૩૬મા વર્ષે ગુરુકૃપાથી ભાગ્યોદય';
        break;
      case 6: // Venus -> 25
        bhagyaYearHi = '25वें एवं 33वें वर्ष में धनधान्य व भाग्योदय';
        bhagyaYearGu = '૨૫મા તેમજ ૩૩મા વર્ષે ધનધાન્ય અને ભાગ્યોદય';
        break;
      case 7: // Saturn -> 36
      default:
        bhagyaYearHi = '28वें, 32वें एवं 36वें वर्ष में स्थायी महा-भाग्योदय';
        bhagyaYearGu = '૨૮મા, ૩૨મા તેમજ ૩૬મા વર્ષે સ્થિર મહા-ભાગ્યોદય';
        break;
    }

    // 2. Dynamic Career Strengths based on 10th Lord
    String careerSectorGu;
    String careerSectorHi;
    String careerDescGu;
    String careerDescHi;

    switch (tenthLordId) {
      case 1: // Sun (Leo 10th)
        careerSectorGu = 'વહીવટી સેવા, સરકારી પદ, રાજનીતિ અને મેનેજમેન્ટ';
        careerSectorHi = 'प्रशासनिक सेवा, सरकारी पद, राजनीति एवं प्रबंधन';
        careerDescGu = 'તમારી કુંડળીમાં દશમ (કર્મ) ભાવના અધિપતિ સૂર્યદેવ છે (સિંહ રાશિ). તમે નેતૃત્વ, વહીવટી સેવાઓ, સરકારી હોદ્દાઓ, રાજનીતિ, કોર્પોરેટ ડાયરેક્ટર અથવા સ્વતંત્ર વ્યાપારમાં સર્વોચ્ચ શિખરે પહોંચશો. તમે બીજાના હાથ નીચે કામ કરવા કરતાં સ્વતંત્ર લીડર તરીકે અદભુત પ્રગતિ કરશો.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी सूर्य देव हैं (सिंह राशि)। आप प्रशासनिक सेवा, सरकारी पद, राजनीति, उच्च प्रबंधन अथवा स्वतंत्र व्यवसाय में सर्वोच्च सफलता प्राप्त करेंगे। नेतृत्व क्षमता आपकी पहचान है।';
        break;
      case 2: // Moon (Cancer 10th)
        careerSectorGu = 'પીઆર, હોસ્પિટાલિટી, મેડિકલ, ક્રિએટિવ આર્ટ્સ અને વ્યાપાર';
        careerSectorHi = 'पीआर, हॉस्पिटैलिटी, चिकित्सा, रचनात्मक कला एवं व्यापार';
        careerDescGu = 'તમારી કુંડળીમાં દશમ ભાવના સ્વામી ચંદ્રદેવ છે (કર્ક રાશિ). જાહેર સંબંધો (PR), હોસ્પિટાલિટી, મેડિકલ/ફાર્મા, ડેરી, પ્રવાસન, કાઉન્સેલિંગ અને સર્જનાત્મક ક્ષેત્રોમાં તમારી કારકિર્દી ખુબ પ્રગતિશીલ રહેશે. લોકો સાથેનું તમારું જીવંત જોડાણ જ તમારી સફળતાની ચાવી બનશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी चन्द्र देव हैं (कर्क राशि)। जनसंपर्क, हॉस्पिटैलिटी, औषधि, रचनात्मक कला, जल उद्योग एवं परामर्श क्षेत्र में आपका करियर अत्यंत उज्ज्वल रहेगा।';
        break;
      case 3: // Mars (Aries/Scorpio 10th)
        careerSectorGu = 'રિયલ એસ્ટેટ, એન્જિનિયરિંગ, સંરક્ષણ/પોલીસ, ટેક સ્ટાર્ટઅપ';
        careerSectorHi = 'रियल एस्टेट, इंजीनियरिंग, पुलिस/सेना, टेक स्टार्टअप';
        careerDescGu = 'તમારી કુંડળીમાં કર્મ ભાવના અધિપતિ પરાક્રમી મંગળદેવ છે ($tenthSignGu રાશિ). રિયલ એસ્ટેટ, જમીન-મકાન નિર્માણ, સિવિલ/મિકેનિકલ એન્જિનિયરિંગ, સંરક્ષણ, સર્જરી, ટેકનોલોજી સ્ટાર્ટઅપ અને સાહસિક વ્યાપારમાં તમે અભૂતપૂર્વ સફળતા મેળવશો. તમારી નિર્ણયશક્તિ અને સાહસ તમને અગ્રણી બનાવશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी मंगल देव हैं ($tenthSignHi राशि)। रियल एस्टेट, निर्माण, इंजीनियरिंग, रक्षा, सर्जरी एवं तकनीकी स्टार्टअप में आपको असाधारण सफलता मिलेगी। आपका अदम्य साहस विजय दिलाएगा।';
        break;
      case 4: // Mercury (Gemini/Virgo 10th)
        careerSectorGu = 'આઇટી/સોફ્ટવેર, ડેટા સાયન્સ, CA, શેરબજાર અને ડિજિટલ માર્કેટિંગ';
        careerSectorHi = 'आईटी/सॉफ्टवेयर, डेटा साइंस, सीए, शेयर बाजार एवं डिजिटल मार्केटिंग';
        careerDescGu = 'તમારી કુંડળીમાં કર્મ ભાવના સ્વામી બુદ્ધિના દાતા બુધદેવ છે ($tenthSignGu રાશિ). આઇટી/સોફ્ટવેર ડેવલપમેન્ટ, ડેટા સાયન્સ, ફાઇનાન્સ, ચાર્ટર્ડ એકાઉન્ટન્સી (CA), શેરબજાર/ટ્રેડિંગ, બેંકિંગ, ઈ-કોમર્સ અને મીડિયામાં તમારી કારકિર્દી સર્વોચ્ચ રહેશે. તમારી તીક્ષ્ણ બુદ્ધિ અને ગણતરી તમને સમૃદ્ધ બનાવશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी बुध देव हैं ($tenthSignHi राशि)। आईटी/सॉफ्टवेयर, डेटा, वित्त, सीए, शेयर बाजार, बैंकिंग एवं संचार क्षेत्र में आपका करियर सर्वोच्च रहेगा। आपकी कुशाग्र बुद्धि आपको धनवान बनाएगी।';
        break;
      case 5: // Jupiter (Sagittarius/Pisces 10th)
        careerSectorGu = 'કાયદો, ઉચ્ચ શિક્ષણ, બેંકિંગ, ફાઇનાન્સ અને કન્સલ્ટિંગ';
        careerSectorHi = 'विधि/न्याय, उच्च शिक्षा, बैंकिंग, वित्त एवं परामर्श';
        careerDescGu = 'તમારી કુંડળીમાં કર્મ ભાવના સ્વામી દેવગુરુ બૃહસ્પતિ છે ($tenthSignGu રાશિ). કાયદો/ન્યાયતંત્ર, શિક્ષણ, પ્રોફેસરશીપ, ફાઇનાન્સિયલ એડવાઇઝરી, બેંકિંગ, આધ્યાત્મિક સંસ્થાઓ અને ઉચ્ચ કન્સલ્ટિંગમાં તમે ઊંચી પદવી અને સન્માન પ્રાપ્ત કરશો. લોકો તમારા જ્ઞાન અને સલાહની કદર કરશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी देवगुरु बृहस्पति हैं ($tenthSignHi राशि)। कानून, उच्च शिक्षा, बैंकिंग, वित्तीय सलाहकार एवं परामर्श में आप सर्वोच्च पद प्राप्त करेंगे। समाज आपके ज्ञान का सम्मान करेगा।';
        break;
      case 6: // Venus (Taurus/Libra 10th)
        careerSectorGu = 'આર્કિટેક્ચર, ડિઝાઇન, લક્ઝરી બ્રાન્ડ્સ, મીડિયા અને ફેશન';
        careerSectorHi = 'आर्किटेक्चर, डिजाइन, लक्जरी ब्रांड्स, मीडिया एवं फैशन';
        careerDescGu = 'તમારી કુંડળીમાં કર્મ ભાવના અધિપતિ શુક્રદેવ છે ($tenthSignGu રાશિ). આર્કિટેક્ચર, ઇન્ટીરીયર ડિઝાઇનિંગ, લક્ઝરી બ્રાન્ડ્સ, મીડિયા-મનોરંજન, ફેશન, જ્વેલરી, હોટેલ મેનેજમેન્ટ અને આધુનિક ઈ-કોમર્સમાં તમારી કારકિર્દી અત્યંત ઝળહળતી રહેશે. તમારી કલાત્મક દ્રષ્ટિ મોટો આર્થિક લાભ કરાવશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी शुक्र देव हैं ($tenthSignHi राशि)। वास्तुकला, डिजाइनिंग, मीडिया, मनोरंजन, लक्जरी उत्पाद एवं फैशन इंडस्ट्री में आपका करियर अत्यंत फलदायी रहेगा। आपकी कलात्मक सोच अपार धन देगी।';
        break;
      case 7: // Saturn (Capricorn/Aquarius 10th)
      default:
        careerSectorGu = 'મોટા ઉદ્યોગો, મેન્યુફેક્ચરિંગ, ઇન્ફ્રાસ્ટ્રક્ચર અને સંશોધન';
        careerSectorHi = 'भारी उद्योग, विनिर्माण, इंफ्रास्ट्रक्चर एवं शोध';
        careerDescGu = 'તમારી કુંડળીમાં કર્મ ભાવના સ્વામી શનિદેવ છે ($tenthSignGu રાશિ). મોટા ઉદ્યોગો, મેન્યુફેક્ચરિંગ, ઇન્ફ્રાસ્ટ્રક્ચર, આઇટી હાર્ડવેર, કાયદો, સંશોધન, લોજિસ્ટિક્સ અને પબ્લિક સેક્ટરમાં તમે ધીમે-ધીમે પરંતુ કાયમી અને અડગ સામ્રાજ્ય ઊભું કરશો. તમારી મહેનત અને ધીરજ તમને શિખરે પહોંચાડશે.';
        careerDescHi = 'आपकी कुंडली में दशम भाव के स्वामी शनि देव हैं ($tenthSignHi राशि)। भारी उद्योग, विनिर्माण, इंफ्रास्ट्रक्चर, शोध, आईटी एवं सार्वजनिक क्षेत्र में आप स्थायी और विशाल साम्राज्य स्थापित करेंगे। आपकी निष्ठा आपको सर्वोच्च बनाएगी।';
        break;
    }

    // 3. Additional Dynamic planetary influence in 10th and 9th
    String planetKarmaGu = '';
    String planetKarmaHi = '';
    if (planetsIn10.isNotEmpty) {
      final namesGu = planetsIn10.map((p) => p.nameGu).join(', ');
      final namesHi = planetsIn10.map((p) => p.nameHi).join(', ');
      planetKarmaGu = ' કર્મ ભાવમાં $namesGu ની ઉપસ્થિતિ કારકિર્દીમાં વિશેષ પદોન્નતિ અને અધિકારો અપાવશે.';
      planetKarmaHi = ' कर्म भाव में $namesHi की उपस्थिति करियर में उच्च पद एवं अधिकार दिलाएगी।';
    }
    if (planetsIn9.isNotEmpty) {
      final namesGu = planetsIn9.map((p) => p.nameGu).join(', ');
      final namesHi = planetsIn9.map((p) => p.nameHi).join(', ');
      planetKarmaGu += ' ભાગ્ય ભાવમાં $namesGu નો પ્રભાવ અણધાર્યા સ્ત્રોતોમાંથી ધન આગમન કરાવશે.';
      planetKarmaHi += ' भाग्य भाव में $namesHi का प्रभाव अप्रत्याशित धन लाभ कराएगा।';
    }

    final fullDescGu = '$careerDescGu$planetKarmaGu દશમેશ ${tenthLordPlanet.nameGu} અને નવમેશ ${ninthLordPlanet.nameGu} ($ninthSignGu રાશિ) ના શુભ પ્રભાવથી ૩૦ વર્ષની વય બાદ અવિરત આર્થિક પ્રગતિ અને સ્થાવર મિલકતના પ્રબળ યોગ બને છે.';
    final fullDescHi = '$careerDescHi$planetKarmaHi दशमेश ${tenthLordPlanet.nameHi} एवं नवमेश ${ninthLordPlanet.nameHi} ($ninthSignHi राशि) के प्रभाव से 30 वर्ष की आयु के बाद निरंतर आर्थिक समृद्धि एवं अचल संपत्ति का प्रबल योग है।';

    final hlGu = [
      'ચોક્કસ ભાગ્યોદય કાળ: $bhagyaYearGu',
      'શ્રેષ્ઠ ક્ષેત્રો: $careerSectorGu',
      'અચલ સંપત્તિ (જમીન-મકાન) અને વાહન સુખનો પ્રબળ યોગ',
      'દશમેશ ${tenthLordPlanet.nameGu}ના પ્રભાવથી સ્વતંત્ર ઉન્નતિ',
    ];

    final hlHi = [
      'सटीक भाग्योदय काल: $bhagyaYearHi',
      'अनुकूल क्षेत्र: $careerSectorHi',
      'अचल संपत्ति एवं वाहन सुख का प्रबल योग',
      'दशमेश ${tenthLordPlanet.nameHi} के प्रभाव से स्वतंत्र उन्नति',
    ];

    return LifeAspectPrediction(
      titleHi: 'भाग्योदय एवं करियर योग',
      titleGu: 'ભાગ્યોદય અને કારકિર્દી યોગ',
      descriptionHi: fullDescHi,
      descriptionGu: fullDescGu,
      highlightsHi: hlHi,
      highlightsGu: hlGu,
      timingOrAge: bhagyaYearGu,
      iconName: 'trending_up',
    );
  }

  static LifeAspectPrediction _getHealthPrediction(int lagna) {
    const healthData = [
      {
        'hi': 'उत्तम शारीरिक शक्ति और रोग प्रतिरोधक क्षमता। सिरदर्द, तनाव और रक्तचाप से बचाव रखें। नियमित प्राणायाम, पर्याप्त जलपान और शांत दिनचर्या आपके लिए संजीवनी के समान है।',
        'gu': 'ઉત્તમ શારીરિક શક્તિ અને રોગપ્રતિકારક ક્ષમતા. માથાનો દુઃખાવો, માનસિક તણાવ અને બ્લડપ્રેશરથી સાવચેત રહેવું. નિયમિત પ્રાણાયામ, પૂરતું પાણી અને શાંત દિનચર્યા તમારા માટે સંજીવની સમાન છે.',
        'hlHi': ['उत्तम जीवन शक्ति', 'तनाव से मुक्ति आवश्यक', 'प्राणायाम लाभकारी'],
        'hlGu': ['ઉત્તમ જીવનશક્તિ', 'તણાવમુક્ત રહેવું જરૂરી', 'પ્રાણાયામ અત્યંત લાભકારી'],
      },
      {
        'hi': 'गले, थायरॉइड और पाचन तंत्र का विशेष ध्यान रखें। मधुर और संतुलित खानपान अपनाएं। नियमित भ्रमण और व्यायाम से स्वास्थ्य सदा उत्तम रहेगा।',
        'gu': 'ગળા, થાઇરોઇડ અને પાચનતંત્રનું વિશેષ ધ્યાન રાખવું. સંતુલિત અને સાત્વિક આહાર અપનાવવો. નિયમિત વૉકિંગ અને યોગાસનથી સ્વાસ્થ્ય સદા ઉત્તમ રહેશે.',
        'hlHi': ['गले व स्वरतंतु की सुरक्षा', 'संतुलित सात्विक आहार', 'नियमित भ्रमण हितकर'],
        'hlGu': ['ગળા અને અવાજની કાળજી', 'સાત્વિક સંતુલિત આહાર', 'નિયમિત ચાલવું હિતકારક'],
      },
      {
        'hi': 'श्वसन तंत्र और तंत्रिका तंत्र का ध्यान रखें। मानसिक विश्राम, गहरी नींद और अत्यधिक चिंता से बचें। योग एवं ध्यान मानसिक शांति प्रदान करेगा।',
        'gu': 'શ્વસનતંત્ર અને ચેતાતંત્રનું ધ્યાન રાખવું. માનસિક આરામ, ગાઢ ઊંઘ અને અતિશય ચિંતાથી બચવું. યોગ અને ધ્યાનથી માનસિક શાંતિ જળવાઈ રહેશે.',
        'hlHi': ['श्वसन प्रणाली का ध्यान', 'मानसिक शांति व विश्राम', 'नियमित ध्यान आवश्यक'],
        'hlGu': ['શ્વસનતંત્રની કાળજી', 'માનસિક શાંતિ અને આરામ', 'નિયમિત ધ્યાન જરૂરી'],
      },
      {
        'hi': 'पाचन संस्थान, छाती और उदर की सुरक्षा रखें। मौसमी परिवर्तनों में सावधानी बरतें। जल का समुचित सेवन और मन की प्रसन्नता स्वास्थ्य का मूल मंत्र है।',
        'gu': 'પાચનતંત્ર, છાતી અને પેટનું ધ્યાન રાખવું. ઋતુ પરિવર્તનમાં સાવચેતી રાખવી. પૂરતું પાણી પીવું અને મનની પ્રસન્નતા જાળવવી એ સ્વાસ્થ્યનો મૂળ મંત્ર છે.',
        'hlHi': ['पाचन स्वास्थ्य पर ध्यान', 'मौसम के अनुसार बचाव', 'मानसिक प्रसन्नता संजीवनी'],
        'hlGu': ['પાચન સ્વાસ્થ્ય પર ધ્યાન', 'ઋતુ અનુસાર સાવચેતી', 'મનની પ્રસન્નતા સંજીવની'],
      },
      {
        'hi': 'हृदय, रीढ़ की हड्डी और आंखों की रक्षा करें। अत्यधिक क्रोध और कार्यभार से बचें। सूर्य नमस्कार और प्रातःकालीन धूप आपके तेज को बढ़ाती है।',
        'gu': 'હૃદય, કરોડરજ્જુ અને આંખોની કાળજી રાખવી. વધુ પડતા ક્રોધ અને કાર્યભારથી બચવું. સૂર્ય નમસ્કાર અને સવારનો સૂર્યપ્રકાશ તમારા તેજમાં વધારો કરે છે.',
        'hlHi': ['हृदय व नेत्र सुरक्षा', 'क्रोध से दूरी आवश्यक', 'सूर्यनमस्कार अत्यंत शुभ'],
        'hlGu': ['હૃદય અને આંખોની કાળજી', 'ક્રોધથી દૂર રહેવું જરૂરી', 'સૂર્ય નમસ્કાર ઉત્તમ'],
      },
      {
        'hi': 'आंतों, पाचन और त्वचा का ध्यान रखें। अत्यधिक सोचने और तनाव से बचें। हरी सब्जियां, फल और समय पर भोजन स्वास्थ्यवर्धक रहेगा।',
        'gu': 'આંતરડા, પાચન અને ત્વચાની કાળજી રાખવી. વધુ પડતી ચિંતા અને તણાવથી દૂર રહેવું. લીલા શાકભાજી, ફળો અને સમયસર ભોજન સ્વાસ્થ્યવર્ધક રહેશે.',
        'hlHi': ['पाचन व त्वचा का ध्यान', 'सकारात्मक चिंतन जरूरी', 'ताजे फल व सलाद लाभकारी'],
        'hlGu': ['પાચન અને ત્વચાની કાળજી', 'હકારાત્મક ચિંતન જરૂરી', 'તાજા ફળો અને સલાડ લાભકારી'],
      },
      {
        'hi': 'गुर्दे (किडनी), कमर और त्वचा की सुरक्षा करें। भरपूर पानी पिएं और चीनी-चिकनाई का संतुलित सेवन करें। स्वच्छ वातावरण में रहना फलदायी है।',
        'gu': 'કિડની, કમર અને ત્વચાનું ધ્યાન રાખવું. ભરપૂર પાણી પીવું અને ગળ્યા તેમજ તળેલા ખોરાકનું સંતુલન રાખવું. સ્વચ્છ વાતાવરણમાં રહેવું હિતકારી છે.',
        'hlHi': ['जल का प्रचुर सेवन', 'किडनी व त्वचा सुरक्षा', 'संतुलित जीवनशैली'],
        'hlGu': ['ભરપૂર પાણી પીવું', 'કિડની અને ત્વચાની કાળજી', 'સંતુલિત જીવનશૈલી'],
      },
      {
        'hi': 'उत्सर्जन तंत्र और रक्त संचार का ध्यान रखें। सात्विक खानपान और नियमित कसरत करें। ध्यान और मौन आपको अद्भुत आरोग्य प्रदान करेगा।',
        'gu': 'ઉત્સર્જન તંત્ર અને રક્ત પરિભ્રમણનું ધ્યાન રાખવું. સાત્વિક ખાનપાન અને નિયમિત કસરત કરવી. ધ્યાન અને મૌન તમને અદભુત આરોગ્ય પ્રદાન કરશે.',
        'hlHi': ['रक्त संचार का ध्यान', 'सात्विक आहार अपनाएं', 'ध्यान व प्राणायाम शुभ'],
        'hlGu': ['રક્ત પરિભ્રમણની કાળજી', 'સાત્વિક આહાર અપનાવવો', 'ધ્યાન અને પ્રાણાયામ શુભ'],
      },
      {
        'hi': 'जांघों, कूल्हों और यकृत (लिवर) का ध्यान रखें। तेल-मसाले से बचें और आउटडोर व्यायाम करें। सकारात्मक दृष्टिकोण आपके स्वास्थ्य की ढाल है।',
        'gu': 'સાથળ, કમર અને લિવરનું ધ્યાન રાખવું. તેલ-મસાલાવાળા ખોરાકથી બચવું અને ઓપન-એર કસરત કરવી. હકારાત્મક અભિગમ તમારા સ્વાસ્થ્યની રક્ષા કરશે.',
        'hlHi': ['लिवर स्वास्थ्य का ध्यान', 'व्यायाम व खेलकूद हितकर', 'सकारात्मक ऊर्जा'],
        'hlGu': ['લિવરના સ્વાસ્થ્યની કાળજી', 'કસરત અને રમતગમત હિતકારી', 'સકારાત્મક ઉર્જા'],
      },
      {
        'hi': 'घुटनों, जोड़ों, हड्डियों और त्वचा की देखभाल करें। वात दोष से बचाव के लिए गर्म और ताजा भोजन करें। तिल के तेल की मालिश और योग अत्यंत लाभकारी है।',
        'gu': 'ઘૂંટણ, સાંધા, હાડકાં અને ત્વચાની વિશેષ કાળજી રાખવી. વાયુ દોષથી બચવા ગરમ અને તાજો ખોરાક લેવો. તલના તેલની માલિશ અને યોગાસન અત્યંત લાભકારી છે.',
        'hlHi': ['जोड़ों व हड्डियों की सुरक्षा', 'वात शामक आहार', 'योग व मालिश लाभकारी'],
        'hlGu': ['સાંધા અને હાડકાંની કાળજી', 'વાયુ શામક ગરમ આહાર', 'યોગ અને માલિશ લાભકારી'],
      },
      {
        'hi': 'पिंडलियों, टखनों और रक्त प्रवाह का ध्यान रखें। पर्याप्त आराम, सुबह की सैर और ताजी हवा में सांस लेना आपके लिए परम औषधि है।',
        'gu': 'પિંડીઓ, ઘૂંટીઓ અને રક્ત પરિભ્રમણનું ધ્યાન રાખવું. પૂરતો આરામ, સવારનું ભ્રમણ અને તાજી હવામાં શ્વાસ લેવો એ તમારા માટે ઉત્તમ ઔષધિ છે.',
        'hlHi': ['पैरों व रक्त प्रवाह का ध्यान', 'ताजी हवा में भ्रमण', 'पर्याप्त विश्राम'],
        'hlGu': ['પગ અને રક્ત પરિભ્રમણની કાળજી', 'તાજી હવામાં ચાલવું', 'પૂરતો આરામ લેવો'],
      },
      {
        'hi': 'पैरों के तलवों, लसिका तंत्र और नींद का ध्यान रखें। ठंडे पेय पदार्थों से बचें और पैरों की स्वच्छता रखें। ध्यान और समुद्र/नदी का शांत सानिध्य आरोग्य देगा।',
        'gu': 'પગના તળિયાં, લસિકા તંત્ર અને ઊંઘનું ધ્યાન રાખવું. ઠંડા પીણાંથી બચવું અને પગની સ્વચ્છતા રાખવી. ધ્યાન અને જળ તત્વનું સાનિધ્ય ઉત્તમ આરોગ્ય આપશે.',
        'hlHi': ['चरणों की स्वच्छता', 'गहरी एवं शांत नींद', 'जलीय सानिध्य में ध्यान'],
        'hlGu': ['પગના તળિયાંની સ્વચ્છતા', 'ગાઢ અને શાંત ઊંઘ', 'જળાશય પાસે ધ્યાન'],
      },
    ];

    final idx = (lagna - 1).clamp(0, 11);
    final data = healthData[idx];

    return LifeAspectPrediction(
      titleHi: 'स्वास्थ्य एवं सावधानियां',
      titleGu: 'આરોગ્ય અને સાવચેતી',
      descriptionHi: data['hi'] as String,
      descriptionGu: data['gu'] as String,
      highlightsHi: List<String>.from(data['hlHi'] as List),
      highlightsGu: List<String>.from(data['hlGu'] as List),
      iconName: 'health_and_safety',
    );
  }

  static Map<String, dynamic> _detectRajaYogas(int lagna, int moonRashi, List<PlanetPosition> planets) {
    final yogasHi = <String>[];
    final yogasGu = <String>[];
    final items = <AstrologicalYogaItem>[];

    final sun = planets.firstWhere((p) => p.id == 1, orElse: () => planets.first);
    final moon = planets.firstWhere((p) => p.id == 2, orElse: () => planets.first);
    final mars = planets.firstWhere((p) => p.id == 3, orElse: () => planets.first);
    final mercury = planets.firstWhere((p) => p.id == 4, orElse: () => planets.first);
    final jupiter = planets.firstWhere((p) => p.id == 5, orElse: () => planets.first);
    final venus = planets.firstWhere((p) => p.id == 6, orElse: () => planets.first);
    final saturn = planets.firstWhere((p) => p.id == 7, orElse: () => planets.first);
    final rahu = planets.firstWhere((p) => p.id == 8, orElse: () => planets.first);
    final ketu = planets.firstWhere((p) => p.id == 9, orElse: () => planets.first);

    // 1. Budhaditya Rajyog (Sun + Mercury in same house)
    if (sun.houseNumber == mercury.houseNumber) {
      const nameHi = 'बुधादित्य राजयोग';
      const nameGu = 'બુધાદિત્ય રાજયોગ';
      const descHi = 'सूर्य और बुध की युति से कुशाग्र बुद्धि, प्रशासनिक सफलता एवं समाज में उच्च प्रतिष्ठा प्राप्त होती है।';
      const descGu = 'સૂર્ય અને બુધની યુતિથી તીક્ષ્ણ બુદ્ધિપ્રતિભા, પ્રશાસનિક ક્ષમતા, વાકચાતુર્ય અને સમાજમાં ઊંચી પ્રતિષ્ઠા પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi (सूर्य + बुध की युति - $descHi)');
      yogasGu.add('$nameGu (સૂર્ય + બુધની યુતિ - $descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'budhaditya',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'प्रखर बौद्धिक क्षमता, व्यापार एवं उच्च पद प्राप्ति योग।',
          impactGu: 'પ્રખર બૌદ્ધિક ક્ષમતા, વ્યાપાર-નોકરીમાં વિજય અને ઉચ્ચ પદવી યોગ.',
          remedyHi: 'प्रतिदिन सूर्य को जल अर्पित करें और श्री गणेश जी की आराधना करें।',
          remedyGu: 'રોજ સૂર્યને અર્ઘ્ય આપવું અને ગણેશજીની આરાધના કરવી.',
          associatedPlanets: ['સૂર્ય', 'બુધ', 'Sun', 'Mercury'],
        ),
      );
    }

    // 2. Gajakesari / Vrajkesari Yog (Jupiter in 1, 4, 7, 10 from Moon)
    final jupFromMoon = ((jupiter.houseNumber - moon.houseNumber + 12) % 12) + 1;
    if ([1, 4, 7, 10].contains(jupFromMoon)) {
      const nameHi = 'गजकेसरी योग (वज्रकेसरी)';
      const nameGu = 'ગજકેસરી / વ્રજકેસરી યોગ';
      const descHi = 'गुरु-चन्द्र के केंद्र संबंध से अपार कीर्ति, ज्ञान, संपत्ति और दीर्घकालिक मान-सम्मान की प्राप्ति होती है।';
      const descGu = 'ગુરુ અને ચંદ્રના કેન્દ્ર સંબંધથી અપરંપાર યશ-કીર્તિ, આધ્યાત્મિક જ્ઞાન, અચલ સંપત્તિ અને સન્માન પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi (गुरु-चंद्र केंद्र - $descHi)');
      yogasGu.add('$nameGu (ગુરુ-ચંદ્ર કેન્દ્ર - $descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'gajakesari',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'समाज में आदर, राजपक्ष से लाभ, शत्रुहंता एवं अखंड यश प्राप्ति।',
          impactGu: 'સમાજમાં સન્માન, શાસકીય લાભ, શત્રુવિજય અને અખંડ યશપ્રાપ્તિ.',
          remedyHi: 'शिव जी एवं भगवान विष्णु की संयुक्त उपासना अत्यंत फलदायी है।',
          remedyGu: 'શિવજી અને ભગવાન શ્રી વિષ્ણુની સંયુક્ત ઉપાસના કરવી.',
          associatedPlanets: ['ગુરુ', 'ચંદ્ર', 'Jupiter', 'Moon'],
        ),
      );
    }

    // 3. Chandra-Mangal Dhan Yog (Moon + Mars conjunction or mutual 7th aspect)
    if (moon.houseNumber == mars.houseNumber || ((moon.houseNumber - mars.houseNumber).abs() == 6)) {
      const nameHi = 'चन्द्र-मंगल धन योग (महालक्ष्मी योग)';
      const nameGu = 'ચંદ્ર-મંગળ ધન યોગ (મહાલક્ષ્મી યોગ)';
      const descHi = 'चन्द्र और मंगल के संबंध से आर्थिक प्रचुरता, व्यापारिक सफलता एवं अचल संपत्ति का वरदान मिलता है।';
      const descGu = 'ચંદ્ર અને મંગળના સંબંધથી આર્થિક સમૃદ્ધિ, વ્યાપારી વિજય અને જમીન-મકાનનું સુખ પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'chandra_mangal',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'निरंतर धन आगमन, रियल एस्टेट एवं व्यवसाय में विशेष उन्नति।',
          impactGu: 'અવિરત ધન આગમન, જમીન-મકાન અને બિઝનેસમાં વિશેષ ઉન્નતિ.',
          remedyHi: 'माता लक्ष्मी जी एवं हनुमान जी की आराधना लाभकारी है।',
          remedyGu: 'માતા મહાલક્ષ્મીજી અને હનુમાનજીની આરાધના કરવી.',
          associatedPlanets: ['ચંદ્ર', 'મંગળ', 'Moon', 'Mars'],
        ),
      );
    }

    // 4. Panch Mahapurusha Yogas (Kendra 1,4,7,10 from Lagna in own/exalted sign)
    // Ruchak (Mars)
    if ([1, 4, 7, 10].contains(mars.houseNumber) && [1, 8, 10].contains(mars.rashiId)) {
      const nameHi = 'रुचक महापुरुष राजयोग';
      const nameGu = 'રુચક મહાપુરુષ રાજયોગ';
      const descHi = 'मंगल केंद्रस्थ होने से असीम साहस, विजय, भूमि-भवन, सेना/पुलिस/खेल में उच्च सम्मान मिलता है।';
      const descGu = 'મંગળ કેન્દ્રસ્થ હોવાથી અસીમ સાહસ, વિજય, જમીન-સંપત્તિ અને શાસકીય ક્ષેત્રે ઉચ્ચ પદ મળે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'ruchak',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'अद्वितीय नेतृत्व क्षमता एवं भूमि-संपत्ति का अखंड सुख।',
          impactGu: 'અદભુત નેતૃત્વ ક્ષમતા અને અચલ સંપત્તિનો અખંડ આનંદ.',
          associatedPlanets: ['મંગળ', 'Mars'],
        ),
      );
    }

    // Bhadra (Mercury)
    if ([1, 4, 7, 10].contains(mercury.houseNumber) && [3, 6].contains(mercury.rashiId)) {
      const nameHi = 'भद्र महापुरुष राजयोग';
      const nameGu = 'ભદ્ર મહાપુરુષ રાજયોગ';
      const descHi = 'बुध केंद्रस्थ होने से अद्भुत वाकपटुता, वाणिज्य सफलता एवं बौद्धिक प्रभुत्व प्राप्त होता है।';
      const descGu = 'બુધ કેન્દ્રસ્થ હોવાથી અદભુત વાણી પ્રભાવ, વાણિજ્ય વિજય અને બૌદ્ધિક વર્ચસ્વ પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'bhadra',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'लेखन, वक्तृत्व, आईटी और व्यापार में अद्वितीय सफलता।',
          impactGu: 'લેખન, વક્તૃત્વ, આઇટી અને બિઝનેસમાં અભૂતપૂર્વ સફળતા.',
          associatedPlanets: ['બુધ', 'Mercury'],
        ),
      );
    }

    // Hamsa (Jupiter)
    if ([1, 4, 7, 10].contains(jupiter.houseNumber) && [4, 9, 12].contains(jupiter.rashiId)) {
      const nameHi = 'हंस महापुरुष राजयोग';
      const nameGu = 'હંસ મહાપુરુષ રાજયોગ';
      const descHi = 'गुरु केंद्रस्थ होने से उच्च आध्यात्मिक ज्ञान, सात्विक वैभव एवं सर्वत्र वंदनीय पद प्राप्त होता है।';
      const descGu = 'ગુરુ કેન્દ્રસ્થ હોવાથી ઉચ્ચ જ્ઞાન, સાત્વિક ઐશ્વર્ય અને સર્વત્ર પૂજનીય પ્રતિષ્ઠા પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'hamsa',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'धर्म, न्याय, शिक्षा और समाज में सर्वोच्च सम्मान की प्राप्ति।',
          impactGu: 'ધર્મ, ન્યાય, શિક્ષણ અને સમાજમાં સર્વોચ્ચ માન-સન્માન.',
          associatedPlanets: ['ગુરુ', 'Jupiter'],
        ),
      );
    }

    // Malavya (Venus)
    if ([1, 4, 7, 10].contains(venus.houseNumber) && [2, 7, 12].contains(venus.rashiId)) {
      const nameHi = 'मालव्य महापुरुष राजयोग';
      const nameGu = 'માલવ્ય મહાપુરુષ રાજયોગ';
      const descHi = 'शुक्र केंद्रस्थ होने से वाहन, विलासिता, कला, सौंदर्य एवं अखंड ऐश्वर्य का योग बनता है।';
      const descGu = 'શુક્ર કેન્દ્રસ્થ હોવાથી ભૌતિક સુખો, વૈભવી વાહન, કલા અને અખંડ ઐશ્વર્યનો યોગ બને છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'malavya',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'वैभवशाली जीवन, उत्तम दांपत्य और कलात्मक क्षेत्रों में कीर्ति।',
          impactGu: 'વૈભવી જીવનશૈલી, ઉત્તમ દાંપત્ય અને કલાત્મક ક્ષેત્રે યશ.',
          associatedPlanets: ['શુક્ર', 'Venus'],
        ),
      );
    }

    // Shasha (Saturn)
    if ([1, 4, 7, 10].contains(saturn.houseNumber) && [7, 10, 11].contains(saturn.rashiId)) {
      const nameHi = 'शश महापुरुष राजयोग';
      const nameGu = 'શશ મહાપુરુષ રાજયોગ';
      const descHi = 'शनि केंद्रस्थ होने से जनसमर्थन, नेतृत्व, न्यायप्रियता, दीर्घायु एवं स्थायी सत्ता प्राप्त होती है।';
      const descGu = 'શનિ કેન્દ્રસ્થ હોવાથી જનસમર્થન, મજબૂત નેતૃત્વ, દીર્ઘાયુ અને કાયમી સત્તા પ્રાપ્ત થાય છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'shasha',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'प्रशासन, राजनीति और बड़े उद्योगों में अपार सफलता।',
          impactGu: 'પ્રશાસન, રાજનીતિ અને મોટા ઉદ્યોગોમાં અપાર વિજય.',
          associatedPlanets: ['શનિ', 'Saturn'],
        ),
      );
    }

    // 5. Vipreet Rajyog (Lords of 6, 8, 12 in 6, 8, 12 - Harsha, Sarala, Vimala)
    final lord6Sign = (lagna + 6 - 2) % 12 + 1;
    final lord8Sign = (lagna + 8 - 2) % 12 + 1;
    final lord12Sign = (lagna + 12 - 2) % 12 + 1;
    final pLord6 = _findSignLord(lord6Sign, planets);
    final pLord8 = _findSignLord(lord8Sign, planets);
    final pLord12 = _findSignLord(lord12Sign, planets);

    if (pLord6 != null && [6, 8, 12].contains(pLord6.houseNumber)) {
      const nameHi = 'हर्ष विपरीत राजयोग (Harsha Rajyog)';
      const nameGu = 'હર્ષ વિપરીત રાજયોગ (Harsha Rajyog)';
      const descHi = 'षष्ठेश का त्रिक भाव में स्थित होना शत्रुओं पर विजय, रोगमुक्ति और आकस्मिक संकट निवारण देता है।';
      const descGu = 'ષષ્ઠેશ ત્રિક ભાવમાં હોવાથી શત્રુવિજય, રોગમુક્તિ અને વિપરીત પરિસ્થિતિમાં અચાનક વિજય અપાવે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'harsha_vipreet',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'चुनौतियों के उपरांत आकस्मिक सफलता एवं शत्रु दमन।',
          impactGu: 'પડકારો પછી અચાનક અપ્રતિમ સફળતા અને શત્રુઓ પર વિજય.',
          associatedPlanets: ['વિપરીત રાજયોગ'],
        ),
      );
    } else if (pLord8 != null && [6, 8, 12].contains(pLord8.houseNumber)) {
      const nameHi = 'सरल विपरीत राजयोग (Sarala Rajyog)';
      const nameGu = 'સરલ વિપરીત રાજયોગ (Sarala Rajyog)';
      const descHi = 'अष्टमेश का त्रिक भाव में होना दीर्घायु, निर्भयता, ज्ञान और आकस्मिक धन संपदा प्रदान करता है।';
      const descGu = 'અષ્ટમેશ ત્રિક ભાવમાં હોવાથી દીર્ઘાયુ, નિર્ભયતા, ગૂઢ જ્ઞાન અને આકસ્મિક ધનલાભ કરાવે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'sarala_vipreet',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'दीर्घायु, अचल संपत्ति एवं गूढ़ विद्याओं में सफलता।',
          impactGu: 'દીર્ઘાયુષ્ય, અચલ સંપત્તિ અને રહસ્યમય ક્ષેત્રોમાં સિદ્ધિ.',
          associatedPlanets: ['વિપરીત રાજયોગ'],
        ),
      );
    } else if (pLord12 != null && [6, 8, 12].contains(pLord12.houseNumber)) {
      const nameHi = 'विमल विपरीत राजयोग (Vimala Rajyog)';
      const nameGu = 'વિમલ વિપરીત રાજયોગ (Vimala Rajyog)';
      const descHi = 'द्वादशेश का त्रिक भाव में होना आर्थिक बचत, स्वतंत्रता, न्यायप्रियता एवं विदेश से लाभ देता है।';
      const descGu = 'દ્વાદશશ ત્રિક ભાવમાં હોવાથી સ્વતંત્ર વિચારસરણી, આર્થિક બચત અને વિદેશથી મોટો લાભ આપે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'vimala_vipreet',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'पवित्र आचरण, विदेश गमन एवं आर्थिक स्थिरता।',
          impactGu: 'પવિત્ર આચરણ, પરદેશ ગમન અને આર્થિક સ્થિરતા.',
          associatedPlanets: ['વિપરીત રાજયોગ'],
        ),
      );
    }

    // 6. Surya Grahan Yog / Dosha (Sun + Rahu / Sun + Ketu)
    if (sun.houseNumber == rahu.houseNumber || sun.houseNumber == ketu.houseNumber) {
      const nameHi = 'सूर्य ग्रहण योग / दोष (सावधानी)';
      const nameGu = 'સૂર્ય ગ્રહણ યોગ / દોષ (સાવધાની)';
      const descHi = 'सूर्य के साथ राहु/केतु की युति से आत्मविश्वास में कमी या पिता/नेत्र कष्ट संभव है।';
      const descGu = 'સૂર્ય સાથે રાહુ/કેતુની યુતિથી આત્મવિશ્વાસ, પિતાના સ્વાસ્થ્ય કે સરકારી કામકાજમાં સાવધાની રાખવી જરૂરી છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'surya_grahan',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'सरकारी कार्यों में विलंब एवं नेत्र/हड्डी की सुरक्षा रखें।',
          impactGu: 'સરકારી કામોમાં ધીરજ રાખવી અને આંખ-હાડકાંની કાળજી લેવી.',
          remedyHi: 'प्रतिदिन आदित्य हृदय स्तोत्र एवं गायत्री मंत्र का जप करें।',
          remedyGu: 'રોજ આદિત્ય હૃદય સ્તોત્ર અને ગાયત્રી મંત્રનો જાપ કરવો.',
          associatedPlanets: ['સૂર્ય', 'રાહુ', 'કેતુ', 'Sun', 'Rahu', 'Ketu'],
        ),
      );
    }

    // 7. Chandra Grahan Yog / Dosha (Moon + Rahu / Moon + Ketu)
    if (moon.houseNumber == rahu.houseNumber || moon.houseNumber == ketu.houseNumber) {
      const nameHi = 'चन्द्र ग्रहण योग / दोष (सावधानी)';
      const nameGu = 'ચંદ્ર ગ્રહણ યોગ / દોષ (સાવધાની)';
      const descHi = 'चन्द्रमा पर राहु/केतु के प्रभाव से मानसिक चंचलता, अनिद्रा या चिंता की स्थिति बन सकती है।';
      const descGu = 'ચંદ્ર પર રાહુ/કેતુના પ્રભાવથી માનસિક ચંચળતા, અતિશય ચિંતા કે અનિદ્રાથી બચવું જરૂરી છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'chandra_grahan',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'मानसिक शांति बनाए रखें, ध्यान एवं योग साधना अत्यंत हितकारी है।',
          impactGu: 'માનસિક શાંતિ જાળવવી, ધ્યાન અને પ્રાણાયામ અત્યંત હિતકારી છે.',
          remedyHi: 'भगवान शिव का जलाभिषेक करें और "ॐ नमः शिवाय" का नियमित जप करें।',
          remedyGu: 'શિવજીનો જળાભિષેક કરવો અને "ૐ નમઃ શિવાય" નો જાપ કરવો.',
          associatedPlanets: ['ચંદ્ર', 'રાહુ', 'કેતુ', 'Moon', 'Rahu', 'Ketu'],
        ),
      );
    }

    // 8. Guru-Chandal Yog / Dosha (Jupiter + Rahu / Ketu)
    if (jupiter.houseNumber == rahu.houseNumber || jupiter.houseNumber == ketu.houseNumber) {
      const nameHi = 'गुरु-चांडाल योग / दोष (सावधानी)';
      const nameGu = 'ગુરુ-ચાંડાલ યોગ / દોષ (સાવધાની)';
      const descHi = 'गुरु और राहु की युति से विचारों में भ्रम, धर्म/गुरु के प्रति संशय अथवा निर्णय में सावधानी अपेक्षित है।';
      const descGu = 'ગુરુ અને રાહુની યુતિથી નિર્ણયો લેવામાં સાવચેતી, વડીલોનું સન્માન અને ધાર્મિક સદાચાર જાળવવો જરૂરી છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'guru_chandal',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'शिक्षा एवं निवेश में विवेकपूर्ण निर्णय लेना लाभकारी होगा।',
          impactGu: 'શિક્ષણ અને રોકાણમાં વિવેકપૂર્ણ નિર્ણય લેવા હિતકારી રહેશે.',
          remedyHi: 'विष्णु सहस्रनाम का पाठ करें और पीली वस्तुओं का दान करें।',
          remedyGu: 'વિષ્ણુ સહસ્રનામનો પાઠ કરવો અને ગુરુવારે પીળી વસ્તુઓનું દાન કરવું.',
          associatedPlanets: ['ગુરુ', 'રાહુ', 'કેતુ', 'Jupiter', 'Rahu', 'Ketu'],
        ),
      );
    }

    // 9. Angarak Yog / Dosha (Mars + Rahu / Ketu)
    if (mars.houseNumber == rahu.houseNumber || mars.houseNumber == ketu.houseNumber) {
      const nameHi = 'अंगारक योग / दोष (सावधानी)';
      const nameGu = 'અંગારક યોગ / દોષ (સાવધાની)';
      const descHi = 'मंगल और राहु/केतु की युति से अत्यधिक उत्तेजना, क्रोध, चोट या रक्त विकार से बचाव रखना चाहिए।';
      const descGu = 'મંગળ અને રાહુ/કેતુની યુતિથી અતિશય ક્રોધ, ઉતાવળા નિર્ણયો કે અકસ્માતથી સાવચેત રહેવું જોઈએ.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'angarak',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'क्रोध पर नियंत्रण रखें, वाहन सावधानी से चलाएं एवं शांत रहें।',
          impactGu: 'ક્રોધ પર કાબૂ રાખવો, વાહન ધીમે ચલાવવું અને શાંતિ જાળવવી.',
          remedyHi: 'प्रति मंगलवार सुंदरकांड का पाठ करें अथवा हनुमान चालीसा पढ़ें।',
          remedyGu: 'દર મંગળવારે સુંદરકાંડ અથવા હનુમાન ચાલીસાનો પાઠ કરવો.',
          associatedPlanets: ['મંગળ', 'રાહુ', 'કેતુ', 'Mars', 'Rahu', 'Ketu'],
        ),
      );
    }

    // 10. Vish Yog / Dosha (Saturn + Moon)
    if (saturn.houseNumber == moon.houseNumber || ((saturn.houseNumber - moon.houseNumber).abs() == 6)) {
      const nameHi = 'विष योग / दोष (सावधानी)';
      const nameGu = 'વિષ યોગ / દોષ (સાવધાની)';
      const descHi = 'शनि और चन्द्रमा के संबंध से मानसिक अवसाद, निराशा अथवा भावनात्मक अकेलापन अनुभव हो सकता है।';
      const descGu = 'શનિ અને ચંદ્રના સંબંધથી માનસિક ઉદાસીનતા, અતિશય વિચાર કે એકલતાથી બચવું હિતકારી છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'vish_yog',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'सकारात्मक दृष्टिकोण रखें और पारिवारिक मेलजोल बनाए रखें।',
          impactGu: 'હકારાત્મક અભિગમ રાખવો અને પરિવાર સાથે સમય પસાર કરવો.',
          remedyHi: 'शनिवार को पीपल वृक्ष पर दीपक जलाएं और महामृत्युंजय मंत्र जपें।',
          remedyGu: 'શનિવારે પીપળે સરસવના તેલનો દીવો કરવો અને મહામૃત્યુંજય જાપ કરવો.',
          associatedPlanets: ['શનિ', 'ચંદ્ર', 'Saturn', 'Moon'],
        ),
      );
    }

    // 11. Shrapit Yog / Dosha (Saturn + Rahu)
    if (saturn.houseNumber == rahu.houseNumber) {
      const nameHi = 'श्रापित योग / दोष (सावधानी)';
      const nameGu = 'શ્રાપિત યોગ / દોષ (સાવધાની)';
      const descHi = 'शनि और राहु की युति से कार्यों में विलंब अथवा पूर्व जन्म के कर्मों का शोधन होता है।';
      const descGu = 'શનિ અને રાહુની યુતિથી કાર્યોમાં વિલંબ આવી શકે છે, પરંતુ નિષ્ઠાપૂર્વક પરિશ્રમથી પૂર્ણ સફળતા મળે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'shrapit_yog',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: false,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'धैर्य एवं सतत परिश्रम से ही सभी कार्य सिद्ध होंगे।',
          impactGu: 'ધીરજ અને સતત પરિશ્રમથી જ તમામ કાર્યોમાં સિદ્ધિ મળશે.',
          remedyHi: 'शिव जी की नियमित पूजा करें और असहायों की सेवा करें।',
          remedyGu: 'શિવજીની નિયમિત પૂજા કરવી અને જરૂરિયાતમંદોને અન્નદાન કરવું.',
          associatedPlanets: ['શનિ', 'રાહુ', 'Saturn', 'Rahu'],
        ),
      );
    }

    // 12. Mahalaxmi Dhan Yog (Jupiter or Venus in 1, 5, 9)
    if ([1, 5, 9].contains(jupiter.houseNumber) || [1, 5, 9].contains(venus.houseNumber)) {
      const nameHi = 'महालक्ष्मी धन योग';
      const nameGu = 'મહાલક્ષ્મી ધન યોગ';
      const descHi = 'त्रिकोण भाव में शुभ ग्रह की स्थिति से प्रचुर धन प्राप्ति, मान-सम्मान एवं सुख-शांति मिलती है।';
      const descGu = 'ત્રિકોણ ભાવમાં શુભ ગ્રહ હોવાથી અખંડ ધનલાભ, કૌટુંબિક સુખ-શાંતિ અને યશપ્રાપ્તિ થાય છે.';
      if (!yogasHi.any((y) => y.contains('महालक्ष्मी धन योग'))) {
        yogasHi.add('$nameHi ($descHi)');
        yogasGu.add('$nameGu ($descGu)');
        items.add(
          const AstrologicalYogaItem(
            id: 'mahalaxmi_dhan',
            nameHi: nameHi,
            nameGu: nameGu,
            isAuspicious: true,
            descriptionHi: descHi,
            descriptionGu: descGu,
            impactHi: 'आर्थिक समृद्धि, ऐश्वर्य और जीवन में निरंतर प्रगति।',
            impactGu: 'આર્થિક સમૃદ્ધિ, વૈભવ અને જીવનમાં સતત પ્રગતિ.',
            associatedPlanets: ['ગુરુ', 'શુક્ર', 'Jupiter', 'Venus'],
          ),
        );
      }
    }

    if (yogasHi.isEmpty) {
      const nameHi = 'शुभ कर्तरी योग';
      const nameGu = 'શુભ કર્તરી યોગ';
      const descHi = 'ग्रहों की शुभ अनुकूलता से जीवन में समय पर कार्य सिद्धि एवं ईश्वरीय कृपा प्राप्त होती है।';
      const descGu = 'ગ્રહોની શુભ અનુકૂળતાથી જીવનમાં સમયસર કાર્યસિદ્ધિ અને ઈશ્વરીય કૃપા જળવાઈ રહે છે.';
      yogasHi.add('$nameHi ($descHi)');
      yogasGu.add('$nameGu ($descGu)');
      items.add(
        const AstrologicalYogaItem(
          id: 'shubh_kartari',
          nameHi: nameHi,
          nameGu: nameGu,
          isAuspicious: true,
          descriptionHi: descHi,
          descriptionGu: descGu,
          impactHi: 'जीवन में शांति एवं निरंतर ईश्वरीय संरक्षण।',
          impactGu: 'જીવનમાં શાંતિ અને સતત દૈવી રક્ષણ.',
        ),
      );
    }

    return {
      'hi': yogasHi,
      'gu': yogasGu,
      'items': items,
    };
  }

  static PlanetPosition? _findSignLord(int signId, List<PlanetPosition> planets) {
    int lordPlanetId;
    switch (signId) {
      case 1:
      case 8:
        lordPlanetId = 3; // Mars
        break;
      case 2:
      case 7:
        lordPlanetId = 6; // Venus
        break;
      case 3:
      case 6:
        lordPlanetId = 4; // Mercury
        break;
      case 4:
        lordPlanetId = 2; // Moon
        break;
      case 5:
        lordPlanetId = 1; // Sun
        break;
      case 9:
      case 12:
        lordPlanetId = 5; // Jupiter
        break;
      case 10:
      case 11:
      default:
        lordPlanetId = 7; // Saturn
        break;
    }
    try {
      return planets.firstWhere((p) => p.id == lordPlanetId);
    } catch (_) {
      return null;
    }
  }

  /// Calculates dignity of planet in its placed Rashi (Exalted, Own, Friend, Neutral, Enemy, Debilitated)
  static Map<String, dynamic> getPlanetDignity(PlanetPosition planet) {
    final pid = planet.id;
    final rid = planet.rashiId;

    String dignity = 'Neutral';
    String labelGu = 'સમ';
    String labelHi = 'सम';
    String descGu = 'સામાન્ય શુભ-અશુભ પરિણામ આપે છે.';
    String descHi = 'सामान्य शुभ-अशुभ फल प्रदान करता है।';

    switch (pid) {
      case 1: // Sun
        if (rid == 1) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'સૂર્ય મેષ રાશિમાં પરમ ઉચ્ચનો થઈ અત્યંત તેજ, માન-સન્માન, સરકારી પદ અને કીર્તિ આપે છે.';
          descHi = 'सूर्य मेष राशि में परम उच्च होकर अतुल्य तेज, मान-सम्मान एवं प्रशासनिक सफलता देता है।';
        } else if (rid == 7) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'તુલા રાશિમાં સૂર્ય નીચનો ગણાય છે. આત્મવિશ્વાસ અને આંખોનું વિશેષ ધ્યાન રાખવું.';
          descHi = 'तुला राशि में सूर्य नीचस्थ होता है। आत्मविश्वास एवं स्वास्थ्य का ध्यान रखें।';
        } else if (rid == 5) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'સિંહ પોતાની સ્વરાશિમાં સૂર્ય રાજવી પ્રભાવ, નેતૃત્વ અને આત્મગૌરવ આપે છે.';
          descHi = 'सिंह स्वराशि में सूर्य राजसी प्रभाव, नेतृत्व एवं आत्मगौरव प्रदान करता है।';
        } else if ([4, 8, 9, 12].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી હોવાથી સૂર્ય અનુકૂળ અને શુભ ફળ પ્રદાન કરે છે.';
          descHi = 'मित्र राशि में स्थित सूर्य शुभ एवं कल्याणकारी परिणाम देता है।';
        } else if ([3, 6].contains(rid)) {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ રાશિમાં સૂર્ય મધ્યમ પરિણામ આપે છે.';
          descHi = 'सम राशि में सूर्य मध्यम परिणाम देता है।';
        } else {
          dignity = 'Enemy';
          labelGu = 'શત્રુ રાશિ (Enemy)';
          labelHi = 'शत्रु राशि (Enemy)';
          descGu = 'શત્રુ ક્ષેત્રી હોવાથી પરિશ્રમ બાદ જ ફળ મળે છે.';
          descHi = 'शत्रु राशि में अधिक परिश्रम के उपरांत ही सफलता मिलती है।';
        }
        break;

      case 2: // Moon
        if (rid == 2) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'વૃષભ રાશિમાં ચંદ્ર ઉચ્ચનો થઈ મનની પ્રસન્નતા, સમૃદ્ધિ અને મોહક વ્યક્તિત્વ આપે છે.';
          descHi = 'वृषभ राशि में चन्द्र उच्च होकर मानसिक शांति, समृद्धि एवं सम्मोहक व्यक्तित्व देता है।';
        } else if (rid == 8) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'વૃશ્ચિકમાં ચંદ્ર નીચનો ગણાય છે. ભાવનાત્મક ઉતાર-ચઢાવથી બચવું.';
          descHi = 'वृश्चिक में चन्द्र नीचस्थ होता है। भावुकता पर नियंत्रण रखें।';
        } else if (rid == 4) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'કર્ક પોતાની સ્વરાશિમાં ચંદ્ર સ્નેહ, સુખ-શાંતિ અને કૌટુંબિક પ્રેમ આપે છે.';
          descHi = 'कर्क स्वराशि में चन्द्र स्नेह, पारिवारिक सुख एवं मानसिक शांति देता है।';
        } else if ([1, 5, 3, 6].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી ચંદ્ર શુભ વિચારો અને કલ્પનાશક્તિ આપે છે.';
          descHi = 'मित्र राशि में चन्द्र रचनात्मकता एवं सौहार्द प्रदान करता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'ચંદ્ર સમભાવે શુભ-અશુભ પરિણામ આપે છે.';
          descHi = 'चन्द्र मध्यम एवं संतुलित फल देता है।';
        }
        break;

      case 3: // Mars
        if (rid == 10) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'મકર રાશિમાં મંગળ પરમ ઉચ્ચ થઈ અસીમ પરાક્રમ, વિજય, જમીન-મકાન અને પદવી આપે છે.';
          descHi = 'मकर राशि में मंगल उच्च होकर असीम पराक्रम, विजय एवं भूमि-भवन का सुख देता है।';
        } else if (rid == 4) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'કર્ક રાશિમાં મંગળ નીચનો હોવાથી ક્રોધ અને અધીરાઈથી બચવું.';
          descHi = 'कर्क में मंगल नीचस्थ होता है। क्रोध एवं जल्दबाजी से बचें।';
        } else if (rid == 1 || rid == 8) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'પોતાની સ્વરાશિ (મેષ/વૃશ્ચિક) માં મંગળ સાહસ, નીડરતા અને નેતૃત્વ આપે છે.';
          descHi = 'अपनी स्वराशि में मंगल साहस, निर्भीकता एवं नेतृत्व क्षमता प्रदान करता है।';
        } else if ([5, 9, 12].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી મંગળ ભાગ્યવૃદ્ધિ અને પરાક્રમ આપે છે.';
          descHi = 'मित्र राशि में मंगल भाग्य वृद्धि एवं बल प्रदान करता है।';
        } else if ([2, 7, 11].contains(rid)) {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ રાશિમાં મંગળ સામાન્ય પરિણામ આપે છે.';
          descHi = 'सम राशि में मंगल मध्यम फल देता है।';
        } else {
          dignity = 'Enemy';
          labelGu = 'શત્રુ રાશિ (Enemy)';
          labelHi = 'शत्रु राशि (Enemy)';
          descGu = 'શત્રુ ક્ષેત્રમાં મંગળ સંઘર્ષ બાદ સફળતા આપે છે.';
          descHi = 'शत्रु राशि में मंगल संघर्षोपरांत विजय देता है।';
        }
        break;

      case 4: // Mercury
        if (rid == 6) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ / સ્વરાશિ (Exalted)';
          labelHi = 'उच्च / स्वराशि (Exalted)';
          descGu = 'કન્યા રાશિમાં બુધ ઉચ્ચનો થઈ અદભુત બુદ્ધિ, વ્યાપારિક સૂઝ અને ગણિત/આઇટીમાં સફળતા આપે છે.';
          descHi = 'कन्या राशि में बुध उच्च होकर प्रखर बुद्धि, व्यापारिक चातुर्य एवं उच्च पद देता है।';
        } else if (rid == 12) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'મીન રાશિમાં બુધ નીચનો ગણાય છે. નિર્ણયો લેવામાં સ્પષ્ટતા રાખવી.';
          descHi = 'मीन में बुध नीचस्थ होता है। निर्णय लेने में विवेक बनाए रखें।';
        } else if (rid == 3) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'મિથુન રાશિમાં બુધ વાકચાતુર્ય, મૌલિક લેખન અને બહુમુખી પ્રતિભા આપે છે.';
          descHi = 'मिथुन में बुध वाकपटुता, सम्मोहन एवं बहुमुखी प्रतिभा देता है।';
        } else if ([1, 5, 2, 7].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી બુધ નોકરી-ધંધામાં સારો લાભ આપે છે.';
          descHi = 'मित्र राशि में बुध आजीविका में उत्तम लाभ प्रदान करता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ ક્ષેત્રમાં બુધ સંતુલિત પરિણામ આપે છે.';
          descHi = 'सम राशि में बुध संतुलित परिणाम देता है।';
        }
        break;

      case 5: // Jupiter
        if (rid == 4) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'કર્ક રાશિમાં દેવગુરુ બૃહસ્પતિ પરમ ઉચ્ચ થઈ સર્વોચ્ચ જ્ઞાન, કીર્તિ, સંતાન સુખ અને અખંડ ભાગ્ય આપે છે.';
          descHi = 'कर्क राशि में बृहस्पति उच्च होकर सर्वोच्च ज्ञान, कीर्ति, संतान सुख एवं अखंड ऐश्वर्य देते हैं।';
        } else if (rid == 10) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'મકર રાશિમાં ગુરુ નીચના ગણાય છે. ગુરુ ઉપાસનાથી નીચભંગ ફળ મળે છે.';
          descHi = 'मकर में गुरु नीचस्थ होते हैं। विष्णु उपासना से शुभता बढ़ती है।';
        } else if (rid == 9 || rid == 12) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'ધન/મીન સ્વરાશિમાં ગુરુ આધ્યાત્મિક જ્ઞાન, ઉદારતા અને ધન-ધાન્ય આપે છે.';
          descHi = 'धनु/मीन स्वराशि में गुरु धर्म, परोपकार एवं प्रचुर समृद्धि देते हैं।';
        } else if ([1, 8, 5].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી ગુરુ ભાગ્યોદય અને આદર-સન્માન આપે છે.';
          descHi = 'मित्र राशि में गुरु भाग्योदय एवं मान-सम्मान प्रदान करते हैं।';
        } else if (rid == 11) {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ ક્ષેત્રમાં ગુરુ સામાન્ય શુભ ફળ આપે છે.';
          descHi = 'सम राशि में गुरु सामान्य शुभ फल देते हैं।';
        } else {
          dignity = 'Enemy';
          labelGu = 'શત્રુ રાશિ (Enemy)';
          labelHi = 'शत्रु राशि (Enemy)';
          descGu = 'શત્રુ ક્ષેત્રમાં ગુરુ સંયમ અને સદાચારથી શુભ ફળ આપે છે.';
          descHi = 'शत्रु राशि में गुरु धैर्य एवं सदाचार से लाभ देते हैं।';
        }
        break;

      case 6: // Venus
        if (rid == 12) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'મીન રાશિમાં શુક્ર પરમ ઉચ્ચ થઈ વૈભવી જીવન, કલા-સંગીત, ઉત્તમ દાંપત્ય અને વિદેશ સુખ આપે છે.';
          descHi = 'मीन राशि में शुक्र उच्च होकर विलासिता, कला, सुखी दांपत्य एवं अपार आकर्षण देते हैं।';
        } else if (rid == 6) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'કન્યા રાશિમાં શુક્ર નીચના ગણાય છે. ખર્ચ અને સંબંધોમાં સંતુલન રાખવું.';
          descHi = 'कन्या में शुक्र नीचस्थ होते हैं। व्यय एवं संबंधों में संतुलन रखें।';
        } else if (rid == 2 || rid == 7) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'વૃષભ/તુલા સ્વરાશિમાં શુક્ર સૌંદર્ય, વાહન સુખ, સ્નેહ અને સંપત્તિ આપે છે.';
          descHi = 'वृषभ/तुला स्वराशि में शुक्र सौंदर्य, वाहन सुख एवं अखंड ऐश्वर्य देते हैं।';
        } else if ([3, 10, 11].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી શુક્ર ભૌતિક સુખોમાં વધારો કરે છે.';
          descHi = 'मित्र राशि में शुक्र भौतिक सुखों में वृद्धि करते हैं।';
        } else if ([1, 8, 9].contains(rid)) {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ ક્ષેત્રમાં શુક્ર મધ્યમ પરિણામ આપે છે.';
          descHi = 'सम राशि में शुक्र मध्यम फल देते हैं।';
        } else {
          dignity = 'Enemy';
          labelGu = 'શત્રુ રાશિ (Enemy)';
          labelHi = 'शत्रु राशि (Enemy)';
          descGu = 'શત્રુ ક્ષેત્રમાં શુક્ર પરિશ્રમ બાદ લાભ આપે છે.';
          descHi = 'शत्रु राशि में शुक्र प्रयास के उपरांत लाभ देते हैं।';
        }
        break;

      case 7: // Saturn
        if (rid == 7) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ (Exalted)';
          labelHi = 'उच्च (Exalted)';
          descGu = 'તુલા રાશિમાં શનિદેવ પરમ ઉચ્ચ થઈ ન્યાય, જનસમર્થન, દીર્ઘાયુ અને અડગ સત્તા આપે છે.';
          descHi = 'तुला राशि में शनि उच्च होकर न्यायप्रियता, जनसमर्थन, दीर्घायु एवं स्थायी सत्ता देते हैं।';
        } else if (rid == 1) {
          dignity = 'Debilitated';
          labelGu = 'નીચ (Debilitated)';
          labelHi = 'नीच (Debilitated)';
          descGu = 'મેષ રાશિમાં શનિ નીચના ગણાય છે. ધીરજ, સદાચાર અને સેવાભાવ રાખવો.';
          descHi = 'मेष में शनि नीचस्थ होते हैं। धैर्य एवं सेवाभाव बनाए रखें।';
        } else if (rid == 10 || rid == 11) {
          dignity = 'Own';
          labelGu = 'સ્વરાશિ (Own Sign)';
          labelHi = 'स्वराशि (Own Sign)';
          descGu = 'મકર/કુંભ સ્વરાશિમાં શનિ પરિશ્રમનું સર્વોચ્ચ ફળ, સ્થિરતા અને નેતૃત્વ આપે છે.';
          descHi = 'मकर/कुंभ स्वराशि में शनि परिश्रम का पूर्ण फल, स्थिरता एवं प्रभुत्व देते हैं।';
        } else if ([3, 6, 2].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર ક્ષેત્રી શનિ વેપાર અને ઉદ્યોગમાં લાભ આપે છે.';
          descHi = 'मित्र राशि में शनि उद्योग एवं व्यवसाय में लाभ देते हैं।';
        } else if ([9, 12].contains(rid)) {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'સમ ક્ષેત્રમાં શનિ સામાન્ય પરિણામ આપે છે.';
          descHi = 'सम राशि में शनि सामान्य परिणाम देते हैं।';
        } else {
          dignity = 'Enemy';
          labelGu = 'શત્રુ રાશિ (Enemy)';
          labelHi = 'शत्रु राशि (Enemy)';
          descGu = 'શત્રુ ક્ષેત્રમાં શનિ સંઘર્ષ બાદ સ્થિરતા આપે છે.';
          descHi = 'शत्रु राशि में शनि सतत श्रम के बाद स्थिरता देते हैं।';
        }
        break;

      case 8: // Rahu
        if (rid == 2 || rid == 3) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ રાશિ (Exalted)';
          labelHi = 'उच्च राशि (Exalted)';
          descGu = 'વૃષભ/મિથુનમાં રાહુ અત્યંત તેજસ્વી બુદ્ધિ, વિદેશ લાભ અને અણધાર્યા ધનલાભ આપે છે.';
          descHi = 'वृषभ/मिथुन में राहु तीव्र बुद्धि, विदेश लाभ एवं अप्रत्याशित धन देता है।';
        } else if (rid == 8 || rid == 9) {
          dignity = 'Debilitated';
          labelGu = 'નીચ રાશિ (Debilitated)';
          labelHi = 'नीच राशि (Debilitated)';
          descGu = 'વૃશ્ચિક/ધનુમાં રાહુ ભ્રમ કે ઉતાવળથી બચવાની સલાહ આપે છે.';
          descHi = 'वृश्चिक/धनु में राहु भ्रम से बचने की प्रेरणा देता है।';
        } else if ([6, 7, 11].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર રાશિમાં રાહુ આધુનિક ટેકનોલોજી અને રાજનીતિમાં આગળ વધારે છે.';
          descHi = 'मित्र राशि में राहु तकनीक एवं राजनीति में सफलता देता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'રાહુ મધ્યમ ફળદાયી છે.';
          descHi = 'राहु मध्यम फलदायी है।';
        }
        break;

      case 9: // Ketu
        if (rid == 8 || rid == 9) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ રાશિ (Exalted)';
          labelHi = 'उच्च राशि (Exalted)';
          descGu = 'વૃશ્ચિક/ધનુમાં કેતુ ગૂઢ વિદ્યા, આંતરજ્ઞાન અને આધ્યાત્મિક મુક્તિ આપે છે.';
          descHi = 'वृश्चिक/धनु में केतु गूढ़ विद्या, अंतर्ज्ञान एवं मोक्ष की दिशा देता है।';
        } else if (rid == 2 || rid == 3) {
          dignity = 'Debilitated';
          labelGu = 'નીચ રાશિ (Debilitated)';
          labelHi = 'नीच राशि (Debilitated)';
          descGu = 'વૃષભ/મિથુનમાં કેતુ મનને શાંત રાખવાની સલાહ આપે છે.';
          descHi = 'वृषभ/मिथुन में केतु मन को शांत रखने की प्रेरणा देता है।';
        } else if ([1, 12].contains(rid)) {
          dignity = 'Friend';
          labelGu = 'મિત્ર રાશિ (Friendly)';
          labelHi = 'मित्र राशि (Friendly)';
          descGu = 'મિત્ર રાશિમાં કેતુ સાધના અને તીર્થયાત્રા કરાવે છે.';
          descHi = 'मित्र राशि में केतु साधना एवं तीर्थयात्रा का फल देता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'કેતુ મધ્યમ આધ્યાત્મિક ફળ આપે છે.';
          descHi = 'केतु मध्यम आध्यात्मिक फल देता है।';
        }
        break;

      case 10: // Uranus (Harshal)
        if (rid == 8) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ રાશિ (Exalted)';
          labelHi = 'उच्च राशि (Exalted)';
          descGu = 'વૃશ્ચિક રાશિમાં હર્ષલ ક્રાંતિકારી વિચારો, વૈજ્ઞાનિક સંશોધન અને અસાધારણ બુદ્ધિમત્તા આપે છે.';
          descHi = 'वृश्चिक राशि में यूरेनस क्रांतिकारी विचार, नवाचार एवं वैज्ञानिक प्रतिभा देता है।';
        } else if (rid == 11) {
          dignity = 'Own';
          labelGu = 'સ્વક્ષેત્ર સમાન (Affinity)';
          labelHi = 'स्वक्षेत्र तुल्य (Affinity)';
          descGu = 'કુંભ રાશિ સાથે હર્ષલનો વિશેષ સહ-સંબંધ હોવાથી આધુનિક ટેકનોલોજી અને સામાજિક બદલાવમાં સહાય કરે છે.';
          descHi = 'कुंभ राशि में यूरेनस आधुनिक तकनीक एवं सामाजिक परिवर्तन में सफलता देता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'હર્ષલ વ્યક્તિગત આઝાદી અને નૂતન સંશોધક ક્ષમતા પ્રદાન કરે છે.';
          descHi = 'यूरेनस स्वतंत्रता एवं मौलिक शोध की क्षमता प्रदान करता है।';
        }
        break;

      case 11: // Neptune (Varuna)
        if (rid == 5) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ રાશિ (Exalted)';
          labelHi = 'उच्च राशि (Exalted)';
          descGu = 'સિંહ રાશિમાં નેપ્ચ્યુન દિવ્ય કલ્પનાશક્તિ, કલાત્મક સિદ્ધિ અને આધ્યાત્મિક આકર્ષણ આપે છે.';
          descHi = 'सिंह राशि में नेपच्यून दिव्य कल्पना, कलात्मक प्रतिभा एवं आध्यात्मिक आकर्षण देता है।';
        } else if (rid == 12) {
          dignity = 'Own';
          labelGu = 'સ્વક્ષેત્ર સમાન (Affinity)';
          labelHi = 'स्वक्षेत्र तुल्य (Affinity)';
          descGu = 'મીન રાશિ સાથે નેપ્ચ્યુનનો વિશેષ સંબંધ હોવાથી ગહન ધ્યાન, સહજજ્ઞાન અને આંતરિક શાંતિ આપે છે.';
          descHi = 'मीन राशि में नेपच्यून गहन ध्यान, अंतःप्रेरणा एवं मानसिक शांति प्रदान करता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'નેપ્ચ્યુન સંવેદનશીલતા અને પરોપકાર ભાવના વધારે છે.';
          descHi = 'नेपच्यून संवेदनशीलता एवं परोपकार की भावना को बढ़ाता है।';
        }
        break;

      case 12: // Pluto (Yama)
        if (rid == 1) {
          dignity = 'Exalted';
          labelGu = 'ઉચ્ચ રાશિ (Exalted)';
          labelHi = 'उच्च राशि (Exalted)';
          descGu = 'મેષ રાશિમાં પ્લૂટો અખૂટ આંતરિક શક્તિ, કઠોર ઈચ્છાશક્તિ અને પુનર્નિર્માણની શક્તિ આપે છે.';
          descHi = 'मेष राशि में प्लूटो अदम्य इच्छाशक्ति, गहन रूपांतरण एवं नेतृत्व की शक्ति देता है।';
        } else if (rid == 8) {
          dignity = 'Own';
          labelGu = 'સ્વક્ષેત્ર સમાન (Affinity)';
          labelHi = 'स्वक्षेत्र तुल्य (Affinity)';
          descGu = 'વૃશ્ચિક રાશિ સાથે પ્લૂટોનો ગાઢ સંબંધ હોવાથી ગૂઢ રહસ્યો, સંશોધન અને જીવન પરિવર્તનમાં વિજય આપે છે.';
          descHi = 'वृश्चिक राशि में प्लूटो गूढ़ रहस्य, आत्मबल एवं जीवन रूपांतरण में सफलता देता है।';
        } else {
          dignity = 'Neutral';
          labelGu = 'સમ રાશિ (Neutral)';
          labelHi = 'सम राशि (Neutral)';
          descGu = 'પ્લૂટો જીવનના જૂના બંધનો તોડી નવો જન્મ અને ક્રાંતિકારી ઉન્નતિ આપે છે.';
          descHi = 'प्लूटो जीवन में सकारात्मक कायाकल्प एवं आत्मिक उन्नति लाता है।';
        }
        break;
    }

    return {
      'dignity': dignity,
      'labelGu': labelGu,
      'labelHi': labelHi,
      'descGu': descGu,
      'descHi': descHi,
    };
  }

  /// Calculates house lordships for a planet in a given Lagna
  static Map<String, dynamic> getPlanetLordships(int planetId, int lagnaRashiId) {
    final houses = <int>[];
    for (int h = 1; h <= 12; h++) {
      final signInHouse = ((lagnaRashiId + h - 2) % 12) + 1;
      int signLord = 0;
      switch (signInHouse) {
        case 1:
        case 8:
          signLord = 3;
          break;
        case 2:
        case 7:
          signLord = 6;
          break;
        case 3:
        case 6:
          signLord = 4;
          break;
        case 4:
          signLord = 2;
          break;
        case 5:
          signLord = 1;
          break;
        case 9:
        case 12:
          signLord = 5;
          break;
        case 10:
        case 11:
          signLord = 7;
          break;
      }
      if (signLord == planetId) {
        houses.add(h);
      }
    }

    const houseNamesHi = ['', 'प्रथम (लग्न)', 'द्वितीय (धन)', 'तृतीय (सहज)', 'चतुर्थ (सुख)', 'पंचम (पुत्र/बुद्धि)', 'षष्ठ (रिपु)', 'सप्तम (जाया/विवाह)', 'अष्टम (आयु)', 'नवम (भाग्य)', 'दशम (कर्म)', 'एकादश (लाभ)', 'द्वादश (व्यय)'];
    const houseNamesGu = ['', 'પ્રથમ (લગ્ન)', 'દ્વિતીય (ધન)', 'તૃતીય (પરાક્રમ)', 'ચતુર્થ (સુખ/માતા)', 'પંચમ (બુદ્ધિ/સંતાન)', 'ષષ્ઠ (શત્રુ/રોગ)', 'સપ્તમ (વિવાહ/ભાગીદારી)', 'અષ્ટમ (આયુષ્ય)', 'નવમ (ભાગ્ય)', 'દશમ (કર્મ/પદવી)', 'એકાદશ (લાભ/આવક)', 'દ્વાદશ (મોક્ષ/વ્યય)'];

    String titleGu = '';
    String titleHi = '';

    if (houses.isEmpty) {
      if (planetId == 8) {
        titleGu = 'છાયાગ્રહ (રાહુ કોઈ ભાવનો સ્વામી નથી, સ્થિત ભાવનું ફળ વધારે છે)';
        titleHi = 'छायाग्रह (राहु किसी भाव का स्वामी नहीं, स्थित भाव का फल बढ़ाता है)';
      } else if (planetId == 9) {
        titleGu = 'છાયાગ્રહ (કેતુ મોક્ષકારક ગ્રહ તરીકે સ્થિત ભાવને પ્રભાવિત કરે છે)';
        titleHi = 'छायाग्रह (केतु मोक्षकारक ग्रह के रूप में स्थित भाव को प्रभावित करता है)';
      } else if (planetId == 10) {
        titleGu = 'બાહ્ય ગ્રહ (આધુનિક જ્યોતિષ મુજબ કુંભ રાશિ અને સંશોધન ભાવ સાથે વિશેષ સંબંધ)';
        titleHi = 'बाह्य ग्रह (आधुनिक ज्योतिष अनुसार कुंभ राशि एवं नवोन्मेष भाव से संबंधित)';
      } else if (planetId == 11) {
        titleGu = 'બાહ્ય ગ્રહ (આધુનિક જ્યોતિષ મુજબ મીન રાશિ, કલ્પના અને આધ્યાત્મિક ભાવ સાથે સંબંધ)';
        titleHi = 'बाह्य ग्रह (आधुनिक ज्योतिष अनुसार मीन राशि, कल्पना एवं आध्यात्म भाव से संबंधित)';
      } else if (planetId == 12) {
        titleGu = 'બાહ્ય ગ્રહ (આધુનિક જ્યોતિષ મુજબ વૃશ્ચિક રાશિ, રહસ્ય અને પરિવર્તન ભાવ સાથે સંબંધ)';
        titleHi = 'बाह्य ग्रह (आधुनिक ज्योतिष अनुसार वृश्चिक राशि, रहस्य एवं परिवर्तन भाव से संबंधित)';
      }
    } else if (houses.length == 1) {
      final h = houses.first;
      titleGu = '${houseNamesGu[h]} ભાવના સ્વામી (Lord of ${h}th House)';
      titleHi = '${houseNamesHi[h]} भाव के स्वामी (Lord of ${h}th House)';
    } else {
      final h1 = houses[0];
      final h2 = houses[1];
      titleGu = '${houseNamesGu[h1]} અને ${houseNamesGu[h2]} ભાવના સ્વામી';
      titleHi = '${houseNamesHi[h1]} एवं ${houseNamesHi[h2]} भाव के स्वामी';
    }

    return {
      'houses': houses,
      'titleGu': titleGu,
      'titleHi': titleHi,
    };
  }

  /// Calculates detailed Graha Fal based on Rashi placement and House placement
  static Map<String, String> getGrahaFal(PlanetPosition planet, int lagnaRashiId) {
    final dignityData = getPlanetDignity(planet);
    final lordData = getPlanetLordships(planet.id, lagnaRashiId);
    final h = planet.houseNumber;
    final rashiNameGu = rashisGu[planet.rashiId - 1];
    final rashiNameHi = rashisHi[planet.rashiId - 1];

    const houseFalSummaryGu = [
      '',
      'લગ્ન ભાવમાં ગ્રહ વ્યક્તિત્વ, આત્મવિશ્વાસ, સ્વાસ્થ્ય અને તેજસ્વિતાને પ્રબળ બનાવે છે.',
      'દ્વિતીય ભાવમાં ગ્રહ સંચિત ધન, મધુર વાણી, કૌટુંબિક સુખ અને આર્થિક સમૃદ્ધિ આપે છે.',
      'તૃતીય ભાવમાં ગ્રહ પરાક્રમ, આંતરિક હિંમત, ભાઈ-બહેન સાથે સ્નેહ અને સંચાર કૌશલ્ય વધારે છે.',
      'ચતુર્થ ભાવમાં ગ્રહ માતાનું વાત્સલ્ય, વાહન સુખ, જમીન-મકાન અને માનસિક શાંતિ આપે છે.',
      'પંચમ ભાવમાં ગ્રહ બુદ્ધિપ્રતિભા, ઉચ્ચ શિક્ષણ, કલાત્મક સર્જનાત્મકતા અને સંતાન સુખ આપે છે.',
      'ષષ્ઠ ભાવમાં ગ્રહ શત્રુઓ પર વિજય, સ્પર્ધાત્મક સફળતા, રોગમુક્તિ અને કર્મનિષ્ઠા આપે છે.',
      'સપ્તમ ભાવમાં ગ્રહ સુખી દાંપત્યજીવન, રૂપવાન-ગુણવાન જીવનસાથી અને વેપારમાં ભાગીદારી આપે છે.',
      'અષ્ટમ ભાવમાં ગ્રહ દીર્ઘાયુષ્ય, આધ્યાત્મિક સંશોધન, ગૂઢ જ્ઞાન અને આકસ્મિક ધનલાભ આપે છે.',
      'નવમ ભાવમાં ગ્રહ પ્રબળ ભાગ્યોદય, ધર્મનિષ્ઠા, તીર્થયાત્રા, ઉચ્ચ જ્ઞાન અને પિતાનો આશીર્વાદ આપે છે.',
      'દશમ ભાવમાં ગ્રહ કારકિર્દીમાં સર્વોચ્ચ પદવી, વેપાર-નોકરીમાં વિજય, માન-સન્માન અને કીર્તિ આપે છે.',
      'એકાદશ ભાવમાં ગ્રહ મહત્વાકાંક્ષાઓની પૂર્તિ, પ્રચુર ધનલાભ, આવકમાં સતત વૃદ્ધિ અને મિત્રોનો સહકાર આપે છે.',
      'દ્વાદશ ભાવમાં ગ્રહ વિદેશ યાત્રા, આધ્યાત્મિક સાધના, દાન-પુણ્ય અને મોક્ષમાર્ગ મોકળો કરે છે.',
    ];

    const houseFalSummaryHi = [
      '',
      'लग्न भाव में ग्रह व्यक्तित्व, स्वास्थ्य, आत्मविश्वास एवं तेजस्विता को प्रखर बनाता है।',
      'द्वितीय भाव में ग्रह संचित धन, मधुर वाणी, पारिवारिक सुख एवं समृद्धि प्रदान करता है।',
      'तृतीय भाव में ग्रह साहस, पराक्रम, छोटे भाई-बहनों का स्नेह एवं संवाद कौशल बढ़ाता है।',
      'चतुर्थ भाव में ग्रह मातृसुख, वाहन, भूमि-भवन एवं मानसिक शांति का वरदान देता है।',
      'पंचम भाव में ग्रह कुशाग्र बुद्धि, उच्च विद्या, रचनात्मकता एवं उत्तम संतान सुख देता है।',
      'षष्ठ भाव में ग्रह शत्रु विजय, प्रतियोगी परीक्षाओं में सफलता एवं आरोग्य सुरक्षा देता है।',
      'सप्तम भाव में ग्रह सुखद दांपत्य, गुणवान जीवनसाथी एवं व्यावसायिक साझेदारी में लाभ देता है।',
      'अष्टम भाव में ग्रह दीर्घायु, अनुसंधान, गूढ़ विद्या एवं आकस्मिक लाभ का कारक बनता है।',
      'नवम भाव में ग्रह प्रचंड भाग्योदय, धर्मपरायणता, तीर्थाटन एवं समाज में उच्च सम्मान देता है।',
      'दशम भाव में ग्रह कर्मक्षेत्र में सर्वोच्च पद, यश, व्यापारिक उन्नति एवं मान-प्रतिष्ठा देता है।',
      'एकादश भाव में ग्रह मनोकामना पूर्ति, प्रचुर आर्थिक लाभ एवं निरंतर आय वृद्धि कराता है।',
      'द्वादश भाव में ग्रह विदेश गमन, आध्यात्मिक उन्नति, दान-पुण्य एवं मोक्ष का मार्ग प्रशस्त करता है।',
    ];

    final rashiFalGu = '$rashiNameGu રાશિમાં ${planet.nameGu}: ${dignityData['descGu']}';
    final rashiFalHi = '$rashiNameHi राशि में ${planet.nameHi}: ${dignityData['descHi']}';

    final houseFalGu = '$h મા ભાવમાં સ્થિતિ: ${houseFalSummaryGu[h.clamp(1, 12)]} (${lordData['titleGu']})';
    final houseFalHi = '$h वें भाव में स्थिति: ${houseFalSummaryHi[h.clamp(1, 12)]} (${lordData['titleHi']})';

    return {
      'rashiFalGu': rashiFalGu,
      'rashiFalHi': rashiFalHi,
      'houseFalGu': houseFalGu,
      'houseFalHi': houseFalHi,
    };
  }

  /// Planet Beej Mantras, deities and classical remedies
  static Map<String, dynamic> getPlanetSpiritualInfo(int planetId) {
    switch (planetId) {
      case 1: // Sun
        return {
          'beejMantraHi': 'ॐ ह्रां ह्रीं ह्रौं सः सूर्याय नमः',
          'beejMantraGu': 'ૐ હ્રાં હ્રીં હ્રૌં સઃ સૂર્યાય નમઃ',
          'vedicMantraHi': 'ॐ घृणिः सूर्य आदित्याय नमः',
          'vedicMantraGu': 'ૐ ઘૃણિઃ સૂર્ય આદિત્યાય નમઃ',
          'deityGu': 'ભગવાન શ્રી સૂર્યનારાયણ / ગાયત્રી માતા',
          'deityHi': 'भगवान श्री सूर्य नारायण / गायत्री माता',
          'gemstoneGu': 'માણેક (Ruby)',
          'gemstoneHi': 'माणिक्य (Ruby)',
          'remedyGu': 'પ્રતિદિન તાંબાના લોટાથી સૂર્યને જળ અર્પણ કરવું, આદિત્ય હૃદય સ્તોત્ર વાંચવું અને ગોળ/તાંબુ દાન કરવું.',
          'remedyHi': 'प्रतिदिन तांबे के लोटे से सूर्य को अर्घ्य दें, आदित्य हृदय स्तोत्र पढ़ें एवं गुड़/तांबे का दान करें।',
        };
      case 2: // Moon
        return {
          'beejMantraHi': 'ॐ श्रां श्रीं श्रौं सः चन्द्रमसे नमः',
          'beejMantraGu': 'ૐ શ્રાં શ્રીં શ્રૌં સઃ ચંદ્રમસે નમઃ',
          'vedicMantraHi': 'ॐ सों सोमाय नमः',
          'vedicMantraGu': 'ૐ સોં સોમાય નમઃ',
          'deityGu': 'ભગવાન દેવાધિદેવ શિવજી',
          'deityHi': 'भगवान देवाधिदेव महादेव शिव',
          'gemstoneGu': 'મોતી (Pearl)',
          'gemstoneHi': 'मोती (Pearl)',
          'remedyGu': 'સોમવારે શિવલિંગ પર દૂધ-જળ ચડાવવું, ચાંદીનો ગ્લાસ વાપરવો અને માતાના ચરણસ્પર્શ કરી આશીર્વાદ લેવા.',
          'remedyHi': 'सोमवार को शिवलिंग पर कच्चा दूध अर्पित करें, चांदी का प्रयोग करें एवं माता के चरण स्पर्श करें।',
        };
      case 3: // Mars
        return {
          'beejMantraHi': 'ॐ क्रां क्रीं क्रौं सः भौमाय नमः',
          'beejMantraGu': 'ૐ ક્રાં ક્રીં ક્રૌં સઃ ભૌમાય નમઃ',
          'vedicMantraHi': 'ॐ अं अंगारकाय नमः',
          'vedicMantraGu': 'ૐ અં અંગારકાય નમઃ',
          'deityGu': 'ભગવાન શ્રી હનુમાનજી / કાર્તિકેય',
          'deityHi': 'भगवान श्री हनुमान जी / कार्तिकेय',
          'gemstoneGu': 'પરવાળું (Red Coral)',
          'gemstoneHi': 'मूंगा (Red Coral)',
          'remedyGu': 'મંગળવારે હનુમાન ચાલીસા અથવા સુંદરકાંડનો પાઠ કરવો, લાલ મસૂર/ગોળ દાન કરવું અને ક્રોધ પર કાબૂ રાખવો.',
          'remedyHi': 'मंगलवार को हनुमान चालीसा अथवा सुंदरकांड का पाठ करें एवं लाल मसूर/गुड़ का दान करें।',
        };
      case 4: // Mercury
        return {
          'beejMantraHi': 'ॐ ब्रां ब्रीं ब्रौं सः बुधाय नमः',
          'beejMantraGu': 'ૐ બ્રાં બ્રીં બ્રૌં સઃ બુધાય નમઃ',
          'vedicMantraHi': 'ॐ बुं बुधाय नमः',
          'vedicMantraGu': 'ૐ બું બુધાય નમઃ',
          'deityGu': 'ભગવાન શ્રી ગણેશજી / શ્રી મહાવિષ્ણુ',
          'deityHi': 'भगवान श्री गणेश जी / श्री महाविष्णु',
          'gemstoneGu': 'પન્ના (Emerald)',
          'gemstoneHi': 'पन्ना (Emerald)',
          'remedyGu': 'બુધવારે ગણેશ અથર્વશીર્ષનો પાઠ કરવો, ગાયને લીલું ઘાસ ખવડાવવું અને તુલસીપત્ર શ્રી વિષ્ણુને અર્પણ કરવું.',
          'remedyHi': 'बुधवार को गणेश अथर्वशीर्ष का पाठ करें, गाय को हरा चारा खिलाएं एवं तुलसी का सेवन करें।',
        };
      case 5: // Jupiter
        return {
          'beejMantraHi': 'ॐ ग्रां ग्रीं ग्रौं सः गुरवे नमः',
          'beejMantraGu': 'ૐ ગ્રાં ગ્રીં ગ્રૌં સઃ ગુરવે નમઃ',
          'vedicMantraHi': 'ॐ बृं बृहस्पतये नमः',
          'vedicMantraGu': 'ૐ બૃં બૃહસ્પતયે નમઃ',
          'deityGu': 'ભગવાન શ્રી મહાવિષ્ણુ / દત્તાત્રેય પ્રભુ',
          'deityHi': 'भगवान श्री महाविष्णु / दत्तात्रेय प्रभु',
          'gemstoneGu': 'પોખરાજ (Yellow Sapphire)',
          'gemstoneHi': 'पुखराज (Yellow Sapphire)',
          'remedyGu': 'ગુરુવારે વિષ્ણુ સહસ્રનામનો પાઠ કરવો, કેસર-ચંદનનું તિલક કરવું અને ચણાની દાળ/હળદરનું દાન કરવું.',
          'remedyHi': 'गुरुवार को विष्णु सहस्रनाम का पाठ करें, केसर का तिलक लगाएं एवं चने की दाल/हल्दी का दान करें।',
        };
      case 6: // Venus
        return {
          'beejMantraHi': 'ॐ द्रां द्रीं द्रौं सः शुक्राय नमः',
          'beejMantraGu': 'ૐ દ્રાં દ્રીં દ્રૌં સઃ શુક્રાય નમઃ',
          'vedicMantraHi': 'ॐ शुं शुक्राय नमः',
          'vedicMantraGu': 'ૐ શું શુક્રાય નમઃ',
          'deityGu': 'માતા મહાલક્ષ્મીજી / માં અંબા',
          'deityHi': 'मां महालक्ष्मी जी / मां दुर्गा',
          'gemstoneGu': 'હીરો / ઓપલ (Diamond / Opal)',
          'gemstoneHi': 'हीरा / ओपल (Diamond / Opal)',
          'remedyGu': 'શુક્રવારે શ્રીસૂક્ત અથવા મહાલક્ષ્મી અષ્ટકમ વાંચવું, સુગંધિત અત્તર વાપરવું અને સાકર/ખીરનું દાન કરવું.',
          'remedyHi': 'शुक्रवार को श्रीसूक्त या कनकधारा स्तोत्र पढ़ें, सुवासित इत्र का प्रयोग करें एवं खीर का दान करें।',
        };
      case 7: // Saturn
        return {
          'beejMantraHi': 'ॐ प्रां प्रीं प्रौં सः शनैश्चराय नमः',
          'beejMantraGu': 'ૐ પ્રાં પ્રીં પ્રૌં સઃ શનૈશ્ચરાય નમઃ',
          'vedicMantraHi': 'ॐ शं शनैश्चराय नमः',
          'vedicMantraGu': 'ૐ શં શનૈશ્ચરાય નમઃ',
          'deityGu': 'ભગવાન શ્રી શનિદેવ / કાળભૈરવ / શિવજી',
          'deityHi': 'भगवान श्री शनिदेव / कालभैरव / शिव जी',
          'gemstoneGu': 'નીલમ (Blue Sapphire)',
          'gemstoneHi': 'नीलम (Blue Sapphire)',
          'remedyGu': 'શનિવારે પીપળાના વૃક્ષ નીચે સરસવના તેલનો દીવો કરવો, શનિ ચાલીસા વાંચવી અને અડદ/તેલ/કાળા તલનું દાન કરવું.',
          'remedyHi': 'शनिवार को पीपल वृक्ष के नीचे सरसों के तेल का दीपक जलाएं, शनि चालीसा पढ़ें एवं तिल/उड़द का दान करें।',
        };
      case 8: // Rahu
        return {
          'beejMantraHi': 'ॐ भ्रां भ्रीं भ्रौं सः राहवे नमः',
          'beejMantraGu': 'ૐ ભ્રાં ભ્રીં ભ્રૌં સઃ રાહવે નમઃ',
          'vedicMantraHi': 'ॐ रां राहवे नमः',
          'vedicMantraGu': 'ૐ રાં રાહવે નમઃ',
          'deityGu': 'ભગવાન ભૈરવનાથ / માં દુર્ગા',
          'deityHi': 'भगवान भैरवनाथ / मां दुर्गा',
          'gemstoneGu': 'ગોમેદ (Hessonite Garnet)',
          'gemstoneHi': 'गोमेद (Hessonite Garnet)',
          'remedyGu': 'મહામૃત્યુંજય મંત્રનો જાપ કરવો, પક્ષીઓને ચણ નાખવું અને સ્વચ્છતા જાળવી વ્યસનથી દૂર રહેવું.',
          'remedyHi': 'महामृत्युंजय मंत्र का जप करें, पक्षियों को दाना डालें एवं स्वच्छता व सात्विकता बनाए रखें।',
        };
      case 9: // Ketu
        return {
          'beejMantraHi': 'ॐ स्त्रां स्त्रीं स्त्रौं सः केतवे नमः',
          'beejMantraGu': 'ૐ સ્ત્રાં સ્ત્રીં સ્ત્રૌં સઃ કેતવે નમઃ',
          'vedicMantraHi': 'ॐ कें केतवे नमः',
          'vedicMantraGu': 'ૐ કેં કેતવે નમઃ',
          'deityGu': 'ભગવાન શ્રી ગણેશજી / ભગવાન વિષ્ણુ',
          'deityHi': 'भगवान श्री गणेश जी / भगवान विष्णु',
          'gemstoneGu': 'લસણિયું (Cat\'s Eye)',
          'gemstoneHi': 'लहसुनिया (Cat\'s Eye)',
          'remedyGu': 'ગણેશજીની આરાધના કરવી, કૂતરાને રોટલી ખવડાવવી અને ધાર્મિક પુસ્તકો અથવા ધ્વજા મંદિરને અર્પણ કરવી.',
          'remedyHi': 'गणेश जी की उपासना करें, काले श्वान को भोजन दें एवं मंदिर में ध्वजा अर्पित करें।',
        };
      case 10: // Uranus (Harshal)
        return {
          'beejMantraHi': 'ॐ हूं हर्षलाय नमः',
          'beejMantraGu': 'ૐ હૂં હર્ષલાય નમઃ',
          'vedicMantraHi': 'ॐ रुद्राय नमः',
          'vedicMantraGu': 'ૐ રુદ્રાય નમઃ',
          'deityGu': 'ભગવાન રુદ્ર / પ્રજાપતિ',
          'deityHi': 'भगवान रुद्र / प्रजापति',
          'gemstoneGu': 'ગોમેદ / એક્વામેરીન (Aquamarine)',
          'gemstoneHi': 'गोमेद / एक्वामरीन (Aquamarine)',
          'remedyGu': 'નવા સંશોધન, વિજ્ઞાન અને રચનાત્મક કાર્યોમાં સક્રિય રહેવું, શિવજીની ઉપાસના કરવી.',
          'remedyHi': 'नवाचार व विज्ञान से जुड़े कार्यों में सक्रिय रहें एवं शिव उपासना करें।',
        };
      case 11: // Neptune (Varuna)
        return {
          'beejMantraHi': 'ॐ वं वरुणाय नमः',
          'beejMantraGu': 'ૐ વં વરુણાય નમઃ',
          'vedicMantraHi': 'ॐ अपांपतये नमः',
          'vedicMantraGu': 'ૐ અપાંપતયે નમઃ',
          'deityGu': 'ભગવાન શ્રી વરુણ દેવ / શ્રી હરિ વિષ્ણુ',
          'deityHi': 'भगवान श्री वरुण देव / श्री हरि विष्णु',
          'gemstoneGu': 'મોતી / મૂનસ્ટોન (Moonstone)',
          'gemstoneHi': 'मोती / मूनस्टोन (Moonstone)',
          'remedyGu': 'જળ તત્વનું સન્માન કરવું, ધ્યાનાભ્યાસ કરવો અને આધ્યાત્મિક સાધના કરવી.',
          'remedyHi': 'जल का सम्मान करें, नियमित ध्यान एवं आध्यात्मिक साधना करें।',
        };
      case 12: // Pluto (Yama)
        return {
          'beejMantraHi': 'ॐ यं यमाय नमः',
          'beejMantraGu': 'ૐ યં યમાય નમઃ',
          'vedicMantraHi': 'ॐ महाकालाय नमः',
          'vedicMantraGu': 'ૐ મહાકાલાય નમઃ',
          'deityGu': 'ભગવાન શ્રી યમરાજ / મહાકાલ',
          'deityHi': 'भगवान श्री यमराज / महाकाल',
          'gemstoneGu': 'લાલ જાસ્પર / કાળો ઓનિક્સ (Black Onyx)',
          'gemstoneHi': 'रेड जैस्पर / काला गोमेद (Black Onyx)',
          'remedyGu': 'ધર્મ અને સત્યનું પાલન કરવું, મહામૃત્યુંજય મંત્રનો જપ કરવો અને સદાચારી જીવન જીવવું.',
          'remedyHi': 'धर्म-सत्य का पालन करें, महामृत्युंजय मंत्र का जप करें एवं सदाचारी बनें।',
        };
      default:
        return {
          'beejMantraHi': 'ॐ नमः शिवाय',
          'beejMantraGu': 'ૐ નમઃ શિવાય',
          'vedicMantraHi': 'ॐ नमः शिवाय',
          'vedicMantraGu': 'ૐ નમઃ શિવાય',
          'deityGu': 'ભગવાન દેવાધિદેવ શિવજી',
          'deityHi': 'भगवान देवाधिदेव महादेव शिव',
          'gemstoneGu': 'રુદ્રાક્ષ (Rudraksha)',
          'gemstoneHi': 'रुद्राक्ष (Rudraksha)',
          'remedyGu': 'પ્રતિદિન ઈશ્વર આરાધના કરવી અને સત્કર્મ કરવા.',
          'remedyHi': 'प्रतिदिन ईश्वर की आराधना करें एवं सत्कर्म करें।',
        };
    }
  }

  /// Classical Antardasha Fal (દશાંતર ફળાદેશ) generator for Mahadasha-Antardasha pairs
  static Map<String, String> getAntardashaFal(String mahaLordGu, String antarLordGu) {
    // Generate authentic classical Phaladeepika interpretation for any Mahadasha-Antardasha pair
    final Map<String, String> guMap = {
      // Sun Maha
      'સૂર્ય-સૂર્ય': 'સૂર્યની સ્વઅંતર્દશામાં આત્મવિશ્વાસમાં વૃદ્ધિ, સરકારી કાર્યોમાં સફળતા અને માન-પ્રતિષ્ઠા મળે છે. સ્વાસ્થ્યમાં આંખ-માથાનું ધ્યાન રાખવું.',
      'સૂર્ય-ચંદ્ર': 'માનસિક શાંતિ, સુખ-સુવિધાઓમાં વધારો, માતા તરફથી લાભ અને જનસંપર્કમાં વિસ્તરણ થાય છે.',
      'સૂર્ય-મંગળ': 'પરાક્રમમાં અભૂતપૂર્વ વધારો, ભૂમિ-મકાન ખરીદીનો શુભ યોગ અને શાસકીય ક્ષેત્રે વિજય મળે છે.',
      'સૂર્ય-રાહુ': 'માનસિક ઉદ્વેગ કે મૂંઝવણ રહી શકે છે, પરંતુ વિદેશી સંપર્કોથી અણધાર્યો ધનલાભ થાય છે. ધીરજ રાખવી.',
      'સૂર્ય-ગુરુ': 'જ્ઞાન, સદાચાર, પુત્ર/સંતાન સુખ અને ધાર્મિક કાર્યોમાં અગ્રેસરતા મળે છે. ઉત્તમ ભાગ્યોદય સમય.',
      'સૂર્ય-શનિ': 'પરિશ્રમનું પ્રમાણ વધે છે. વડીલોના સ્વાસ્થ્યની કાળજી રાખવી અને ધીરજપૂર્વક કાર્યો પૂર્ણ કરવા.',
      'સૂર્ય-બુધ': 'બુધાદિત્ય પ્રભાવથી વ્યાપાર-વાણિજ્યમાં મોટો ફાયદો, બુદ્ધિપ્રતિભામાં નિખાર અને પદોન્નતિ થાય છે.',
      'સૂર્ય-કેતુ': 'આધ્યાત્મિક ચિંતન વધે છે. યાત્રાઓ ફળદાયી બને છે અને ઈશ્વરભક્તિમાં મન લાગે છે.',
      'સૂર્ય-શુક્ર': 'કલા, સંગીત અને ભૌતિક સુખ-સગવડો વધે છે. ખર્ચ પર સંયમ રાખવો.',

      // Moon Maha
      'ચંદ્ર-ચંદ્ર': 'સંપૂર્ણ માનસિક શાંતિ, પારિવારિક સુખ, ધનલાભ અને કૌટુંબિક પ્રસન્નતાનો સમય છે.',
      'ચંદ્ર-મંગળ': 'ચંદ્ર-મંગળના પ્રભાવથી અચલ સંપત્તિ, બિઝનેસમાં મોટો નફો અને સાહસિક કાર્યોમાં વિજય મળે છે.',
      'ચંદ્ર-રાહુ': 'કાલ્પનિક ચિંતાઓથી બચવું. શિવ આરાધનાથી અણધાર્યા સ્ત્રોતોમાંથી ધન આગમન થાય છે.',
      'ચંદ્ર-ગુરુ': 'ગજકેસરી યોગ સમાન પ્રભાવ! અપરંપાર યશ-કીર્તિ, ધાર્મિક ઉત્સવો અને આર્થિક સમૃદ્ધિ મળે છે.',
      'ચંદ્ર-શનિ': 'મિશ્ર ફળ મળે છે. વિષ યોગ શાંતિ માટે મહામૃત્યુંજય જાપ કરવો હિતકારી છે.',
      'ચંદ્ર-બુધ': 'બૌદ્ધિક સફળતા, સંચાર ક્ષેત્રે લાભ, નવો વેપાર શરૂ કરવા માટે ઉત્તમ કાળ છે.',
      'ચંદ્ર-કેતુ': 'ધ્યાન અને આધ્યાત્મિકતામાં રસ વધે છે. તીર્થયાત્રાના પ્રબળ યોગ બને છે.',
      'ચંદ્ર-શુક્ર': 'વાહન, વસ્ત્ર, આભૂષણ અને સુખી દાંપત્યજીવનનો શ્રેષ્ઠ સમય છે. ધન-ધાન્યમાં વૃદ્ધિ થાય છે.',
      'ચંદ્ર-સૂર્ય': 'સરકારી લાભ, પિતાનો સહકાર અને સમાજમાં ઊંચી પ્રતિષ્ઠા પ્રાપ્ત થાય છે.',

      // Mars Maha
      'મંગળ-મંગળ': 'અસીમ પરાક્રમ, જમીન-મિલકત ખરીદી અને નેતૃત્વ ક્ષમતામાં વધારો થાય છે.',
      'મંગળ-રાહુ': 'અંગારક પ્રભાવથી ક્રોધ અને ઉતાવળથી બચવું. સુંદરકાંડ પાઠથી અડચણો દૂર થાય છે.',
      'મંગળ-ગુરુ': 'ભાગ્યોદય, સંતાન સુખ, ધાર્મિક સન્માન અને સમાજમાં પ્રતિષ્ઠિત પદ પ્રાપ્ત થાય છે.',
      'મંગળ-શનિ': 'પરિશ્રમ વધુ કરવો પડે, પરંતુ ટેકનિકલ કે ઉદ્યોગ ક્ષેત્રે અંતે મોટો વિજય મળે છે.',
      'મંગળ-બુધ': 'વાકચાતુર્યથી વેપારમાં ફાયદો, મુકદ્દમા કે વિવાદોમાં શાંતિથી ઉકેલ આવે છે.',
      'મંગળ-કેતુ': 'આધ્યાત્મિક શક્તિ અને સાહસમાં વૃદ્ધિ થાય છે. વાહન ચલાવતી વખતે સાવચેતી રાખવી.',
      'મંગળ-શુક્ર': 'ભૌતિક સુખો, દાંપત્યમાં પ્રેમ અને જમીન-મકાનની સજાવટમાં ખર્ચ થાય છે.',
      'મંગળ-સૂર્ય': 'રાજકીય પદ, પ્રશાસનિક વિજય અને શત્રુઓ પર સંપૂર્ણ સરસાઈ મળે છે.',
      'મંગળ-ચંદ્ર': 'ધન સંપત્તિમાં વૃદ્ધિ, માતા સાથે સ્નેહ અને વ્યવસાયિક લાભ થાય છે.',

      // Rahu Maha
      'રાહુ-રાહુ': 'અચાનક ફેરફારો અને નવી તકો મળે છે. વિદેશ યાત્રા કે આઇટી ક્ષેત્રે મોટો લાભ થાય છે.',
      'રાહુ-ગુરુ': 'ગુરુ ચાંડાલ પ્રભાવમાં સદાચાર રાખવો. વિષ્ણુ સહસ્રનામથી ગુરુકૃપા અને જ્ઞાનલાભ થાય છે.',
      'રાહુ-શનિ': 'ધીમી પણ અડગ પ્રગતિ. શનિવારે દીપદાનથી જૂની મુશ્કેલીઓનો અંત આવે છે.',
      'રાહુ-બુધ': 'બૌદ્ધિક પ્રતિભાથી આઇટી, શેરબજાર કે કન્સલ્ટિંગમાં બમ્પર નફો મળે છે.',
      'રાહુ-કેતુ': 'આધ્યાત્મિક વૈરાગ્ય અને જીવનના ગૂઢ રહસ્યો સમજવાનો સમય છે.',
      'રાહુ-શુક્ર': 'ભૌતિક વૈભવ, મોજશોખ અને વિદેશી સાધન-સંપત્તિમાં પ્રચંડ વૃદ્ધિ થાય છે.',
      'રાહુ-સૂર્ય': 'સૂર્ય આરાધનાથી માન-સન્માન વધે છે અને વિદેશી શાસનથી લાભ થાય છે.',
      'રાહુ-ચંદ્ર': 'ભાવનાત્મક સ્થિરતા જાળવવી. શિવપૂજનથી માનસિક શક્તિમાં વૃદ્ધિ થાય છે.',
      'રાહુ-મંગળ': 'હનુમાનજીની ભક્તિથી શત્રુવિજય અને જમીન-સંપત્તિમાં અણધાર્યો ફાયદો થાય છે.',

      // Jupiter Maha
      'ગુરુ-ગુરુ': 'પરમ જ્ઞાન, સંતાન સુખ, ધર્મ-કર્મ અને આર્થિક સમૃદ્ધિનો સુવર્ણ કાળ છે.',
      'ગુરુ-શનિ': 'સ્થાયી સંપત્તિનું સર્જન, ગંભીર જ્ઞાન અને સમાજમાં સ્થિર પ્રતિષ્ઠા મળે છે.',
      'ગુરુ-બુધ': 'વિદ્યા, વક્તૃત્વ, પુસ્તક લેખન અને વાણિજ્યમાં સર્વોચ્ચ સફળતા મળે છે.',
      'ગુરુ-કેતુ': 'આધ્યાત્મિક ઊંચાઈઓ, ગુરુકૃપા અને તીર્થયાત્રાઓનો આશીર્વાદ પ્રાપ્ત થાય છે.',
      'ગુરુ-શુક્ર': 'વાહન, ઉત્તમ વૈભવ, વિવાહ અને રાજવી સુખોનો અદભુત યોગ બને છે.',
      'ગુરુ-સૂર્ય': 'પ્રશાસનમાં ઉચ્ચ સન્માન, આત્મોન્નતિ અને રાજ્ય તરફથી પુરસ્કાર મળે છે.',
      'ગુરુ-ચંદ્ર': 'ગજકેસરી યોગ! પરમ શાંતિ, યશ-કીર્તિ અને અખંડ લક્ષ્મીજીનો વાસ રહે છે.',
      'ગુરુ-મંગળ': 'પરાક્રમ, ભૂમિલાભ, સાહસ અને ધર્મ રક્ષામાં વિજય પ્રાપ્ત થાય છે.',
      'ગુરુ-રાહુ': 'વિદેશગમન, ઉચ્ચ સંશોધન અને અણધારી તકોનો સમય છે.',

      // Saturn Maha
      'શનિ-શનિ': 'પરિશ્રમનું શ્રેષ્ઠ ફળ, અનુશાસન અને જીવનમાં મજબૂત પાયો નંખાય છે.',
      'શનિ-બુધ': 'બિઝનેસમાં તેજી, મિત્રોનો સહકાર અને બૌદ્ધિક ક્ષેત્રે મોટી પ્રગતિ થાય છે.',
      'શનિ-કેતુ': 'આધ્યાત્મિક ચિંતન અને વૈરાગ્યભાવ વધે છે. શિવ સાધના ઉત્તમ છે.',
      'શનિ-શુક્ર': 'શનિ-શુક્ર મિત્રતાથી અચલ સંપત્તિ, વાહન સુખ અને વૈભવમાં વધારો થાય છે.',
      'શનિ-સૂર્ય': 'સૂર્ય-શનિના મિશ્ર પ્રભાવમાં નમ્રતા અને સૂર્ય ઉપાસનાથી યશ મળે છે.',
      'શનિ-ચંદ્ર': 'માનસિક શાંતિ જાળવવી. મહામૃત્યુંજય જાપથી મુશ્કેલીઓ આપોઆપ દૂર થાય છે.',
      'શનિ-મંગળ': 'ટેકનિકલ કાર્યમાં મોટી સફળતા મળે છે. ક્રોધ પર સંયમ રાખવો.',
      'શનિ-રાહુ': 'ધીરજથી કામ લેવું. પક્ષીઓને ચણ નાખવાથી વિઘ્નો દૂર થાય છે.',
      'શનિ-ગુરુ': 'ભાગ્યોદય, આધ્યાત્મિક સિદ્ધિ અને સમાજમાં વરિષ્ઠ પદવી પ્રાપ્ત થાય છે.',

      // Mercury Maha
      'બુધ-બુધ': 'તીક્ષ્ણ બુદ્ધિ, વ્યાપારિક સફળતા, વાકચાતુર્ય અને નવી વિદ્યા પ્રાપ્તિનો કાળ છે.',
      'બુધ-કેતુ': 'આધ્યાત્મિક જિજ્ઞાસા અને ગૂઢ વિષયોમાં ઊંડું જ્ઞાન પ્રાપ્ત થાય છે.',
      'બુધ-શુક્ર': 'કલા, સૌંદર્ય, વિલાસ અને ઉત્તમ દાંપત્ય સુખનો યોગ છે.',
      'બુધ-સૂર્ય': 'બુધાદિત્ય ફળ! સમાજમાં ઉચ્ચ માન, સરકારી સફળતા અને પ્રમોશન મળે છે.',
      'બુધ-ચંદ્ર': 'મધુર વાણી, સ્નેહ અને સર્જનાત્મક કલાઓમાં વિશેષ પ્રગતિ થાય છે.',
      'બુધ-મંગળ': 'ઝડપી નિર્ણયોથી વ્યાપારમાં લાભ. વાદ-વિવાદથી દૂર રહેવું.',
      'બુધ-રાહુ': 'આઇટી, વિદેશી વેપાર અને સંચાર માધ્યમોથી મોટો ધનલાભ થાય છે.',
      'બુધ-ગુરુ': 'ઉચ્ચ શિક્ષણ, પદવી, સંતાન સુખ અને જ્ઞાનવૃદ્ધિનો શ્રેષ્ઠ સમય છે.',
      'બુધ-શનિ': 'સ્થિર વ્યાપાર, ટેકનિકલ કાર્યો અને આયોજનબદ્ધ રોકાણમાં મોટો નફો મળે છે.',

      // Ketu Maha
      'કેતુ-કેતુ': 'આધ્યાત્મિક વૈરાગ્ય, આત્મખોજ અને ગણેશ ઉપાસનાથી શાંતિ મળે છે.',
      'કેતુ-શુક્ર': 'ભૌતિક સુખોમાં મધ્યમ ફળ. કલા અને સંગીતમાં રસ વધે છે.',
      'કેતુ-સૂર્ય': 'સૂર્ય ઉપાસનાથી આત્મબળ અને સરકારી કાર્યોમાં સફળતા મળે છે.',
      'કેતુ-ચંદ્ર': 'મનની શાંતિ માટે શિવ આરાધના શ્રેષ્ઠ છે. તીર્થયાત્રાનો યોગ બને છે.',
      'કેતુ-મંગળ': 'સાહસ વધે છે. હનુમાન ચાલીસાથી સંકટોમાંથી મુક્તિ મળે છે.',
      'કેતુ-રાહુ': 'જીવનમાં મોટા આધ્યાત્મિક પરિવર્તનો અને ગૂઢ અનુભવો થાય છે.',
      'કેતુ-ગુરુ': 'ગુરુકૃપા, ધાર્મિક યાત્રાઓ, જ્ઞાન અને ઈશ્વરભક્તિમાં સર્વોચ્ચ આનંદ મળે છે.',
      'કેતુ-શનિ': 'પરિશ્રમ અને સાધનાથી આંતરિક શક્તિનો વિકાસ થાય છે.',
      'કેતુ-બુધ': 'બૌદ્ધિક સૂઝ અને આધ્યાત્મિક પુસ્તકોના અધ્યયનથી લાભ થાય છે.',

      // Venus Maha
      'શુક્ર-શુક્ર': 'અખંડ વૈભવ, વાહન, ઉત્તમ મકાન, સ્નેહ અને સૌંદર્યનો શ્રેષ્ઠ સમય છે.',
      'શુક્ર-સૂર્ય': 'સમાજમાં પ્રતિષ્ઠા, માન-સન્માન અને સરકારી વર્તુળોમાં પ્રભાવ વધે છે.',
      'શુક્ર-ચંદ્ર': 'માનસિક પ્રસન્નતા, કૌટુંબિક સુખ અને કલા-સંગીતમાં વિશેષ સિદ્ધિ મળે છે.',
      'શુક્ર-મંગળ': 'જમીન-મકાન અને પ્રોપર્ટી ખરીદીના પ્રબળ યોગ બને છે. દાંપત્યમાં પ્રેમ વધે છે.',
      'શુક્ર-રાહુ': 'વિદેશ ગમન, આધુનિક ટેકનોલોજી અને વૈભવી સાધનોમાં વૃદ્ધિ થાય છે.',
      'શુક્ર-ગુરુ': 'જ્ઞાન, વિવાહ, સંતાન સુખ, ધનલાભ અને આધ્યાત્મિક ઉન્નતિનો ઉત્તમ સમય.',
      'શુક્ર-શનિ': 'અચલ સંપત્તિ, ઉદ્યોગ-ધંધામાં સ્થિરતા અને જૂના રોકાણોમાંથી મોટો નફો મળે છે.',
      'શુક્ર-બુધ': 'બુદ્ધિ અને કળાના સમન્વયથી વેપારમાં પ્રચંડ વૃદ્ધિ અને યશપ્રાપ્તિ થાય છે.',
      'શુક્ર-કેતુ': 'આધ્યાત્મિક સાધના અને દાન-પુણ્યમાં રુચિ વધે છે.',
    };

    final key = '$mahaLordGu-$antarLordGu';
    final gu = guMap[key] ?? '$mahaLordGu મહાદશામાં $antarLordGu અંતર્દશા શુભ અને સંતુલિત ફળ પ્રદાન કરશે.';

    // Generate matching Hindi description
    final hi = gu
        .replaceAll('સૂર્ય', 'सूर्य')
        .replaceAll('ચંદ્ર', 'चन्द्र')
        .replaceAll('મંગળ', 'मंगल')
        .replaceAll('બુધ', 'बुध')
        .replaceAll('ગુરુ', 'गुरु')
        .replaceAll('શુક્ર', 'शुक्र')
        .replaceAll('શનિ', 'शनि')
        .replaceAll('રાહુ', 'राहु')
        .replaceAll('કેતુ', 'केतु')
        .replaceAll('મહાદશા', 'महादशा')
        .replaceAll('અંતર્દશા', 'अंतर्दशा')
        .replaceAll('મળે છે', 'मिलता है')
        .replaceAll('થાય છે', 'होता है')
        .replaceAll('વધે છે', 'बढ़ता है')
        .replaceAll('યોગ બને છે', 'योग बनता है')
        .replaceAll('શાંતિ', 'शांति')
        .replaceAll('સુખ', 'सुख')
        .replaceAll('લાભ', 'लाभ');

    return {
      'gu': gu,
      'hi': hi,
    };
  }

  static Map<String, String> _getSpiritualRemedies(int lagna, int moonRashi) {
    final fifthSign = (lagna + 4 - 1) % 12 + 1;

    String ishtaHi;
    String ishtaGu;
    String mantraHi;
    String mantraGu;
    String direction;

    switch (fifthSign) {
      case 1: // Aries (Mars)
      case 8: // Scorpio (Mars)
        ishtaHi = 'भगवान श्री हनुमान जी / कार्तिकेय';
        ishtaGu = 'ભગવાન શ્રી હનુમાનજી / કાર્તિકેય';
        mantraHi = 'ॐ हं हनुमते रुद्रात्मकाय हुं फट्';
        mantraGu = 'ૐ હં હનુમતે રુદ્રાત્મકાય હૂં ફટ્';
        direction = 'દક્ષિણ (South)';
        break;
      case 2: // Taurus (Venus)
      case 7: // Libra (Venus)
        ishtaHi = 'मां महालक्ष्मी जी / मां दुर्गा';
        ishtaGu = 'માતા મહાલક્ષ્મીજી / માં અંબા';
        mantraHi = 'ॐ श्रीं ह्रीं क्लीं महालक्ष्म्यै नमः';
        mantraGu = 'ૐ શ્રીં હ્રીં ક્લીં મહાલક્ષ્મ્યૈ નમઃ';
        direction = 'અગ્નિ (South-East)';
        break;
      case 3: // Gemini (Mercury)
      case 6: // Virgo (Mercury)
        ishtaHi = 'भगवान श्री गणेश जी / श्री विष्णु';
        ishtaGu = 'ભગવાન શ્રી ગણેશજી / શ્રી મહાવિષ્ણુ';
        mantraHi = 'ॐ गं गणपतये नमः';
        mantraGu = 'ૐ ગં ગણપતયે નમઃ';
        direction = 'ઉત્તર (North)';
        break;
      case 4: // Cancer (Moon)
        ishtaHi = 'भगवान देवाधिदेव महादेव शिव';
        ishtaGu = 'ભગવાન દેવાધિદેવ મહાદેવ શિવજી';
        mantraHi = 'ॐ नमः शिवाय';
        mantraGu = 'ૐ નમઃ શિવાય';
        direction = 'વાયવ્ય (North-West)';
        break;
      case 5: // Leo (Sun)
        ishtaHi = 'भगवान श्री सूर्य नारायण / गायत्री माता';
        ishtaGu = 'ભગવાન શ્રી સૂર્યનારાયણ / ગાયત્રી માતા';
        mantraHi = 'ॐ घृणि सूर्याय नमः';
        mantraGu = 'ૐ ઘૃણિ સૂર્યાય નમઃ';
        direction = 'પૂર્વ (East)';
        break;
      case 9: // Sagittarius (Jupiter)
      case 12: // Pisces (Jupiter)
        ishtaHi = 'भगवान श्री महाविष्णु / दत्तात्रेय प्रभु';
        ishtaGu = 'ભગવાન શ્રી મહાવિષ્ણુ / દત્તાત્રેય પ્રભુ';
        mantraHi = 'ॐ नमो भगवते वासुदेवाय';
        mantraGu = 'ૐ નમો ભગવતે વાસુદેવાય';
        direction = 'ઈશાન (North-East)';
        break;
      case 10: // Capricorn (Saturn)
      case 11: // Aquarius (Saturn)
      default:
        ishtaHi = 'भगवान कालभैरव / श्री शनिदेव / शिव जी';
        ishtaGu = 'ભગવાન કાળભૈરવ / શ્રી શનિદેવ / મહાદેવ';
        mantraHi = 'ॐ शं शनैश्चराय नमः / ॐ नमः शिवाय';
        mantraGu = 'ૐ શં શનૈશ્ચરાય નમઃ / ૐ નમઃ શિવાય';
        direction = 'પશ્ચિમ (West)';
        break;
    }

    return {
      'ishtaHi': ishtaHi,
      'ishtaGu': ishtaGu,
      'mantraHi': mantraHi,
      'mantraGu': mantraGu,
      'direction': direction,
    };
  }
}
