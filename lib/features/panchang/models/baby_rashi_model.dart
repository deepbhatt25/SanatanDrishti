class BabyRashiModel {
  final DateTime birthDateTime;
  final String rashiHindi;
  final String rashiGujarati;
  final String rashiEn;
  final String rashiSymbol;
  final String nakshatraHindi;
  final String nakshatraGujarati;
  final int pada;
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

  const BabyRashiModel({
    required this.birthDateTime,
    required this.rashiHindi,
    required this.rashiGujarati,
    required this.rashiEn,
    required this.rashiSymbol,
    required this.nakshatraHindi,
    required this.nakshatraGujarati,
    required this.pada,
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
  });
}
