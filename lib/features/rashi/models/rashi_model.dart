import '../../../core/constants/rashi_data.dart';

class RashiReadingModel {
  final String date;
  final String zodiacSign;
  final String horoscopeText;
  final String? horoscopeTextHindi;
  final String? horoscopeTextGujarati;
  final String? careerOutlook;
  final String? careerOutlookHindi;
  final String? careerOutlookGujarati;
  final String? loveOutlook;
  final String? loveOutlookHindi;
  final String? loveOutlookGujarati;
  final String? healthOutlook;
  final String? healthOutlookHindi;
  final String? healthOutlookGujarati;
  final String? mood;
  final String? compatibility;
  final String? luckyTime;
  final String? luckyNumber;
  final String? luckyColor;
  final String? luckyGemstone;
  final String? luckyDirection;
  final bool isFromCache;

  const RashiReadingModel({
    required this.date,
    required this.zodiacSign,
    required this.horoscopeText,
    this.horoscopeTextHindi,
    this.horoscopeTextGujarati,
    this.careerOutlook,
    this.careerOutlookHindi,
    this.careerOutlookGujarati,
    this.loveOutlook,
    this.loveOutlookHindi,
    this.loveOutlookGujarati,
    this.healthOutlook,
    this.healthOutlookHindi,
    this.healthOutlookGujarati,
    this.mood,
    this.compatibility,
    this.luckyTime,
    this.luckyNumber,
    this.luckyColor,
    this.luckyGemstone,
    this.luckyDirection,
    this.isFromCache = false,
  });

  factory RashiReadingModel.fromJson(Map<String, dynamic> json, {bool isCached = false}) {
    return RashiReadingModel(
      date: json['date']?.toString() ?? '',
      zodiacSign: json['zodiac_sign']?.toString() ?? json['sign']?.toString() ?? '',
      horoscopeText: json['horoscope']?.toString() ?? json['horoscope_text']?.toString() ?? '',
      horoscopeTextHindi: json['horoscope_hindi']?.toString(),
      horoscopeTextGujarati: json['horoscope_gujarati']?.toString(),
      careerOutlook: json['career_outlook']?.toString(),
      careerOutlookHindi: json['career_outlook_hindi']?.toString(),
      careerOutlookGujarati: json['career_outlook_gujarati']?.toString(),
      loveOutlook: json['love_outlook']?.toString(),
      loveOutlookHindi: json['love_outlook_hindi']?.toString(),
      loveOutlookGujarati: json['love_outlook_gujarati']?.toString(),
      healthOutlook: json['health_outlook']?.toString(),
      healthOutlookHindi: json['health_outlook_hindi']?.toString(),
      healthOutlookGujarati: json['health_outlook_gujarati']?.toString(),
      mood: json['mood']?.toString(),
      compatibility: json['compatibility']?.toString(),
      luckyTime: json['lucky_time']?.toString(),
      luckyNumber: json['lucky_number']?.toString(),
      luckyColor: json['lucky_color']?.toString(),
      luckyGemstone: json['lucky_gemstone']?.toString(),
      luckyDirection: json['lucky_direction']?.toString(),
      isFromCache: isCached,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'zodiac_sign': zodiacSign,
      'horoscope': horoscopeText,
      if (horoscopeTextHindi != null) 'horoscope_hindi': horoscopeTextHindi,
      if (horoscopeTextGujarati != null) 'horoscope_gujarati': horoscopeTextGujarati,
      if (careerOutlook != null) 'career_outlook': careerOutlook,
      if (careerOutlookHindi != null) 'career_outlook_hindi': careerOutlookHindi,
      if (careerOutlookGujarati != null) 'career_outlook_gujarati': careerOutlookGujarati,
      if (loveOutlook != null) 'love_outlook': loveOutlook,
      if (loveOutlookHindi != null) 'love_outlook_hindi': loveOutlookHindi,
      if (loveOutlookGujarati != null) 'love_outlook_gujarati': loveOutlookGujarati,
      if (healthOutlook != null) 'health_outlook': healthOutlook,
      if (healthOutlookHindi != null) 'health_outlook_hindi': healthOutlookHindi,
      if (healthOutlookGujarati != null) 'health_outlook_gujarati': healthOutlookGujarati,
      if (mood != null) 'mood': mood,
      if (compatibility != null) 'compatibility': compatibility,
      if (luckyTime != null) 'lucky_time': luckyTime,
      if (luckyNumber != null) 'lucky_number': luckyNumber,
      if (luckyColor != null) 'lucky_color': luckyColor,
      if (luckyGemstone != null) 'lucky_gemstone': luckyGemstone,
      if (luckyDirection != null) 'lucky_direction': luckyDirection,
    };
  }

