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

  // 9 Grahas
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
      if (pid == 3 || pid == 5 || pid == 7) {
        final diff = ((geoLong - sunSayana + 360.0) % 360.0);
        planetRetroMap[pid] = (diff > 120 && diff < 240);
      } else {
        planetRetroMap[pid] = false;
      }
    }

    final result = <PlanetPosition>[];

    for (int pid = 1; pid <= 9; pid++) {
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

    const gemsHi = ['मूंगा (Red Coral)', 'हीरा (Diamond)', 'पन्ना (Emerald)', 'मोती (Pearl)', 'माणिक्य (Ruby)', 'पन्ना (Emerald)', 'हीरा (Diamond)', 'मूंगा (Red Coral)', 'पुखराज (Yellow Sapphire)', 'नीलम (Blue Sapphire)', 'नीलम (Blue Sapphire)', 'पुखराज (Yellow Sapphire)'];
    const gemsGu = ['પરવાળું (Red Coral)', 'હીરો (Diamond)', 'પન્ના (Emerald)', 'મોતી (Pearl)', 'માણેક (Ruby)', 'પન્ના (Emerald)', 'હીરો (Diamond)', 'પરવાળું (Red Coral)', 'પોખરાજ (Yellow Sapphire)', 'નીલમ (Blue Sapphire)', 'નીલમ (Blue Sapphire)', 'પોખરાજ (Yellow Sapphire)'];

    const luckyNumbers = ['9', '6', '5', '2', '1', '5', '6', '9', '3', '8', '8', '3'];
    const luckyColors = ['लाल, केसरिया (Red, Saffron)', 'सफेद, क्रीम (White, Cream)', 'हरा, पीला (Green, Yellow)', 'सफेद, चांदी (White, Silver)', 'सुनहरा, नारंगी (Gold, Orange)', 'हरा, हल्का नीला (Green, Cyan)', 'सफेद, गुलाबी (White, Pink)', 'गहरा लाल, मैरून (Maroon)', 'पीला, सुनहरा (Yellow, Gold)', 'नीला, काला (Blue, Black)', 'आसमानी नीला (Sky Blue)', 'पीला, नारंगी (Yellow, Orange)'];

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
      'luckyColor': luckyColors[rashiIdx],
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

    result.add(
      VimshottariDashaItem(
        planetNameHi: firstLordMeta['hi'] as String,
        planetNameGu: firstLordMeta['gu'] as String,
        startDate: currentStartDate,
        endDate: firstEndDate,
        durationYears: remainingFirstLordYears.round(),
        isCurrent: now.isAfter(currentStartDate) && now.isBefore(firstEndDate),
      ),
    );

    currentStartDate = firstEndDate;

    for (int i = 1; i < 9; i++) {
      final lordIdx = (startLordIdx + i) % 9;
      final lordMeta = dashaCycle[lordIdx];
      final years = lordMeta['years'] as int;
      final days = (years * 365.25).round();
      final endDate = currentStartDate.add(Duration(days: days));

      result.add(
        VimshottariDashaItem(
          planetNameHi: lordMeta['hi'] as String,
          planetNameGu: lordMeta['gu'] as String,
          startDate: currentStartDate,
          endDate: endDate,
          durationYears: years,
          isCurrent: now.isAfter(currentStartDate) && now.isBefore(endDate),
        ),
      );

      currentStartDate = endDate;
    }

    return result;
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

    // 6. Raja Yogas & Special Auspicious Combinations (વિશેષ રાજયોગ)
    final rajaYogas = _detectRajaYogas(lagnaRashiId, moonRashiId, planets);

    // 7. Ishta Devata & Sacred Mantras
    final spiritualData = _getSpiritualRemedies(lagnaRashiId, moonRashiId);

    return KundaliLifePrediction(
      physicalAppearance: appearanceData,
      personalitySwabhav: swabhavData,
      marriagePrediction: marriageData,
      careerBhagyodaya: careerData,
      healthPrediction: healthData,
      rajaYogasHi: rajaYogas['hi']!,
      rajaYogasGu: rajaYogas['gu']!,
      luckyDirection: spiritualData['direction']!,
      ishtaDevataHi: spiritualData['ishtaHi']!,
      ishtaDevataGu: spiritualData['ishtaGu']!,
      sacredMantraHi: spiritualData['mantraHi']!,
      sacredMantraGu: spiritualData['mantraGu']!,
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
    String timingAgeHi;
    String timingAgeGu;

    switch (lagna) {
      case 1: // Aries -> 7th Libra (Venus)
      case 7: // Libra -> 7th Aries (Mars)
        timingAgeHi = '24 से 27 वर्ष की आयु (उत्तम विवाह योग)';
        timingAgeGu = '૨૪ થી ૨૭ વર્ષની વય (ઉત્તમ લગ્ન યોગ)';
        break;
      case 2: // Taurus -> 7th Scorpio (Mars)
      case 8: // Scorpio -> 7th Taurus (Venus)
        timingAgeHi = '25 से 28 वर्ष की आयु (शुभ विवाह काल)';
        timingAgeGu = '૨૫ થી ૨૮ વર્ષની વય (શુભ લગ્ન સમય)';
        break;
      case 3: // Gemini -> 7th Sagittarius (Jupiter)
      case 9: // Sagittarius -> 7th Gemini (Mercury)
        timingAgeHi = '23 से 27 वर्ष की आयु (भाग्यशाली विवाह योग)';
        timingAgeGu = '૨૩ થી ૨૭ વર્ષની વય (ભાગ્યશાળી લગ્ન યોગ)';
        break;
      case 4: // Cancer -> 7th Capricorn (Saturn)
      case 10: // Capricorn -> 7th Cancer (Moon)
        timingAgeHi = '26 से 29 वर्ष की आयु (परिपक्व एवं स्थिर दांपत्य योग)';
        timingAgeGu = '૨૬ થી ૨૯ વર્ષની વય (પરિપક્વ અને સ્થિર દાંપત્ય યોગ)';
        break;
      case 5: // Leo -> 7th Aquarius (Saturn)
      case 11: // Aquarius -> 7th Leo (Sun)
        timingAgeHi = '26 से 30 वर्ष की आयु (प्रतिष्ठित विवाह योग)';
        timingAgeGu = '૨૬ થી ૩૦ વર્ષની વય (પ્રતિષ્ઠિત લગ્ન યોગ)';
        break;
      case 6: // Virgo -> 7th Pisces (Jupiter)
      case 12: // Pisces -> 7th Virgo (Mercury)
      default:
        timingAgeHi = '25 से 28 वर्ष की आयु (सुखद दांपत्य योग)';
        timingAgeGu = '૨૫ થી ૨૮ વર્ષની વય (સુખદ દાંપત્ય યોગ)';
        break;
    }

    final descHi = 'सप्तम भाव के स्वामी एवं शुभ ग्रहों के अनुकूल प्रभाव से आपका जीवनसाथी संस्कारी, रूपवान, बुद्धिमान और पारिवारिक मूल्यों का आदर करने वाला होगा। विवाह के पश्चात आपके भाग्य और आर्थिक स्थिति में विशेष वृद्धि होगी। दांपत्य जीवन में परस्पर समझ, सम्मान और प्रेम का सुंदर समन्वय रहेगा।';
    final descGu = 'સપ્તમ ભાવના અધિપતિ અને શુભ ગ્રહોના અનુકૂળ પ્રભાવ અનુસાર તમારા જીવનસાથી સંસ્કારી, દેખાવડા, બુદ્ધિશાળી અને કૌટુંબિક મૂલ્યોનું સન્માન કરનારા હશે. લગ્ન પછી તમારા ભાગ્ય અને આર્થિક સમૃદ્ધિમાં વિશેષ વૃદ્ધિ થશે. દાંપત્ય જીવનમાં પરસ્પર આદર, સમજણ અને પ્રેમનો ઉત્તમ સમન્વય રહેશે.';

    final highlightsHi = [
      timingAgeHi,
      'सुशिक्षित एवं संस्कारी जीवनसाथी',
      'विवाह के उपरांत तीव्र भाग्योदय',
      'स्थिर एवं सुखमय दांपत्य जीवन',
    ];

    final highlightsGu = [
      timingAgeGu,
      'સુશિક્ષિત અને સંસ્કારી જીવનસાથી',
      'લગ્ન પછી વિશેષ ભાગ્યોદય',
      'સ્થિર અને સુખમય દાંપત્ય જીવન',
    ];

    return LifeAspectPrediction(
      titleHi: 'विवाह समय एवं दांपत्य योग',
      titleGu: 'વિવાહ અને દાંપત્ય યોગ',
      descriptionHi: descHi,
      descriptionGu: descGu,
      highlightsHi: highlightsHi,
      highlightsGu: highlightsGu,
      timingOrAge: timingAgeGu,
      iconName: 'favorite',
    );
  }

  static LifeAspectPrediction _getCareerBhagyodaya(int lagna, int moonRashi, List<PlanetPosition> planets, DateTime birthDate) {
    String bhagyaYearHi = '28वें एवं 32वें वर्ष में तीव्र भाग्योदय';
    String bhagyaYearGu = '૨૮મા તેમજ ૩૨મા વર્ષે પ્રબળ ભાગ્યોદય';

    switch (lagna) {
      case 1: // Aries -> Jupiter 9th lord -> 16, 22, 28, 32
        bhagyaYearHi = '22वें एवं 28वें वर्ष में प्रमुख भाग्योदय योग';
        bhagyaYearGu = '૨૨મા તેમજ ૨૮મા વર્ષે મુખ્ય ભાગ્યોદય યોગ';
        break;
      case 2: // Taurus -> Saturn 9th lord -> 36
        bhagyaYearHi = '32वें एवं 36वें वर्ष में स्थायी भाग्योदय';
        bhagyaYearGu = '૩૨મા તેમજ ૩૬મા વર્ષે કાયમી ભાગ્યોદય';
        break;
      case 3: // Gemini -> Saturn 9th lord -> 36
        bhagyaYearHi = '25वें एवं 32वें वर्ष में भाग्योदय';
        bhagyaYearGu = '૨૫મા તેમજ ૩૨મા વર્ષે ભાગ્યોદય';
        break;
      case 4: // Cancer -> Jupiter 9th lord -> 16, 22, 28, 32
        bhagyaYearHi = '24वें एवं 28वें वर्ष में भाग्योदय योग';
        bhagyaYearGu = '૨૪મા તેમજ ૨૮મા વર્ષે ભાગ્યોદય યોગ';
        break;
      case 5: // Leo -> Mars 9th lord -> 28
        bhagyaYearHi = '28वें एवं 34वें वर्ष में राजयोग एवं भाग्योदय';
        bhagyaYearGu = '૨૮મા તેમજ ૩૪મા વર્ષે રાજયોગ અને ભાગ્યોદય';
        break;
      case 6: // Virgo -> Venus 9th lord -> 25
        bhagyaYearHi = '25वें एवं 33वें वर्ष में धन लाभ एवं भाग्योदय';
        bhagyaYearGu = '૨૫મા તેમજ ૩૩મા વર્ષે ધનલાભ અને ભાગ્યોદય';
        break;
      case 7: // Libra -> Mercury 9th lord -> 32
        bhagyaYearHi = '24वें एवं 32वें वर्ष में व्यावसायिक भाग्योदय';
        bhagyaYearGu = '૨૪મા તેમજ ૩૨મા વર્ષે વ્યવસાયિક ભાગ્યોદય';
        break;
      case 8: // Scorpio -> Moon 9th lord -> 24
        bhagyaYearHi = '24वें एवं 28वें वर्ष में उन्नति योग';
        bhagyaYearGu = '૨૪મા તેમજ ૨૮મા વર્ષે ઉન્નતિ યોગ';
        break;
      case 9: // Sagittarius -> Sun 9th lord -> 22
        bhagyaYearHi = '22वें एवं 29वें वर्ष में विशेष सम्मान व भाग्योदय';
        bhagyaYearGu = '૨૨મા તેમજ ૨૯મા વર્ષે વિશેષ માન-સન્માન અને ભાગ્યોદય';
        break;
      case 10: // Capricorn -> Mercury 9th lord -> 32
        bhagyaYearHi = '28वें, 32वें एवं 36वें वर्ष में प्रचंड भाग्योदय एवं कीर्ति';
        bhagyaYearGu = '૨૮મા, ૩૨મા તેમજ ૩૬મા વર્ષે પ્રચંડ ભાગ્યોદય અને યશ-કીર્તિ';
        break;
      case 11: // Aquarius -> Venus 9th lord -> 25
        bhagyaYearHi = '25वें एवं 36वें वर्ष में धनधान्य व भाग्योदय';
        bhagyaYearGu = '૨૫મા તેમજ ૩૬મા વર્ષે ધનધાન્ય અને ભાગ્યોદય';
        break;
      case 12: // Pisces -> Mars 9th lord -> 28
        bhagyaYearHi = '28वें एवं 35वें वर्ष में भाग्योदय व यश';
        bhagyaYearGu = '૨૮મા તેમજ ૩૫મા વર્ષે ભાગ્યોદય અને યશપ્રાપ્તિ';
        break;
    }

    final descHi = 'कर्म भाव (10th House) और भाग्य भाव (9th House) की युति के अनुसार आप अपनी बुद्धि, परिश्रम और कुशल प्रबंधन से उच्च सफलता अर्जित करेंगे। आईटी/सॉफ्टवेयर, व्यापार, प्रबंधन, सरकारी सेवा, वित्तीय परामर्श या तकनीकी क्षेत्र में आपका करियर अत्यंत उज्ज्वल रहेगा। 30 वर्ष की आयु के पश्चात निरंतर आर्थिक प्रगति एवं भूमि-भवन का प्रबल योग है।';
    final descGu = 'કર્મ ભાવ (10મો ભાવ) અને ભાગ્ય ભાવ (9મો ભાવ) ના પ્રબળ પ્રભાવ અનુસાર તમે તમારી બુદ્ધિપ્રતિભા, પરિશ્રમ અને કુશળ આયોજનથી સર્વોચ્ચ શિખરો સર કરશો. આઇટી/ટેકનોલોજી, વેપાર-વાણિજ્ય, મેનેજમેન્ટ, સરકારી ક્ષેત્ર, ફાયનાન્સ અથવા કન્સલ્ટિંગ ક્ષેત્રે તમારી કારકિર્દી અત્યંત ઝળહળતી રહેશે. ૩૦ વર્ષની વય પછી અવિરત આર્થિક પ્રગતિ તેમજ જમીન-મકાન ખરીદવાના પ્રબળ યોગ બને છે.';

    final hlHi = [
      'सटीक भाग्योदय काल: $bhagyaYearHi',
      'अनुकूल क्षेत्र: आईटी, व्यापार, प्रबंधन एवं परामर्श',
      'अचल संपत्ति एवं वाहन सुख का प्रबल योग',
      'आयु के मध्य भाग में निरंतर आर्थिक समृद्धि',
    ];

    final hlGu = [
      'ચોક્કસ ભાગ્યોદય કાળ: $bhagyaYearGu',
      'શ્રેષ્ઠ ક્ષેત્રો: આઇટી, બિઝનેસ, મેનેજમેન્ટ અને કન્સલ્ટિંગ',
      'અચલ સંપત્તિ (જમીન-મકાન) અને વાહન સુખનો પ્રબળ યોગ',
      'ઉંમરના મધ્ય ભાગમાં સતત આર્થિક સમૃદ્ધિ',
    ];

    return LifeAspectPrediction(
      titleHi: 'भाग्योदय एवं करियर योग',
      titleGu: 'ભાગ્યોદય અને કારકિર્દી યોગ',
      descriptionHi: descHi,
      descriptionGu: descGu,
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

  static Map<String, List<String>> _detectRajaYogas(int lagna, int moonRashi, List<PlanetPosition> planets) {
    final yogasHi = <String>[];
    final yogasGu = <String>[];

    final sun = planets.firstWhere((p) => p.id == 1, orElse: () => planets.first);
    final moon = planets.firstWhere((p) => p.id == 2, orElse: () => planets.first);
    final mars = planets.firstWhere((p) => p.id == 3, orElse: () => planets.first);
    final mercury = planets.firstWhere((p) => p.id == 4, orElse: () => planets.first);
    final jupiter = planets.firstWhere((p) => p.id == 5, orElse: () => planets.first);
    final venus = planets.firstWhere((p) => p.id == 6, orElse: () => planets.first);
    final saturn = planets.firstWhere((p) => p.id == 7, orElse: () => planets.first);

    // 1. Budhaditya Yoga (Sun + Mercury in same house)
    if (sun.houseNumber == mercury.houseNumber) {
      yogasHi.add('बुधादित्य राजयोग (सूर्य + बुध کی युति - कुशाग्र बुद्धि, प्रशासनिक सफलता एवं समाज में उच्च प्रतिष्ठा)');
      yogasGu.add('બુધાદિત્ય રાજયોગ (સૂર્ય + બુધની યુતિ - તીક્ષ્ણ બુદ્ધિપ્રતિભા, પ્રશાસનિક સફળતા અને સમાજમાં ઊંચી પ્રતિષ્ઠા)');
    }

    // 2. Gajakesari Yoga (Jupiter in 1, 4, 7, 10 from Moon)
    final jupFromMoon = ((jupiter.houseNumber - moon.houseNumber + 12) % 12) + 1;
    if ([1, 4, 7, 10].contains(jupFromMoon)) {
      yogasHi.add('गजकेसरी योग (गुरु-चंद्र केंद्र - अपार कीर्ति, ज्ञान, संपत्ति और दीर्घकालिक सम्मान)');
      yogasGu.add('ગજકેસરી યોગ (ગુરુ-ચંદ્ર કેન્દ્ર - અપરંપાર યશ-કીર્તિ, જ્ઞાન, અચલ સંપત્તિ અને સન્માન)');
    }

    // 3. Chandra-Mangal Dhan Yoga (Moon + Mars together or mutual aspect)
    if (moon.houseNumber == mars.houseNumber || ((moon.houseNumber - mars.houseNumber).abs() == 6)) {
      yogasHi.add('चन्द्र-मंगल धन योग (आर्थिक प्रचुरता, व्यापारिक सफलता एवं अचल संपत्ति का वरदान)');
      yogasGu.add('ચંદ્ર-મંગળ ધન યોગ (આર્થિક સમૃદ્ધિ, વ્યાપારી વિજય અને જમીન-મકાનનો શુભ યોગ)');
    }

    // 4. Panch Mahapurusha Yogas (In Kendra 1,4,7,10 from Lagna in own/exalted signs)
    if ([1, 4, 7, 10].contains(saturn.houseNumber) && [7, 10, 11].contains(saturn.rashiId)) {
      yogasHi.add('शश महापुरुष राजयोग (शनि केंद्रस्थ - नेतृत्व, जनसमर्थन, दीर्घायु एवं स्थायी सत्ता)');
      yogasGu.add('શશ મહાપુરુષ રાજયોગ (શનિ કેન્દ્રસ્થ - જનસમર્થન, નેતૃત્વ, દીર્ઘાયુ અને કાયમી સત્તા)');
    }

    if ([1, 4, 7, 10].contains(jupiter.houseNumber) && [4, 9, 12].contains(jupiter.rashiId)) {
      yogasHi.add('हंस महापुरुष राजयोग (गुरु केंद्रस्थ - उच्च आध्यात्मिक ज्ञान, सात्विक वैभव एवं सर्वत्र वंदनीय पद)');
      yogasGu.add('હંસ મહાપુરુષ રાજયોગ (ગુરુ કેન્દ્રસ્થ - ઉચ્ચ જ્ઞાન, સાત્વિક ઐશ્વર્ય અને સર્વત્ર પૂજનીય પદ)');
    }

    if ([1, 4, 7, 10].contains(venus.houseNumber) && [2, 7, 12].contains(venus.rashiId)) {
      yogasHi.add('मालव्य महापुरुष राजयोग (शुक्र केंद्रस्थ - वाहन, विलासिता, कला एवं अखंड ऐश्वर्य)');
      yogasGu.add('માલવ્ય મહાપુરુષ રાજયોગ (શુક્ર કેન્દ્રસ્થ - ભૌતિક સુખો, વૈભવ, કલા અને અખંડ ઐશ્વર્ય)');
    }

    if ([1, 4, 7, 10].contains(mercury.houseNumber) && [3, 6].contains(mercury.rashiId)) {
      yogasHi.add('भद्र महापुरुष राजयोग (बुध केंद्रस्थ - अद्भुत वाकपटुता, वाणिज्य सफलता एवं बौद्धिक प्रभुत्व)');
      yogasGu.add('ભદ્ર મહાપુરુષ રાજયોગ (બુધ કેન્દ્રસ્થ - અદભુત વાણી પ્રભાવ, વાણિજ્ય વિજય અને બૌદ્ધિક વર્ચસ્વ)');
    }

    if ([1, 4, 7, 10].contains(mars.houseNumber) && [1, 8, 10].contains(mars.rashiId)) {
      yogasHi.add('रुचक महापुरुष राजयोग (मंगल केंद्रस्थ - असीम साहस, विजय, भूमि-भवन एवं पराक्रम)');
      yogasGu.add('રુચક મહાપુરુષ રાજયોગ (મંગળ કેન્દ્રસ્થ - અસીમ સાહસ, વિજય, જમીન-સંપત્તિ અને પરાક્રમ)');
    }

    if ([1, 5, 9].contains(jupiter.houseNumber) || [1, 5, 9].contains(venus.houseNumber)) {
      yogasHi.add('महालक्ष्मी धन योग (त्रिकोणस्थ शुभ ग्रह - प्रचुर धन प्राप्ति, मान-सम्मान एवं सुख-शांति)');
      yogasGu.add('મહાલક્ષ્મી ધન યોગ (ત્રિકોણસ્થ શુભ ગ્રહ - પ્રચુર ધનલાભ, માન-સન્માન અને સુખ-શાંતિ)');
    }

    if (yogasHi.isEmpty) {
      yogasHi.add('शुभ कर्तरी योग (ग्रहों की शुभ अनुकूलता से जीवन में समय पर कार्य सिद्धि एवं ईश्वरीय कृपा)');
      yogasGu.add('શુભ કર્તરી યોગ (ગ્રહોની શુભ અનુકૂળતાથી જીવનમાં સમયસર કાર્યસિદ્ધિ અને ઈશ્વરીય કૃપા)');
    }

    return {
      'hi': yogasHi,
      'gu': yogasGu,
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
