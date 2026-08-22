enum Gender { male, female, other }

class KundaliProfile {
  final String id;
  final String name;
  final Gender gender;
  final DateTime dateOfBirth;
  final int birthTimeHour;
  final int birthTimeMinute;
  final String cityName;
  final double latitude;
  final double longitude;
  final double timezone;
  final DateTime createdAt;

  const KundaliProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.birthTimeHour,
    required this.birthTimeMinute,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    this.timezone = 5.5,
    required this.createdAt,
  });

  String get formattedTime {
    final hour = birthTimeHour % 12 == 0 ? 12 : birthTimeHour % 12;
    final minute = birthTimeMinute.toString().padLeft(2, '0');
    final period = birthTimeHour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender.name,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'birthTimeHour': birthTimeHour,
        'birthTimeMinute': birthTimeMinute,
        'cityName': cityName,
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory KundaliProfile.fromJson(Map<String, dynamic> json) => KundaliProfile(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] as String? ?? 'जातक',
        gender: Gender.values.firstWhere(
          (e) => e.name == json['gender'],
          orElse: () => Gender.male,
        ),
        dateOfBirth: DateTime.tryParse(json['dateOfBirth'] as String? ?? '') ?? DateTime.now(),
        birthTimeHour: json['birthTimeHour'] as int? ?? 12,
        birthTimeMinute: json['birthTimeMinute'] as int? ?? 0,
        cityName: json['cityName'] as String? ?? 'New Delhi',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
        timezone: (json['timezone'] as num?)?.toDouble() ?? 5.5,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

class PlanetPosition {
  final int id;
  final String nameHi;
  final String nameGu;
  final String nameEn;
  final String shortHi;
  final String shortGu;
  final String shortEn;
  final int rashiId; // 1: Aries to 12: Pisces
  final double degree; // 0.0 to 30.0 inside the Rashi
  final int houseNumber; // 1 to 12
  final int navamshaRashiId; // 1 to 12
  final String nakshatra;
  final int pada;
  final bool isRetrograde;

  const PlanetPosition({
    required this.id,
    required this.nameHi,
    required this.nameGu,
    required this.nameEn,
    required this.shortHi,
    required this.shortGu,
    required this.shortEn,
    required this.rashiId,
    required this.degree,
    required this.houseNumber,
    required this.navamshaRashiId,
    required this.nakshatra,
    required this.pada,
    this.isRetrograde = false,
  });

  String get formattedDegree {
    final deg = degree.floor();
    final min = ((degree - deg) * 60).round();
    return '$deg° ${min.toString().padLeft(2, '0')}\'';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameHi': nameHi,
        'nameGu': nameGu,
        'nameEn': nameEn,
        'shortHi': shortHi,
        'shortGu': shortGu,
        'shortEn': shortEn,
        'rashiId': rashiId,
        'degree': degree,
        'houseNumber': houseNumber,
        'navamshaRashiId': navamshaRashiId,
        'nakshatra': nakshatra,
        'pada': pada,
        'isRetrograde': isRetrograde,
      };

  factory PlanetPosition.fromJson(Map<String, dynamic> json) => PlanetPosition(
        id: json['id'] as int? ?? 1,
        nameHi: json['nameHi'] as String? ?? '',
        nameGu: json['nameGu'] as String? ?? '',
        nameEn: json['nameEn'] as String? ?? '',
        shortHi: json['shortHi'] as String? ?? '',
        shortGu: json['shortGu'] as String? ?? '',
        shortEn: json['shortEn'] as String? ?? '',
        rashiId: json['rashiId'] as int? ?? 1,
        degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
        houseNumber: json['houseNumber'] as int? ?? 1,
        navamshaRashiId: json['navamshaRashiId'] as int? ?? 1,
        nakshatra: json['nakshatra'] as String? ?? '',
        pada: json['pada'] as int? ?? 1,
        isRetrograde: json['isRetrograde'] as bool? ?? false,
      );
}

class MangalDoshaResult {
  final bool hasDosha;
  final String doshaTypeHi;
  final String doshaTypeGu;
  final String descriptionHi;
  final String descriptionGu;
  final String remedyHi;
  final String remedyGu;

  const MangalDoshaResult({
    required this.hasDosha,
    required this.doshaTypeHi,
    required this.doshaTypeGu,
    required this.descriptionHi,
    required this.descriptionGu,
    required this.remedyHi,
    required this.remedyGu,
  });

  Map<String, dynamic> toJson() => {
        'hasDosha': hasDosha,
        'doshaTypeHi': doshaTypeHi,
        'doshaTypeGu': doshaTypeGu,
        'descriptionHi': descriptionHi,
        'descriptionGu': descriptionGu,
        'remedyHi': remedyHi,
        'remedyGu': remedyGu,
      };

  factory MangalDoshaResult.fromJson(Map<String, dynamic> json) => MangalDoshaResult(
        hasDosha: json['hasDosha'] as bool? ?? false,
        doshaTypeHi: json['doshaTypeHi'] as String? ?? '',
        doshaTypeGu: json['doshaTypeGu'] as String? ?? '',
        descriptionHi: json['descriptionHi'] as String? ?? '',
        descriptionGu: json['descriptionGu'] as String? ?? '',
        remedyHi: json['remedyHi'] as String? ?? '',
        remedyGu: json['remedyGu'] as String? ?? '',
      );
}

class VimshottariDashaItem {
  final String planetNameHi;
  final String planetNameGu;
  final DateTime startDate;
  final DateTime endDate;
  final int durationYears;
  final bool isCurrent;

  const VimshottariDashaItem({
    required this.planetNameHi,
    required this.planetNameGu,
    required this.startDate,
    required this.endDate,
    required this.durationYears,
    required this.isCurrent,
  });

  Map<String, dynamic> toJson() => {
        'planetNameHi': planetNameHi,
        'planetNameGu': planetNameGu,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'durationYears': durationYears,
        'isCurrent': isCurrent,
      };

  factory VimshottariDashaItem.fromJson(Map<String, dynamic> json) => VimshottariDashaItem(
        planetNameHi: json['planetNameHi'] as String? ?? '',
        planetNameGu: json['planetNameGu'] as String? ?? '',
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now(),
        durationYears: json['durationYears'] as int? ?? 0,
        isCurrent: json['isCurrent'] as bool? ?? false,
      );
}

class BhavaInterpretation {
  final int houseNumber;
  final String titleHi;
  final String titleGu;
  final String descriptionHi;
  final String descriptionGu;
  final int signId;
  final List<String> planetsPresent;

  const BhavaInterpretation({
    required this.houseNumber,
    required this.titleHi,
    required this.titleGu,
    required this.descriptionHi,
    required this.descriptionGu,
    required this.signId,
    required this.planetsPresent,
  });

  Map<String, dynamic> toJson() => {
        'houseNumber': houseNumber,
        'titleHi': titleHi,
        'titleGu': titleGu,
        'descriptionHi': descriptionHi,
        'descriptionGu': descriptionGu,
        'signId': signId,
        'planetsPresent': planetsPresent,
      };

  factory BhavaInterpretation.fromJson(Map<String, dynamic> json) => BhavaInterpretation(
        houseNumber: json['houseNumber'] as int? ?? 1,
        titleHi: json['titleHi'] as String? ?? '',
        titleGu: json['titleGu'] as String? ?? '',
        descriptionHi: json['descriptionHi'] as String? ?? '',
        descriptionGu: json['descriptionGu'] as String? ?? '',
        signId: json['signId'] as int? ?? 1,
        planetsPresent: (json['planetsPresent'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
}

class LifeAspectPrediction {
  final String titleHi;
  final String titleGu;
  final String descriptionHi;
  final String descriptionGu;
  final List<String> highlightsHi;
  final List<String> highlightsGu;
  final String? timingOrAge;
  final String iconName;

  const LifeAspectPrediction({
    required this.titleHi,
    required this.titleGu,
    required this.descriptionHi,
    required this.descriptionGu,
    this.highlightsHi = const [],
    this.highlightsGu = const [],
    this.timingOrAge,
    required this.iconName,
  });

  Map<String, dynamic> toJson() => {
        'titleHi': titleHi,
        'titleGu': titleGu,
        'descriptionHi': descriptionHi,
        'descriptionGu': descriptionGu,
        'highlightsHi': highlightsHi,
        'highlightsGu': highlightsGu,
        'timingOrAge': timingOrAge,
        'iconName': iconName,
      };

  factory LifeAspectPrediction.fromJson(Map<String, dynamic> json) => LifeAspectPrediction(
        titleHi: json['titleHi'] as String? ?? '',
        titleGu: json['titleGu'] as String? ?? '',
        descriptionHi: json['descriptionHi'] as String? ?? '',
        descriptionGu: json['descriptionGu'] as String? ?? '',
        highlightsHi: (json['highlightsHi'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        highlightsGu: (json['highlightsGu'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        timingOrAge: json['timingOrAge'] as String?,
        iconName: json['iconName'] as String? ?? 'auto_awesome',
      );
}

class KundaliLifePrediction {
  final LifeAspectPrediction physicalAppearance; // દેખાવ અને શારીરિક સ્વરૂપ
  final LifeAspectPrediction personalitySwabhav; // સ્વભાવ અને વ્યક્તિત્વ
  final LifeAspectPrediction marriagePrediction; // લગ્ન સમય, જીવનસાથી અને દાંપત્ય
  final LifeAspectPrediction careerBhagyodaya; // ભાગ્યોદય સમય, કારકિર્દી અને ધન
  final LifeAspectPrediction healthPrediction; // આરોગ્ય અને સુખાકારી
  final List<String> rajaYogasHi; // વિશેષ રાજયોગ
  final List<String> rajaYogasGu;
  final String luckyDirection;
  final String ishtaDevataHi;
  final String ishtaDevataGu;
  final String sacredMantraHi;
  final String sacredMantraGu;

  const KundaliLifePrediction({
    required this.physicalAppearance,
    required this.personalitySwabhav,
    required this.marriagePrediction,
    required this.careerBhagyodaya,
    required this.healthPrediction,
    this.rajaYogasHi = const [],
    this.rajaYogasGu = const [],
    required this.luckyDirection,
    required this.ishtaDevataHi,
    required this.ishtaDevataGu,
    required this.sacredMantraHi,
    required this.sacredMantraGu,
  });

  Map<String, dynamic> toJson() => {
        'physicalAppearance': physicalAppearance.toJson(),
        'personalitySwabhav': personalitySwabhav.toJson(),
        'marriagePrediction': marriagePrediction.toJson(),
        'careerBhagyodaya': careerBhagyodaya.toJson(),
        'healthPrediction': healthPrediction.toJson(),
        'rajaYogasHi': rajaYogasHi,
        'rajaYogasGu': rajaYogasGu,
        'luckyDirection': luckyDirection,
        'ishtaDevataHi': ishtaDevataHi,
        'ishtaDevataGu': ishtaDevataGu,
        'sacredMantraHi': sacredMantraHi,
        'sacredMantraGu': sacredMantraGu,
      };

  factory KundaliLifePrediction.fromJson(Map<String, dynamic> json) => KundaliLifePrediction(
        physicalAppearance: json['physicalAppearance'] != null && (json['physicalAppearance']['descriptionGu'] as String? ?? '').isNotEmpty
            ? LifeAspectPrediction.fromJson(json['physicalAppearance'] as Map<String, dynamic>)
            : const LifeAspectPrediction(
                titleHi: 'शारीरिक रूप-रंग एवं व्यक्तित्व स्वरूप',
                titleGu: 'શારીરિક દેખાવ અને વ્યક્તિત્વ સ્વરૂપ',
                descriptionHi: 'मध्यम से लंबा सुगठित कद, विचारमग्न गंभीर आंखें, आकर्षक मुखाकृति एवं राजसी गरिमा। आयु के साथ चेहरे पर और अधिक निखार, गंभीरता एवं तेज प्रकट होता है।',
                descriptionGu: 'મધ્યમથી ઊંચું સુદ્રઢ કદ, વિચારશીલ ગંભીર આંખો, આકર્ષક ચહેરો અને રાજવી ગરિમા. ઉંમર વધવાની સાથે ચહેરા પર વધુ તેજ, ગંભીરતા અને પરિપક્વ નિખાર પ્રગટ થાય છે.',
                highlightsHi: ['सुगठित अस्थि ढांचा', 'गंभीर विचारशील आंखें', 'राजसी गरिमा'],
                highlightsGu: ['સુદ્રઢ મજબૂત બાંધો', 'વિચારશીલ ગંભીર આંખો', 'પરિપક્વ રાજવી ગરિમા'],
                iconName: 'face',
              ),
        personalitySwabhav: json['personalitySwabhav'] != null && (json['personalitySwabhav']['descriptionGu'] as String? ?? '').isNotEmpty
            ? LifeAspectPrediction.fromJson(json['personalitySwabhav'] as Map<String, dynamic>)
            : const LifeAspectPrediction(
                titleHi: 'स्वभाव, व्यवहार एवं व्यक्तित्व',
                titleGu: 'સ્વભાવ, આચરણ અને વ્યક્તિત્વ',
                descriptionHi: 'शांत, दयालु, आध्यात्मिक, ईमानदार और कर्तव्यनिष्ठ स्वभाव। दूसरों की सहायता के लिए तत्पर रहते हैं और अपने लक्ष्य के प्रति दृढ़ संकल्पित रहते हैं।',
                descriptionGu: 'શાંત, દયાળુ, આધ્યાત્મિક, પ્રમાણિક અને કર્તવ્યનિષ્ઠ સ્વભાવ. અન્યોની સહાય માટે સદા તત્પર રહે છે અને પોતાના લક્ષ્ય પ્રત્યે દ્રઢ સંકલ્પબદ્ધ રહે છે.',
                highlightsHi: ['कर्तव्यनिष्ठ एवं ईमानदार', 'शांत एवं आध्यात्मिक मन', 'दृढ़ संकल्प'],
                highlightsGu: ['કર્તવ્યનિષ્ઠ અને પ્રમાણિક', 'શાંત અને આધ્યાત્મિક મન', 'દ્રઢ સંકલ્પ'],
                iconName: 'psychology',
              ),
        marriagePrediction: json['marriagePrediction'] != null && (json['marriagePrediction']['descriptionGu'] as String? ?? '').isNotEmpty
            ? LifeAspectPrediction.fromJson(json['marriagePrediction'] as Map<String, dynamic>)
            : const LifeAspectPrediction(
                titleHi: 'विवाह समय एवं दांपत्य योग',
                titleGu: 'વિવાહ અને દાંપત્ય યોગ',
                descriptionHi: 'सप्तम भाव के शुभ प्रभाव से आपका जीवनसाथी संस्कारी, बुद्धिमान, रूपवान और पारिवारिक मूल्यों का सम्मान करने वाला होगा। विवाह पश्चात भाग्य में निरंतर वृद्धि होगी।',
                descriptionGu: 'સપ્તમ ભાવના શુભ પ્રભાવ અનુસાર તમારા જીવનસાથી સંસ્કારી, બુદ્ધિશાળી, દેખાવડા અને કૌટુંબિક મૂલ્યોનું સન્માન કરનારા હશે. લગ્ન પછી ભાગ્યમાં અવિરત વૃદ્ધિ થશે.',
                highlightsHi: ['25 से 28 वर्ष की आयु (उत्तम विवाह काल)', 'संस्कारी जीवनसाथी', 'सुखमय दांपत्य'],
                highlightsGu: ['૨૫ થી ૨૮ વર્ષની વય (ઉત્તમ લગ્ન સમય)', 'સંસ્કારી જીવનસાથી', 'સુખમય દાંપત્ય'],
                timingOrAge: '૨૫ થી ૨૮ વર્ષની વય',
                iconName: 'favorite',
              ),
        careerBhagyodaya: json['careerBhagyodaya'] != null && (json['careerBhagyodaya']['descriptionGu'] as String? ?? '').isNotEmpty
            ? LifeAspectPrediction.fromJson(json['careerBhagyodaya'] as Map<String, dynamic>)
            : const LifeAspectPrediction(
                titleHi: 'भाग्योदय एवं करियर योग',
                titleGu: 'ભાગ્યોદય અને કારકિર્દી યોગ',
                descriptionHi: 'कर्म भाव और भाग्य भाव की अनुकूलता से आप आईटी, व्यापार, प्रबंधन, सरकारी सेवा या तकनीकी परामर्श में उच्च सफलता अर्जित करेंगे। 28 से 32 वर्ष में प्रचंड भाग्योदय योग है।',
                descriptionGu: 'કર્મ ભાવ અને ભાગ્ય ભાવની અનુકૂળતાથી તમે આઇટી, બિઝનેસ, મેનેજમેન્ટ, સરકારી ક્ષેત્ર અથવા કન્સલ્ટિંગમાં સર્વોચ્ચ સફળતા મેળવશો. ૨૮ થી ૩૨ વર્ષે પ્રચંડ ભાગ્યોદય યોગ છે.',
                highlightsHi: ['28वें एवं 32वें वर्ष में भाग्योदय', 'आईटी एवं व्यापार में सफलता', 'अचल संपत्ति योग'],
                highlightsGu: ['૨૮મા તેમજ ૩૨મા વર્ષે ભાગ્યોદય', 'આઇટી અને બિઝનેસમાં સફળતા', 'અચલ સંપત્તિ યોગ'],
                timingOrAge: '૨૮મા તેમજ ૩૨મા વર્ષે ભાગ્યોદય',
                iconName: 'trending_up',
              ),
        healthPrediction: json['healthPrediction'] != null && (json['healthPrediction']['descriptionGu'] as String? ?? '').isNotEmpty
            ? LifeAspectPrediction.fromJson(json['healthPrediction'] as Map<String, dynamic>)
            : const LifeAspectPrediction(
                titleHi: 'स्वास्थ्य एवं सावधानियां',
                titleGu: 'આરોગ્ય અને સાવચેતી',
                descriptionHi: 'उत्तम शारीरिक शक्ति और रोग प्रतिरोधक क्षमता। नियमित प्राणायाम, पर्याप्त जलपान और सकारात्मक दिनचर्या आपके आरोग्य को सदैव उत्तम बनाए रखेगी।',
                descriptionGu: 'ઉત્તમ શારીરિક શક્તિ અને રોગપ્રતિકારક ક્ષમતા. નિયમિત પ્રાણાયામ, પૂરતું પાણી અને સકારાત્મક દિનચર્યા તમારા આરોગ્યને સદા ઉત્તમ રાખશે.',
                highlightsHi: ['उत्तम जीवन शक्ति', 'प्राणायाम लाभकारी', 'सकारात्मक चिंतन'],
                highlightsGu: ['ઉત્તમ જીવનશક્તિ', 'પ્રાણાયામ લાભકારી', 'હકારાત્મક ચિંતન'],
                iconName: 'health_and_safety',
              ),
        rajaYogasHi: (json['rajaYogasHi'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [
          'बुधादित्य राजयोग (सूर्य + बुध की युति - कुशाग्र बुद्धि, प्रशासनिक सफलता एवं समाज में उच्च प्रतिष्ठा)',
          'गजकेसरी योग (गुरु-चंद्र केंद्र - अपार कीर्ति, ज्ञान, संपत्ति और सम्मान)',
        ],
        rajaYogasGu: (json['rajaYogasGu'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [
          'બુધાદિત્ય રાજયોગ (સૂર્ય + બુધની યુતિ - તીક્ષ્ણ બુદ્ધિપ્રતિભા, પ્રશાસનિક સફળતા અને સમાજમાં ઊંચી પ્રતિષ્ઠા)',
          'ગજકેસરી યોગ (ગુરુ-ચંદ્ર કેન્દ્ર - અપરંપાર યશ-કીર્તિ, જ્ઞાન, સંપત્તિ અને સન્માન)',
        ],
        luckyDirection: json['luckyDirection'] as String? ?? 'ઉત્તર-પૂર્વ (North-East)',
        ishtaDevataHi: json['ishtaDevataHi'] as String? ?? 'भगवान देवाधिदेव महादेव शिव',
        ishtaDevataGu: json['ishtaDevataGu'] as String? ?? 'ભગવાન દેવાધિદેવ મહાદેવ શિવજી',
        sacredMantraHi: json['sacredMantraHi'] as String? ?? 'ॐ नमः शिवाय',
        sacredMantraGu: json['sacredMantraGu'] as String? ?? 'ૐ નમઃ શિવાય',
      );
}

class KundaliResult {
  final KundaliProfile profile;
  final int lagnaRashiId;
  final double lagnaDegree;
  final int moonRashiId;
  final int sunRashiId;
  final String nakshatraHi;
  final String nakshatraGu;
  final int charan;
  final String ganaHi;
  final String ganaGu;
  final String nadiHi;
  final String nadiGu;
  final String yoniHi;
  final String yoniGu;
  final String varnaHi;
  final String varnaGu;
  final String luckyColor;
  final String luckyColorHi;
  final String luckyColorGu;
  final int luckyNumber;
  final String luckyGemstoneHi;
  final String luckyGemstoneGu;
  final MangalDoshaResult mangalDosha;
  final List<PlanetPosition> planets;
  final List<VimshottariDashaItem> dashas;
  final List<BhavaInterpretation> bhavas;
  final KundaliLifePrediction lifePrediction;

  const KundaliResult({
    required this.profile,
    required this.lagnaRashiId,
    required this.lagnaDegree,
    required this.moonRashiId,
    required this.sunRashiId,
    required this.nakshatraHi,
    required this.nakshatraGu,
    required this.charan,
    required this.ganaHi,
    required this.ganaGu,
    required this.nadiHi,
    required this.nadiGu,
    required this.yoniHi,
    required this.yoniGu,
    required this.varnaHi,
    required this.varnaGu,
    required this.luckyColor,
    this.luckyColorHi = '',
    this.luckyColorGu = '',
    required this.luckyNumber,
    required this.luckyGemstoneHi,
    required this.luckyGemstoneGu,
    required this.mangalDosha,
    required this.planets,
    required this.dashas,
    required this.bhavas,
    required this.lifePrediction,
  });

  /// Lagna's Navamsha Rashi ID (1 to 12)
  int get lagnaNavamshaRashiId {
    final lagnaTotalLong = (lagnaRashiId - 1) * 30.0 + lagnaDegree;
    return ((lagnaTotalLong / (30.0 / 9.0)).floor() % 12) + 1;
  }

  /// Map from house number (1-12) to sign id (1-12) in D1 Lagna chart
  Map<int, int> get houseSignMap {
    final map = <int, int>{};
    for (int h = 1; h <= 12; h++) {
      int sign = (lagnaRashiId + h - 2) % 12 + 1;
      map[h] = sign;
    }
    return map;
  }

  /// Map from house number (1-12) to planets placed in that house in D1
  Map<int, List<PlanetPosition>> get housePlanetsMap {
    final map = <int, List<PlanetPosition>>{};
    for (int h = 1; h <= 12; h++) {
      map[h] = [];
    }
    for (final p in planets) {
      final h = ((p.rashiId - lagnaRashiId + 12) % 12) + 1;
      if (h >= 1 && h <= 12) {
        map[h]?.add(p);
      }
    }
    return map;
  }

  /// Navamsha (D9) house to planets map (relative to Lagna's Navamsha sign)
  Map<int, List<PlanetPosition>> get navamshaHousePlanetsMap {
    final map = <int, List<PlanetPosition>>{};
    for (int h = 1; h <= 12; h++) {
      map[h] = [];
    }
    final d9Lagna = lagnaNavamshaRashiId;
    for (final p in planets) {
      final h = ((p.navamshaRashiId - d9Lagna + 12) % 12) + 1;
      if (h >= 1 && h <= 12) {
        map[h]?.add(p);
      }
    }
    return map;
  }

  /// Chandra Kundali house to planets map (relative to Moon's sign)
  Map<int, List<PlanetPosition>> get chandraHousePlanetsMap {
    final map = <int, List<PlanetPosition>>{};
    for (int h = 1; h <= 12; h++) {
      map[h] = [];
    }
    for (final p in planets) {
      final h = ((p.rashiId - moonRashiId + 12) % 12) + 1;
      if (h >= 1 && h <= 12) {
        map[h]?.add(p);
      }
    }
    return map;
  }

  Map<String, dynamic> toJson() => {
        'profile': profile.toJson(),
        'lagnaRashiId': lagnaRashiId,
        'lagnaDegree': lagnaDegree,
        'moonRashiId': moonRashiId,
        'sunRashiId': sunRashiId,
        'nakshatraHi': nakshatraHi,
        'nakshatraGu': nakshatraGu,
        'charan': charan,
        'ganaHi': ganaHi,
        'ganaGu': ganaGu,
        'nadiHi': nadiHi,
        'nadiGu': nadiGu,
        'yoniHi': yoniHi,
        'yoniGu': yoniGu,
        'varnaHi': varnaHi,
        'varnaGu': varnaGu,
        'luckyColor': luckyColor,
        'luckyColorHi': luckyColorHi,
        'luckyColorGu': luckyColorGu,
        'luckyNumber': luckyNumber,
        'luckyGemstoneHi': luckyGemstoneHi,
        'luckyGemstoneGu': luckyGemstoneGu,
        'mangalDosha': mangalDosha.toJson(),
        'planets': planets.map((p) => p.toJson()).toList(),
        'dashas': dashas.map((d) => d.toJson()).toList(),
        'bhavas': bhavas.map((b) => b.toJson()).toList(),
        'lifePrediction': lifePrediction.toJson(),
      };

  factory KundaliResult.fromJson(Map<String, dynamic> json) => KundaliResult(
        profile: KundaliProfile.fromJson(json['profile'] as Map<String, dynamic>? ?? {}),
        lagnaRashiId: json['lagnaRashiId'] as int? ?? 1,
        lagnaDegree: (json['lagnaDegree'] as num?)?.toDouble() ?? 0.0,
        moonRashiId: json['moonRashiId'] as int? ?? 1,
        sunRashiId: json['sunRashiId'] as int? ?? 1,
        nakshatraHi: json['nakshatraHi'] as String? ?? '',
        nakshatraGu: json['nakshatraGu'] as String? ?? '',
        charan: json['charan'] as int? ?? 1,
        ganaHi: json['ganaHi'] as String? ?? '',
        ganaGu: json['ganaGu'] as String? ?? '',
        nadiHi: json['nadiHi'] as String? ?? '',
        nadiGu: json['nadiGu'] as String? ?? '',
        yoniHi: json['yoniHi'] as String? ?? '',
        yoniGu: json['yoniGu'] as String? ?? '',
        varnaHi: json['varnaHi'] as String? ?? '',
        varnaGu: json['varnaGu'] as String? ?? '',
        luckyColor: json['luckyColor'] as String? ?? 'Gold',
        luckyColorHi: json['luckyColorHi'] as String? ?? json['luckyColor'] as String? ?? 'पीला, सुनहरा',
        luckyColorGu: json['luckyColorGu'] as String? ?? json['luckyColor'] as String? ?? 'પીળો, સોનેરી',
        luckyNumber: json['luckyNumber'] as int? ?? 1,
        luckyGemstoneHi: json['luckyGemstoneHi'] as String? ?? '',
        luckyGemstoneGu: json['luckyGemstoneGu'] as String? ?? '',
        mangalDosha: MangalDoshaResult.fromJson(json['mangalDosha'] as Map<String, dynamic>? ?? {}),
        planets: (json['planets'] as List<dynamic>?)
                ?.map((e) => PlanetPosition.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        dashas: (json['dashas'] as List<dynamic>?)
                ?.map((e) => VimshottariDashaItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        bhavas: (json['bhavas'] as List<dynamic>?)
                ?.map((e) => BhavaInterpretation.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        lifePrediction: json['lifePrediction'] != null
            ? KundaliLifePrediction.fromJson(json['lifePrediction'] as Map<String, dynamic>)
            : KundaliLifePrediction.fromJson({}),
      );
}

