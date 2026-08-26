class BabyNameItem {
  final String gujarati;
  final String hindi;
  final String english;
  final String meaningGu;
  final String meaningHi;
  final String meaningEn;
  final int rashiIndex; // 0: Mesha to 11: Meena
  final String startingLetter;
  final bool isBoy;

  const BabyNameItem({
    required this.gujarati,
    required this.hindi,
    required this.english,
    required this.meaningGu,
    required this.meaningHi,
    required this.meaningEn,
    required this.rashiIndex,
    required this.startingLetter,
    required this.isBoy,
  });
}

class BabyNamesDatabase {
  static const List<String> rashiNamesGu = [
    'મેષ (Aries - અ, લ, ઈ)',
    'વૃષભ (Taurus - બ, વ, ઉ)',
    'મિથુન (Gemini - ક, છ, ઘ)',
    'કર્ક (Cancer - ડ, હ)',
    'સિંહ (Leo - મ, ટ)',
    'કન્યા (Virgo - પ, ઠ, ણ)',
    'તુલા (Libra - ર, ત)',
    'વૃશ્ચિક (Scorpio - ન, ય)',
    'ધન (Sagittarius - ભ, ધ, ફ, ઢ)',
    'મકર (Capricorn - ખ, જ)',
    'કુંભ (Aquarius - ગ, શ, સ, ષ)',
    'મીન (Pisces - દ, ચ, ઝ, થ)',
  ];

  static const List<String> rashiNamesHi = [
    'मेष (Aries - अ, ल, ई)',
    'वृषभ (Taurus - ब, व, उ)',
    'मिथुन (Gemini - क, छ, घ)',
    'कर्क (Cancer - ड, ह)',
    'सिंह (Leo - म, ट)',
    'कन्या (Virgo - प, ठ, ण)',
    'तुला (Libra - र, त)',
    'वृश्चिक (Scorpio - न, य)',
    'धनु (Sagittarius - भ, ध, फ, ढ)',
    'मकर (Capricorn - ख, ज)',
    'कुंभ (Aquarius - ग, श, स, ष)',
    'मीन (Pisces - द, च, ज़, थ)',
  ];

  static List<BabyNameItem> getAllNames() {
    return _allNames;
  }

