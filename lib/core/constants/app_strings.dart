import '../providers/language_provider.dart';

class AppStrings {
  // App Branding
  static const String appName = 'SanatanDrishti';
  static String appTitle(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સનાતન દૃષ્ટિ' : 'सनातन दृष्टि';
  static String appTagline(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'પંચાંગ • ગીતા • કુંડળી • રાશિ' : 'पञ्चाङ्ग • गीता • कुण्डली • राशि';

  // Navigation
  static String navPanchang(AppLanguage lang) => lang == AppLanguage.gujarati ? 'પંચાંગ' : 'पञ्चाङ्ग';
  static const String navPanchangEnglish = 'Panchang';

  static String navGeeta(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ગીતા' : 'गीता';
  static const String navGeetaEnglish = 'Geeta';

  static String navRashi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'રાશિ' : 'राशि';
  static const String navRashiEnglish = 'Rashi';

  // Geeta
  static String geetaHomeTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'શ્રીમદ્ ભગવદ્ ગીતા' : 'श्रीमद्भगवद्गीता';
  static String geetaSubtitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'અઢાર પાવન અધ્યાયો • ૭૦૦ શ્લોકો' : 'अष्टादश अध्यायाः • ७०० श्लोकाः';

  static String chapter(AppLanguage lang) => lang == AppLanguage.gujarati ? 'અધ્યાય' : 'अध्याय';
  static String verse(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શ્લોક' : 'श्लोक';
  static String translation(AppLanguage lang) => lang == AppLanguage.gujarati ? 'અનુવાદ' : 'अनुवाद';
  static String commentary(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ભાષ્ય / અર્થ' : 'व्याख्या / अर्थ';
  static String transliteration(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ઉચ્ચારણ' : 'उच्चारण';
  static String commentator(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ભાષ્યકાર' : 'भाष्यकार';
  static String bookmarks(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સંગ્રહિત શ્લોકો' : 'संग्रहित श्लोक';
  static String searchVerses(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શ્લોક શોધો' : 'श्लोक खोजें';
  static String lastRead(AppLanguage lang) => lang == AppLanguage.gujarati ? 'વાચન ચાલુ રાખો' : 'वाचन जारी रखें';
  static String slokTab(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શ્લોક (Slok)' : 'श्लोक (Slok)';
  static String meanTab(AppLanguage lang) => lang == AppLanguage.gujarati ? 'અનુવાદ (Mean)' : 'अनुवाद (Mean)';

  // Panchang
  static String panchangTitle(AppLanguage lang) => lang == AppLanguage.gujarati ? 'દૈનિક પંચાંગ' : 'दैनिक पञ्चाङ्ग';
  static String tithi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'તિથિ' : 'तिथि';
  static String nakshatra(AppLanguage lang) => lang == AppLanguage.gujarati ? 'નક્ષત્ર' : 'नक्षत्र';
  static String yoga(AppLanguage lang) => lang == AppLanguage.gujarati ? 'યોગ' : 'योग';
  static String karana(AppLanguage lang) => lang == AppLanguage.gujarati ? 'કરણ' : 'करण';
  static String vaar(AppLanguage lang) => lang == AppLanguage.gujarati ? 'વાર' : 'वार';
  static String sunrise(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સૂર્યોદય' : 'सूर्योदय';
  static String sunset(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સૂર્યાસ્ત' : 'सूर्यास्त';
  static String moonrise(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્રોદય' : 'चन्द्रोदय';
  static String moonset(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્રાસ્ત' : 'चन्द्रास्त';
  static String ritu(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ઋતુ' : 'ऋतु';
  static String samvat(AppLanguage lang) => lang == AppLanguage.gujarati ? 'વિક્રમ સંવત' : 'विक्रम संवत्';
  static String shakaSamvat(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શક સંવત' : 'शक संवत्';
  static String rahuKaal(AppLanguage lang) => lang == AppLanguage.gujarati ? 'રાહુ કાળ' : 'राहु काल';
  static String abhijitMuhurta(AppLanguage lang) => lang == AppLanguage.gujarati ? 'અભિજિત મુહૂર્ત' : 'अभिजित मुहूर्त';
  static String yamaganda(AppLanguage lang) => lang == AppLanguage.gujarati ? 'યમગંડ' : 'यमगण्ड';
  static String gulikai(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ગુલિકા' : 'गुलिकाय';
  static String brahmaMuhurta(AppLanguage lang) => lang == AppLanguage.gujarati ? 'બ્રહ્મ મુહૂર્ત' : 'ब्रह्म मुहूर्त';
  static String startTime(AppLanguage lang) => lang == AppLanguage.gujarati ? 'પ્રારંભ' : 'प्रारम्भ';
  static String endTime(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સમાપ્તિ' : 'समाप्ति';
  static String next(AppLanguage lang) => lang == AppLanguage.gujarati ? 'આગામી' : 'आगामी';
  static String moonRashi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્ર રાશિ' : 'चन्द्र राशि';
  static String sun(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સૂર્ય (Sun)' : 'सूर्य (Sun)';
  static String moon(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્ર (Moon)' : 'चन्द्र (Moon)';
  static String sunriseLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સૂર્યોદય (Rise)' : 'सूर्योदय (Rise)';
  static String sunsetLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સૂર્યાસ્ત (Set)' : 'सूर्यास्त (Set)';
  static String moonriseLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્રોદય (Rise)' : 'ચન્દ્રોદય (Rise)';
  static String moonsetLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચંદ્રાસ્ત (Set)' : 'चन्द्रास्त (Set)';

  // Muhurta Timings
  static String muhurtaSectionTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'શુભ અને અશુભ કાળ' : 'शुभ एवं अशुभ काल';
  static String abhijitLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'અભિજિત મુહૂર્ત (Abhijit)' : 'अभिजित मुहूर्त (Abhijit)';
  static String brahmaLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'બ્રહ્મ મુહૂર્ત (Brahma)' : 'ब्रह्म मुहूर्त (Brahma)';
  static String rahuKaalLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'રાહુ કાળ (Rahu Kaal)' : 'राहु काल (Rahu Kaal)';
  static String yamagandaLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'યમગંડ (Yamaganda)' : 'यमगण्ड (Yamaganda)';
  static String gulikaiLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ગુલિક કાળ (Gulikai)' : 'गुलिक काल (Gulikai)';
  static String abhijitProhibited(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'વર્જિત (બુધવારે અશુભ)' : 'वर्जित (Inauspicious on Wed)';

  // Choghadiya
  static String choghadiyaTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'દિવસ અને રાત્રિના ચોઘડિયા' : 'दिन एवं रात का चौघड़िया';
  static String dayChoghadiya(AppLanguage lang) => lang == AppLanguage.gujarati ? 'દિવસ (Day)' : 'दिन (Day)';
  static String nightChoghadiya(AppLanguage lang) => lang == AppLanguage.gujarati ? 'રાત્રિ (Night)' : 'रात (Night)';
  static String activeNow(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચાલુ છે' : 'चल रहा है';

  // Baby Born Rashi & Namkaran
  static String babyBornFab(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જન્મ રાશિ & નામકરણ' : 'जन्म राशि & नामकरण';
  static String babyBornTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'બાળ જન્મ રાશિ & નામકરણ' : 'बालक जन्म राशि & नामकरण';
  static String birthDate(AppLanguage lang) => lang == AppLanguage.gujarati ? 'જન્મ તારીખ' : 'जन्म तिथि';
  static String birthTime(AppLanguage lang) => lang == AppLanguage.gujarati ? 'જન્મ સમય' : 'जन्म समय';
  static String janmaRashi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'જન્મ રાશિ' : 'जन्म राशि';
  static String janmaNakshatra(AppLanguage lang) => lang == AppLanguage.gujarati ? 'જન્મ નક્ષત્ર' : 'जन्म नक्षत्र';
  static String charan(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ચરણ (પાદ)' : 'चरण (पाद)';
  static String namakshar(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શુભ નામાક્ષર' : 'शुभ नामाक्षर';
  static String elementLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'તત્વ' : 'तत्व';
  static String rulingPlanetLabel(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સ્વામી ગ્રહ' : 'स्वामी ग्रह';
  static String luckyGem(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શુભ રત્ન' : 'शुभ रत्न';
  static String luckyColors(AppLanguage lang) => lang == AppLanguage.gujarati ? 'શુભ રંગ' : 'शुभ रंग';
  static String gana(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ગણ' : 'गण';
  static String nadi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'નાડી' : 'नाड़ी';

  // Rashi
  static String rashiTitle(AppLanguage lang) => lang == AppLanguage.gujarati ? 'રાશિ ભવિષ્ય' : 'राशि भविष्य';
  static String myRashi(AppLanguage lang) => lang == AppLanguage.gujarati ? 'મારી રાશિ' : 'मेरी राशि';
  static String dailyPrediction(AppLanguage lang) => lang == AppLanguage.gujarati ? 'આજનું રાશિફળ' : 'आज का राशिफल';
  static String luckyNumber(AppLanguage lang) => lang == AppLanguage.gujarati ? 'લકી નંબર' : 'लकी नंबर';
  static String luckyColor(AppLanguage lang) => lang == AppLanguage.gujarati ? 'લકી કલર' : 'लकी कलर';
  static String yesterday(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ગઈકાલે' : 'बीता कल';
  static String today(AppLanguage lang) => lang == AppLanguage.gujarati ? 'આજે' : 'आज';
  static String tomorrow(AppLanguage lang) => lang == AppLanguage.gujarati ? 'આવતીકાલે' : 'कल';

  // Common
  static String retry(AppLanguage lang) => lang == AppLanguage.gujarati ? 'ફરી પ્રયાસ કરો' : 'पुनः प्रयास करें';
  static String errorGeneric(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'કંઈક ખોટું થયું છે. કૃપા કરીને ફરી પ્રયાસ કરો.' : 'कुछ त्रुटि हुई। कृपया पुनः प्रयास करें।';
  static String offlineMessage(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ઓફલાઇન મોડ — સચોટ વૈદિક ગણતરી' : 'ऑफ़लाइन मोड — सटीक वैदिक गणना';
  static String selectCity(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સ્થાન પસંદ કરો' : 'स्थान चयन';
  static String searchCity(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'શહેર શોધો...' : 'शहर खोजें...';

  // Settings
  static String settings(AppLanguage lang) => lang == AppLanguage.gujarati ? 'સેટિંગ્સ' : 'सेटिंग्स';
  static String settingsSubtitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ઍપ પ્રાથમિકતાઓ અને ગોઠવણી' : 'ऐप प्राथमिकताएं एवं विन्यास';
  static String languageSelection(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ભાષા પસંદગી (Language Selection)' : 'भाषा चयन (Language Selection)';
  static String appearance(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'દેખાવ અને થીમ (Appearance)' : 'दिखावट एवं थीम (Appearance)';
  static String darkMode(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ડાર્ક મોડ (Dark Mode)' : 'डार्क मोड (Dark Mode)';
  static String resetSystemTheme(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'સિસ્ટમ થીમ પુનઃસ્થાપિત કરો' : 'सिस्टम थीम रीसेट करें';
  static String geetaAndAudio(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ગીતા અને વાચન સેટિંગ્સ (Geeta & Audio)' : 'गीता एवं वाचन सेटिंग्स (Geeta & Audio)';
  static String speechSpeed(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'વાચન ગતિ (TTS Speech Speed)' : 'वाचन गति (TTS Speech Speed)';
  static String autoAdvanceTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'આગળના શ્લોક પર આપમેળે જવું (Auto-Advance)' : 'अगले श्लोक पर स्वतः आगे बढ़ें';
  static String autoAdvanceSubtitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જ્યારે શ્લોકનું વાચન પૂર્ણ થાય ત્યારે આપમેળે આગળનો શ્લોક ચલાવો' : 'श्लोक वाचन पूर्ण होने पर स्वतः अगला श्लोक चलाएं';
  static String defaultRashiTitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'મારી મૂળ રાશિ (Default Rashi)' : 'मेरी डिफ़ॉल्ट राशि (Default Rashi)';

  // Kundali
  static String createKundali(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'કુંડળી બનાવો' : 'कुंडली बनाएं';
  static String createKundaliSubtitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'સચોટ વૈદિક જન્મપત્રિકા અને ગ્રહ ફળાદેશ' : 'सटीक वैदिक जन्मपत्रिका एवं ग्रह फलादेश';
  static String janamKundali(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જન્મ કુંડળી' : 'जन्म कुंडली';
  static String savedKundalis(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'મારી સંગ્રહિત કુંડળીઓ' : 'मेरी संग्रहित कुंडलियां';
  static String savedKundalisSubtitle(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'સાચવેલી કુંડળીઓ જુઓ અને ડાઉનલોડ કરો' : 'सहेजी गई कुंडलियां देखें एवं डाउनलोड करें';
  static String fullName(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જાતકનું પૂરું નામ' : 'जातक का पूरा नाम';
  static String gender(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જાતિ (લિંગ)' : 'लिंग (Gender)';
  static String male(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'પુરુષ (Male)' : 'पुरुष (Male)';
  static String female(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'સ્ત્રી (Female)' : 'स्त्री (Female)';
  static String otherGender(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'અન્ય (Other)' : 'अन्य (Other)';
  static String dateOfBirthLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જન્મ તારીખ' : 'जन्म तिथि (Date of Birth)';
  static String birthTimeLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જન્મ સમય' : 'जन्म समय (Time of Birth)';
  static String birthPlaceLabel(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'જન્મ સ્થાન (શહેર)' : 'जन्म स्थान (City)';
  static String generateKundaliBtn(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'કુંડળી બનાવો અને જુઓ' : 'कुंडली बनाएं एवं देखें';
  static String downloadKundaliBtn(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ડાઉનલોડ / સાચવો' : 'डाउनलोड / सहेजें';
  static String lagnaChart(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'લગ્ન કુંડળી (D1)' : 'लग्न कुंडली (D1)';
  static String navamshaChart(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'નવમાંશ કુંડળી (D9)' : 'नवमांश कुंडली (D9)';
  static String chandraChart(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ચંદ્ર કુંડળી' : 'चन्द्र कुंडली';
  static String grahaSthiti(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'ગ્રહ સ્થિતિ' : 'ग्रह स्थिति';
  static String doshaAnalysis(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'દોષ વિશ્લેષણ' : 'दोष विश्लेषण';
  static String dashaTimeline(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'વિંશોત્તરી દશા' : 'विंशोत्तरी दशा';
  static String bhavaPhala(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? '૧૨ ભાવ ફળાદેશ' : '१२ भाव फलादेश';
  static String avakahadaChakra(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'અવકહડા ચક્ર' : 'अवकहड़ा चक्र';
  static String noSavedKundalis(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'કોઈ સંગ્રહિત કુંડળી નથી' : 'कोई संग्रहित कुंडली नहीं है';
  static String deleteConfirm(AppLanguage lang) =>
      lang == AppLanguage.gujarati ? 'શું તમે આ કુંડળી કાઢી નાખવા માંગો છો?' : 'क्या आप यह कुंडली हटाना चाहते हैं?';
}

