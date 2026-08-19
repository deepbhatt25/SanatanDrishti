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

      // Authentic Vedic Festival & Tehvar detection
      final fest = _detectFestival(date, month, isShukla, tithiNumberInPaksha, isPurnima, isAmavasya);

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

    const lunarMonthsHi = [
      'पौष - माघ', 'माघ - फाल्गुन', 'फाल्गुन - चैत्र', 'चैत्र - वैशाख',
      'वैशाख - ज्येष्ठ', 'ज्येष्ठ - आषाढ़', 'आषाढ़ - श्रावण', 'श्रावण - भाद्रपद',
      'भाद्रपद - आश्विन', 'आश्विन - कार्तिक', 'कार्तिक - मार्गशीर्ष', 'मार्गशीर्ष - पौष'
    ];
    const lunarMonthsGu = [
      'પોષ - મહા', 'મહા - ફાગણ', 'ફાગણ - ચૈત્ર', 'ચૈત્ર - વૈશાખ',
      'વૈશાખ - જેઠ', 'જેઠ - અષાઢ', 'અષાઢ - શ્રાવણ', 'શ્રાવણ - ભાદરવો',
      'ભાદરવો - આસો', 'આસો - કારતક', 'કારતક - માગશર', 'માગશર - પોષ'
    ];

    return MonthTithiCalendarData(
      year: year,
      month: month,
      monthNameEn: monthNamesEn[month - 1],
      monthNameHi: monthNamesHi[month - 1],
      monthNameGu: monthNamesGu[month - 1],
      vikramSamvat: '${year + 57}',
      shakaSamvat: '${year - 78}',
      lunarMonthHi: lunarMonthsHi[month - 1],
      lunarMonthGu: lunarMonthsGu[month - 1],
      days: days,
      firstWeekdayOffset: firstWeekday,
      totalDays: totalDays,
    );
  }

  static ({String nameHi, String nameGu, String shortNameHi, String shortNameGu, bool isMajorTehvar})? _detectFestival(
    DateTime date,
    int month,
    bool isShukla,
    int tithiNum,
    bool isPurnima,
    bool isAmavasya,
  ) {
    // 1. January: Makar Sankranti & Uttarayan
    if (month == 1 && date.day == 14) {
      return (
        nameHi: 'मकर संक्रांति / पोंगल महापर्व',
        nameGu: 'મકરસંક્રાંતિ / ઉત્તરાયણ પર્વ',
        shortNameHi: 'मकर संक्रांति',
        shortNameGu: 'ઉત્તરાયણ',
        isMajorTehvar: true,
      );
    }
    if (month == 1 && date.day == 15) {
      return (
        nameHi: 'उत्तरायण पर्व / वासी उत्तरायण',
        nameGu: 'વાસી ઉત્તરાયણ',
        shortNameHi: 'उत्तरायण',
        shortNameGu: 'વાસી ઉત્તરાયણ',
        isMajorTehvar: true,
      );
    }

    // 2. Vasant Panchami / Saraswati Puja (Jan/Feb)
    if ((month == 1 || month == 2) && isShukla && tithiNum == 5) {
      return (
        nameHi: 'वसन्त पंचमी / सरस्वती पूजा',
        nameGu: 'વસંત પંચમી / સરસ્વતી પૂજા',
        shortNameHi: 'वसन्त पंचमी',
        shortNameGu: 'વસંત પંચમી',
        isMajorTehvar: true,
      );
    }

    // 3. Maha Shivratri (Feb/March - Krishna Chaturdashi)
    if ((month == 2 || month == 3) && !isShukla && tithiNum == 14) {
      return (
        nameHi: 'महाशिवरात्रि महापर्व',
        nameGu: 'મહાશિવરાત્રી મહોત્સવ',
        shortNameHi: 'महाशिवरात्रि',
        shortNameGu: 'મહાશિવરાત્રી',
        isMajorTehvar: true,
      );
    }

    // 4. Holi & Dhuleti (March/April - Phalguna Purnima & Chaitra Krishna 1)
    if ((month == 3 || month == 4) && isShukla && tithiNum == 15) {
      return (
        nameHi: 'होलिका दहन / फाल्गुन पूर्णिमा',
        nameGu: 'હોલિકા દહન / પૂનમ',
        shortNameHi: 'होलिका दहन',
        shortNameGu: 'હોલિકા દહન',
        isMajorTehvar: true,
      );
    }
    if ((month == 3 || month == 4) && !isShukla && tithiNum == 1) {
      return (
        nameHi: 'धुलेंडी / रंगोत्सव / होली',
        nameGu: 'ધૂળેટી / રંગોત્સવ પર્વ',
        shortNameHi: 'धुलेंडी',
        shortNameGu: 'ધૂળેટી',
        isMajorTehvar: true,
      );
    }

    // 5. Chaitra Navratri / Gudi Padwa, Ram Navami, Hanuman Jayanti (March/April)
    if ((month == 3 || month == 4) && isShukla && tithiNum == 1) {
      return (
        nameHi: 'चैत्र नवरात्रि / गुड़ी पड़वा',
        nameGu: 'ચૈત્ર નવરાત્રી / ગુડી પડવો',
        shortNameHi: 'गुड़ी पड़वा',
        shortNameGu: 'ચૈત્ર નવરાત્રી',
        isMajorTehvar: true,
      );
    }
    if ((month == 3 || month == 4) && isShukla && tithiNum == 9) {
      return (
        nameHi: 'श्री राम नवमी जन्मोत्सव',
        nameGu: 'શ્રી રામ નવમી મહોત્સવ',
        shortNameHi: 'राम नवमी',
        shortNameGu: 'રામ નવમી',
        isMajorTehvar: true,
      );
    }
    if ((month == 3 || month == 4) && isShukla && tithiNum == 15) {
      return (
        nameHi: 'श्री हनुमान जयंती जन्मोत्सव',
        nameGu: 'શ્રી હનુમાન જયંતિ મહોત્સવ',
        shortNameHi: 'हनुमान जयंती',
        shortNameGu: 'હનુમાન જયંતિ',
        isMajorTehvar: true,
      );
    }

    // 6. Akshaya Tritiya (April/May - Vaishakha Sud 3)
    if ((month == 4 || month == 5) && isShukla && tithiNum == 3) {
      return (
        nameHi: 'अक्षय तृतीया / आखा तीज',
        nameGu: 'અક્ષય તૃતીયા / અખાત્રીજ',
        shortNameHi: 'अक्षय तृतीया',
        shortNameGu: 'અખાત્રીજ',
        isMajorTehvar: true,
      );
    }

    // 7. Jagannath Ratha Yatra & Guru Purnima (June/July - Ashadha Sud 2 & Sud 15)
    if ((month == 6 || month == 7) && isShukla && tithiNum == 2) {
      return (
        nameHi: 'जगन्नाथ रथयात्रा',
        nameGu: 'જગન્નાથ રથયાત્રા',
        shortNameHi: 'रथयात्रा',
        shortNameGu: 'રથયાત્રા',
        isMajorTehvar: true,
      );
    }
    if (month == 7 && isShukla && tithiNum == 15) {
      return (
        nameHi: 'गुरु पूर्णिमा / व्यास पूजा',
        nameGu: 'ગુરુ પૂર્ણિમા / વ્યાસ પૂજા',
        shortNameHi: 'गुरु पूर्णिमा',
        shortNameGu: 'ગુરુ પૂર્ણિમા',
        isMajorTehvar: true,
      );
    }

    // 8. Shravana Month (August): Raksha Bandhan / Balev (Shravana Sud 15)
    if (month == 8 && (isPurnima || (isShukla && tithiNum == 15))) {
      return (
        nameHi: 'रक्षाबंधन / श्रावणी पूर्णिमा',
        nameGu: 'રક્ષાબંધન / બળેવ પર્વ',
        shortNameHi: 'रक्षाबंधन',
        shortNameGu: 'રક્ષાબંધન',
        isMajorTehvar: true,
      );
    }

    // 9. Shravana Vad (September 2026): Shitala Satam & Shri Krishna Janmashtami (ALWAYS after Raksha Bandhan)
    if (month == 9 && !isShukla && tithiNum == 7) {
      return (
        nameHi: 'शीतला सातम / शीतला सप्तमी',
        nameGu: 'શીતળા સાતમ / રાંધણ છઠ',
        shortNameHi: 'शीतला सातम',
        shortNameGu: 'શીતળા સાતમ',
        isMajorTehvar: true,
      );
    }
    if (month == 9 && !isShukla && tithiNum == 8) {
      return (
        nameHi: 'श्रीकृष्ण जन्माष्टमी / गोकुळाष्टमी',
        nameGu: 'શ્રીકૃષ્ણ જન્માષ્ટમી મહોત્સવ',
        shortNameHi: 'जन्माष्टमी',
        shortNameGu: 'જન્માષ્ટમી',
        isMajorTehvar: true,
      );
    }

    // 10. Bhadrapada Month (SEPTEMBER ONLY): Ganesh Chaturthi, Rishi Panchami & Anant Chaturdashi (Ganesh Visarjan)
    // NOTE: Ganesh Chaturthi & Visarjan are ALWAYS in Bhadrapada (September), strictly AFTER Raksha Bandhan!
    if (month == 9 && isShukla && tithiNum == 4) {
      return (
        nameHi: 'श्री गणेश चतुर्थी / गणेशोत्सव',
        nameGu: 'શ્રી ગણેશ ચતુર્થી / ગણેશોત્સવ',
        shortNameHi: 'गणेश चतुर्थी',
        shortNameGu: 'ગણેશ ચતુર્થી',
        isMajorTehvar: true,
      );
    }
    if (month == 9 && isShukla && tithiNum == 5) {
      return (
        nameHi: 'ऋषि पंचमी व्रत',
        nameGu: 'ઋષિ પાંચમ વ્રત',
        shortNameHi: 'ऋषि पंचमी',
        shortNameGu: 'ઋષિ પાંચમ',
        isMajorTehvar: false,
      );
    }
    if (month == 9 && isShukla && tithiNum == 14) {
      return (
        nameHi: 'अनंत चतुर्दशी / गणेश विसर्जन',
        nameGu: 'અનંત ચતુર્દશી / ગણેશ વિસર્જન',
        shortNameHi: 'अनंत चतुर्दशी',
        shortNameGu: 'અનંત ચૌદશ',
        isMajorTehvar: true,
      );
    }

    // 11. Bhadrapada / Ashvina Krishna: Pitru Paksha / Shraddha (September/October)
    if ((month == 9 || month == 10) && !isShukla && date.day >= 20) {
      if (isAmavasya || tithiNum == 15) {
        return (
          nameHi: 'सर्वपितृ अमावस्या / महालय श्राद्ध',
          nameGu: 'સર્વપિતૃ અમાસ / શ્રાદ્ધ તર્પણ',
          shortNameHi: 'सर्वपितृ અમાસ',
          shortNameGu: 'સર્વપિત્રી અમાસ',
          isMajorTehvar: true,
        );
      }
    }

    // 12. Ashvina Month (October): Sharad Navratri, Durga Ashtami, Dussehra, Sharad Purnima
    if (month == 10 && isShukla && tithiNum == 1) {
      return (
        nameHi: 'शारदीय नवरात्रि प्रारंभ / घटस्थापना',
        nameGu: 'શારદીય નવરાત્રી પ્રારંભ / ઘટસ્થાપના',
        shortNameHi: 'नवरात्रि',
        shortNameGu: 'નવરાત્રી',
        isMajorTehvar: true,
      );
    }
    if (month == 10 && isShukla && tithiNum == 8) {
      return (
        nameHi: 'महाअष्टमी / दुर्गाष्टमी पूजन',
        nameGu: 'દુર્ગા અષ્ટમી / આસો સુદ આઠમ',
        shortNameHi: 'दुर्गाष्टमी',
        shortNameGu: 'દુર્ગાષ્ટમી',
        isMajorTehvar: true,
      );
    }
    if (month == 10 && isShukla && tithiNum == 10) {
      return (
        nameHi: 'विजयादशमी / दशहरा महापर्व',
        nameGu: 'વિજયાદશમી / દશેરા પર્વ',
        shortNameHi: 'दशहरा',
        shortNameGu: 'દશેરા',
        isMajorTehvar: true,
      );
    }
    if (month == 10 && (isPurnima || (isShukla && tithiNum == 15))) {
      return (
        nameHi: 'शरद पूर्णिमा / कोजागरी व्रत',
        nameGu: 'શરદ પૂનમ / માણેકઠારી પૂનમ',
        shortNameHi: 'शरद पूर्णिमा',
        shortNameGu: 'શરદ પૂનમ',
        isMajorTehvar: true,
      );
    }

    // 13. Diwali Festival Season (Oct / Nov): Dhanteras, Kali Chaudas, Diwali
    if ((month == 10 || month == 11) && !isShukla && tithiNum == 13) {
      return (
        nameHi: 'धनतेरस / धन्वंतरि जयंती',
        nameGu: 'ધનતેરસ / લક્ષ્મી પૂજન',
        shortNameHi: 'धनतेरस',
        shortNameGu: 'ધનતેરસ',
        isMajorTehvar: true,
      );
    }
    if ((month == 10 || month == 11) && !isShukla && tithiNum == 14) {
      return (
        nameHi: 'काली चौदस / रूप चौदस',
        nameGu: 'કાળી ચૌદશ / હનુમાન પૂજન',
        shortNameHi: 'काली चौदस',
        shortNameGu: 'કાળી ચૌદશ',
        isMajorTehvar: true,
      );
    }
    if ((month == 10 || month == 11) && !isShukla && (tithiNum == 15 || isAmavasya)) {
      return (
        nameHi: 'दीपावली / महालक्ष्मी पूजन',
        nameGu: 'દીપાવલી / લક્ષ્મી પૂજન',
        shortNameHi: 'दीपावली',
        shortNameGu: 'દિવાળી',
        isMajorTehvar: true,
      );
    }

    // 14. Kartika Month (Oct / Nov): Bestu Varas (New Year), Bhai Dooj, Labh Pancham, Tulsi Vivah, Dev Diwali
    if ((month == 10 || month == 11) && isShukla && tithiNum == 1 && date.day >= 15) {
      return (
        nameHi: 'गोवर्धन पूजा / नूतन वर्ष / अन्नकूट',
        nameGu: 'બેસતું વર્ષ / નૂતન વર્ષાભિનંદન',
        shortNameHi: 'नूतन वर्ष',
        shortNameGu: 'બેસતું વર્ષ',
        isMajorTehvar: true,
      );
    }
    if ((month == 10 || month == 11) && isShukla && tithiNum == 2 && date.day >= 15) {
      return (
        nameHi: 'भाई दूज / यम द्वितीया',
        nameGu: 'ભાઈબીજ / યમ દ્વિતીયા',
        shortNameHi: 'भाई दूज',
        shortNameGu: 'ભાઈબીજ',
        isMajorTehvar: true,
      );
    }
    if ((month == 10 || month == 11) && isShukla && tithiNum == 5 && date.day >= 15) {
      return (
        nameHi: 'लाभ पंचमी / ज्ञान पंचमी',
        nameGu: 'લાભ પાંચમ / વેપાર મુહૂર્ત',
        shortNameHi: 'लाभ पंचमी',
        shortNameGu: 'લાભ પાંચમ',
        isMajorTehvar: true,
      );
    }
    if (month == 11 && isShukla && tithiNum == 11) {
      return (
        nameHi: 'देवउठनी एकादशी / तुलसी विवाह',
        nameGu: 'દેવઉઠી અગિયારસ / તુલસી વિવાહ',
        shortNameHi: 'तुलसी विवाह',
        shortNameGu: 'તુલસી વિવાહ',
        isMajorTehvar: true,
      );
    }
    if (month == 11 && (isPurnima || (isShukla && tithiNum == 15))) {
      return (
        nameHi: 'देव दीपावली / कार्तिक पूर्णिमा',
        nameGu: 'દેવ દિવાળી / ત્રિપુરારી પૂનમ',
        shortNameHi: 'देव दीपावली',
        shortNameGu: 'દેવ દિવાળી',
        isMajorTehvar: true,
      );
    }

    // 15. Gita Jayanti (December - Margashirsha Sud 11)
    if (month == 12 && isShukla && tithiNum == 11) {
      return (
        nameHi: 'श्रीमद्भगवद्गीता जयंती / मोक्षदा एकादशी',
        nameGu: 'શ્રીમદ્ ભગવદ્ ગીતા જયંતી / મોક્ષદા અગિયારસ',
        shortNameHi: 'गीता जयंती',
        shortNameGu: 'ગીતા જયંતી',
        isMajorTehvar: true,
      );
    }

    // 16. Monthly recurring Vrats (Ekadashi, Pradosh, Sankashti, Vinayaka)
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
