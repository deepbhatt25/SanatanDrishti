import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/core/services/location_service.dart';
import 'package:bhagvat_geeta_app/features/panchang/models/tithi_calendar_model.dart';
import 'package:bhagvat_geeta_app/features/panchang/repositories/panchang_repository.dart';

void main() {
  group('Gujarati & Hindi Tithi Calendar Tests', () {
    const city = CityLocation(
      name: 'Ahmedabad',
      nameHindi: 'अहमदाबाद',
      nameGujarati: 'અમદાવાદ',
      latitude: 23.0225,
      longitude: 72.5714,
      timezone: 5.5,
    );

    test('19 August 2026 matches Daily Panchang exactly as Shukla Saptami (સુદ સાતમ)', () {
      final date19Aug = DateTime(2026, 8, 19);
      final panchang = PanchangRepository.calculateVedicPanchang(date19Aug, city);
      final tithiData = PanchangRepository.calculateVedicTithi(date19Aug);

      expect(tithiData.tithiNumberInPaksha, 7);
      expect(tithiData.isShukla, true);
      expect(tithiData.tithiNameGu, 'સુદ સાતમ');
      expect(tithiData.tithiNameHi, 'शुक्ल सप्तमी');
      expect(tithiData.shortTithiGu, 'સુદ ૭');
      expect(tithiData.shortTithiHi, 'शु. ७');

      expect(panchang.tithi.contains('सप्तमी') || panchang.tithi.contains('Saptami'), true);
      expect(panchang.tithiPaksha.contains('शुक्ल') || panchang.tithiPaksha.contains('Shukla'), true);
    });

    test('Raksha Bandhan is in August Purnima and Ganesh Visarjan is in September after Raksha Bandhan', () {
      final augCalendar = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 8,
        city: city,
      );
      final sepCalendar = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 9,
        city: city,
      );

      // August: Has Raksha Bandhan
      final rakshaBandhanDay = augCalendar.days.firstWhere((d) => d.isPurnima);
      expect(rakshaBandhanDay.isMajorTehvar, true);
      expect(rakshaBandhanDay.festivalHi?.contains('रक्षाबंधन'), true);
      expect(rakshaBandhanDay.festivalGu?.contains('રક્ષાબંધન'), true);

      // August MUST NOT have Ganesh Chaturthi or Ganesh Visarjan
      final augHasGanesh = augCalendar.days.any((d) =>
          (d.festivalHi?.contains('गणेश') ?? false) ||
          (d.festivalGu?.contains('ગણેશ') ?? false));
      expect(augHasGanesh, false);

      // September: Has Ganesh Chaturthi and Ganesh Visarjan
      final ganeshChaturthi = sepCalendar.days.firstWhere((d) => d.isShukla && d.tithiNumberInPaksha == 4);
      expect(ganeshChaturthi.isMajorTehvar, true);
      expect(ganeshChaturthi.festivalHi?.contains('गणेश चतुर्थी'), true);
      expect(ganeshChaturthi.festivalGu?.contains('ગણેશ ચતુર્થી'), true);

      final ganeshVisarjan = sepCalendar.days.firstWhere((d) => d.isShukla && d.tithiNumberInPaksha == 14);
      expect(ganeshVisarjan.isMajorTehvar, true);
      expect(ganeshVisarjan.festivalHi?.contains('अनंत चतुर्दशी'), true);
      expect(ganeshVisarjan.festivalGu?.contains('અનંત ચતુર્દશી'), true);
    });

    test('Generates complete 31 days for August 2026', () {
      final calendarData = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 8,
        city: city,
      );

      expect(calendarData.totalDays, 31);
      expect(calendarData.days.length, 31);
      expect(calendarData.monthNameEn, 'August');
      expect(calendarData.monthNameGu, 'ઓગસ્ટ');
      expect(calendarData.monthNameHi, 'अगस्त');
      expect(calendarData.vikramSamvat, '2083');

      expect(calendarData.days.first.day, 1);
      expect(calendarData.days.last.day, 31);
    });

    test('Identifies Purnima and Amavasya accurately', () {
      final calendarData = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 8,
        city: city,
      );

      final hasPurnima = calendarData.days.any((d) => d.isPurnima);
      final hasAmavasya = calendarData.days.any((d) => d.isAmavasya);

      expect(hasPurnima, true);
      expect(hasAmavasya, true);
    });

    test('Identifies Ekadashi in month', () {
      final calendarData = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 8,
        city: city,
      );

      final ekadashis = calendarData.days.where((d) => d.isEkadashi).toList();
      expect(ekadashis.isNotEmpty, true);

      for (final day in calendarData.days) {
        expect(day.tithiNameGu.isNotEmpty, true);
        expect(day.tithiNameHi.isNotEmpty, true);
        expect(day.shortTithiGu.isNotEmpty, true);
        expect(day.shortTithiHi.isNotEmpty, true);
      }
    });

    test('Generates accurate days for February leap and non-leap years', () {
      final nonLeap = MonthTithiCalendarData.generateMonthCalendar(
        year: 2025,
        month: 2,
        city: city,
      );
      expect(nonLeap.totalDays, 28);

      final leap = MonthTithiCalendarData.generateMonthCalendar(
        year: 2028,
        month: 2,
        city: city,
      );
      expect(leap.totalDays, 29);
    });

    test('October 2026 has Sarvapitri Amavasya, Navratri, Dussehra, Sharad Purnima, and NO duplicate Diwali', () {
      final octCalendar = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 10,
        city: city,
      );

      // 10 Oct is Sarvapitri Amavasya (Bhadrapada Vad Amavasya)
      final oct10 = octCalendar.days.firstWhere((d) => d.day == 10);
      expect(oct10.isAmavasya, true);
      expect(oct10.festivalGu?.contains('સર્વપિતૃ અમાસ'), true);
      expect(oct10.festivalGu?.contains('દિવાળી'), false);

      // October MUST NOT contain Diwali, Dhanteras, Kali Chaudas, or Bestu Varas
      final octHasDiwali = octCalendar.days.any((d) =>
          (d.festivalGu?.contains('દીપાવલી') ?? false) ||
          (d.shortFestivalGu?.contains('દિવાળી') ?? false) ||
          (d.festivalGu?.contains('ધનતેરસ') ?? false) ||
          (d.festivalGu?.contains('બેસતું વર્ષ') ?? false));
      expect(octHasDiwali, false);

      // 11 Oct is Navratri Prarambh
      final oct11 = octCalendar.days.firstWhere((d) => d.day == 11);
      expect(oct11.isShukla, true);
      expect(oct11.tithiNumberInPaksha, 1);
      expect(oct11.festivalGu?.contains('નવરાત્રી'), true);

      // 21 Oct is Dussehra
      final oct21 = octCalendar.days.firstWhere((d) => d.day == 21);
      expect(oct21.isShukla, true);
      expect(oct21.tithiNumberInPaksha, 10);
      expect(oct21.festivalGu?.contains('દશેરા'), true);

      // 26 Oct is Sharad Purnima
      final oct26 = octCalendar.days.firstWhere((d) => d.day == 26);
      expect(oct26.isPurnima, true);
      expect(oct26.festivalGu?.contains('શરદ પૂનમ'), true);
    });

    test('November 2026 has Dhanteras, Kali Chaudas, Diwali (9 Nov), Bestu Varas, Labh Pancham, and Dev Diwali', () {
      final novCalendar = MonthTithiCalendarData.generateMonthCalendar(
        year: 2026,
        month: 11,
        city: city,
      );

      // 7 Nov is Dhanteras
      final nov7 = novCalendar.days.firstWhere((d) => d.day == 7);
      expect(nov7.festivalGu?.contains('ધનતેરસ'), true);

      // 8 Nov is Kali Chaudas
      final nov8 = novCalendar.days.firstWhere((d) => d.day == 8);
      expect(nov8.festivalGu?.contains('કાળી ચૌદશ'), true);

      // 9 Nov is Diwali (Aso Vad Amavasya)
      final nov9 = novCalendar.days.firstWhere((d) => d.day == 9);
      expect(nov9.isAmavasya, true);
      expect((nov9.festivalGu?.contains('દીપાવલી') ?? false) || (nov9.festivalGu?.contains('લક્ષ્મી પૂજન') ?? false), true);

      // 10 Nov is Bestu Varas (Kartak Sud 1)
      final nov10 = novCalendar.days.firstWhere((d) => d.day == 10);
      expect(nov10.isShukla, true);
      expect(nov10.tithiNumberInPaksha, 1);
      expect(nov10.festivalGu?.contains('બેસતું વર્ષ'), true);

      // 14 Nov is Labh Pancham (Kartak Sud 5)
      final nov14 = novCalendar.days.firstWhere((d) => d.day == 14);
      expect(nov14.isShukla, true);
      expect(nov14.tithiNumberInPaksha, 5);
      expect(nov14.festivalGu?.contains('લાભ પાંચમ'), true);

      // 24 Nov is Dev Diwali (Kartak Purnima)
      final nov24 = novCalendar.days.firstWhere((d) => d.day == 24);
      expect(nov24.isPurnima, true);
      expect(nov24.festivalGu?.contains('દેવ દિવાળી'), true);
    });

    test('Generates valid Tithi calendar for past years (e.g. 1950, 1980, 2000)', () {
      final cal1950 = MonthTithiCalendarData.generateMonthCalendar(
        year: 1950,
        month: 1,
        city: city,
      );
      expect(cal1950.year, 1950);
      expect(cal1950.month, 1);
      expect(cal1950.totalDays, 31);
      expect(cal1950.days.length, 31);
      expect(cal1950.vikramSamvat.isNotEmpty, true);
      expect(cal1950.days.any((d) => d.isPurnima || d.isAmavasya), true);

      final cal2000 = MonthTithiCalendarData.generateMonthCalendar(
        year: 2000,
        month: 2,
        city: city,
      );
      expect(cal2000.year, 2000);
      expect(cal2000.totalDays, 29); // Leap year
      expect(cal2000.days.length, 29);
    });

    test('Generates valid Tithi calendar for future years (e.g. 2030, 2050)', () {
      final cal2030 = MonthTithiCalendarData.generateMonthCalendar(
        year: 2030,
        month: 10,
        city: city,
      );
      expect(cal2030.year, 2030);
      expect(cal2030.month, 10);
      expect(cal2030.totalDays, 31);
      expect(cal2030.days.length, 31);
      expect(cal2030.vikramSamvat.isNotEmpty, true);

      final cal2050 = MonthTithiCalendarData.generateMonthCalendar(
        year: 2050,
        month: 8,
        city: city,
      );
      expect(cal2050.year, 2050);
      expect(cal2050.month, 8);
      expect(cal2050.totalDays, 31);
      expect(cal2050.days.length, 31);
    });
  });
}
