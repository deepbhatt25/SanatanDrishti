import '../../../core/services/location_service.dart';
import '../repositories/panchang_repository.dart';

class CalendarDayTithi {
  final DateTime date;
  final int day;
  final int tithiIndex; // 0 to 29
  final int tithiNumberInPaksha; // 1 to 15
  final bool isShukla;
  final String tithiNameHi;
  final String tithiNameGu;
  final String shortTithiHi;
  final String shortTithiGu;
  final String pakshaLabelHi;
  final String pakshaLabelGu;
  final String? festivalHi;
  final String? festivalGu;
  final String? shortFestivalHi;
  final String? shortFestivalGu;
  final bool isMajorTehvar;
  final bool isPurnima;
  final bool isAmavasya;
  final bool isEkadashi;
  final bool isPradosh;
  final bool isShivratri;
  final bool isToday;

  const CalendarDayTithi({
    required this.date,
    required this.day,
    required this.tithiIndex,
    required this.tithiNumberInPaksha,
    required this.isShukla,
    required this.tithiNameHi,
    required this.tithiNameGu,
    required this.shortTithiHi,
    required this.shortTithiGu,
    required this.pakshaLabelHi,
    required this.pakshaLabelGu,
    this.festivalHi,
    this.festivalGu,
    this.shortFestivalHi,
    this.shortFestivalGu,
    this.isMajorTehvar = false,
    required this.isPurnima,
    required this.isAmavasya,
    required this.isEkadashi,
    required this.isPradosh,
    required this.isShivratri,
    required this.isToday,
  });
}

class MonthTithiCalendarData {
  final int year;
  final int month;
  final String monthNameEn;
  final String monthNameHi;
  final String monthNameGu;
  final String vikramSamvat;
  final String shakaSamvat;
  final String lunarMonthHi;
  final String lunarMonthGu;
  final List<CalendarDayTithi> days;
  final int firstWeekdayOffset; // 0 for Sunday, 1 for Monday...
  final int totalDays;

  const MonthTithiCalendarData({
    required this.year,
    required this.month,
    required this.monthNameEn,
    required this.monthNameHi,
    required this.monthNameGu,
    required this.vikramSamvat,
    required this.shakaSamvat,
    required this.lunarMonthHi,
    required this.lunarMonthGu,
    required this.days,
    required this.firstWeekdayOffset,
    required this.totalDays,
  });

  static MonthTithiCalendarData generateMonthCalendar({
    required int year,
    required int month,
    required CityLocation city,
  }) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final totalDays = lastDayOfMonth.day;
    final now = DateTime.now();

    // Sunday = 7 in Dart, we map Sunday to index 0, Mon=1...Sat=6
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final List<CalendarDayTithi> days = [];
    final Set<String> uniqueLunarMonthsHi = {};
    final Set<String> uniqueLunarMonthsGu = {};

    for (int dayNum = 1; dayNum <= totalDays; dayNum++) {
      final date = DateTime(year, month, dayNum);

      // Shared Unified Vedic Tithi calculation (Guaranteed 100% in sync with Daily Panchang)
      final tithiData = PanchangRepository.calculateVedicTithi(date);

      final tithiIndex = tithiData.tithiIndex;
      final tithiNumberInPaksha = tithiData.tithiNumberInPaksha;
      final isShukla = tithiData.isShukla;
      final isPurnima = tithiIndex == 14;
      final isAmavasya = tithiIndex == 29;
      final isEkadashi = tithiNumberInPaksha == 11;
      final isPradosh = tithiNumberInPaksha == 13;
      final isShivratri = !isShukla && tithiNumberInPaksha == 14;

      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

      uniqueLunarMonthsHi.add(tithiData.lunarMonthHi);
      uniqueLunarMonthsGu.add(tithiData.lunarMonthGu);

      // Authentic Vedic Festival & Tehvar detection based on EXACT Amanta Lunar Month!
      final fest = _detectFestival(
        date: date,
        lunarMonthId: tithiData.lunarMonthId,
        isShukla: isShukla,
        tithiNum: tithiNumberInPaksha,
        isPurnima: isPurnima,
        isAmavasya: isAmavasya,
      );

      days.add(CalendarDayTithi(
        date: date,
        day: dayNum,
        tithiIndex: tithiIndex,
        tithiNumberInPaksha: tithiNumberInPaksha,
        isShukla: isShukla,
        tithiNameHi: tithiData.tithiNameHi,
        tithiNameGu: tithiData.tithiNameGu,
        shortTithiHi: tithiData.shortTithiHi,
        shortTithiGu: tithiData.shortTithiGu,
        pakshaLabelHi: tithiData.pakshaLabelHi,
        pakshaLabelGu: tithiData.pakshaLabelGu,
        festivalHi: fest?.nameHi,
        festivalGu: fest?.nameGu,
        shortFestivalHi: fest?.shortNameHi,
        shortFestivalGu: fest?.shortNameGu,
        isMajorTehvar: fest?.isMajorTehvar ?? false,
        isPurnima: isPurnima,
        isAmavasya: isAmavasya,
        isEkadashi: isEkadashi,
        isPradosh: isPradosh,
        isShivratri: isShivratri,
        isToday: isToday,
      ));
    }

