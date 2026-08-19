import '../../../core/constants/rashi_data.dart';

class RashiReadingModel {
  final String date;
  final String zodiacSign;
  final String horoscopeText;
  final String? horoscopeTextHindi;
  final String? careerOutlook;
  final String? careerOutlookHindi;
  final String? loveOutlook;
  final String? loveOutlookHindi;
  final String? healthOutlook;
  final String? healthOutlookHindi;
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
    this.careerOutlook,
    this.careerOutlookHindi,
    this.loveOutlook,
    this.loveOutlookHindi,
    this.healthOutlook,
    this.healthOutlookHindi,
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
      careerOutlook: json['career_outlook']?.toString(),
      careerOutlookHindi: json['career_outlook_hindi']?.toString(),
      loveOutlook: json['love_outlook']?.toString(),
      loveOutlookHindi: json['love_outlook_hindi']?.toString(),
      healthOutlook: json['health_outlook']?.toString(),
      healthOutlookHindi: json['health_outlook_hindi']?.toString(),
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
      if (careerOutlook != null) 'career_outlook': careerOutlook,
      if (careerOutlookHindi != null) 'career_outlook_hindi': careerOutlookHindi,
      if (loveOutlook != null) 'love_outlook': loveOutlook,
      if (loveOutlookHindi != null) 'love_outlook_hindi': loveOutlookHindi,
      if (healthOutlook != null) 'health_outlook': healthOutlook,
      if (healthOutlookHindi != null) 'health_outlook_hindi': healthOutlookHindi,
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
}