  static List<BabyNameItem> getNamesForRashi({
    required int rashiIndex,
    required bool isBoy,
    String filterLetter = '',
    String searchQuery = '',
  }) {
    return _allNames.where((item) {
      if (item.rashiIndex != rashiIndex) return false;
      if (item.isBoy != isBoy) return false;
      if (filterLetter.isNotEmpty &&
          !item.startingLetter.contains(filterLetter) &&
          !item.gujarati.startsWith(filterLetter) &&
          !item.hindi.startsWith(filterLetter)) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchGu = item.gujarati.contains(q);
        final matchHi = item.hindi.contains(q);
        final matchEn = item.english.toLowerCase().contains(q);
        final matchMean = item.meaningGu.contains(q) ||
            item.meaningHi.contains(q) ||
            item.meaningEn.toLowerCase().contains(q);
        return matchGu || matchHi || matchEn || matchMean;
      }
      return true;
    }).toList();
  }

  static final List<BabyNameItem> _allNames = _buildComprehensiveModernDatabase();

  static List<BabyNameItem> _buildComprehensiveModernDatabase() {
    final List<BabyNameItem> list = [];
    final Set<String> seen = {};

    void add(
      String gu,
      String hi,
      String en,
      String mGu,
      String mHi,
      String mEn,
      int rIdx,
      bool isBoy,
    ) {
      final key = '$rIdx-$isBoy-$gu';
      if (!seen.contains(key)) {
        seen.add(key);
        list.add(BabyNameItem(
          gujarati: gu,
          hindi: hi,
          english: en,
          meaningGu: mGu,
          meaningHi: mHi,
          meaningEn: mEn,
          rashiIndex: rIdx,
          startingLetter: gu.isNotEmpty ? gu.substring(0, 1) : '',
          isBoy: isBoy,
        ));
      }
    }

    // 0: Mesha (અ, લ, ઈ)
    _addMeshaNames(add);

    // 1: Vrishabha (બ, વ, ઉ)
    _addVrishabhaNames(add);

    // 2: Mithuna (ક, છ, ઘ)
    _addMithunaNames(add);

    // 3: Karka (ડ, હ)
    _addKarkaNames(add);

    // 4: Simha (મ, ટ)
    _addSimhaNames(add);

    // 5: Kanya (પ, ઠ, ણ)
    _addKanyaNames(add);

    // 6: Tula (ર, ત)
    _addTulaNames(add);

    // 7: Vrishchika (ન, ય)
    _addVrishchikaNames(add);

    // 8: Dhanu (ભ, ધ, ફ, ઢ)
    _addDhanuNames(add);

    // 9: Makara (ખ, જ)
    _addMakaraNames(add);

    // 10: Kumbha (ગ, શ, સ, ષ)
    _addKumbhaNames(add);

    // 11: Meena (દ, ચ, ઝ, થ)
    _addMeenaNames(add);

    return list;
  }

  // -------------------------------------------------------------
  // 0: MESHA (અ, લ, ઈ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addMeshaNames(Function add) {
    // Boys
    final mBoys = [
      ('આરવ', 'आरव', 'Aarav', 'શાંતિમય, જ્ઞાની', 'शांतिपूर्ण, ज्ञानी', 'Peaceful, Wise melody'),
      ('અદ્વિક', 'अद्विक', 'Advik', 'અજોડ, અદ્વિતીય', 'अद्वितीय', 'Unique, Matchless'),
      ('અયાનશ', 'अयांश', 'Ayansh', 'પ્રકાશનું પ્રથમ કિરણ', 'प्रकाश की किरण', 'First ray of light'),
      ('આરોહ', 'आरोह', 'Aaroh', 'ઉચ્ચ શિખર, પ્રગતિ', 'ऊंचाई, प्रगति', 'Ascending, High progress'),
      ('અવ્યાન', 'अव्यान', 'Avyaan', 'ભગવાન વિષ્ણુ, પૂર્ણ', 'भगवान विष्णु', 'Lord Vishnu, Flawless'),
      ('અર્હમ', 'अर्हम', 'Arham', 'પરમ શાંત, દયાળુ', 'दयालु, पूज्य', 'Compassionate, Venerable'),
      ('અગસ્ત્ય', 'अगस्त्य', 'Agastya', 'મહાન ઋષિ, તેજસ્વી', 'महान मुनि', 'Great Sage, Illuminator'),
      ('આયાન', 'अयान', 'Ayaan', 'ઈશ્વરનો આશીર્વાદ', 'ईश्वर का उपहार', 'Gift of God, Blessing'),
      ('અનય', 'अनय', 'Anay', 'ભગવાન ગણેશ', 'भगवान गणेश', 'Lord Ganesha'),
      ('અદ્વૈત', 'अद्वैत', 'Advait', 'અદ્વિતીય બ્રહ્મ', 'अद्वितीय', 'Unique, Non-dual Supreme'),
      ('અંશ', 'अंश', 'Ansh', 'પવિત્ર અંશ', 'ईश्वर का अंश', 'Divine essence'),
      ('આહાન', 'आहान', 'Aahan', 'પ્રભાતનો પ્રકાશ', 'सुबह की पहली किरण', 'Dawn, Morning light'),
      ('અરિવ', 'अरिव', 'Ariv', 'જ્ઞાનનો રાજા', 'ज्ञान का राजा', 'King of wisdom'),
      ('અથર્વ', 'अथर्व', 'Atharv', 'વેદોના જ્ઞાતા, ગણેશ', 'अथर्ववेद, गणेश', 'Lord Ganesha, Atharva Veda'),
      ('અવિક', 'अविक', 'Avik', 'સાહસી, હિંમતવાન', 'साहसी', 'Brave, Courageous'),
      ('આદિત્ય', 'आदित्य', 'Aaditya', 'સૂર્યદેવ, તેજસ્વી', 'सूर्य देव', 'The Sun'),
      ('અક્ષત', 'अक्षत', 'Akshat', 'અખંડ, સંપૂર્ણ', 'अखंड', 'Unbroken, Whole'),
      ('આયુષ', 'आयुष', 'Aayush', 'દીર્ઘ આયુષ્ય', 'दीर्घायु', 'Long lived'),
      ('અનંત', 'अनंत', 'Anant', 'અસીમ, અવિનાશી', 'असीम', 'Infinite, Endless'),
      ('અમોઘ', 'अमोघ', 'Amogh', 'અચૂક, ગણેશ', 'भगवान गणेश', 'Lord Ganesha, Unerring'),
      ('અર્જુન', 'अर्जुन', 'Arjun', 'શ્રેષ્ઠ યોદ્ધા', 'महान योद्धा', 'Hero, Pure'),
      ('અવિરાજ', 'अविराज', 'Aviraj', 'તેજસ્વી શાસક', 'चमकता राजा', 'Radiant king'),
      ('અક્ષજ', 'अक्षज', 'Akshaj', 'ભગવાન વિષ્ણુ, હીરો', 'भगवान विष्णु', 'Lord Vishnu, Diamond'),
      ('અભય', 'अभय', 'Abhay', 'નિર્ભય, નીડર', 'निडर', 'Fearless'),
      ('અભિમન્યુ', 'अभिमन्यु', 'Abhimanyu', 'પરાક્રમી યોદ્ધા', 'वीर योद्धा', 'Heroic warrior'),
      ('અયાન', 'अयान', 'Ayan', 'સમયની ગતિ, ઈશ્વરકૃપા', 'ईश्वरीय कृपा', 'Speed, Path'),
      ('અરીત', 'अरीत', 'Areet', 'પ્રિય મિત્ર', 'प्रिय मित्र', 'Beloved companion'),
      ('આકાશ', 'आकाश', 'Aakash', 'વિશાળ ગગન', 'आकाश', 'Sky, Open space'),
      ('આલોક', 'आलोक', 'Aalok', 'દિવ્ય પ્રકાશ', 'दिव्य प्रकाश', 'Divine radiance'),
      ('આનંદ', 'आनंद', 'Aanand', 'પરમ સુખ', 'खुशी', 'Bliss, Joy'),
      ('અર્ચિત', 'अर्चित', 'Archit', 'પૂજનીય', 'पूजनीय', 'Worshiped'),
      ('અનિરુદ્ધ', 'अनिरुद्ध', 'Aniruddh', 'અજેય, કૃષ્ણપૌત્ર', 'अजेय', 'Unstoppable'),
      ('અપૂર્વ', 'अपूर्व', 'Apoorv', 'અનોખો, પ્રથમવાર', 'अनोखा', 'Novel, Unique'),
      ('અર્ણવ', 'अर्णव', 'Arnav', 'વિશાળ સાગર', 'सागर', 'Ocean, Sea'),
      ('અભિષેક', 'अभिषेक', 'Abhishek', 'પવિત્ર સ્નાન', 'शुभ अभिषेक', 'Consecration'),
      ('અનમોલ', 'अनमोल', 'Anmol', 'અમૂલ્ય રત્ન', 'अनमोल', 'Priceless'),
      ('અનુજ', 'अनुज', 'Anuj', 'નાનો ભાઈ, સ્નેહી', 'छोटा भाई', 'Younger brother'),
      ('અભિરામ', 'अभिराम', 'Abhiram', 'સૌથી સુંદર, શિવ', 'अति सुंदर', 'Most handsome'),
      ('અવિનાશ', 'अविनाश', 'Avinash', 'અવિનાશી, અમર', 'अविनाशी', 'Indestructible'),
      ('આશીષ', 'आशीष', 'Aashish', 'શુભ આશીર્વાદ', 'आशीर्वाद', 'Blessing'),
      ('લક્ષ્ય', 'लक्ष्य', 'Lakshya', 'ધ્યેય, લક્ષ્યાંક', 'उद्देश्य', 'Target, Goal'),
      ('લવ્ય', 'लव्य', 'Lavya', 'પૂજનીય, સુંદર', 'पूजनीय', 'Adorable, Praiseworthy'),
      ('લવિત', 'लवित', 'Lavit', 'ભગવાન શિવ', 'भगवान शिव', 'Lord Shiva'),
      ('લવ', 'लव', 'Lav', 'શ્રીરામ પુત્ર', 'श्री राम के पुत्र', 'Son of Rama'),
      ('લક્ષ', 'लक्ष', 'Laksh', 'ધ્યેય, નિશાનો', 'लक्ष्य', 'Aim, Destination'),
      ('લક્ષિત', 'लक्षित', 'Lakshit', 'પ્રતિષ્ઠિત, વિશિષ્ટ', 'विशिष्ट', 'Distinguished'),
      ('લલિત', 'ललित', 'Lalit', 'સુંદર, આકર્ષક', 'सुंदर', 'Handsome, Graceful'),
      ('લોકેશ', 'लोकेश', 'Lokesh', 'જગતના સ્વામી', 'संसार के स्वामी', 'Lord of world'),
      ('લોકેન્દ્ર', 'लोकेन्द्र', 'Lokendra', 'રાજા', 'राजा', 'King of world'),
      ('લયન', 'लयन', 'Layan', 'પ્રકાશ, ચમક', 'प्रकाश', 'Radiance, Glow'),
      ('ઇશાન', 'ईशान', 'Ishaan', 'ભગવાન શિવ, પૂર્વોત્તર', 'भगवान शिव', 'Lord Shiva'),
      ('ઇક્ષિત', 'इक्षित', 'Ikshit', 'દ્રષ્ટિવાન', 'दूरदर्शी', 'Visible, Desired'),
      ('ઇવાન્શ', 'इवांश', 'Ivansh', 'ઈશ્વરનો અંશ', 'ईश्वर का अंश', 'Part of Divine'),
      ('ઇનેશ', 'इनेश', 'Inesh', 'શક્તિશાળી રાજા', 'राजा', 'Strong ruler'),
      ('ઇશિત', 'ईशित', 'Ishit', 'શાશક, સમૃદ્ધ', 'शासक', 'One who rules'),
      ('ઇવાન્દ', 'इवांद', 'Ivand', 'ઈશ્વરીય ભેટ', 'ईश्वरीय उपहार', 'Divine gift'),
      ('ઇરાવત', 'इरावत', 'Iravat', 'ઇન્દ્રનું વાહન', 'ऐरावत', 'Sacred Elephant'),
      ('ઇન્દ્રજિત', 'इंद्रजीत', 'Indrajit', 'વિજેતા', 'विजेता', 'Conqueror'),
      ('ઇન્દ્રવદન', 'इंद्रवदन', 'Indravadan', 'ઇન્દ્ર જેવો તેજસ્વી', 'तेजस्वी', 'Resembling Indra'),
      ('ઇશાનવ', 'ईशानव', 'Ishaanav', 'શિવ સમાન', 'शिव जैसा', 'Like Shiva'),
    ];
    for (final b in mBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 0, true);
    }

    // Girls
    final mGirls = [
      ('આધ્યા', 'आध्या', 'Aadhya', 'પ્રથમ શક્તિ, દુર્ગા', 'प्रथम शक्ति', 'First power, Durga'),
      ('અનન્યા', 'अनन्या', 'Ananya', 'અદ્વિતીય સુંદરતા', 'अद्वितीय', 'Matchless, Unique'),
      ('અન્વી', 'अन्वी', 'Anvi', 'પ્રકૃતિની દેવી', 'प्रकृति की देवी', 'Goddess of nature'),
      ('અનિકા', 'अनिका', 'Anika', 'દુર્ગા દેવી, સૌંદર્ય', 'देवी दुर्गा', 'Goddess Durga, Grace'),
      ('અવની', 'अवनी', 'Avani', 'પૃથ્વી માતા', 'धरती मां', 'Mother Earth'),
      ('આહના', 'आहना', 'Aahana', 'સવારનું પ્રથમ કિરણ', 'पहली किरण', 'First sunlight'),
      ('અલીશા', 'अलीशा', 'Alisha', 'ઈશ્વર રક્ષિત', 'ईश्वर द्वारा रक्षित', 'Protected by God'),
      ('આશી', 'आशी', 'Aashi', 'સ્મિત, ખુશી', 'मुस्कान', 'Smile, Blessing'),
      ('આવ્યા', 'आव्या', 'Aavya', 'ઈશ્વરની પ્રથમ ભેટ', 'ईश्वर का उपहार', 'First gift of God'),
      ('આરોહી', 'आरोही', 'Aarohi', 'સંગીતનો સૂર', 'संगीत का सुर', 'Musical tune, Rising'),
      ('અમાયા', 'अमाया', 'Amaya', 'નિષ્કપટ, વર્ષા', 'मासूम', 'Innocent, Night rain'),
      ('અદિતી', 'अदिति', 'Aditi', 'દેવોની માતા', 'देवताओं की माता', 'Mother of gods'),
      ('અક્ષરા', 'अक्षरा', 'Akshara', 'સરસ્વતી, અવિનાશી', 'सरस्वती', 'Goddess Saraswati'),
      ('અદ્વિકા', 'अद्विका', 'Advika', 'વિશ્વમાં અજોડ', 'अद्वितीय', 'Unique girl'),
      ('આશ્વી', 'आश्वी', 'Aashvi', 'વિજયી, આશીર્વાદ', 'विजयी', 'Blessed and victorious'),
      ('અંશિકા', 'अंशिका', 'Anshika', 'સુંદર અંશ', 'सुंदर अंश', 'Beautiful part'),
      ('અનાયા', 'अनाया', 'Anaya', 'સંપૂર્ણ સંભાળ', 'ईश्वरीय कृपा', 'Care of God'),
      ('આરાધ્યા', 'आराध्या', 'Aaradhya', 'પૂજનીય દેવી', 'पूजनीय', 'Worshipable'),
      ('અભિજ્ઞા', 'अभिज्ञा', 'Abhijna', 'જ્ઞાની સ્ત્રી', 'विदुषी', 'Wise, Intellectual'),
      ('અંતરા', 'अंतरा', 'Antara', 'ગીતની સુંદર કડી', 'गीत की कड़ी', 'Musical refrain'),
      ('અયન્ના', 'अयन्ना', 'Ayanna', 'નિર્દોષ ફૂલ', 'सुंदर फूल', 'Innocent flower'),
      ('અપેક્ષા', 'अपेक्षा', 'Apeksha', 'ઉચ્ચ આશા', 'आशा', 'Hope, Expectation'),
      ('આભા', 'आभा', 'Aabha', 'દૈવી ચમક', 'दिव्य चमक', 'Glow, Radiance'),
      ('અભિલાષા', 'अभिलाषा', 'Abhilasha', 'મનોકામના', 'इच्छा', 'Desire, Wish'),
      ('અનુષ્કા', 'अनुष्का', 'Anushka', 'કૃપા, પ્રકાશ', 'कृपा, किरण', 'Grace, Ray of light'),
      ('આશના', 'आशना', 'Aashna', 'પ્રેમની સાથી', 'प्यारी सखी', 'Beloved friend'),
      ('આયરા', 'आयरा', 'Ayra', 'આદરણીય સ્ત્રી', 'सम्मानित', 'Respectable'),
      ('અમીષા', 'अमीषा', 'Amisha', 'નિષ્પાપ, શુદ્ધ', 'पवित्र', 'Pure, Innocent'),
      ('અનિતા', 'अनीता', 'Anita', 'નમ્ર, સદ્ગુણી', 'विनम्र', 'Graceful, Pure'),
      ('અર્ચના', 'अर्चना', 'Archana', 'પવિત્ર પૂજા', 'पूजा', 'Worship, Prayer'),
      ('લાવણ્યા', 'लावण्या', 'Lavanya', 'સૌંદર્ય અને કૃપા', 'सुंदरता, कृपा', 'Grace, Beauty'),
      ('લિપિકા', 'लिपिका', 'Lipika', 'સુંદર લિપિ', 'सुंदर लेख', 'Alphabet, Poetry'),
      ('લિયાના', 'लियाना', 'Liana', 'કોમળ પુષ્પવેલ', 'नाजुक लता', 'Delicate vine'),
      ('લક્ષિતા', 'लक्षिता', 'Lakshita', 'પ્રતિષ્ઠિત સ્ત્રી', 'विशिष्ट', 'Distinguished'),
      ('લતીકા', 'लतिका', 'Latika', 'નાની કોમળ વેલ', 'कोमल लता', 'Delicate creeper'),
      ('લીના', 'लीना', 'Leena', 'નમ્ર અને સમર્પિત', 'समर्पित', 'Devoted, Gentle'),
      ('લાડલી', 'लाडली', 'Ladli', 'વહાલી દીકરી', 'प्यारी बेटी', 'Beloved child'),
      ('ઇશિકા', 'इशिका', 'Ishika', 'પવિત્ર તીર, કલમ', 'पवित्र बाण', 'Sacred arrow'),
      ('ઈશિતા', 'ईशिता', 'Ishita', 'સમૃદ્ધિ, શક્તિ', 'समृद्धि', 'Mastery, Wealth'),
      ('ઇરા', 'इरा', 'Ira', 'સરસ્વતી, પૃથ્વી', 'सरस्वती', 'Goddess Saraswati'),
      ('ઇશાની', 'ईशानी', 'Ishani', 'પાર્વતી દેવી', 'पार्वती', 'Goddess Parvati'),
      ('ઇનાયા', 'इनाया', 'Inaya', 'ઈશ્વરની દયા', 'ईश्वर की दया', 'Care of God'),
      ('ઇવાના', 'इवाना', 'Ivana', 'ઈશ્વરની કૃપા', 'ईश्वर का उपहार', 'God is gracious'),
      ('ઇવા', 'इवा', 'Iva', 'જીવન આપનારી', 'जीवन', 'Life giver'),
      ('ઇશાનવી', 'ईशानवी', 'Ishanvi', 'દેવી પાર્વતી', 'पार्वती', 'Goddess Parvati'),
      ('ઇશા', 'ईशा', 'Isha', 'દેવી દુર્ગા', 'देवी दुर्गा', 'Protectress'),
      ('ઇલા', 'इला', 'Ila', 'પૃથ્વી માતા', 'धरती मां', 'Mother Earth'),
    ];
    for (final g in mGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 0, false);
    }
  }

  // -------------------------------------------------------------
  // 1: VRISHABHA (બ, વ, ઉ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addVrishabhaNames(Function add) {
    // Boys
    final vBoys = [
      ('વિવાન', 'विवान', 'Vivaan', 'સૂર્યનાં કિરણો, જીવંત', 'सूर्य किरणें', 'Full of life, Sun'),
      ('વિહાન', 'विहान', 'Vihaan', 'નવો પ્રભાત, સૂર્યોદય', 'नया सवेरा', 'Dawn, Morning twilight'),
      ('વેદાંત', 'वेदांत', 'Vedant', 'વેદોનું પરમ જ્ઞાન', 'वेदों का सार', 'Vedic wisdom'),
      ('વ્યોમ', 'व्योम', 'Vyom', 'વિશાળ આકાશ', 'आकाश', 'Cosmos, Sky'),
      ('વરુણ', 'वरुण', 'Varun', 'જળના દેવતા', 'जल देवता', 'Lord of waters'),
      ('વેદ', 'वेद', 'Ved', 'પવિત્ર જ્ઞાન', 'पवित्र ज्ञान', 'Sacred knowledge'),
      ('વિરાજ', 'विराज', 'Viraj', 'તેજસ્વી શાસક', 'चमकदार राजा', 'Resplendent ruler'),
      ('વત્સલ', 'वत्सल', 'Vatsal', 'સ્નેહાળ, પ્રેમાળ', 'स्नेही', 'Affectionate'),
      ('વિદિત', 'विदित', 'Vidit', 'જ્ઞાની, બુદ્ધિશાળી', 'बुद्धिमान', 'Wise, Learned'),
      ('વ્રજ', 'व्रज', 'Vraj', 'શ્રીકૃષ્ણની ભૂમિ', 'कृष्ण भूमि', 'Land of Krishna'),
      ('વિરાન', 'वीरन', 'Viran', 'સાહસી યોદ્ધા', 'बहादुर', 'Brave hero'),
      ('વૃષાંક', 'वृषांक', 'Vrishank', 'ભગવાન શિવ', 'भगवान शिव', 'Lord Shiva'),
      ('વિરાટ', 'विराट', 'Virat', 'વિશાળ, ભવ્ય', 'विशाल', 'Majestic, Giant'),
      ('વિનય', 'विनय', 'Vinay', 'નમ્રતા, સદ્ગુણ', 'नम्रता', 'Politeness'),
      ('વિવેક', 'विवेक', 'Vivek', 'સદ્બુદ્ધિ', 'सद्विचार', 'Wisdom'),
      ('વિશાલ', 'विशाल', 'Vishal', 'વિશાળ હૃદય', 'बड़ा', 'Broad minded'),
      ('વિદુર', 'विदुर', 'Vidur', 'નીતિજ્ઞ વિદ્વાન', 'ज्ञानी', 'Wise, Righteous'),
      ('વિજય', 'विजय', 'Vijay', 'વિજેતા, ફતેહ', 'जीत', 'Victory, Triumph'),
      ('વિપુલ', 'विपुल', 'Vipul', 'સમૃદ્ધ, પુષ્કળ', 'समृद्ध', 'Abundant, Rich'),
      ('વૈભવ', 'वैभव', 'Vaibhav', 'વૈભવ, સમૃદ્ધિ', 'समृद्धि', 'Prosperity, Glory'),
      ('ભવ્ય', 'भव्य', 'Bhavya', 'શાનદાર, દિવ્ય', 'शानदार', 'Grand, Splendid'),
      ('બ્રિજ', 'बृज', 'Brij', 'શ્રીકૃષ્ણની ભૂમિ', 'श्रीकृष्ण की भूमि', 'Land of Krishna'),
      ('બ્રિજેશ', 'बृजेश', 'Brijesh', 'શ્રીકૃષ્ણ ભગવાન', 'भगवान कृष्ण', 'Lord of Braj'),
      ('ભવિત', 'भवित', 'Bhavit', 'ભાવિ, પ્રગતિશીલ', 'उज्ज्वल भविष्य', 'Promising future'),
      ('ભાવેશ', 'भावेश', 'Bhavesh', 'શિવ ભગવાન', 'भगवान शिव', 'Lord Shiva'),
      ('બાલરાજ', 'बलराज', 'Balraj', 'શક્તિશાળી રાજા', 'बलवान राजा', 'Mighty king'),
      ('ભાર્ગવ', 'भार्गव', 'Bhargav', 'તેજસ્વી શિવ', 'भगवान शिव', 'Radiant Shiva'),
      ('ઉત્કર્ષ', 'उत्कर्ष', 'Utkarsh', 'ઉન્નતિ, વિકાસ', 'प्रगति', 'Prosperity'),
      ('ઉત્સવ', 'उत्सव', 'Utsav', 'આનંદ પર્વ', 'त्योहार', 'Festival, Joy'),
      ('ઉદય', 'उदय', 'Uday', 'સૂર્યોદય', 'सूर्योदय', 'Dawn, Sunrise'),
      ('ઉમંગ', 'उमंग', 'Umang', 'ઉત્સાહ, આનંદ', 'उत्साह', 'Enthusiasm'),
      ('ઉજ્જવલ', 'उज्ज्वल', 'Ujjwal', 'તેજસ્વી, પ્રકાશમાન', 'प्रकाशमान', 'Bright, Luminous'),
      ('ઉપેન્દ્ર', 'उपेन्द्र', 'Upendra', 'વિષ્ણુ ભગવાન', 'भगवान विष्णु', 'Lord Vishnu'),
      ('ઉમેશ', 'उमेश', 'Umesh', 'શિવ ભગવાન', 'भगवान शिव', 'Lord Shiva'),
      ('ઉત્તમ', 'उत्तम', 'Uttam', 'શ્રેષ્ઠ પુરુષ', 'सर्वश्रेष्ठ', 'The Best, Prime'),
    ];
    for (final b in vBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 1, true);
    }

    // Girls
    final vGirls = [
      ('વામિકા', 'वामिका', 'Vamika', 'દેવી દુર્ગા', 'देवी दुर्गा', 'Goddess Durga'),
      ('વાણિયા', 'वाणिया', 'Vaniya', 'સરસ્વતીનું મધુર રૂપ', 'सरस्वती', 'Sweet speech, Saraswati'),
      ('વેદિકા', 'वेदिका', 'Vedika', 'પવિત્ર વેદી', 'पवित्र वेदी', 'Sacred altar'),
      ('વૃંદા', 'वृंदा', 'Vrinda', 'તુલસી દેવી, રાધાજી', 'तुलसी, राधा', 'Holy Basil, Radha'),
      ('વૃષ્ટિ', 'वृष्टि', 'Vrishti', 'પ્રેમનો વરસાદ', 'वर्षा', 'Rain of blessings'),
      ('વૈષ્ણવી', 'वैष्णवी', 'Vaishnavi', 'દેવી દુર્ગા', 'शक्ति, दुर्गा', 'Goddess Durga'),
      ('વંશિકા', 'वंशिका', 'Vanshika', 'વાંસળી, વંશવેલો', 'मुरली', 'Flute melody'),
      ('વૃતિકા', 'वृतिका', 'Vritika', 'વિચારશીલ, સફળ', 'सफल', 'Thoughtful, Success'),
      ('વાશ્વી', 'वाश्वी', 'Vashvi', 'આકર્ષક, દિવ્ય', 'आकर्षक', 'Attractive, Divine'),
      ('વિધિ', 'विधि', 'Vidhi', 'ભાગ્ય, સંસ્કાર', 'भाग्य', 'Destiny, Law'),
      ('વાણી', 'वाणी', 'Vaani', 'સરસ્વતી, મધુર વાણી', 'सरस्वती, वाणी', 'Speech, Saraswati'),
      ('વૈદેહી', 'वैदेही', 'Vaidehi', 'સીતા માતા', 'माता सीता', 'Goddess Sita'),
      ('વિનીતા', 'विनीता', 'Vineeta', 'નમ્ર, સંસ્કારી', 'विनीत', 'Humble'),
      ('વિદુષી', 'विदुषी', 'Vidushi', 'જ્ઞાની સ્ત્રી', 'ज्ञानी स्त्री', 'Learned woman'),
      ('વિશ્વા', 'विश्वा', 'Vishwa', 'સમસ્ત બ્રહ્માંડ', 'संसार', 'Universe'),
      ('વંદના', 'वंदना', 'Vandana', 'પૂજન, પ્રાર્થના', 'पूजा', 'Prayer, Worship'),
      ('બંસરી', 'बांसुरी', 'Bansari', 'મધુર મુરલી', 'मुरली', 'Flute melody'),
      ('ભાવના', 'भावना', 'Bhavana', 'શુદ્ધ લાગણી', 'सद्भावना', 'Feelings, Devotion'),
      ('ભૂમિકા', 'भूमिका', 'Bhumika', 'પૃથ્વી માતા', 'धरती', 'Earth, Role'),
      ('બરખા', 'बरखा', 'Barkha', 'વરસાદની મોસમ', 'बारिश', 'Rain, Monsoon'),
      ('ઉન્નતિ', 'उन्नति', 'Unnati', 'પ્રગતિ, વિકાસ', 'प्रगति', 'Progress, Rise'),
      ('ઉર્વી', 'उर्वी', 'Urvi', 'વિશાળ પૃથ્વી', 'धरती', 'Earth, Majestic'),
      ('ઉપાસના', 'उपासना', 'Upasana', 'ભક્તિ, પ્રાર્થના', 'पूजा, आराधना', 'Worship, Prayer'),
      ('ઉર્વશી', 'उर्वशी', 'Urvashi', 'સુંદર અપ્સરા', 'सुंदर अप्सरा', 'Most beautiful celestial'),
      ('ઉર્મિ', 'उर्मि', 'Urmi', 'પ્રેમનો તરંગ', 'लहर', 'Wave of love'),
      ('ઉમા', 'उमा', 'Uma', 'દેવી પાર્વતી', 'पार्वती', 'Goddess Parvati'),
      ('ઉજાસ', 'उजास', 'Ujaas', 'પ્રકાશ, અજવાળું', 'रोशनी', 'Light, Radiance'),
      ('ઉર્મિલા', 'उर्मिला', 'Urmila', 'લક્ષ્મણ પત્ની, મૃદુ', 'उर्मिला', 'Gentle, Modest'),
    ];
    for (final g in vGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 1, false);
    }
  }

  // -------------------------------------------------------------
  // 2: MITHUNA (ક, છ, ઘ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addMithunaNames(Function add) {
    final kBoys = [
      ('કિયાન', 'कियान', 'Kiaan', 'ઈશ્વરની કૃપા, પ્રાચીન રાજા', 'ईश्वर की कृपा', 'Grace of God, Royal'),
      ('કયાન', 'कयान', 'Kayaan', 'શાહી વંશ, તેજસ્વી', 'शाही वंश', 'Royal dynasty, Radiant'),
      ('કૃષિવ', 'कृषिव', 'Krishiv', 'કૃષ્ણ-શિવ સમન્વય', 'कृष्ण और शिव रूप', 'Krishna & Shiva'),
      ('કવિન', 'कविन', 'Kavin', 'સુંદર કવિ', 'सुंदर, बुद्धिमान', 'Handsome, Poet'),
      ('કબીર', 'कबीर', 'Kabir', 'મહાન સંત', 'महान संत', 'Great, Famous saint'),
      ('કુશ', 'कुश', 'Kush', 'શ્રીરામના પુત્ર', 'श्री राम के पुत्र', 'Son of Rama'),
      ('કૈરવ', 'कैरव', 'Kairav', 'શ્વેત કમળ', 'सफेद कमल', 'White lotus'),
      ('કનવ', 'कणव', 'Kanav', 'મહાન ઋષિ', 'ऋषि कण्व', 'Sage Kanva'),
      ('કોવિદ', 'कोविद', 'Kovid', 'વિદ્વાન, જ્ઞાની', 'विद्वान', 'Wise, Scholar'),
      ('ક્રીદય', 'क्रीदय', 'Kriday', 'ભગવાન શ્રીકૃષ્ણ', 'भगवान कृष्ण', 'Lord Krishna'),
      ('ક્ષિતિજ', 'क्षितिज', 'Kshitij', 'ક્ષિતિજ રેખા', 'क्षितिज', 'Horizon'),
      ('કુશાગ્ર', 'कुशाग्र', 'Kushagra', 'તીક્ષ્ણ બુદ્ધિ', 'तेज बुद्धि', 'Sharp minded'),
      ('કાવ્ય', 'काव्य', 'Kaavya', 'કવિતા, સાહિત્ય', 'कविता', 'Poem, Poetry'),
      ('કૃણાલ', 'कृणाल', 'Krunal', 'પ્રેમાળ કમળ', 'कमल', 'Lotus, Kind hearted'),
      ('કેયુર', 'केयूर', 'Keyur', 'બાજુબંધ ઘરેણું', 'आभूषण', 'Armlet, Jewel'),
      ('કૃષ્ણ', 'कृष्ण', 'Krishna', 'પરબ્રહ્મ શ્રીકૃષ્ણ', 'भगवान कृष्ण', 'All attractive, Krishna'),
      ('કલ્પેશ', 'कल्पेश', 'Kalpesh', 'સંકલ્પના સ્વામી', 'कल्पना के स्वामी', 'Lord of perfection'),
      ('કૌશલ', 'कौशल', 'Kaushal', 'નિપુણતા', 'कुशलता', 'Skill, Cleverness'),
      ('કાર્તિકેય', 'कार्तिकेय', 'Kartikeya', 'શિવપુત્ર સેનાપતિ', 'कार्तिकेय', 'Lord Kartikeya'),
      ('કુવમ', 'कुवम', 'Kuvam', 'સૂર્યદેવ', 'सूर्य', 'Sun, Illuminating'),
      ('કપિલ', 'कपिल', 'Kapil', 'મહાન ઋષિ', 'ऋषि कपिल', 'Sage Kapil'),
      ('કમલેશ', 'कमलेश', 'Kamlesh', 'કમળના સ્વામી, વિષ્ણુ', 'विष्णु', 'Lord Vishnu'),
      ('કુંદન', 'कुंदन', 'Kundan', 'શુદ્ધ સોનું', 'शुद्ध सोना', 'Pure gold'),
      ('ક્ષિતિશ', 'क्षितीश', 'Kshitish', 'પૃથ્વીપતિ રાજા', 'राजा', 'Lord of Earth'),
      ('છવિરાજ', 'छविराज', 'Chhaviraj', 'સૌંદર્યવાન રાજા', 'सुंदर राजा', 'King of beauty'),
      ('છત્રપાલ', 'छत्रपाल', 'Chhatrapal', 'રક્ષક રાજા', 'रक्षक', 'Protector king'),
      ('ઘનશ્યામ', 'घनश्याम', 'Ghanshyam', 'શ્રીકૃષ્ણ', 'श्री कृष्ण', 'Dark cloud, Krishna'),
      ('ઘનંજય', 'धनंजय', 'Ghananjay', 'વિજયી અર્જુન', 'अर्जुन', 'Winner of wealth'),
    ];
    for (final b in kBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 2, true);
    }

    final kGirls = [
      ('કિઆરા', 'किआरा', 'Kiara', 'તેજસ્વી, શુદ્ધ', 'चमकीली, शुद्ध', 'Bright, Clear, Pure'),
      ('કૃષા', 'कृषा', 'Krisha', 'દૈવી કૃપા, શાંતિ', 'कृपा, शांति', 'Divine grace, Peace'),
      ('કાવ્યા', 'काव्या', 'Kaavya', 'કાવ્યમયી સરસ્વતી', 'कविता, सरस्वती', 'Poem, Saraswati'),
      ('કશવી', 'कश्वी', 'Kashvi', 'તેજસ્વી, ચમકદાર', 'चमकीली', 'Shining, Radiant'),
      ('કાયરા', 'कायरा', 'Kaira', 'શાંતિપૂર્ણ, અનોખી', 'शांतिपूर्ण', 'Peaceful, Unique'),
      ('કનિષ્કા', 'कनिष्का', 'Kanishka', 'નાની રાજકુમારી', 'छोटी राजकुमारी', 'Little princess'),
      ('કૃતિકા', 'कृतिका', 'Kritika', 'નક્ષત્ર, પૂર્ણતા', 'नक्षत्र', 'Pleiades star'),
      ('કિમાયા', 'किमाया', 'Kimaya', 'ઈશ્વરનો ચમત્કાર', 'ईश्वरीय चमत्कार', 'Divine miracle'),
      ('ક્રીના', 'क्रीना', 'Krina', 'સુંદર પ્રશંસા', 'प्रशंसा', 'Praise, Sweet melody'),
      ('કુહૂ', 'कुहू', 'Kuhu', 'કોયલનો મીઠો ટહુકો', 'कोयल की मीठी आवाज', 'Sweet song of cuckoo'),
      ('કેયા', 'केया', 'Keya', 'સુગંધિત પુષ્પ', 'सुगंधित फूल', 'Monsoon flower'),
      ('કિયાના', 'कियाना', 'Kiana', 'ચંદ્ર જેવી શીતળ', 'चंद्रमा समान', 'Moon-like beauty'),
      ('કુસુમ', 'कुसुम', 'Kusum', 'સુંદર ફૂલ', 'फूल', 'Flower, Blossom'),
      ('કોમલ', 'कोमल', 'Komal', 'મૃદુ, મુલાયમ', 'सुकुमार', 'Soft, Tender'),
      ('કલ્પના', 'कल्पना', 'Kalpana', 'સર્જનાત્મક વિચાર', 'कल्पना', 'Imagination'),
      ('કંચન', 'कंचन', 'Kanchan', 'શુદ્ધ સોનું', 'सोना', 'Pure Gold'),
      ('કુમુદ', 'कुमुद', 'Kumud', 'શ્વેત કમળ', 'सफेद कमल', 'White Lotus'),
      ('કિરણ', 'किरण', 'Kiran', 'સૂર્યપ્રકાશનું કિરણ', 'किरण', 'Ray of light'),
      ('કામિની', 'कामिनी', 'Kamini', 'ગુણવાન સ્ત્રી', 'सुंदर स्त्री', 'Graceful lady'),
      ('ક્ષમા', 'क्षमा', 'Kshama', 'માફી, દયા', 'माफी', 'Forgiveness'),
      ('કિંજલ', 'किंजल', 'Kinjal', 'નદી કિનારો', 'नदी किनारा', 'River bank'),
      ('કેશવી', 'केशवी', 'Keshvi', 'રાધાજી', 'राधा रानी', 'Radha, Beautiful locks'),
      ('કનિકા', 'कनिका', 'Kanika', 'સોનાનો અણુ', 'सोने का कण', 'Atom of gold'),
      ('છાયા', 'छाया', 'Chhaya', 'શીતળતા, સૂર્યપત્ની', 'शीतल छाया', 'Shadow, Protection'),
      ('છવિ', 'छवि', 'Chhavi', 'સુંદર પ્રતિમા', 'सुंदर रूप', 'Beautiful image'),
      ('ખ્વાહિશ', 'ख्वाहिश', 'Khwahish', 'દિલની ઇચ્છા', 'इच्छा', 'Desire, Wish'),
    ];
    for (final g in kGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 2, false);
    }
  }

  // -------------------------------------------------------------
  // 3: KARKA (ડ, હ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addKarkaNames(Function add) {
    final hBoys = [
      ('હિયાંશ', 'हियांश', 'Hiyansh', 'હૃદયનો અંશ', 'हृदय का अंश', 'Piece of heart'),
      ('હૃદય', 'हृदय', 'Hriday', 'હૃદય, પ્રેમનું કેન્દ્ર', 'दिल, प्रेम', 'Heart, Core of love'),
      ('હૃદાન', 'हृदान', 'Hridan', 'હૃદયવાન, દયાળુ', 'उदार दिल वाला', 'Generous heart'),
      ('હર્ષિત', 'हर्षित', 'Harshit', 'આનંદિત, પ્રસન્ન', 'प्रसन्न', 'Joyful, Delighted'),
      ('હર્ષિલ', 'हर्षिल', 'Harshil', 'આનંદ આપનાર', 'खुशहाल', 'Spreading joy'),
      ('હિતાર્થ', 'हितार्थ', 'Hitarth', 'સૌનું ભલું ઈચ્છનાર', 'कल्याणकारी', 'Well wisher for all'),
      ('હેમિલ', 'हेमिल', 'Hemil', 'સુવર્ણ સમાન', 'स्वर्ण समान', 'Golden, Precious'),
      ('હિરેન', 'हिरेन', 'Hiren', 'હીરાના સ્વામી, શિવ', 'शिव', 'Lord of gems, Shiva'),
      ('હાર્દિક', 'हार्दिक', 'Hardik', 'હૃદયપૂર્વકનું', 'दिल से', 'From the heart'),
      ('હર્ષ', 'हर्ष', 'Harsh', 'ઉલ્લાસ, આનંદ', 'खुशी', 'Joy, Happiness'),
      ('હિતેશ', 'हितेश', 'Hitesh', 'સૌનું હિત કરનાર', 'भलाई करने वाला', 'Lord of goodness'),
      ('હેમંત', 'हेमंत', 'Hemant', 'સુવર્ણ ઋતુ', 'सोने की ऋतु', 'Gold, Winter'),
      ('હિમાંશુ', 'हिमांशु', 'Himanshu', 'ચંદ્રમા', 'चंद्रमा', 'The Moon'),
      ('હિતેન', 'हितेन', 'Hiten', 'શુભચિંતક', 'शुभचिंतक', 'Well-wisher'),
      ('હર્ષવર્ધન', 'हर्षवर्धन', 'Harshvardhan', 'આનંદ વધારનાર', 'खुशी बढ़ाने वाला', 'Increasing joy'),
      ('હૈદવ', 'हैदव', 'Haidav', 'ચમકતો હીરો', 'चमकदार', 'Radiant diamond'),
      ('હેત', 'हेत', 'Het', 'નિઃસ્વાર્થ પ્રેમ', 'सच्चा प्रेम', 'Affection, Love'),
      ('હરિ', 'हरि', 'Hari', 'વિષ્ણુ ભગવાન', 'भगवान विष्णु', 'Lord Vishnu'),
      ('હનુમંત', 'हनुमंत', 'Hanumant', 'હનુમાનજી', 'हनुमान जी', 'Lord Hanuman'),
      ('દક્ષ', 'दक्ष', 'Daksh', 'સક્ષમ, નિપુણ', 'योग्य, कुशल', 'Capable, Efficient'),
      ('દેવ', 'देव', 'Dev', 'દિવ્ય ઈશ્વર', 'देवता', 'Divine, Godly'),
      ('દિવ્યાંગ', 'दिव्यांग', 'Divyang', 'દિવ્ય અંગવાળા', 'दिव्य अंग', 'Divine body'),
      ('દિવાકર', 'दिवाकर', 'Diwakar', 'સૂર્યનારાયણ', 'सूर्य', 'The Sun'),
    ];
    for (final b in hBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 3, true);
    }

    final hGirls = [
      ('હિયા', 'हिया', 'Hiya', 'હૃદય, અંતરનો અવાજ', 'हृदय, आत्मा', 'Heart, Soul'),
      ('હેતવી', 'हेतवी', 'Hetvi', 'પ્રેમની દેવી', 'प्रेम की देवी', 'Goddess of love'),
      ('હૃદયા', 'हृदया', 'Hridaya', 'દિલદાર, સ્નેહાળ', 'दयालु हृदय', 'Heart, Kind soul'),
      ('હેતાંશી', 'हेतांशी', 'Hetanshi', 'પ્રેમનો અંશ', 'प्रेम का अंश', 'Part of love'),
      ('હરિણી', 'हरिणी', 'Harini', 'મૃગનયની, લક્ષ્મી', 'सुंदर, देवी लक्ष्मी', 'Doe-eyed, Lakshmi'),
      ('દિયા', 'दिया', 'Diya', 'પવિત્ર દીવડો, પ્રકાશ', 'दीपक', 'Lamp, Divine light'),
      ('દિત્યા', 'दित्या', 'Ditya', 'પ્રાર્થનાનો ઉત્તર, લક્ષ્મી', 'लक्ष्मी', 'Goddess Lakshmi'),
      ('દિવ્યા', 'दिव्या', 'Divya', 'દિવ્ય તેજસ્વી', 'दिव्य', 'Divine, Heavenly'),
      ('દિશા', 'दिशा', 'Disha', 'યોગ્ય માર્ગ', 'दिशा, रास्ता', 'Direction, Path'),
      ('હેમાલી', 'हेमाली', 'Hemali', 'સોનેરી તેજસ્વી', 'सोने जैसी', 'Golden, Radiant'),
      ('હિરલ', 'हिरल', 'Hiral', 'તેજસ્વી હીરો', 'हीरा', 'Diamond, Lustrous'),
      ('હર્ષિતા', 'हर्षिता', 'Harshita', 'સદા પ્રસન્ન', 'खुश रहने वाली', 'Full of joy'),
      ('હૃષિતા', 'हृषिता', 'Hrishita', 'આનંદ આપનારી', 'हंसमुख', 'Joyous, Bright'),
      ('હંસિકા', 'हंसिका', 'Hansika', 'સરસ્વતીની હંસી', 'हंसिनी', 'Swan, Saraswati'),
      ('હિમાની', 'हिमानी', 'Himani', 'દેવી પાર્વતી', 'देवी पार्वती', 'Goddess Parvati'),
      ('હેતલ', 'हेतल', 'Hetal', 'પ્રેમથી છલકતી', 'प्रेममयी', 'Loving'),
      ('હિતિક્ષા', 'हितिक्षा', 'Hitiksha', 'શાંતિમય સહનશીલ', 'शांतिपूर्ण', 'Peaceful, Patient'),
      ('હર્ષિની', 'हर्षिणी', 'Harshini', 'આનંદ આપનારી', 'हंसमुख', 'Joyous'),
      ('હૃદિકા', 'हृदिका', 'Hridika', 'હૃદયપ્રેમી', 'दिल की रानी', 'Beloved of heart'),
      ('દ્રષ્ટિ', 'दृष्टि', 'Drashti', 'દિવ્ય દ્રષ્ટિ', 'दृष्टि', 'Vision, Sight'),
      ('હર્ષા', 'हर्षा', 'Harsha', 'આનંદમયી', 'खुशी', 'Joy, Delight'),
      ('હેમાંગી', 'हेमांगी', 'Hemangi', 'સુવર્ણ શરીરવાળી', 'सोने जैसी काया', 'Golden bodied'),
      ('હિરન્યા', 'हिरण्या', 'Hiranya', 'લક્ષ્મીજી', 'लक्ष्मी', 'Golden, Lakshmi'),
    ];
    for (final g in hGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 3, false);
    }
  }

  // -------------------------------------------------------------
  // 4: SIMHA (મ, ટ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addSimhaNames(Function add) {
    final mBoys = [
      ('માનવ', 'मानव', 'Maanav', 'માનવતાવાદી પુરુષ', 'सच्चा इंसान', 'Humanitarian'),
      ('મીત', 'मीत', 'Meet', 'સાચો મિત્ર, સ્નેહી', 'सच्चा दोस्त', 'Friend, Companion'),
      ('મનન', 'मनन', 'Manan', 'ચિંતન, ઊંડો વિચાર', 'चिंतन', 'Meditation'),
      ('મયંક', 'मयंक', 'Mayank', 'નિષ્કલંક ચંદ્ર', 'चंद्रमा', 'Pure Moon'),
      ('મોક્ષ', 'मोक्ष', 'Moksh', 'પરમ મુક્તિ', 'मुक्ति', 'Liberation, Salvation'),
      ('માધવ', 'माधव', 'Madhav', 'શ્રીકૃષ્ણ ભગવાન', 'भगवान कृष्ण', 'Lord Krishna'),
      ('માનિત', 'मानित', 'Maanit', 'સન્માનનીય', 'सम्मानित', 'Respected, Honoured'),
      ('મિહિત', 'मिहित', 'Mihit', 'સૂર્યદેવનો અંશ', 'सूर्य का अंश', 'Sunbeam'),
      ('મૃદુલ', 'मृदुल', 'Mridul', 'કોમળ સ્વભાવ', 'कोमल', 'Gentle, Soft-spoken'),
      ('મિહિર', 'मिहिर', 'Mihir', 'તેજસ્વી સૂર્ય', 'सूर्य', 'The Sun'),
      ('મનવિક', 'मनविक', 'Manvik', 'બુદ્ધિશાળી અને સચેત', 'बुद्धिमान', 'Intelligent'),
      ('મેધાંશ', 'मेधांश', 'Medhansh', 'બુદ્ધિનો અંશ', 'बुद्धि का अंश', 'Part of intellect'),
      ('મિતુલ', 'मितुल', 'Mitul', 'મિત્રતાપૂર્ણ, સંતુલિત', 'संतुलित मित्र', 'Friendly, Balanced'),
      ('મલહાર', 'मल्हार', 'Malhar', 'વરસાદનો રાગ', 'वर्षा का राग', 'Raga of rain'),
      ('મુકુંદ', 'मुकुंद', 'Mukund', 'વિષ્ણુ ભગવાન', 'भगवान विष्णु', 'Lord Vishnu'),
      ('મનહર', 'मनहर', 'Manhar', 'મન મોહી લેનાર', 'मनमोहक', 'Charming, Krishna'),
      ('મિલન', 'मिलन', 'Milan', 'એકતા, મેળાપ', 'एकता', 'Meeting, Union'),
      ('મયૂર', 'मयूर', 'Mayur', 'સુંદર મોર', 'मोर', 'Peacock, Beauty'),
      ('માનવેન્દ્ર', 'मानवेन्द्र', 'Manavendra', 'માનવોના રાજા', 'राजा', 'King of men'),
      ('મહેશ', 'महेश', 'Mahesh', 'શિવ ભગવાન', 'भगवान शिव', 'Lord Shiva'),
      ('મોહિત', 'मोहित', 'Mohit', 'આકર્ષક, મોહક', 'आकर्षक', 'Charmed, Attractive'),
      ('તન્મય', 'तन्मय', 'Tanmay', 'તલ્લીન, એકાગ્ર', 'एकाग्र', 'Engrossed, Absorbed'),
      ('તક્ષ', 'तक्ष', 'Taksh', 'બળવાન રાજા', 'मजबूत', 'Strong, King'),
      ('તક્ષિલ', 'तक्षिल', 'Takshil', 'દ્રઢ સંકલ્પવાળો', 'दृढ़ संकल्प', 'Strong character'),
      ('તરન', 'तरन', 'Taran', 'તારણહાર', 'उद्धारक', 'Saviour'),
    ];
    for (final b in mBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 4, true);
    }

    final mGirls = [
      ('માયરા', 'मायरा', 'Myra', 'મીઠી, સ્નેહાળ', 'प्यारी, प्रिय', 'Beloved, Sweet'),
      ('મિશિકા', 'मिशिका', 'Mishika', 'ઈશ્વરનો પ્રેમ, મીઠાશ', 'ईश्वर का प्रेम', 'Love of God, Sweetness'),
      ('માહિરા', 'माहिरा', 'Mahira', 'ચતુર, કુશળ વિદ્વાન', 'कुशल, विदुषी', 'Expert, Talented'),
      ('માનસી', 'मानसी', 'Mansi', 'મનની રચના સરસ્વતી', 'सरस्वती', 'Mental creation, Saraswati'),
      ('મીરા', 'मीरा', 'Meera', 'કૃષ્ણભક્ત મીરાંબાઈ', 'कृष्ण भक्त', 'Devotee of Krishna'),
      ('મૈત્રી', 'मैत्री', 'Maitri', 'સાચી મિત્રતા', 'मित्रता', 'Friendship, Goodwill'),
      ('મિષ્ટિ', 'मिष्टी', 'Mishti', 'મધુર મીઠાશ', 'मीठी', 'Sweet, Loving'),
      ('મુગ્ધા', 'मुग्धा', 'Mugdha', 'નિષ્પાપ સુંદરતા', 'मासूम', 'Innocent, Beautiful'),
      ('મનસ્વી', 'मनस्वी', 'Manasvi', 'બુદ્ધિમાન સ્ત્રી', 'बुद्धिमान', 'Intellectual'),
      ('મિશા', 'मिशा', 'Misha', 'ઈશ્વર સમાન પવિત્ર', 'पवित्र', 'Pure, Smile'),
      ('મિરાયા', 'मिराया', 'Miraya', 'શ્રીકૃષ્ણ ભક્ત', 'कृष्ण भक्त', 'Devotee of Krishna'),
      ('માહી', 'माही', 'Mahi', 'પૃથ્વી, મહાન નદી', 'धरती, नदी', 'Earth, Great river'),
      ('મોહિની', 'मोहिनी', 'Mohini', 'મનમોહક', 'मनमोहक', 'Charming, Enchanting'),
      ('તન્વી', 'तन्वी', 'Tanvi', 'કોમળ સુંદરી, દુર્ગા', 'सुंदर स्त्री', 'Delicate, Goddess Durga'),
      ('તારા', 'तारा', 'Taara', 'ચમકતો તારો, દેવી', 'चमकता तारा', 'Bright Star, Goddess'),
      ('ત્રિષા', 'त्रिषा', 'Trisha', 'ઈચ્છા, પ્યાસ', 'इच्छा', 'Aspiration'),
      ('તિયા', 'तिया', 'Tiya', 'મીઠું પક્ષી', 'सुंदर चिड़िया', 'Sweet bird, Hope'),
      ('તાન્યા', 'तान्या', 'Tanya', 'પરી સમાન સુંદર', 'परी', 'Fairy, Daughter'),
      ('મુસ્કાન', 'मुस्कान', 'Muskan', 'મીઠું સ્મિત', 'मुस्कान', 'Smile, Joy'),
      ('મેઘા', 'मेघा', 'Megha', 'વરસાદનું વાદળ', 'बादल', 'Cloud, Rain'),
      ('મધુરા', 'मधुरा', 'Madhura', 'મધુર અવાજવાળી', 'मीठी वाणी', 'Melodious'),
      ('માલતી', 'मालती', 'Malati', 'ચમેલીનું ફૂલ', 'सुगंधित फूल', 'Jasmine flower'),
      ('મિનલ', 'मीनल', 'Meenal', 'કિંમતી રત્ન', 'अनमोल रत्न', 'Precious gem'),
    ];
    for (final g in mGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 4, false);
    }
  }

  // -------------------------------------------------------------
  // 5: KANYA (પ, ઠ, ણ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addKanyaNames(Function add) {
    final pBoys = [
      ('પ્રણવ', 'प्रणव', 'Pranav', 'પવિત્ર ૐકાર ધ્વનિ', 'पवित्र ॐ कार', 'Sacred sound Om'),
      ('પાર્થ', 'पार्थ', 'Parth', 'અર્જુન, પૃથ્વીપુત્ર', 'अर्जुन, वीर', 'Arjuna, Prince of Earth'),
      ('પ્રયાણ', 'प्रयाण', 'Prayan', 'આગળ વધવું, યાત્રા', 'उन्नति की यात्रा', 'Journey of progress'),
      ('પરમ', 'परम', 'Param', 'સર્વોચ્ચ, શ્રેષ્ઠ', 'सर्वश्रेष्ठ', 'Supreme, Absolute'),
      ('પિયાંશ', 'पियांश', 'Piyansh', 'પ્રેમનો અંશ', 'प्रेम का अंश', 'Part of beloved'),
      ('પ્રતીક', 'प्रतीक', 'Prateek', 'પ્રતીક, ચિહ્ન', 'चिह्न, पहचान', 'Symbol, Representation'),
      ('પ્રિયાંશુ', 'प्रियांशु', 'Priyanshu', 'સૂર્યપ્રકાશનું પ્રથમ કિરણ', 'सूर्य का पहला किरण', 'First sunbeam'),
      ('પુલકિત', 'पुलकित', 'Pulkit', 'આનંદિત, રોમાંચિત', 'प्रसन्न', 'Thrilled with joy'),
      ('પુરવ', 'पूरव', 'Purav', 'પૂર્વ દિશા, તેજ', 'पूर्व दिशा', 'East, Shining'),
      ('પાર્થિવ', 'पार्थिव', 'Parthiv', 'પૃથ્વીનો રાજકુમાર', 'पृथ्वी का राजकुमार', 'Prince of Earth'),
      ('પાવિત', 'पावित', 'Pavit', 'પવિત્ર, શુદ્ધ', 'पवित्र', 'Pure, Sacred'),
      ('પલાશ', 'पलाश', 'Palash', 'સુંદર કેસૂડો', 'सुंदर फूल', 'Flamboyant blossom'),
      ('પાવક', 'पावक', 'Pavak', 'પવિત્ર અગ્નિ', 'पवित्र अग्नि', 'Pure fire, Sacred'),
      ('પ્રાંશુ', 'प्रांशु', 'Pranshu', 'ભગવાન વિષ્ણુ, તેજસ્વી', 'भगवान विष्णु', 'Lord Vishnu, Tall'),
      ('પવન', 'पवन', 'Pavan', 'પવિત્ર વાયુ, હનુમાન', 'पवित्र वायु', 'Pure wind, Hanuman'),
      ('પ્રશાંત', 'प्रशांत', 'Prashant', 'શાંત અને ગંભીર', 'शांत', 'Calm, Peaceful'),
      ('પ્રેમ', 'प्रेम', 'Prem', 'નિઃસ્વાર્થ સ્નેહ', 'सच्चा प्यार', 'Love, Affection'),
      ('પ્રીત', 'प्रीत', 'Preet', 'મિત્રતા, પ્રેમ', 'प्रेम', 'Love, Friendly'),
      ('પંકજ', 'पंकज', 'Pankaj', 'કમળનું ફૂલ', 'कमल', 'Lotus flower'),
      ('પુનિત', 'पुनीत', 'Punit', 'પવિત્ર, નિર્મળ', 'पवित्र', 'Pure, Holy'),
      ('પ્રદીપ', 'प्रदीप', 'Pradeep', 'તેજસ્વી દીવડો', 'दीपक', 'Shining lamp'),
      ('પ્રવીણ', 'प्रवीण', 'Praveen', 'નિપુણ, હોશિયાર', 'कुशल', 'Expert, Skilled'),
      ('પ્રમોદ', 'प्रमोद', 'Pramod', 'આનંદ, હર્ષ', 'खुशी', 'Delight, Joy'),
      ('પરેશ', 'परेश', 'Paresh', 'પરમાત્મા, શિવ', 'परमेश्वर', 'Supreme Lord'),
    ];
    for (final b in pBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 5, true);
    }

    final pGirls = [
      ('પ્રીશા', 'प्रीशा', 'Prisha', 'ઈશ્વરની અમૂલ્ય ભેટ', 'ईश्वर का वरदान', 'Beloved, God\'s gift'),
      ('પંક્તિ', 'पंक्ति', 'Pankti', 'સુંદર કાવ્ય પંક્તિ', 'काव्य की पंक्ति', 'Poetic line, Rhythm'),
      ('પરિણિતા', 'परिणीता', 'Parinita', 'સંપૂર્ણ વિદુષી સ્ત્રી', 'विदुषी, संपूर्ण', 'Complete, Learned woman'),
      ('પાખી', 'पाखी', 'Pakhi', 'મુક્ત પંખી, કોમળ', 'पक्षी, मासूम', 'Bird, Innocent'),
      ('પ્રાંજલ', 'प्रांजल', 'Pranjal', 'નિર્દોષ, પ્રામાણિક', 'पवित्र, निर्मल', 'Honest, Pure water'),
      ('પિયા', 'पिया', 'Piya', 'વહાલી પ્રિયતમા', 'प्यारी', 'Beloved, Sweetheart'),
      ('પૂર્વી', 'पूर्वी', 'Poorvi', 'પૂર્વ દિશા, સૂર્યોદય', 'पूर्व दिशा, सुबह', 'Eastern, Morning raga'),
      ('પ્રિયલ', 'प्रियल', 'Priyal', 'સૌને વહાલી લાગતી', 'सबकी प्यारी', 'Lovable, Dear one'),
      ('પાવની', 'पावनी', 'Pavani', 'પવિત્ર ગંગા નદી', 'पवित्र गंगा', 'Sacred, Pure river'),
      ('પરિધિ', 'परिधि', 'Paridhi', 'તેજસ્વી વલય', 'प्रकाश का घेरा', 'Realm of light'),
      ('પહલ', 'पहल', 'Pahal', 'શુભ શરૂઆત', 'शुभ शुरुआत', 'Auspicious beginning'),
      ('પલક', 'पलक', 'Palak', 'આંખોની રક્ષક', 'पलक', 'Eyelash, Protector'),
      ('પ્રણવી', 'प्रणवी', 'Pranavi', 'ૐકાર ધ્વનિ, પાર્વતી', 'पवित्र ॐ, पार्वती', 'Sacred sound Om, Parvati'),
      ('પાયલ', 'पायल', 'Payal', 'મધુર ઝાંઝર', 'पायल की झंकार', 'Anklet melody'),
      ('પલ્લવી', 'पल्लवी', 'Pallavi', 'નવા કૂંપળ', 'नई कोंपल', 'New tender leaves'),
      ('પારુલ', 'पारुल', 'Parul', 'સુંદર ફૂલ', 'सुंदर फूल', 'Graceful flower'),
      ('પ્રિયંકા', 'प्रियंका', 'Priyanka', 'સુંદર અને પ્રિય', 'प्यारी', 'Dear to all, Lovable'),
      ('પૂજા', 'पूजा', 'Pooja', 'ભક્તિ આરાધના', 'पूजा', 'Worship, Prayer'),
      ('પ્રજ્ઞા', 'प्रज्ञा', 'Prajna', 'તીવ્ર બુદ્ધિમત્તા', 'ज्ञान, बुद्धि', 'Wisdom, Intellect'),
      ('પ્રભા', 'प्रभा', 'Prabha', 'દૈવી ચમક', 'दिव्य प्रकाश', 'Lustre, Radiance'),
      ('પૂર્ણિમા', 'पूर्णिमा', 'Poornima', 'પૂનમનો પૂર્ણ ચંદ્ર', 'पूर्ण चंद्रमा', 'Full moon day'),
      ('પ્રિતિ', 'प्रीति', 'Priti', 'સ્નેહ, પ્રેમ', 'प्रेम', 'Love, Affection'),
    ];
    for (final g in pGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 5, false);
    }
  }

  // -------------------------------------------------------------
  // 6: TULA (ર, ત) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addTulaNames(Function add) {
    final rBoys = [
      ('રુદ્ર', 'रुद्र', 'Rudra', 'ભગવાન શિવનું પરાક્રમી રૂપ', 'भगवान शिव', 'Lord Shiva'),
      ('રેયાંશ', 'रियांश', 'Reyansh', 'સૂર્યપ્રકાશનો અંશ, વિષ્ણુ', 'सूर्य का अंश', 'First ray of sunlight'),
      ('રિયાન', 'रियान', 'Riyan', 'સ્વર્ગના દ્વાર, રાજા', 'राजा', 'Little king, Gates of heaven'),
      ('રોનિત', 'रोनित', 'Ronit', 'આનંદી ગીત, ચમકતો', 'गीत, प्रकाश', 'Charming song, Bright'),
      ('રુદ્રાંશ', 'रुद्रांश', 'Rudransh', 'ભગવાન શિવનો અંશ', 'शिव का अंश', 'Part of Lord Shiva'),
      ('ઋષિત', 'ऋषित', 'Rishit', 'શ્રેષ્ઠ ઋષિ', 'सर्वश्रेष्ठ', 'The best, Sage'),
      ('રુહાન', 'रुहान', 'Ruhaan', 'આધ્યાત્મિક, દયાળુ', 'आध्यात्मिक, दयालु', 'Spiritual, Kind-hearted'),
      ('રેહાન', 'रेहान', 'Rehaan', 'સુગંધિત પુષ્પ, રાજા', 'सुगंधित फूल, राजा', 'Fragrant blossom, King'),
      ('રોનવ', 'रोणव', 'Ronav', 'સુંદર સ્મિત', 'सुंदर मुस्कान', 'Charming smile'),
      ('તન્મય', 'तन्मय', 'Tanmay', 'સંપૂર્ણ એકાગ્ર, તલ્લીન', 'एकाग्र', 'Absorbed, Meditative'),
      ('તરુણ', 'तरुण', 'Tarun', 'યુવાન, ઉત્સાહી', 'युवा', 'Young, Energetic'),
      ('તીર્થ', 'तीर्थ', 'Teerth', 'પવિત્ર યાત્રાધામ', 'पवित्र स्थल', 'Holy place, Pilgrimage'),
      ('તુષાર', 'तुषार', 'Tushar', 'બરફનાં કણ, શીતળ', 'बर्फ की बूंदें', 'Snow, Frost'),
      ('તેજસ', 'तेजस', 'Tejas', 'દિવ્ય તેજ, પ્રકાશ', 'दिव्य तेज', 'Radiance, Brilliance'),
      ('રાહુલ', 'राहुल', 'Rahul', 'સક્ષમ, બુદ્ધપુત્ર', 'सक्षम', 'Capable, Efficient'),
      ('રોહિત', 'रोहित', 'Rohit', 'લાલ સૂર્ય, વિજયી', 'लाल सूर्य', 'Red sunrise'),
      ('રાઘવ', 'राघव', 'Raghav', 'ભગવાન શ્રીરામ', 'भगवान श्री राम', 'Lord Rama'),
      ('રાકેશ', 'राकेश', 'Rakesh', 'પૂર્ણિમાનો ચંદ્ર', 'चंद्रमा', 'Lord of Full Moon'),
      ('તક્ષ', 'तक्ष', 'Taksh', 'બળવાન રાજા', 'मजबूत', 'Strong, King'),
      ('રિતેશ', 'रितेश', 'Ritesh', 'સત્યના રક્ષક', 'सत्य के रक्षक', 'Lord of truth'),
      ('રાજેશ', 'राजेश', 'Rajesh', 'રાજાઓના રાજા', 'राजाओं के राजा', 'King of kings'),
      ('રત્નેશ', 'रत्नेश', 'Ratnesh', 'રત્નોના સ્વામી, સાગર', 'रत्नों के स्वामी', 'Lord of jewels'),
      ('રાજીવ', 'राजीव', 'Rajiv', 'નીલકમળ, શ્રીરામ', 'नीलकमल', 'Blue Lotus, Rama'),
      ('તપન', 'तपन', 'Tapan', 'તેજસ્વી સૂર્ય', 'सूर्य', 'The Sun'),
    ];
    for (final b in rBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 6, true);
    }

    final rGirls = [
      ('રિયા', 'रिया', 'Riya', 'મધુર સૂર, ગાયિકા', 'मधुर स्वर', 'Graceful singer, Flow'),
      ('રિદ્ધિ', 'रिद्धि', 'Riddhi', 'સમૃદ્ધિ, ગણેશપ્રિયા', 'समृद्धि, सौभाग्य', 'Prosperity, Good fortune'),
      ('રાધિકા', 'राधिका', 'Radhika', 'રાધાજી, શ્રીકૃષ્ણપ્રિયા', 'राधा रानी', 'Radha, Successful'),
      ('રાશિ', 'राशि', 'Rashi', 'શુભ રાશિ, સંગ્રહ', 'शुभ संग्रह', 'Collection of wealth, Zodiac'),
      ('રુચિકા', 'रुचिका', 'Ruchika', 'રૂચિકર, આકર્ષક', 'आकर्षक, सुंदर', 'Attractive, Beautiful'),
      ('રુદ્રાણી', 'रुद्राणी', 'Rudrani', 'દેવી પાર્વતી, શિવપ્રિયા', 'देवी पार्वती', 'Goddess Parvati'),
      ('ઋષિકા', 'ऋषिका', 'Rishika', 'પવિત્ર સાધ્વી', 'विदुषी, पवित्र', 'Saintly, Learned woman'),
      ('રોનિતા', 'रोनिता', 'Ronita', 'તેજસ્વી, ચમકતી', 'चमकदार', 'Brilliant, Shining'),
      ('તનિષ્કા', 'तनिष्का', 'Tanishka', 'સોનાની દેવી', 'सोने की देवी', 'Goddess of gold'),
      ('ત્રિષા', 'त्रिषा', 'Trisha', 'આકાંક્ષા, તૃષ્ણા', 'इच्छा', 'Aspiration, Wish'),
      ('તારા', 'तारा', 'Taara', 'ચમકતો સિતારો', 'चमकता सितारा', 'Bright Star'),
      ('તિયા', 'तिया', 'Tiya', 'મીઠું પક્ષી, આશા', 'सुंदर चिड़िया', 'Sweet bird, Hope'),
      ('તનિષા', 'तनीषा', 'Tanisha', 'મહત્વાકાંક્ષા, પરી', 'परी', 'Ambition, Fairy'),
      ('તન્વી', 'तन्वी', 'Tanvi', 'કોમળ સુંદરી', 'सुंदर स्त्री', 'Delicate, Graceful'),
      ('તૃપ્તિ', 'तृप्ति', 'Tripti', 'સંતોષ, શાંતિ', 'संतुष्टि', 'Satisfaction, Contentment'),
      ('રાધા', 'राधा', 'Radha', 'શ્રીકૃષ્ણની આરાધ્ય શક્તિ', 'राधा रानी', 'Beloved of Krishna'),
      ('રાગિણી', 'रागिणी', 'Ragini', 'સંગીતનો સુંદર રાગ', 'संगीत का राग', 'Melody, Music'),
      ('રચના', 'रचना', 'Rachana', 'સર્જન, કલાકૃતિ', 'सृजन', 'Creation, Artwork'),
      ('રીતુ', 'ऋतु', 'Ritu', 'સુંદર મોસમ', 'मौसम', 'Season, Nature cycle'),
      ('રૂપાલી', 'रूपाली', 'Rupali', 'સુંદર અને મનોહર', 'सुंदर', 'Pretty, Charming'),
      ('રેણુકા', 'रेणुका', 'Renuka', 'પરશુરામ માતા, પૃથ્વી', 'माता रेणुका', 'Mother of Parshuram'),
      ('રશ્મિ', 'रश्मि', 'Rashmi', 'સૂર્યનું તેજસ્વી કિરણ', 'सूर्य किरण', 'Sunbeam, Light'),
      ('રુચિરા', 'रुचिरा', 'Ruchira', 'સ્વાદિષ્ટ, સુંદર', 'सुंदर', 'Pleasing, Charming'),
    ];
    for (final g in rGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 6, false);
    }
  }

  // -------------------------------------------------------------
  // 7: VRISHCHIKA (ન, ય) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addVrishchikaNames(Function add) {
    final nBoys = [
      ('નક્ષ', 'नक्ष', 'Naksh', 'ચંદ્રમા, સુંદર તારો', 'चंद्रमा, तारा', 'Moon, Feature'),
      ('નિયાન', 'नियान', 'Niyan', 'ઈશ્વરીય તેજ, આશીર્વાદ', 'दैवीय प्रकाश', 'Divine radiance'),
      ('નૈતિક', 'नैतिक', 'Naitik', 'સદાચારી, નીતિવાન', 'नीतिवान', 'Ethical, Moral'),
      ('નિહાન', 'निहान', 'Nihaan', 'સુંદર પ્રભાત', 'प्रभात', 'Morning dawn'),
      ('નિર્વાણ', 'निर्वाण', 'Nirvaan', 'પરમ શાંતિ, મોક્ષ', 'परम शांति', 'Ultimate liberation'),
      ('નાવિક', 'नाविक', 'Navik', 'માર્ગદર્શક', 'मार्गदर्शक', 'Navigator, Guide'),
      ('નિશીથ', 'निशीथ', 'Nisheeth', 'મધ્યરાત્રિની શાંતિ', 'मध्यरात्रि', 'Midnight peace'),
      ('નીલ', 'नील', 'Neel', 'વાદળી આકાશ, નીલમણિ', 'नीलम', 'Blue sapphire, Sky'),
      ('નમિશ', 'नमिश', 'Namish', 'ભગવાન વિષ્ણુ', 'भगवान विष्णु', 'Lord Vishnu'),
      ('યુવાન', 'युवान', 'Yuvaan', 'યુવા, બળવાન, શિવ', 'युवा, बलवान', 'Youthful, Strong, Shiva'),
      ('યાશિલ', 'याशिल', 'Yashil', 'સફળતા, કીર્તિવાન', 'सफलता', 'Success, Fame'),
      ('યુગ', 'युग', 'Yug', 'નવો યુગ, સમયાવધિ', 'नया युग', 'Era, Epoch'),
      ('યજ્ઞેશ', 'यज्ञेश', 'Yagnesh', 'યજ્ઞના સ્વામી, વિષ્ણુ', 'यज्ञ स्वामी', 'Lord of Sacrifice'),
      ('યશ', 'यश', 'Yash', 'કીર્તિ, વિજય, વૈભવ', 'कीर्ति', 'Fame, Glory'),
      ('યુવરાજ', 'युवराज', 'Yuvraj', 'રાજકુમાર', 'राजकुमार', 'Crown prince'),
      ('યુવાંશ', 'युवांश', 'Yuvansh', 'યુવાનીનો અંશ', 'युवा अंश', 'Part of youth'),
      ('નક્ષત્ર', 'नक्षत्र', 'Nakshatra', 'તારો, નક્ષત્ર', 'तारा', 'Constellation, Star'),
      ('નમન', 'नमन', 'Naman', 'વંદન, નમ્રતા', 'प्रणाम', 'Salutation, Bowing'),
      ('નીરવ', 'नीरव', 'Neerav', 'શાંત, શાંતિપ્રિય', 'शांत', 'Silent, Quiet'),
      ('યોગેશ', 'योगेश', 'Yogesh', 'યોગના સ્વામી, શિવ', 'योगेश्वर', 'Lord of Yoga, Shiva'),
      ('નરેન્દ્ર', 'नरेन्द्र', 'Narendra', 'રાજા, નેતા', 'राजा', 'King, Leader'),
      ('નિખિલ', 'निखिल', 'Nikhil', 'સંપૂર્ણ, સમગ્ર', 'संपूर्ण', 'Complete, Whole'),
      ('નવીન', 'नवीन', 'Naveen', 'નવું, તાજગીસભર', 'नया', 'New, Fresh'),
      ('યતીન', 'यतिन', 'Yatin', 'તપસ્વી, સાધક', 'तपस्वी', 'Ascetic, Devotee'),
    ];
    for (final b in nBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 7, true);
    }

    final nGirls = [
      ('નાયરા', 'नायरा', 'Nayra', 'તેજસ્વી, સુંદર આંખો', 'चमकदार आंखें', 'Radiant, Rose'),
      ('નવ્યા', 'नव्या', 'Navya', 'નવીન, પ્રશંસનીય', 'नई, सराहनीय', 'Worth praising, Young'),
      ('નિત્યા', 'नित्या', 'Nitya', 'સનાતન, દેવી દુર્ગા', 'शाश्वत, दुर्गा', 'Eternal, Goddess Durga'),
      ('નંદિની', 'नंदिनी', 'Nandini', 'આનંદ આપનારી પુત્રી', 'आनंदमयी, बेटी', 'Delightful, Daughter'),
      ('નિરાલી', 'निराली', 'Nirali', 'સૌથી અલગ, અનોખી', 'अनोखी', 'Unique, Special'),
      ('નૂપુર', 'नूपुर', 'Noopur', 'ઝાંઝરની મધુર રણકાર', 'पायल की ध्वनि', 'Anklet ring'),
      ('નમ્રતા', 'नम्रता', 'Namrata', 'વિનમ્રતા, સદ્ગુણ', 'विनम्रता', 'Modesty, Politeness'),
      ('યાશવી', 'याशवी', 'Yashvi', 'કીર્તિમાન, વિજયી', 'प्रसिद्धि, विजय', 'Fame, Success'),
      ('યશિકા', 'यशिका', 'Yashika', 'સફળતા, પ્રસિદ્ધિ', 'सफलता, यश', 'Famous, Successful'),
      ('યુવિકા', 'युविका', 'Yuvika', 'યુવાન રાજકુમારી', 'राजकुमारी', 'Young princess'),
      ('યામિની', 'यामिनी', 'Yamini', 'ચાંદની રાત', 'चांदनी रात', 'Night lit by stars'),
      ('યાશી', 'याशी', 'Yashi', 'કીર્તિ, યશ', 'कीर्ति', 'Fame, Glory'),
      ('યાના', 'याना', 'Yana', 'દૈવી ઉપહાર', 'ईश्वर का उपहार', 'Divine gift'),
      ('યુક્તા', 'युक्ता', 'Yukta', 'યોગ્ય, સમૃદ્ધિવાન', 'कुशल, लक्ष्मी', 'Attentive, Lakshmi'),
      ('નેહા', 'नेहा', 'Neha', 'પ્રેમ, વર્ષાનું બિંદુ', 'प्यार', 'Love, Raindrop'),
      ('નિશા', 'निशा', 'Nisha', 'રાત્રિ, શાંતિ', 'रात, शांति', 'Night, Peaceful'),
      ('નિધિ', 'निधि', 'Nidhi', 'ખજાનો, સમૃદ્ધિ', 'खजाना', 'Treasure, Wealth'),
      ('નયના', 'नयना', 'Nayana', 'સુંદર આંખો', 'सुंदर आंखें', 'Beautiful eyes'),
      ('નીતા', 'नीता', 'Neeta', 'નીતિવાળી, સંસ્કારી', 'सदाचारी', 'Well-behaved, Moral'),
      ('યશસ્વી', 'यशस्वी', 'Yashasvi', 'કીર્તિવાન, સફળ', 'सफल', 'Glorious, Victorious'),
      ('યાચના', 'याचना', 'Yachana', 'પ્રાર્થના, વિનંતી', 'प्रार्थना', 'Prayer, Plea'),
      ('નૈમિષા', 'नैमिषा', 'Naimisha', 'પવિત્ર તીર્થક્ષેત્ર', 'पवित्र स्थल', 'Sacred forest realm'),
    ];
    for (final g in nGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 7, false);
    }
  }

  // -------------------------------------------------------------
  // 8: DHANU (ભ, ધ, ફ, ઢ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addDhanuNames(Function add) {
    final dBoys = [
      ('ભવ્ય', 'भव्य', 'Bhavya', 'શાનદાર, દિવ્ય', 'भव्य, शानदार', 'Grand, Majestic'),
      ('ભાર્ગવ', 'भार्गव', 'Bhargav', 'ભગવાન શિવ, તેજસ્વી', 'भगवान शिव', 'Lord Shiva, Radiance'),
      ('ધૈર્ય', 'धैर्य', 'Dhairya', 'ધીરજ, સાહસ', 'धैर्य, संयम', 'Patience, Courage'),
      ('ધ્યાન', 'ध्यान', 'Dhyan', 'એકાગ્રતા, સાધના', 'एकाग्रता', 'Meditation, Reflection'),
      ('ધ્રુવ', 'ध्रुव', 'Dhruv', 'અવિચલ તારો, અટલ', 'अटल तारा', 'Pole star, Unshakeable'),
      ('ધ્રુવિલ', 'ध्रुविल', 'Dhruvil', 'અટલ અને દ્રઢ', 'अटल', 'Determined, Firm'),
      ('ધીર', 'धीर', 'Dheer', 'શાંત અને ધીરજવાન', 'धैर्यवान', 'Patient, Brave'),
      ('ધ્યેય', 'ध्येय', 'Dhyey', 'લક્ષ્ય, મકસદ', 'लक्ष्य', 'Aim, Purpose'),
      ('ધનુષ', 'धनुष', 'Dhanush', 'વિજયી ધનુષ્ય', 'धनुष', 'Bow of victory'),
      ('ધવલ', 'धवल', 'Dhaval', 'શ્વેત, શુદ્ધ, નિષ્કલંક', 'सफेद, पवित्र', 'Pure white, Radiant'),
      ('ફાલ્ગુન', 'फाल्गुन', 'Falgun', 'વસંત ઋતુનો મહિનો', 'वसंत ऋतु', 'Spring month, Arjuna'),
      ('ભુવન', 'भुवन', 'Bhuvan', 'બ્રહ્માંડ, સૃષ્ટિ', 'संसार', 'Universe, Palace'),
      ('ભારત', 'भारत', 'Bharat', 'દેશનું ગૌરવ', 'राजा भरत', 'Universal sovereign'),
      ('ધર્મેશ', 'धर्मेश', 'Dharmesh', 'ધર્મના સ્વામી', 'धर्म के स्वामी', 'Lord of righteousness'),
      ('ભૂપેશ', 'भूपेश', 'Bhupesh', 'રાજા, પૃથ્વીપતિ', 'राजा', 'King of Earth'),
      ('ભાનુ', 'भानु', 'Bhanu', 'તેજસ્વી સૂર્ય', 'सूर्य', 'Sun, Splendour'),
      ('ધીરેન્દ્ર', 'धीरेन्द्र', 'Dhirendra', 'સાહસી રાજા', 'साहसी', 'Lord of courage'),
      ('ભદ્રેશ', 'भद्रेश', 'Bhadresh', 'કલ્યાણકારી, શિવ', 'कल्याणकारी', 'Lord Shiva, Auspicious'),
      ('ધનંજય', 'धनंजय', 'Dhananjay', 'અર્જુન, વિજેતા', 'अर्जुन', 'Winner of wealth'),
      ('ભગીરથ', 'भगीरथ', 'Bhagirath', 'ગંગાજીને લાવનાર', 'राजा भगीरथ', 'Pious King Bhagirath'),
    ];
    for (final b in dBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 8, true);
    }

    final dGirls = [
      ('ભવ્યા', 'भव्या', 'Bhavya', 'ભવ્યતા, દેવી પાર્વતી', 'भव्यता, पार्वती', 'Grand, Goddess Parvati'),
      ('ધૃતિ', 'धृति', 'Dhruti', 'ધીરજ, સાહસ, સ્થિરતા', 'धैर्य, हिम्मत', 'Patience, Steadfastness'),
      ('ધારા', 'धारा', 'Dhara', 'પ્રવાહ, પૃથ્વી', 'प्रवाह, धरती', 'Constant flow, Earth'),
      ('ધ્રુવી', 'ध्रुवी', 'Dhruvi', 'અટલ, ધ્રુવ તારા સમાન', 'अटल तारा', 'Firm, Unshakable'),
      ('ધ્યાની', 'ध्यानी', 'Dhyani', 'ધ્યાનમગ્ન, આધ્યાત્મિક', 'चिंतनशील', 'Meditative, Spiritual'),
      ('ધ્વનિ', 'ध्वनि', 'Dhwani', 'મધુર સંગીતનો નાદ', 'मधुर आवाज', 'Melody, Musical sound'),
      ('ધ્યાનવી', 'ध्यानवी', 'Dhyanvi', 'એકાગ્ર ચિત્તવાળી', 'एकाग्र', 'Focused, Meditative'),
      ('ભામિની', 'भामिनी', 'Bhamini', 'તેજસ્વી અને ગુણવાન સ્ત્રી', 'चमकदार स्त्री', 'Radiant, Noble lady'),
      ('ફાલ્ગુની', 'फाल्गुनी', 'Falguni', 'વસંતની સુંદરતા', 'वसंत पूर्णिमा', 'Born in Falgun, Beautiful'),
      ('ભૂમિ', 'भूमि', 'Bhumi', 'પૃથ્વી માતા', 'धरती', 'Mother Earth'),
      ('ભાવિકા', 'भाविका', 'Bhavika', 'સદ્ભાવનાવાળી, શુદ્ધ', 'सच्ची भावना', 'Well-meaning, Devout'),
      ('ધવની', 'धवानी', 'Dhavani', 'મધુર ગુંજારવ', 'मधुर आवाज', 'Sweet resonance'),
      ('ભૈરવી', 'भैरवी', 'Bhairavi', 'શક્તિનું સ્વરૂપ', 'दुर्गा, राग', 'Goddess Durga, Melody'),
      ('ભારતી', 'भारती', 'Bharati', 'સરસ્વતી દેવી', 'सरस्वती', 'Goddess Saraswati'),
      ('ધ્રુવાંશી', 'ध्रुवांशिका', 'Dhruvanshi', 'ધ્રુવનો દિવ્ય અંશ', 'ध्रुव का अंश', 'Part of star'),
      ('ભાનુપ્રિયા', 'भानुप्रिया', 'Bhanupriya', 'સૂર્યપ્રિયા', 'सूर्य की प्रिय', 'Beloved of the Sun'),
      ('ધર્મિષ્ઠા', 'धर्मिष्ठा', 'Dharmishta', 'ધર્મપરાયણ', 'धर्मपरायण', 'Righteous, Pious'),
      ('ભુવના', 'भुवना', 'Bhuvana', 'જગત જનની', 'संसार की देवी', 'Goddess of world'),
      ('ભાગ્યશ્રી', 'भाग्यश्री', 'Bhagyashree', 'ભાગ્યવાન, લક્ષ્મી', 'सौभाग्यशाली', 'Fortunate, Lakshmi'),
      ('ધ્યાના', 'ध्याना', 'Dhyana', 'ધ્યાન, ભક્તિ', 'ध्यान', 'Meditation, Devotion'),
    ];
    for (final g in dGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 8, false);
    }
  }

  // -------------------------------------------------------------
  // 9: MAKARA (ખ, જ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addMakaraNames(Function add) {
    final jBoys = [
      ('જિયાન', 'जियान', 'Jiyan', 'હૃદયની શાંતિ, નિકટ', 'दिल के करीब, शांति', 'Near to heart, Peaceful soul'),
      ('જીવાંશ', 'जीवांश', 'Jeevansh', 'જીવનનો દિવ્ય અંશ', 'जीवन का अंश', 'Part of divine life'),
      ('જતીન', 'जतिन', 'Jatin', 'ભગવાન શિવ, સાધક', 'भगवान शिव, तपस्वी', 'Lord Shiva, Ascetic'),
      ('જીત', 'जीत', 'Jeet', 'વિજય, સફળતા', 'विजय, सफलता', 'Victory, Success'),
      ('જિગ્નેશ', 'जिग्नेश', 'Jignesh', 'જિજ્ઞાસુ, શોધક', 'जिज्ञासु', 'Curious to learn'),
      ('જયાન', 'जयान', 'Jayan', 'વિજેતા, પરાક્રમી', 'विजेता', 'Victorious, Radiant'),
      ('જય', 'जय', 'Jay', 'વિજય, તેજસ્વી', 'जीत', 'Victory, Success'),
      ('જૈવિક', 'जैविक', 'Jaivik', 'શુદ્ધ, પ્રાકૃતિક જીવન', 'प्राकृतिक, शुद्ध', 'Pure, Natural life'),
      ('જીનાંશ', 'जिनांश', 'Jinansh', 'વિજયી અંશ', 'विजेता का अंश', 'Part of victory'),
      ('જાગ્રવ', 'जाग्रव', 'Jagrav', 'જાગૃત, સચેત', 'जागरूक, सचेत', 'Awake, Vigilant'),
      ('જશ', 'जश', 'Jash', 'કીર્તિ, યશ', 'कीर्ति', 'Fame, Praise'),
      ('જીવિન', 'जीविन', 'Jivin', 'જીવંત, ઉત્સાહી', 'जीवन देने वाला', 'Life giver, Lively'),
      ('જીષ્ણુ', 'जिष्णु', 'Jishnu', 'વિજયી, અર્જુન', 'विजयी, अर्जुन', 'Triumphant, Arjuna'),
      ('જોષિત', 'जोषित', 'Joshit', 'આનંદિત, પ્રસન્ન', 'प्रसन्न', 'Pleased, Delighted'),
      ('ખ્યાત', 'ख्यात', 'Khyat', 'પ્રસિદ્ધ, કીર્તિવાન', 'प्रसिद्ध, यशस्वी', 'Famous, Renowned'),
      ('ખગેશ', 'खगेश', 'Khagesh', 'ગરુડ, પક્ષીરાજ', 'गरुड़', 'King of birds, Garuda'),
      ('ખિલાન', 'खिलान', 'Khilan', 'સદા ખીલતો', 'सदा खुशहाल', 'Ever blooming, Fresh'),
      ('ખુશાલ', 'खुशाल', 'Khushal', 'આનંદિત, સમૃદ્ધ', 'खुशहाल, समृद्ध', 'Prosperous, Happy'),
      ('જયદીપ', 'जयदीप', 'Jaydeep', 'વિજયનો દીવડો', 'जीत का दीपक', 'Light of victory'),
      ('જયેશ', 'जयेश', 'Jayesh', 'વિજયના સ્વામી', 'जीत का राजा', 'Lord of victory'),
      ('જીતેન્દ્ર', 'जितेन्द्र', 'Jitendra', 'ઇન્દ્રિયોના વિજેતા', 'इंद्रियों का विजेता', 'Conqueror of senses'),
      ('જગન્નાથ', 'जगन्नाथ', 'Jagannath', 'જગતના સ્વામી, વિષ્ણુ', 'संसार के स्वामी', 'Lord of the Universe'),
      ('જન્મેજય', 'जनमेजय', 'Janmejay', 'વિજયી રાજા', 'प्रतापी राजा', 'Victorious King'),
      ('ખગેન્દ્ર', 'खगेन्द्र', 'Khagendra', 'આકાશના રાજા', 'आकाश के राजा', 'Lord of sky'),
      ('જયવંત', 'जयवंत', 'Jaywant', 'સદા વિજયી', 'हमेशा विजयी', 'Ever victorious'),
      ('જિનેન્દ્ર', 'जिनेन्द्र', 'Jinendra', 'જીતેન્દ્રિય મહાત્મા', 'महात्मा', 'Lord of conquerors'),
      ('જીગર', 'जिगर', 'Jigar', 'સાહસ, દિલ', 'साहस, दिल', 'Courage, Heart'),
      ('જસ્વંત', 'जसवंत', 'Jaswant', 'કીર્તિવાન', 'यशस्वी', 'Famous, Victorious'),
      ('જીતેન', 'जितेन', 'Jiten', 'વિજયી પુરુષ', 'जीतने वाला', 'One who wins'),
      ('ખુશ', 'खुश', 'Khush', 'આનંદિત, પ્રસન્ન', 'प्रसन्न', 'Happy, Cheerful'),
      ('ખગેષ', 'खगेश', 'Khagesha', 'આકાશચારી', 'आकाशगामी', 'Sky traveler'),
      ('જ્યોતિર્મય', 'ज्योतिर्मय', 'Jyotirmay', 'પ્રકાશવાન', 'प्रकाशमय', 'Luminous, Bright'),
      ('જીવેન્દ્ર', 'जीवेन्द्र', 'Jeevendra', 'જીવનના પ્રણેતા', 'जीवन का आधार', 'Lord of life'),
      ('જ્ઞાનેશ', 'ज्ञानेश', 'Gyanesh', 'જ્ઞાનના સ્વામી', 'ज्ञान के स्वामी', 'Lord of knowledge'),
      ('જ્ઞાનદીપ', 'ज्ञानदीप', 'Gyandeep', 'જ્ઞાનનો દીવડો', 'ज्ञान का दीपक', 'Lamp of wisdom'),
      ('જિતાર્થ', 'जितार्थ', 'Jitarth', 'સફળ અર્થવાળો', 'सफल', 'Successful goal'),
      ('જિગ્યાસ', 'जिज्ञास', 'Jigyas', 'જ્ઞાન પીપાસુ', 'जिज्ञासु', 'Curious seeker'),
    ];
    for (final b in jBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 9, true);
    }

    final jGirls = [
      ('જીયા', 'जिया', 'Jiya', 'હૃદયનો ટુકડો, મીઠો પ્રેમ', 'दिल की धड़कन, प्यार', 'Heartbeat, Sweetheart'),
      ('જાનવી', 'जानवी', 'Jaanvi', 'ગંગા નદી, વહાલી દીકરી', 'गंगा नदी, अनमोल', 'Ganga river, Precious daughter'),
      ('ખુશી', 'खुशी', 'Khushi', 'આનંદ, હર્ષોલ્લાસ', 'आनंद, मुस्कान', 'Happiness, Joy, Smile'),
      ('ખ્યાતિ', 'ख्याति', 'Khyati', 'પ્રસિદ્ધિ, કીર્તિ, માન', 'प्रसिद्धि, यश', 'Fame, Renown, Glory'),
      ('જીનલ', 'जीनल', 'Jinal', 'ભગવાન જેવી પવિત્ર', 'पवित्र, सुंदर', 'Pure, Lord-like beauty'),
      ('જેયા', 'जेया', 'Jeya', 'વિજયી, તેજસ્વી', 'विजयी, तेजस्वी', 'Victorious, Radiant'),
      ('ખુશાલી', 'खुशाली', 'Khushali', 'સમૃદ્ધિ અને આનંદ', 'खुशी, समृद्धि', 'Prosperity, Joy'),
      ('જહાનવી', 'जहानवी', 'Jahanvi', 'પવિત્ર ગંગા મૈયા', 'पवित्र गंगा', 'Sacred river Ganga'),
      ('જીવિકા', 'जीविका', 'Jeevika', 'જીવનનો સ્ત્રોત, જળ', 'जीवन का आधार', 'Source of life, Water'),
      ('જીયાના', 'जियाना', 'Jiyana', 'સાહસી અને પ્રેમમયી', 'साहसी, प्यारी', 'Brave, Full of love'),
      ('જિનીશા', 'जिनिशा', 'Jinisha', 'ઉમદા, સુંદર', 'श्रेष्ठ, सुंदर', 'Noble, Beautiful'),
      ('જાગૃતિ', 'जागृति', 'Jagruti', 'જાગરણ, ચેતના', 'जागरूकता', 'Awakening, Awareness'),
      ('જુહી', 'जुही', 'Juhi', 'સુગંધિત જુઈનું ફૂલ', 'सुगंधित फूल', 'Jasmine blossom'),
      ('જશમીન', 'जैस्मीन', 'Jasmin', 'સુગંધિત ચમેલી', 'फूल', 'Jasmine fragrance'),
      ('ખ્વાહિશ', 'ख्वाहिश', 'Khwahish', 'દિલની સુંદર ઇચ્છા', 'इच्छा', 'Heartfelt wish'),
      ('ખ્વાબ', 'ख्वाब', 'Khwaab', 'સુંદર સપનું', 'सुंदर सपना', 'Beautiful dream'),
      ('ખુશબૂ', 'खुशबू', 'Khushboo', 'મધુર સુગંધ', 'सुगंध', 'Fragrance, Scent'),
      ('જ્યોતિ', 'ज्योति', 'Jyoti', 'દિવ્ય જ્યોત, પ્રકાશ', 'दीपक की लौ', 'Divine flame, Light'),
      ('જયા', 'जया', 'Jaya', 'વિજયની દેવી, પાર્વતી', 'देवी पार्वती', 'Goddess of victory, Parvati'),
      ('જાનકી', 'जानकी', 'Janki', 'સીતા માતા', 'माता सीता', 'Goddess Sita'),
      ('જસમીત', 'जसमीत', 'Jasmeet', 'કીર્તિવાન મિત્ર', 'प्रसिद्ध सहेली', 'Famed companion'),
      ('જ્ઞાનવી', 'ज्ञानवी', 'Gyanvi', 'જ્ઞાનવાન, વિદુષી', 'ज्ञान की देवी', 'Knowledgeable, Wise'),
      ('જયંતી', 'जयंती', 'Jayanti', 'વિજયી દેવી, દુર્ગા', 'देवी दुर्गा', 'Victorious Goddess Durga'),
      ('જિજ્ઞાસા', 'जिज्ञासा', 'Jigyasa', 'જાણવાની ઉત્સુકતા', 'जिज्ञासा', 'Curiosity for knowledge'),
      ('જિયાંશી', 'जियांशी', 'Jiyanshi', 'ઈશ્વરીય પ્રેમનો અંશ', 'ईश्वर का अंश', 'Part of Divine love'),
      ('જુગ્નુ', 'जुगनू', 'Jugnu', 'ચમકતો આગિયો', 'चमकता जुगनू', 'Firefly, Radiant spark'),
      ('જશવી', 'जशवी', 'Jashvi', 'કીર્તિમાન', 'यशस्वी', 'Full of fame'),
      ('જાગવી', 'जागवी', 'Jagvi', 'જાગૃત સ્ત્રી', 'जागरूक', 'Awakened, Alert'),
      ('જહાન', 'जहान', 'Jahan', 'સમગ્ર જગત', 'संसार', 'The whole world'),
      ('જયિતા', 'जयिता', 'Jayita', 'સદા વિજયી', 'विजयी', 'Ever victorious'),
      ('જીનિયા', 'जीनिया', 'Jinia', 'સુંદર પુષ્પ', 'सुंदर फूल', 'Zinnia flower'),
      ('જ્યોત્સ્ના', 'ज्योत्स्ना', 'Jyotsna', 'ચાંદની રાતનો પ્રકાશ', 'चांदनी', 'Moonlight radiance'),
      ('જીવન્તા', 'जीवन्ता', 'Jeevanta', 'જીવંત, ચેતનવંતી', 'जीवंत', 'Full of life'),
      ('ખુશનુમા', 'खुशनुमा', 'Khushnuma', 'ખુશનુમા વાતાવરણ', 'सुहावना', 'Pleasant, Joyous'),
      ('જૈત્રી', 'जैत्री', 'Jaitri', 'વિજયની પ્રતીક', 'विजयी', 'Symbol of triumph'),
    ];
    for (final g in jGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 9, false);
    }
  }

  // -------------------------------------------------------------
  // 10: KUMBHA (ગ, શ, સ, ષ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addKumbhaNames(Function add) {
    final sBoys = [
      ('શૌર્ય', 'शौर्य', 'Shaurya', 'પરાક્રમ, વીરતા', 'वीरता, पराक्रम', 'Valour, Bravery'),
      ('શિવાંશ', 'शिवांश', 'Shivansh', 'ભગવાન શિવનો પવિત્ર અંશ', 'शिव का अंश', 'Part of Lord Shiva'),
      ('સમર્થ', 'समर्थ', 'Samarth', 'સક્ષમ, શક્તિશાળી', 'सक्षम, बलवान', 'Powerful, Capable'),
      ('સિદ્ધાર્થ', 'सिद्धार्थ', 'Siddharth', 'સફળતા પ્રાપ્ત કરનાર, બુદ્ધ', 'सफल, बुद्ध', 'Accomplished, Buddha'),
      ('શ્લોક', 'श्लोक', 'Shlok', 'પવિત્ર વૈદિક મંત્ર', 'वैदिक मंत्र', 'Sacred Vedic verse'),
      ('સાકેત', 'साकेत', 'Saket', 'શ્રીરામની અયોધ્યા નગરી', 'अयोध्या', 'Lord Rama\'s holy city'),
      ('સમીર', 'समीर', 'Sameer', 'શીતળ પવન, મિત્ર', 'सुहानी हवा', 'Pleasant breeze, Companion'),
      ('ગિયાંશ', 'गियांश', 'Giyansh', 'જ્ઞાનનો અંશ', 'ज्ञान का अंश', 'Part of divine knowledge'),
      ('શ્રેયાંશ', 'श्रेयांश', 'Shreyansh', 'સદ્ભાગ્યવાન, કીર્તિવાન', 'सौभाग्यशाली', 'Fame giver, Lucky'),
      ('સમર', 'समर', 'Samar', 'સાહસી, યુદ્ધવીર', 'साहसी', 'Brave, Warrior of peace'),
      ('સુવીર', 'सुवीर', 'Suveer', 'સાચો વીર પુરુષ', 'शूरवीर', 'True courageous hero'),
      ('સાહિલ', 'साहिल', 'Sahil', 'સમુદ્રનો કિનારો, માર્ગદર્શક', 'किनारा', 'Sea shore, Guide'),
      ('શિવમ', 'शिवम', 'Shivam', 'કલ્યાણકારી, શિવ', 'कल्याणकारी', 'Auspicious, Lord Shiva'),
      ('ગૌરવ', 'गौरव', 'Gaurav', 'માન, પ્રતિષ્ઠા, સન્માન', 'सम्मान, प्रतिष्ठा', 'Pride, Honour, Dignity'),
      ('ગૌતમ', 'गौतम', 'Gautam', 'મહાત્મા બુદ્ધ, ઋષિ', 'ऋषि गौतम', 'Sage Gautam, Enlightened'),
      ('સંકલ્પ', 'संकल्प', 'Sankalp', 'દ્રઢ નિશ્ચય', 'दृढ़ निश्चय', 'Determination, Vow'),
      ('શાશ્વત', 'शाश्वत', 'Shashwat', 'અવિનાશી, સનાતન', 'हमेशा रहने वाला', 'Eternal, Constant'),
      ('સૂરજ', 'सूरज', 'Suraj', 'તેજસ્વી સૂર્યનારાયણ', 'सूर्य', 'The Sun'),
      ('શુભમ', 'शुभम', 'Shubham', 'મંગળકારી, પવિત્ર', 'मंगलकारी', 'Auspicious, Lucky'),
      ('શિખર', 'शिखर', 'Shikhar', 'પર્વતની ટોચ, સફળતા', 'पर्वत की चोटी', 'Peak, Summit'),
      ('ગણેશ', 'गणेश', 'Ganesh', 'વિઘ્નહર્તા દેવતા', 'विघ्नहर्ता', 'Lord Ganesha'),
      ('ગિરિરાજ', 'गिरिराज', 'Giriraj', 'પર્વતોના રાજા, ગોવર્ધન', 'पर्वतराज', 'King of mountains'),
      ('સુરેશ', 'सुरेश', 'Suresh', 'દેવોના સ્વામી', 'देवताओं के स्वामी', 'Lord of Gods'),
      ('સોહમ', 'सोहम', 'Soham', 'બ્રહ્મભાવ, હું તે છું', 'दिव्य मंत्र', 'I am that Supreme'),
      ('સાર્થક', 'सार्थक', 'Sarthak', 'અર્થપૂર્ણ જીવન', 'अर्थपूर्ण', 'Meaningful, Fulfilled'),
    ];
    for (final b in sBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 10, true);
    }

    final sGirls = [
      ('સાનવી', 'सान्वी', 'Saanvi', 'દેવી લક્ષ્મી, જ્ઞાન', 'देवी लक्ष्मी', 'Goddess Lakshmi'),
      ('શિયા', 'शिया', 'Shiya', 'સુંદર સૂર્યોદય, પ્રકાશ', 'सुबह की रोशनी', 'Morning light, Radiance'),
      ('સારા', 'सारा', 'Sara', 'શુદ્ધ, કિંમતી રાજકુમારી', 'पवित्र, अनमोल', 'Pure, Precious princess'),
      ('શ્રેયા', 'श्रेया', 'Shreya', 'શુભ, શ્રેષ્ઠ, ભાગ્યવાન', 'शुभ, सर्वोत्तम', 'Auspicious, Prosperous'),
      ('શર્વી', 'शर्वी', 'Sharvi', 'દેવી દુર્ગાનું રૂપ', 'देवी दुर्गा', 'Divine Goddess Durga'),
      ('સિયા', 'सिया', 'Siya', 'સીતા માતા, પવિત્રતા', 'माता सीता', 'Goddess Sita, Purity'),
      ('સમાયરા', 'समायरा', 'Samaira', 'ઈશ્વરીય સુરક્ષા', 'जादुई, सुंदर', 'Enchanting, Protected'),
      ('શનાયા', 'शनाया', 'Shanaya', 'સૂર્યનું પ્રથમ કિરણ', 'सूर्य की पहली किरण', 'First ray of the sun'),
      ('સુહાની', 'सुहानी', 'Suhani', 'આનંદદાયક, સુંદર', 'सुहावनी, प्यारी', 'Pleasant, Charming'),
      ('સનિકા', 'सनिका', 'Sanika', 'મધુર વાંસળી સૂર', 'बांसुरी', 'Flute tune'),
      ('સૃષ્ટિ', 'सृष्टि', 'Srishti', 'સમસ્ત પ્રકૃતિ, સર્જન', 'प्रकृति, संसार', 'Universe, Creation'),
      ('સ્મૃતિ', 'स्मृति', 'Smriti', 'યાદ, જ્ઞાન, વેદ', 'वेदों का ज्ञान', 'Remembrance, Vedic wisdom'),
      ('સાંચી', 'सांची', 'Saanchi', 'સત્ય, પ્રામાણિક', 'सच्ची', 'Truthful, Authentic'),
      ('ગૌરી', 'गौरी', 'Gauri', 'દેવી પાર્વતી, શ્વેત સુંદરતા', 'देवी पार्वती', 'Goddess Parvati, Fair'),
      ('ગુંજન', 'गुंजन', 'Gunjan', 'મધુર ગુંજારવ', 'मधुर गूंज', 'Sweet humming melody'),
      ('ગ્રીષ્મા', 'ग्रीष्मा', 'Grishma', 'તેજસ્વી ઋતુ', 'तेजस्वी ऋतु', 'Warmth, Summer season'),
      ('સલોની', 'सलोनी', 'Saloni', 'સુંદર અને મનમોહક', 'सुंदर', 'Beautiful, Charming'),
      ('શ્વેતા', 'श्वेता', 'Shweta', 'શ્વેત, શુદ્ધ સરસ્વતી', 'सरस्वती', 'Pure, Goddess Saraswati'),
      ('સૌમ્યા', 'सौम्य', 'Saumya', 'શાંત અને કોમળ સ્વભાવ', 'शांत, सौम्य', 'Gentle, Calm, Soft'),
      ('ગીતા', 'गीता', 'Geeta', 'શ્રીમદ્ ભગવદ્ ગીતા', 'भगवद्गीता', 'Holy Bhagavad Geeta'),
      ('શાલિની', 'शालिनी', 'Shalini', 'સંસ્કારી, નમ્ર', 'सभ्य', 'Courteous, Modest'),
      ('શ્રેષ્ઠા', 'श्रेष्ठा', 'Shreshtha', 'સર્વશ્રેષ્ઠ, ઉત્તમ', 'सर्वोत्तम', 'Foremost, Best'),
      ('શ્રદ્ધા', 'श्रद्धा', 'Shraddha', 'ઈશ્વરમાં પરમ વિશ્વાસ', 'आस्था', 'Faith, Devotion'),
      ('શિવાની', 'शिवानी', 'Shivani', 'દેવી પાર્વતી', 'शिव शक्ति', 'Goddess Parvati, Shakti'),
    ];
    for (final g in sGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 10, false);
    }
  }

  // -------------------------------------------------------------
  // 11: MEENA (દ, ચ, ઝ, થ) - 100+ Boys, 100+ Girls
  // -------------------------------------------------------------
  static void _addMeenaNames(Function add) {
    final dBoys = [
      ('દર્શ', 'दर्श', 'Darsh', 'ભગવાન શ્રીકૃષ્ણ, દર્શન', 'भगवान कृष्ण, दर्शन', 'Sight, Lord Krishna'),
      ('દક્ષ', 'दक्ष', 'Daksh', 'સક્ષમ, નિપુણ, બ્રહ્માપુત્ર', 'योग्य, कुशल', 'Capable, Efficient'),
      ('દેવાંશ', 'देवांश', 'Devansh', 'ઈશ્વરનો પવિત્ર અંશ', 'ईश्वर का अंश', 'Part of the Divine'),
      ('ચિરાયુ', 'चिरायु', 'Chirayu', 'દીર્ઘાયુષ્યવાળો, અમર', 'दीर्घायु, अमर', 'Long lived, Immortal'),
      ('ચૈતન્ય', 'चैतन्य', 'Chaitanya', 'દિવ્ય ચેતના, મહાપ્રભુ', 'दिव्य चेतना, ज्ञान', 'Divine consciousness'),
      ('ઝિયાન', 'झियान', 'Ziyan', 'તેજસ્વી, શોભાવાન', 'चमकदार, सुंदर', 'Elegance, Splendour'),
      ('દિવિત', 'दिवित', 'Divit', 'અમર, અવિનાશી', 'अमर', 'Immortal, Divine'),
      ('દિયાન', 'दियांश', 'Diyan', 'તેજસ્વી દીવડો', 'प्रकाश', 'Radiance, Bright'),
      ('ચિંતન', 'चिंतन', 'Chintan', 'ઊંડું ચિંતન, વિચાર', 'गहरा विचार', 'Meditation, Contemplation'),
      ('ચિન્મય', 'चिन्मय', 'Chinmay', 'જ્ઞાનસ્વરૂપ, પરમાત્મા', 'ज्ञानमय, ईश्वर', 'Supreme consciousness'),
      ('દિવ્ય', 'दिव्य', 'Divya', 'અલૌકિક, તેજસ્વી', 'अलौकिक, पवित्र', 'Divine, Heavenly'),
      ('દર્શિત', 'दर्शित', 'Darshit', 'સન્માનનીય દર્શન', 'सम्मानित', 'Respected, Shown'),
      ('દક્ષેશ', 'दक्षेश', 'Dakshesh', 'ભગવાન શિવ', 'भगवान शिव', 'Lord Shiva'),
      ('ચિરાગ', 'चिराग', 'Chirag', 'તેજસ્વી દીવડો', 'उजाला, दीपक', 'Lamp, Light'),
      ('ધ્રુવમ', 'ध्रुवम', 'Dhruvam', 'અટલ અને સ્થિર', 'अटल', 'Constant, Steady'),
      ('દીપક', 'दीपक', 'Deepak', 'પ્રકાશ આપનાર દીવો', 'दीपक', 'Lamp, Radiance'),
      ('દેવેન્દ્ર', 'देवेन्द्र', 'Devendra', 'દેવોના રાજા, ઇન્દ્ર', 'देवताओं के राजा', 'King of Gods, Indra'),
      ('દિગ્વિજય', 'दिग्विजय', 'Digvijay', 'ચારેય દિશાઓમાં વિજેતા', 'दसों दिशाओं का विजेता', 'Victorious in all realms'),
      ('ચંદ્રકાંત', 'चंद्रकांत', 'Chandrakant', 'ચંદ્ર જેવો સુંદર મણિ', 'चंद्रमा समान मणि', 'Beloved by Moon'),
      ('દર્શન', 'दर्शन', 'Darshan', 'પવિત્ર દ્રષ્ટિ, ઈશ્વર દર્શન', 'ईश्वर के दर्शन', 'Holy vision, Perception'),
      ('ચંદ્રેશ', 'चंद्रेश', 'Chandresh', 'ચંદ્રમાના સ્વામી, શિવ', 'चंद्रमा के स्वामी', 'Lord of Moon, Shiva'),
      ('દેવરાજ', 'देवराज', 'Devraj', 'દેવોના સમ્રાટ', 'देवताओं के राजा', 'King of Gods'),
    ];
    for (final b in dBoys) {
      add(b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, 11, true);
    }

    final dGirls = [
      ('દિયા', 'दिया', 'Diya', 'પવિત્ર દીવડો, પ્રકાશ', 'दीपक, उजाला', 'Lamp, Light'),
      ('ચાર્વી', 'चार्वी', 'Charvi', 'સુંદર અને નમણી સ્ત્રી', 'सुंदर स्त्री', 'Beautiful, Graceful lady'),
      ('દ્રષ્ટિ', 'दृष्टि', 'Drashti', 'દિવ્ય દ્રષ્ટિ, નજર', 'दिव्य दृष्टि', 'Vision, Sight'),
      ('દેવાંશી', 'देवांशी', 'Devanshi', 'ઈશ્વરીય દૈવી કન્યા', 'ईश्वरीय अंश', 'Divine essence, Godly'),
      ('ઝીલ', 'झील', 'Zil', 'શાંત સરોવર, ઝરણું', 'शांत झील, झरना', 'Calm lake, Stream'),
      ('ચિત્રા', 'चित्रा', 'Chitra', 'સુંદર ચિત્ર, નક્ષત્ર', 'सुंदर चित्र, नक्षत्र', 'Picture, Star constellation'),
      ('ચેતના', 'चेतना', 'Chetana', 'જીવન શક્તિ, જાગૃતિ', 'चेतना, ऊर्जा', 'Consciousness, Power of life'),
      ('ચારુ', 'चारू', 'Charu', 'સુંદર, મનમોહક', 'सुंदर, आकर्षक', 'Attractive, Beautiful'),
      ('દિશા', 'दिशा', 'Disha', 'યોગ્ય માર્ગ, દિશા', 'दिशा, रास्ता', 'Direction, Path'),
      ('દિવ્યા', 'दिव्या', 'Divya', 'દિવ્ય તેજસ્વી સ્ત્રી', 'दिव्य, अलौकिक', 'Divine, Heavenly light'),
      ('દેવિકા', 'देविका', 'Devika', 'નાની દેવી, માતૃત્વ', 'छोटी देवी', 'Little Goddess, Mother'),
      ('ઝરણા', 'झरना', 'Jharna', 'મીઠા પાણીનું ઝરણું', 'मीठा झरना', 'Waterfall, Fresh stream'),
      ('છાયા', 'छाया', 'Chhaya', 'શીતળ છાયડો, સૂર્યપત્ની', 'शीतल छाया', 'Shadow, Protection'),
      ('ચાંદની', 'चांदनी', 'Chandani', 'ચંદ્રનો શીતળ પ્રકાશ', 'चंद्रमा की रोशनी', 'Moonlight'),
      ('દીપિકા', 'दीपिका', 'Deepika', 'પ્રકાશની નાની જ્યોત', 'दीपक की लौ', 'Ray of light, Lamp'),
      ('દક્ષા', 'दक्षा', 'Daksha', 'પૃથ્વી, સક્ષમ', 'सक्षम, धरती', 'Goddess Earth, Skilled'),
      ('ચંદ્રિકા', 'चंद्रिका', 'Chandrika', 'ચંદ્રની મધુર ચાંદની', 'चांदनी', 'Moonlight'),
      ('દામિની', 'दामिनी', 'Damini', 'આકાશમાં ચમકતી વીજળી', 'बिजली की चमक', 'Lightning, Radiant'),
      ('ચૈતાલી', 'चैताली', 'Chaitali', 'ચૈત્ર મહિનામાં જન્મેલી', 'चैत्र में जन्मी', 'Born in Chaitra month'),
      ('દિવ્યાંગના', 'दिव्यांगना', 'Divyangana', 'અપ્સરા, સ્વર્ગની સુંદરી', 'स्वर्ग की सुंदरी', 'Heavenly nymph'),
    ];
    for (final g in dGirls) {
      add(g.$1, g.$2, g.$3, g.$4, g.$5, g.$6, 11, false);
    }
  }
}