    const monthNamesEn = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const monthNamesHi = [
      'जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
      'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
    ];
    const monthNamesGu = [
      'જાન્યુઆરી', 'ફેબ્રુઆરી', 'માર્ચ', 'એપ્રિલ', 'મે', 'જૂન',
      'જુલાઈ', 'ઓગસ્ટ', 'સપ્ટેમ્બર', 'ઓક્ટોબર', 'નવેમ્બર', 'ડિસેમ્બર'
    ];

    final headerLunarMonthHi = uniqueLunarMonthsHi.isNotEmpty
        ? uniqueLunarMonthsHi.join(' - ')
        : 'माह';
    final headerLunarMonthGu = uniqueLunarMonthsGu.isNotEmpty
        ? uniqueLunarMonthsGu.join(' - ')
        : 'માસ';

    return MonthTithiCalendarData(
      year: year,
      month: month,
      monthNameEn: monthNamesEn[month - 1],
      monthNameHi: monthNamesHi[month - 1],
      monthNameGu: monthNamesGu[month - 1],
      vikramSamvat: '${year + 57}',
      shakaSamvat: '${year - 78}',
      lunarMonthHi: headerLunarMonthHi,
      lunarMonthGu: headerLunarMonthGu,
      days: days,
      firstWeekdayOffset: firstWeekday,
      totalDays: totalDays,
    );
  }

  static ({String nameHi, String nameGu, String shortNameHi, String shortNameGu, bool isMajorTehvar})? _detectFestival({
    required DateTime date,
    required int lunarMonthId, // 1 = Chaitra, 2 = Vaishakha, ..., 6 = Bhadrapada, 7 = Ashvina, 8 = Kartika, ..., 12 = Phalguna
    required bool isShukla,
    required int tithiNum,
    required bool isPurnima,
    required bool isAmavasya,
  }) {
    // 1. Fixed Solar Festivals
    if (date.month == 1 && date.day == 14) {
      return (
        nameHi: 'मकर संक्रांति / पोंगल महापर्व',
        nameGu: 'મકરસંક્રાંતિ / ઉત્તરાયણ પર્વ',
        shortNameHi: 'मकर संक्रांति',
        shortNameGu: 'ઉત્તરાયણ',
        isMajorTehvar: true,
      );
    }
    if (date.month == 1 && date.day == 15) {
      return (
        nameHi: 'उत्तरायण पर्व / वासी उत्तरायण',
        nameGu: 'વાસી ઉત્તરાયણ',
        shortNameHi: 'उत्तरायण',
        shortNameGu: 'વાસી ઉત્તરાયણ',
        isMajorTehvar: true,
      );
    }

    // 2. Chaitra Month (૧. ચૈત્ર)
    if (lunarMonthId == 1) {
      if (isShukla && tithiNum == 1) {
        return (
          nameHi: 'चैत्र नवरात्रि प्रारंभ / गुड़ी पड़वा',
          nameGu: 'ચૈત્રી નવરાત્રી પ્રારંભ / ગુડી પડવો',
          shortNameHi: 'गुड़ी पड़वा',
          shortNameGu: 'ચૈત્ર નવરાત્રી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 2) {
        return (
          nameHi: 'चेटीचंड / झूलेलाल जयंती',
          nameGu: 'ચેટીચંડ / ઝૂલેલાલ જયંતી',
          shortNameHi: 'चेटीचंड',
          shortNameGu: 'ચેટીચંડ',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 3) {
        return (
          nameHi: 'मत्स्य जयंती / गणगौर पूजा',
          nameGu: 'મત્સ્ય જયંતી / ગણગૌર ત્રીજ',
          shortNameHi: 'गणगौर',
          shortNameGu: 'ગણગૌર',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 9) {
        return (
          nameHi: 'श्री राम नवमी जन्मोत्सव',
          nameGu: 'શ્રી રામ નવમી મહોત્સવ',
          shortNameHi: 'राम नवमी',
          shortNameGu: 'રામ નવમી',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'श्री हनुमान जयंती जन्मोत्सव',
          nameGu: 'શ્રી હનુમાન જયંતિ મહોત્સવ',
          shortNameHi: 'हनुमान जयंती',
          shortNameGu: 'હનુમાન જયંતિ',
          isMajorTehvar: true,
        );
      }
    }

    // 3. Vaishakha Month (૨. વૈશાખ)
    if (lunarMonthId == 2) {
      if (isShukla && tithiNum == 3) {
        return (
          nameHi: 'अक्षय तृतीया / आखा तीज / परशुराम जयंती',
          nameGu: 'અક્ષય તૃતીયા / અખાત્રીજ / પરશુરામ જયંતી',
          shortNameHi: 'अक्षय तृतीया',
          shortNameGu: 'અખાત્રીજ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 14) {
        return (
          nameHi: 'नृसिंह जयंती व्रत',
          nameGu: 'નૃસિંહ જયંતી વ્રત',
          shortNameHi: 'नृसिंह जयंती',
          shortNameGu: 'નૃસિંહ જયંતી',
          isMajorTehvar: false,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'बुद्ध पूर्णिमा / वैशाखी पूर्णिमा',
          nameGu: 'બુદ્ધ પૂર્ણિમા / વૈશાખી પૂનમ',
          shortNameHi: 'बुद्ध पूर्णिमा',
          shortNameGu: 'બુદ્ધ પૂર્ણિમા',
          isMajorTehvar: true,
        );
      }
      if (isAmavasya) {
        return (
          nameHi: 'शनि जयंती / वट सावित्री व्रत',
          nameGu: 'શનિ જયંતી / વટ સાવિત્રી અમાસ',
          shortNameHi: 'शनि जयंती',
          shortNameGu: 'શનિ જયંતી',
          isMajorTehvar: true,
        );
      }
    }

    // 4. Jyeshtha Month (૩. જેઠ)
    if (lunarMonthId == 3) {
      if (isShukla && tithiNum == 10) {
        return (
          nameHi: 'गंगा दशहरा महापर्व',
          nameGu: 'ગંગા દશેરા પર્વ',
          shortNameHi: 'गंगा दशहरा',
          shortNameGu: 'ગંગા દશેરા',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 11) {
        return (
          nameHi: 'निर्जला एकादशी व्रत',
          nameGu: 'નિર્જળા અગિયારસ / ભીમ અગિયારસ',
          shortNameHi: 'निर्जला एकादशी',
          shortNameGu: 'નિર્જળા અગિયારસ',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'वट सावित्री पूर्णिमा / ज्येष्ठ पूर्णिमा',
          nameGu: 'વટ સાવિત્રી પૂનમ / જેઠી પૂનમ',
          shortNameHi: 'वट पूर्णिमा',
          shortNameGu: 'વટ પૂનમ',
          isMajorTehvar: false,
        );
      }
    }

    // 5. Ashadha Month (૪. અષાઢ)
    if (lunarMonthId == 4) {
      if (isShukla && tithiNum == 2) {
        return (
          nameHi: 'जगन्नाथ रथयात्रा / अषाढ़ी बीज',
          nameGu: 'અષાઢી બીજ / જગન્નાથ રથયાત્રા / કચ્છી નવું વર્ષ',
          shortNameHi: 'रथयात्रा',
          shortNameGu: 'અષાઢી બીજ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 11) {
        return (
          nameHi: 'देवशयनी एकादशी / चातुर्मास प्रारंभ',
          nameGu: 'દેવશયની અગિયારસ / ચાતુર્માસ પ્રારંભ',
          shortNameHi: 'देवशयनी',
          shortNameGu: 'દેવશયની',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'गुरु पूर्णिमा / व्यास पूजा',
          nameGu: 'ગુરુ પૂર્ણિમા / વ્યાસ પૂજન',
          shortNameHi: 'गुरु पूर्णिमा',
          shortNameGu: 'ગુરુ પૂનમ',
          isMajorTehvar: true,
        );
      }
      if (isAmavasya) {
        return (
          nameHi: 'हरियाली अमावस्या / दीप पूजा',
          nameGu: 'દિવાસો / હરિયાળી અમાસ / એવ્રત-જીવ્રત',
          shortNameHi: 'દિવાસો',
          shortNameGu: 'દિવાસો',
          isMajorTehvar: true,
        );
      }
    }

    // 6. Shravana Month (૫. શ્રાવણ)
    if (lunarMonthId == 5) {
      if (isShukla && tithiNum == 3) {
        return (
          nameHi: 'हरियाली तीज व्रत',
          nameGu: 'હરિયાળી ત્રીજ / કજોળી ત્રીજ',
          shortNameHi: 'हरियाली तीज',
          shortNameGu: 'હરિયાળી ત્રીજ',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 5) {
        return (
          nameHi: 'नाग पंचमी पूजन',
          nameGu: 'નાગ પાંચમ / નાગ પૂજન',
          shortNameHi: 'नाग पंचमी',
          shortNameGu: 'નાગ પાંચમ',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'रक्षाबंधन / श्रावणी पूर्णिमा',
          nameGu: 'રક્ષાબંધન / બળેવ પર્વ',
          shortNameHi: 'रक्षाबंधन',
          shortNameGu: 'રક્ષાબંધન',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 6) {
        return (
          nameHi: 'हलषष्ठी / रांधण छठ',
          nameGu: 'રાંધણ છઠ / હળષષ્ઠી વ્રત',
          shortNameHi: 'રાંધણ છઠ',
          shortNameGu: 'રાંધણ છઠ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 7) {
        return (
          nameHi: 'शीतला सातम / शीतला सप्तमी',
          nameGu: 'શીતળા સાતમ / શીતળા માતા પૂજન',
          shortNameHi: 'शीतला सातम',
          shortNameGu: 'શીતળા સાતમ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 8) {
        return (
          nameHi: 'श्रीकृष्ण जन्माष्टमी / गोकुळाष्टमी',
          nameGu: 'શ્રીકૃષ્ણ જન્માષ્ટમી મહોત્સવ',
          shortNameHi: 'जन्माष्टमी',
          shortNameGu: 'જન્માષ્ટમી',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 9) {
        return (
          nameHi: 'नंद महोत्सव / दधि कांदो',
          nameGu: 'નંદ મહોત્સવ / દહીં હાંડી',
          shortNameHi: 'नंद उत्सव',
          shortNameGu: 'નંદ મહોત્સવ',
          isMajorTehvar: false,
        );
      }
      if (isAmavasya) {
        return (
          nameHi: 'पिठोरी अमावस्या / श्रावणी अमावस्या',
          nameGu: 'શ્રાવણી અમાસ / પિઠોરી અમાસ / દર્શ અમાસ',
          shortNameHi: 'શ્રાવણી અમાસ',
          shortNameGu: 'શ્રાવણી અમાસ',
          isMajorTehvar: false,
        );
      }
    }

    // 7. Bhadrapada Month (૬. ભાદરવો)
    if (lunarMonthId == 6) {
      if (isShukla && tithiNum == 3) {
        return (
          nameHi: 'हरतालिका तीज / केवड़ा तीज',
          nameGu: 'કેવડા ત્રીજ / હરતાલિકા ત્રીજ વ્રત',
          shortNameHi: 'हरतालिका तीज',
          shortNameGu: 'કેવડા ત્રીજ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 4) {
        return (
          nameHi: 'श्री गणेश चतुर्थी / गणेशोत्सव',
          nameGu: 'શ્રી ગણેશ ચતુર્થી / ગણેશોત્સવ',
          shortNameHi: 'गणेश चतुर्थी',
          shortNameGu: 'ગણેશ ચતુર્થી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 5) {
        return (
          nameHi: 'ऋषि पंचमी व्रत / सामा पांचम',
          nameGu: 'સામા પાંચમ / ઋષિ પાંચમ વ્રત',
          shortNameHi: 'ऋषि पंचमी',
          shortNameGu: 'સામા પાંચમ',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 8) {
        return (
          nameHi: 'राधाष्टमी / महालक्ष्मी व्रत प्रारंभ',
          nameGu: 'રાધાષ્ટમી / મહાલક્ષ્મી વ્રત પ્રારંભ',
          shortNameHi: 'राधाष्टमी',
          shortNameGu: 'રાધાષ્ટમી',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 11) {
        return (
          nameHi: 'परिवर्तिनी एकादशी / जलझूलनी ग्यारस',
          nameGu: 'પરિવર્તિની અગિયારસ / જળઝીલણી એકાદશી',
          shortNameHi: 'जलझूलनी',
          shortNameGu: 'જળઝીલણી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 14) {
        return (
          nameHi: 'अनंत चतुर्दशी / गणेश विसर्जन',
          nameGu: 'અનંત ચતુર્દશી / ગણેશ વિસર્જન',
          shortNameHi: 'अनंत चतुर्दशी',
          shortNameGu: 'અનંત ચૌદશ',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'भाद्रपद पूर्णिमा / महालय श्राद्ध प्रारंभ',
          nameGu: 'ભાદરવી પૂનમ / મહાલય શ્રાદ્ધ પ્રારંભ / અંબાજી મેળો',
          shortNameHi: 'શ્રાદ્ધ પ્રારંભ',
          shortNameGu: 'ભાદરવી પૂનમ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && isAmavasya) {
        return (
          nameHi: 'सर्वपितृ अमावस्या / महालय श्राद्ध तर्पण',
          nameGu: 'સર્વપિતૃ અમાસ / શ્રાદ્ધ તર્પણ સમાપ્તિ',
          shortNameHi: 'सर्वपितृ અમાસ',
          shortNameGu: 'સર્વપિતૃ અમાસ',
          isMajorTehvar: true,
        );
      }
    }

    // 8. Ashvina Month (૭. આસો - શારદીય નવરાત્રી, દશેરા & દિવાળી)
    if (lunarMonthId == 7) {
      if (isShukla && tithiNum == 1) {
        return (
          nameHi: 'शारदीय नवरात्रि प्रारंभ / घटस्थापना',
          nameGu: 'શારદીય નવરાત્રી પ્રારંભ / ઘટસ્થાપના',
          shortNameHi: 'नवरात्रि',
          shortNameGu: 'નવરાત્રી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 8) {
        return (
          nameHi: 'महाअष्टमी / दुर्गाष्टमी पूजन',
          nameGu: 'દુર્ગા અષ્ટમી / મહાઅષ્ટમી હવન',
          shortNameHi: 'दुर्गाष्टमी',
          shortNameGu: 'દુર્ગાષ્ટમી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 9) {
        return (
          nameHi: 'महानवमी / आयुध पूजा',
          nameGu: 'મહાનવમી / આયુધ પૂજન',
          shortNameHi: 'महानवमी',
          shortNameGu: 'મહાનવમી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 10) {
        return (
          nameHi: 'विजयादशमी / दशहरा महापर्व',
          nameGu: 'વિજયાદશમી / દશેરા / શસ્ત્ર પૂજન',
          shortNameHi: 'दशहरा',
          shortNameGu: 'દશેરા',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'शरद पूर्णिमा / कोजागरी व्रत',
          nameGu: 'શરદ પૂનમ / માણેકઠારી પૂનમ',
          shortNameHi: 'शरद पूर्णिमा',
          shortNameGu: 'શરદ પૂનમ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 11) {
        return (
          nameHi: 'रमा एकादशी व्रत',
          nameGu: 'રમા અગિયારસ વ્રત',
          shortNameHi: 'रमा एकादशी',
          shortNameGu: 'રમા અગિયારસ',
          isMajorTehvar: false,
        );
      }
      if (!isShukla && tithiNum == 12) {
        return (
          nameHi: 'गोवत्स द्वादशी / वाघ बारस',
          nameGu: 'વાઘ બારસ / ગોવત્સ દ્વાદશી',
          shortNameHi: 'वाघ बारस',
          shortNameGu: 'વાઘ બારસ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 13) {
        return (
          nameHi: 'धनतेरस / धन्वंतरि जयंती',
          nameGu: 'ધનતેરસ / લક્ષ્મી પૂજન / ધન્વંતરિ જયંતી',
          shortNameHi: 'धनतेरस',
          shortNameGu: 'ધનતેરસ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 14) {
        return (
          nameHi: 'काली चौदस / रूप चौदस / हनुमान पूजा',
          nameGu: 'કાળી ચૌદશ / હનુમાન પૂજન / રૂપ ચતુર્દશી',
          shortNameHi: 'काली चौदस',
          shortNameGu: 'કાળી ચૌદશ',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && isAmavasya) {
        return (
          nameHi: 'दीपावली / महालक्ष्मी पूजन / दीपदान',
          nameGu: 'દીપાવલી / લક્ષ્મી પૂજન / ચોપડા પૂજન',
          shortNameHi: 'दीपावली',
          shortNameGu: 'દિવાળી',
          isMajorTehvar: true,
        );
      }
    }

    // 9. Kartika Month (૮. કારતક - નૂતન વર્ષ & દેવ દિવાળી)
    if (lunarMonthId == 8) {
      if (isShukla && tithiNum == 1) {
        return (
          nameHi: 'गोवर्धन पूजा / नूतन वर्ष / अन्नकूट',
          nameGu: 'બેસતું વર્ષ / નૂતન વર્ષાભિનંદન / ગોવર્ધન પૂજા',
          shortNameHi: 'નૂતન વર્ષ',
          shortNameGu: 'બેસતું વર્ષ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 2) {
        return (
          nameHi: 'भाई दूज / यम द्वितीया',
          nameGu: 'ભાઈબીજ / યમ દ્વિતીયા',
          shortNameHi: 'भाई दूज',
          shortNameGu: 'ભાઈબીજ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 5) {
        return (
          nameHi: 'लाभ पंचमी / ज्ञान पंचमी',
          nameGu: 'લાભ પાંચમ / સૌભાગ્ય પંચમી / વેપાર મુહૂર્ત',
          shortNameHi: 'लाभ पंचमी',
          shortNameGu: 'લાભ પાંચમ',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 6) {
        return (
          nameHi: 'छठ पूजा (सूर्य षष्ठी)',
          nameGu: 'છઠ્ઠ પૂજા (સૂર્ય ષષ્ઠી પર્વ)',
          shortNameHi: 'छठ पूजा',
          shortNameGu: 'છઠ્ઠ પૂજા',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 8) {
        return (
          nameHi: 'गोपाष्टमी व्रत',
          nameGu: 'ગોપાષ્ટમી / ગૌ પૂજન',
          shortNameHi: 'गोपाष्टमी',
          shortNameGu: 'ગોપાષ્ટમી',
          isMajorTehvar: false,
        );
      }
      if (isShukla && tithiNum == 11) {
        return (
          nameHi: 'देवउठनी एकादशी / तुलसी विवाह प्रारंभ',
          nameGu: 'દેવઉઠી અગિયારસ / તુલસી વિવાહ પ્રારંભ / પ્રબોધિની',
          shortNameHi: 'तुलसी विवाह',
          shortNameGu: 'તુલસી વિવાહ',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'देव दीपावली / कार्तिक पूर्णिमा / त्रिपुरारी',
          nameGu: 'દેવ દિવાળી / ત્રિપુરા ઉત્સવ / કાર્તિકી પૂનમ',
          shortNameHi: 'देव दीपावली',
          shortNameGu: 'દેવ દિવાળી',
          isMajorTehvar: true,
        );
      }
    }

    // 10. Margashirsha Month (૯. માગશર)
    if (lunarMonthId == 9) {
      if (isShukla && tithiNum == 11) {
        return (
          nameHi: 'श्रीमद्भगवद्गीता जयंती / मोक्षदा एकादशी',
          nameGu: 'શ્રીમદ્ ભગવદ્ ગીતા જયંતી / મોક્ષદા અગિયારસ',
          shortNameHi: 'गीता जयंती',
          shortNameGu: 'ગીતા જયંતી',
          isMajorTehvar: true,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'श्री दत्तात्रेय जयंती / मार्गशीर्ष पूर्णिमा',
          nameGu: 'શ્રી દત્તાત્રેય જયંતી / માગશર પૂનમ',
          shortNameHi: 'दत्तात्रेय जयंती',
          shortNameGu: 'દત્તાત્રેય જયંતી',
          isMajorTehvar: true,
        );
      }
    }

    // 11. Pausha Month (૧૦. પોષ)
    if (lunarMonthId == 10) {
      if (isPurnima) {
        return (
          nameHi: 'पौष पूर्णिमा / शाकंभरी पूर्णिमा',
          nameGu: 'પોષી પૂનમ / શાકંભરી પૂર્ણિમા / અંબાજી પ્રાગટ્ય',
          shortNameHi: 'પોષી પૂનમ',
          shortNameGu: 'પોષી પૂનમ',
          isMajorTehvar: true,
        );
      }
    }

    // 12. Magha Month (૧૧. મહા)
    if (lunarMonthId == 11) {
      if (isShukla && tithiNum == 5) {
        return (
          nameHi: 'बसंत पंचमी / सरस्वती पूजन',
          nameGu: 'વસંત પંચમી / સરસ્વતી પૂજન',
          shortNameHi: 'बसंत पंचमी',
          shortNameGu: 'વસંત પંચમી',
          isMajorTehvar: true,
        );
      }
      if (isShukla && tithiNum == 7) {
        return (
          nameHi: 'रथ सप्तमी / आरोग्य सप्तमी',
          nameGu: 'રથ સપ્તમી / આરોગ્ય સપ્તમી',
          shortNameHi: 'रथ सप्तमी',
          shortNameGu: 'રથ સપ્તમી',
          isMajorTehvar: false,
        );
      }
      if (isPurnima) {
        return (
          nameHi: 'माघ पूर्णिमा स्नान / गुरु रविदास जयंती',
          nameGu: 'મહા પૂનમ સ્નાન / રવિદાસ જયંતી',
          shortNameHi: 'माघ पूर्णिमा',
          shortNameGu: 'મહા પૂનમ',
          isMajorTehvar: false,
        );
      }
      if (!isShukla && tithiNum == 14) {
        return (
          nameHi: 'महाशिवरात्रि महापर्व',
          nameGu: 'મહાશિવરાત્રી પર્વ / શિવરાત્રી વ્રત',
          shortNameHi: 'महाशिवरात्रि',
          shortNameGu: 'મહાશિવરાત્રી',
          isMajorTehvar: true,
        );
      }
    }

    // 13. Phalguna Month (૧૨. ફાગણ)
    if (lunarMonthId == 12) {
      if (isPurnima) {
        return (
          nameHi: 'होलिका दहन / फाल्गुनी पूर्णिमा',
          nameGu: 'હોલિકા દહન / ફાગણી પૂનમ / ડાકોર મેળો',
          shortNameHi: 'होलिका दहन',
          shortNameGu: 'હોલિકા દહન',
          isMajorTehvar: true,
        );
      }
      if (!isShukla && tithiNum == 1) {
        return (
          nameHi: 'धुलेंडी / होली रंगोत्सव',
          nameGu: 'ધૂળેટી / રંગોત્સવ પર્વ',
          shortNameHi: 'धुलेंडी',
          shortNameGu: 'ધૂળેટી',
          isMajorTehvar: true,
        );
      }
    }

    // 14. Monthly recurring Vrats (Ekadashi, Pradosh, Sankashti, Vinayaka)
    if (tithiNum == 11) {
      return (
        nameHi: isShukla ? 'शुक्ल एकादशी व्रत' : 'कृष्ण एकादशी व्रत',
        nameGu: isShukla ? 'સુદ અગિયારસ વ્રત' : 'વદ અગિયારસ વ્રત',
        shortNameHi: 'एकादशी',
        shortNameGu: 'અગિયારસ',
        isMajorTehvar: false,
      );
    }
    if (tithiNum == 13) {
      return (
        nameHi: isShukla ? 'शुक्ल प्रदोष व्रत' : 'कृष्ण प्रदोष व्रत',
        nameGu: isShukla ? 'સુદ પ્રદોષ વ્રત' : 'વદ પ્રદોષ વ્રત',
        shortNameHi: 'प्रदोष',
        shortNameGu: 'પ્રદોષ',
        isMajorTehvar: false,
      );
    }
    if (!isShukla && tithiNum == 4) {
      return (
        nameHi: 'संकष्टी चतुर्थी व्रत',
        nameGu: 'સંકષ્ટી ચોથ વ્રત',
        shortNameHi: 'संकष्टी',
        shortNameGu: 'સંકષ્ટી',
        isMajorTehvar: false,
      );
    }
    if (isShukla && tithiNum == 4) {
      return (
        nameHi: 'विनायक चतुर्थी व्रत',
        nameGu: 'વિનાયક ચોથ વ્રત',
        shortNameHi: 'विनायक',
        shortNameGu: 'વિનાયક',
        isMajorTehvar: false,
      );
    }

    return null;
  }
}