  RashiInfo get rashiInfo => RashiData.getRashiByParam(zodiacSign);

  String? getEffectiveHoroscope(bool isGujarati) {
    if (isGujarati) {
      if (horoscopeTextGujarati != null && horoscopeTextGujarati!.isNotEmpty) {
        return horoscopeTextGujarati;
      }
      final rInfo = rashiInfo;
      return 'આજે ${rInfo.gujaratiName} રાશિના જાતકો માટે દિવસ અત્યંત શુભ અને સકારાત્મક રહેવાનો છે. ${rInfo.rulingPlanetGujarati} ની કૃપાથી તમારા આત્મવિશ્વાસમાં વધારો થશે. કાર્યક્ષેત્રમાં નવી ઉત્તમ તકો પ્રાપ્ત થશે તેમજ પારિવારિક વાતાવરણ સુખદ અને આનંદમય રહેશે. \'${rInfo.mantra}\' મંત્રનો જાપ કરવો કલ્યાણકારી નીવડશે.';
    }
    return horoscopeTextHindi;
  }

  String? getEffectiveCareer(bool isGujarati) {
    if (isGujarati) {
      return careerOutlookGujarati ?? 'કાર્યક્ષેત્રમાં નવી મહત્વપૂર્ણ જવાબદારીઓ અને પદોન્નતિના શુભ યોગ છે.';
    }
    return careerOutlookHindi;
  }

  String? getEffectiveLove(bool isGujarati) {
    if (isGujarati) {
      return loveOutlookGujarati ?? 'પારિવારિક જીવનમાં સુખ-શાંતિ જળવાશે અને પરસ્પર સ્નેહભાવ વધશે.';
    }
    return loveOutlookHindi;
  }

  String? getEffectiveHealth(bool isGujarati) {
    if (isGujarati) {
      return healthOutlookGujarati ?? 'સ્વાસ્થ્ય ઉત્તમ રહેશે. યોગ અને પ્રાણાયામથી મનમાં સ્ફૂર્તિ જળવાશે.';
    }
    return healthOutlookHindi;
  }

  String getEffectiveCompatibility(bool isGujarati) {
    if (isGujarati) {
      switch (rashiInfo.element.split(' ').first) {
        case 'अग्नि':
          return 'સિંહ (Leo), ધનુ (Sagittarius)';
        case 'पृथ्वी':
          return 'વૃષભ (Taurus), મકર (Capricorn)';
        case 'वायु':
          return 'મિથુન (Gemini), કુંભ (Aquarius)';
        case 'जल':
        default:
          return 'કર્ક (Cancer), મીન (Pisces)';
      }
    }
    return compatibility ?? 'कर्क (Cancer), मीन (Pisces)';
  }

  String getEffectiveLuckyDirection(bool isGujarati) {
    if (isGujarati) {
      if (luckyDirection != null) {
        return luckyDirection!
            .replaceAll('उत्तर', 'ઉત્તર')
            .replaceAll('पूर्व', 'પૂર્વ')
            .replaceAll('दक्षिण', 'દક્ષિણ')
            .replaceAll('पश्चिम', 'પશ્ચિમ');
      }
      return 'ઉત્તર (North)';
    }
    return luckyDirection ?? 'उत्तर (North)';
  }

  String getEffectiveLuckyGemstone(bool isGujarati) {
    if (isGujarati) {
      if (luckyGemstone != null) {
        return luckyGemstone!
            .replaceAll('माणिक्य', 'માણેક')
            .replaceAll('मोती', 'મોતી')
            .replaceAll('मूंगा', 'મૂંગા')
            .replaceAll('पन्ना', 'પન્ના')
            .replaceAll('पुखराज', 'પોખરાજ')
            .replaceAll('हीरा', 'હીરો')
            .replaceAll('नीलम', 'નીલમ')
            .replaceAll('गोमेद', 'ગોમેદ')
            .replaceAll('लहसुनिया', 'લહસુનિયા');
      }
      return 'પોખરાજ (Yellow Sapphire)';
    }
    return luckyGemstone ?? 'माणिक्य (Ruby)';
  }
}
