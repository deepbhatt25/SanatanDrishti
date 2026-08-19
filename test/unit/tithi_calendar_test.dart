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
  });
}
