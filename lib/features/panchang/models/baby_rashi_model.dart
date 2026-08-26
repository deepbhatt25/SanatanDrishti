class BabyRashiModel {
  final DateTime birthDateTime;
  final String rashiHindi;
  final String rashiGujarati;
  final String rashiEn;
  final String rashiSymbol;
  final String rashiStartTime;
  final String rashiEndTime;
  final String prevRashiHindi;
  final String prevRashiGujarati;
  final String prevRashiEn;
  final String nextRashiHindi;
  final String nextRashiGujarati;
  final String nextRashiEn;

  final String nakshatraHindi;
  final String nakshatraGujarati;
  final int pada;
  final String nakshatraStartTime;
  final String nakshatraEndTime;
  final String prevNakshatraHindi;
  final String prevNakshatraGujarati;
  final String nextNakshatraHindi;
  final String nextNakshatraGujarati;

  final String tithiHindi;
  final String tithiGujarati;
  final String tithiStartTime;
  final String tithiEndTime;
  final String prevTithiHindi;
  final String prevTithiGujarati;
  final String nextTithiHindi;
  final String nextTithiGujarati;

  final String yogaHindi;
  final String yogaGujarati;
  final String yogaStartTime;
  final String yogaEndTime;
  final String prevYogaHindi;
  final String prevYogaGujarati;
  final String nextYogaHindi;
  final String nextYogaGujarati;

  final String karanaHindi;
  final String karanaGujarati;
  final String karanaStartTime;
  final String karanaEndTime;
  final String prevKaranaHindi;
  final String prevKaranaGujarati;
  final String nextKaranaHindi;
  final String nextKaranaGujarati;

  final String vaarHindi;
  final String vaarGujarati;
  final String vaarStartTime;
  final String vaarEndTime;
  final String prevVaarHindi;
  final String prevVaarGujarati;
  final String nextVaarHindi;
  final String nextVaarGujarati;

  final String rulingPlanet;
  final String rulingPlanetGujarati;
  final String element;
  final String elementGujarati;
  final String gana;
  final String ganaGujarati;
  final String nadi;
  final String nadiGujarati;
  final List<String> allPadaNamakshar;
  final String recommendedLetter;
  final String favorableColors;
  final String favorableColorsGujarati;
  final String favorableGemstone;
  final String favorableGemstoneGujarati;
  final List<String> boyNames;
  final List<String> boyNamesGujarati;
  final List<String> girlNames;
  final List<String> girlNamesGujarati;

  const BabyRashiModel({
    required this.birthDateTime,
    required this.rashiHindi,
    required this.rashiGujarati,
    required this.rashiEn,
    required this.rashiSymbol,
    this.rashiStartTime = '',
    this.rashiEndTime = '',
    this.prevRashiHindi = '',
    this.prevRashiGujarati = '',
    this.prevRashiEn = '',
    this.nextRashiHindi = '',
    this.nextRashiGujarati = '',
    this.nextRashiEn = '',
    required this.nakshatraHindi,
    required this.nakshatraGujarati,
    required this.pada,
    this.nakshatraStartTime = '',
    this.nakshatraEndTime = '',
    this.prevNakshatraHindi = '',
    this.prevNakshatraGujarati = '',
    this.nextNakshatraHindi = '',
    this.nextNakshatraGujarati = '',
    this.tithiHindi = '',
    this.tithiGujarati = '',
    this.tithiStartTime = '',
    this.tithiEndTime = '',
    this.prevTithiHindi = '',
    this.prevTithiGujarati = '',
    this.nextTithiHindi = '',
    this.nextTithiGujarati = '',
    this.yogaHindi = '',
    this.yogaGujarati = '',
    this.yogaStartTime = '',
    this.yogaEndTime = '',
    this.prevYogaHindi = '',
    this.prevYogaGujarati = '',
    this.nextYogaHindi = '',
    this.nextYogaGujarati = '',
    this.karanaHindi = '',
    this.karanaGujarati = '',
    this.karanaStartTime = '',
    this.karanaEndTime = '',
    this.prevKaranaHindi = '',
    this.prevKaranaGujarati = '',
    this.nextKaranaHindi = '',
    this.nextKaranaGujarati = '',
    this.vaarHindi = '',
    this.vaarGujarati = '',
    this.vaarStartTime = '',
    this.vaarEndTime = '',
    this.prevVaarHindi = '',
    this.prevVaarGujarati = '',
    this.nextVaarHindi = '',
    this.nextVaarGujarati = '',
    required this.rulingPlanet,
    required this.rulingPlanetGujarati,
    required this.element,
    required this.elementGujarati,
    required this.gana,
    required this.ganaGujarati,
    required this.nadi,
    required this.nadiGujarati,
    required this.allPadaNamakshar,
    required this.recommendedLetter,
    required this.favorableColors,
    required this.favorableColorsGujarati,
    required this.favorableGemstone,
    required this.favorableGemstoneGujarati,
    this.boyNames = const [],
    this.boyNamesGujarati = const [],
    this.girlNames = const [],
    this.girlNamesGujarati = const [],
  });
}
