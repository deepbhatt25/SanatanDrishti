import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../models/tithi_calendar_model.dart';
import '../providers/panchang_provider.dart';

class TithiCalendarWidget extends StatefulWidget {
  final VoidCallback? onDateSelectedCallback;

  const TithiCalendarWidget({
    super.key,
    this.onDateSelectedCallback,
  });

  @override
  State<TithiCalendarWidget> createState() => _TithiCalendarWidgetState();
}

class _TithiCalendarWidgetState extends State<TithiCalendarWidget> {
  late DateTime _viewMonth;
  DateTime? _lastObservedDate;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PanchangProvider>();
    _viewMonth = DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
    _lastObservedDate = provider.selectedDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<PanchangProvider>();
    if (_lastObservedDate != provider.selectedDate) {
      _lastObservedDate = provider.selectedDate;
      if (_viewMonth.year != provider.selectedDate.year || _viewMonth.month != provider.selectedDate.month) {
        setState(() {
          _viewMonth = DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
        });
      }
    }
  }

  void _previousMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _viewMonth = DateTime(now.year, now.month, 1);
    });
    final provider = context.read<PanchangProvider>();
    provider.selectDate(now);
    widget.onDateSelectedCallback?.call();
  }

  void _openMonthYearPicker(BuildContext context, bool isDark, bool isGujarati) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MonthYearPickerSheet(
        initialYear: _viewMonth.year,
        initialMonth: _viewMonth.month,
        isDark: isDark,
        isGujarati: isGujarati,
        onApply: (selectedYear, selectedMonth) {
          setState(() {
            _viewMonth = DateTime(selectedYear, selectedMonth, 1);
          });
          final provider = context.read<PanchangProvider>();
          final currentDay = provider.selectedDate.day;
          final maxDay = DateTime(selectedYear, selectedMonth + 1, 0).day;
          final safeDay = currentDay <= maxDay ? currentDay : maxDay;
          provider.selectDate(DateTime(selectedYear, selectedMonth, safeDay));
          widget.onDateSelectedCallback?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panchangProvider = context.watch<PanchangProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedDate = panchangProvider.selectedDate;
    final now = DateTime.now();
    final isCurrentMonth = _viewMonth.year == now.year && _viewMonth.month == now.month;

    final monthData = MonthTithiCalendarData.generateMonthCalendar(
      year: _viewMonth.year,
      month: _viewMonth.month,
      city: panchangProvider.selectedCity,
    );

    final selectedDayData = monthData.days.cast<CalendarDayTithi?>().firstWhere(
          (d) =>
              d != null &&
              d.date.year == selectedDate.year &&
              d.date.month == selectedDate.month &&
              d.date.day == selectedDate.day,
          orElse: () => null,
        );

    final weekdayNames = isGujarati
        ? const ['રવિ', 'સોમ', 'મંગળ', 'બુધ', 'ગુરુ', 'શુક્ર', 'શનિ']
        : const ['रवि', 'सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.gold.withAlpha(90),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(80) : AppColors.maroonPrimary.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Header: Interactive Month Navigation & Vikram Samvat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 28, color: AppColors.saffronPrimary),
                onPressed: _previousMonth,
                tooltip: isGujarati ? 'અગાઉનો મહિનો' : 'पिछला महीना',
              ),
              Expanded(
                child: Tooltip(
                  message: isGujarati ? 'માસ અને વર્ષ પસંદ કરો' : 'माह एवं वर्ष चुनें',
                  child: InkWell(
                    onTap: () => _openMonthYearPicker(context, isDark, isGujarati),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withAlpha(50) : AppColors.saffronPrimary.withAlpha(15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.gold.withAlpha(isDark ? 90 : 130),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lunar Month & Vikram Samvat
                          Text(
                            isGujarati
                                ? '${monthData.lunarMonthGu} • સંવત ${monthData.vikramSamvat}'
                                : '${monthData.lunarMonthHi} • संवत् ${monthData.vikramSamvat}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.saffronPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.saffronPrimary,
                                  ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          // Gregorian Month Year + Dropdown Arrow
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.saffronPrimary),
                              const SizedBox(width: 5),
                              Text(
                                isGujarati
                                    ? '${monthData.monthNameGu} ${_viewMonth.year}'
                                    : '${monthData.monthNameHi} ${_viewMonth.year}',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.maroonPrimary,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.maroonPrimary,
                                      ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down_rounded, size: 22, color: AppColors.saffronPrimary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 28, color: AppColors.saffronPrimary),
                onPressed: _nextMonth,
                tooltip: isGujarati ? 'આગામી મહિનો' : 'अगला महीना',
              ),
            ],
          ),

          // Quick Jump to Today if viewing another month
          if (!isCurrentMonth) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: _goToToday,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColors.saffronPrimary.withAlpha(isDark ? 45 : 20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.saffronPrimary, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.today_rounded, size: 13, color: AppColors.saffronPrimary),
                    const SizedBox(width: 4),
                    Text(
                      isGujarati
                          ? 'આજનો માસ (${DateFormat('MMM yyyy').format(now)})'
                          : 'वर्तमान माह (${DateFormat('MMM yyyy').format(now)})',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // 2. Weekday Header Row (Sun - Sat)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withAlpha(60) : AppColors.saffronPrimary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: weekdayNames.asMap().entries.map((entry) {
                final idx = entry.key;
                final name = entry.value;
                final isSunday = idx == 0;

                return Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isSunday
                                ? Colors.redAccent
                                : (isDark ? AppColors.goldLight : AppColors.textPrimaryLight),
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isSunday
                                ? Colors.redAccent
                                : (isDark ? AppColors.goldLight : AppColors.textPrimaryLight),
                          ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // 3. Calendar Day Grid (7 columns, Center Aligned, Highlighted Tehvars)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: monthData.firstWeekdayOffset + monthData.totalDays,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              if (index < monthData.firstWeekdayOffset) {
                // Empty leading cell
                return const SizedBox.shrink();
              }

              final dayIndex = index - monthData.firstWeekdayOffset;
              final dayData = monthData.days[dayIndex];
              final isSelected = dayData.date.year == selectedDate.year &&
                  dayData.date.month == selectedDate.month &&
                  dayData.date.day == selectedDate.day;

              final isSunday = (index % 7) == 0;
              final shortFest = isGujarati ? dayData.shortFestivalGu : dayData.shortFestivalHi;
              final hasFest = shortFest != null && shortFest.isNotEmpty;

              return InkWell(
                onTap: () {
                  panchangProvider.selectDate(dayData.date);
                  widget.onDateSelectedCallback?.call();
                },
                borderRadius: BorderRadius.circular(9),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFF8C00), Color(0xFFE65100)],
                          )
                        : (dayData.isMajorTehvar
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFFF9800).withAlpha(isDark ? 65 : 35),
                                  const Color(0xFFFFD54F).withAlpha(isDark ? 50 : 20),
                                ],
                              )
                            : (dayData.isToday
                                ? LinearGradient(
                                    colors: [
                                      AppColors.gold.withAlpha(isDark ? 60 : 35),
                                      AppColors.saffronPrimary.withAlpha(isDark ? 50 : 25),
                                    ],
                                  )
                                : null)),
                    color: !isSelected && !dayData.isMajorTehvar && !dayData.isToday
                        ? (isDark ? Colors.black.withAlpha(40) : Colors.white)
                        : null,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.goldLight
                          : (dayData.isMajorTehvar
                              ? const Color(0xFFFF9800)
                              : (dayData.isToday
                                  ? AppColors.saffronPrimary
                                  : (dayData.isPurnima || dayData.isAmavasya
                                      ? AppColors.gold.withAlpha(150)
                                      : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)))),
                      width: isSelected ? 1.8 : (dayData.isMajorTehvar ? 1.5 : (dayData.isToday ? 1.3 : 0.8)),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gregorian Day Number (Center Aligned)
                      Text(
                        '${dayData.day}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isSunday ? Colors.redAccent : (isDark ? Colors.white : AppColors.textPrimaryLight)),
                        ),
                      ),

                      const SizedBox(height: 1),

                      // Detailed Tithi Label (Center Aligned)
                      Text(
                        isGujarati ? dayData.shortTithiGu : dayData.shortTithiHi,
                        textAlign: TextAlign.center,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 9.2,
                                fontWeight: (dayData.isPurnima || dayData.isAmavasya || dayData.isEkadashi)
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (dayData.isPurnima
                                        ? const Color(0xFFD4AF37)
                                        : (dayData.isAmavasya
                                            ? (isDark ? Colors.white70 : Colors.black87)
                                            : (dayData.isEkadashi
                                                ? AppColors.saffronPrimary
                                                : (isDark ? Colors.white70 : AppColors.textSecondaryLight)))),
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 9.2,
                                fontWeight: (dayData.isPurnima || dayData.isAmavasya || dayData.isEkadashi)
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (dayData.isPurnima
                                        ? const Color(0xFFD4AF37)
                                        : (dayData.isAmavasya
                                            ? (isDark ? Colors.white70 : Colors.black87)
                                            : (dayData.isEkadashi
                                                ? AppColors.saffronPrimary
                                                : (isDark ? Colors.white70 : AppColors.textSecondaryLight)))),
                              ),
                        maxLines: 1,
                      ),

                      // Highlighted Tehvar / Festival Tag or Dot
                      if (hasFest && dayData.isMajorTehvar) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withAlpha(220) : const Color(0xFFFF9800),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            shortFest,
                            textAlign: TextAlign.center,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 7.2,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? const Color(0xFFE65100) : Colors.white,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 7.2,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? const Color(0xFFE65100) : Colors.white,
                                  ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else if (hasFest || dayData.isPurnima || dayData.isAmavasya || dayData.isEkadashi) ...[
                        const SizedBox(height: 3),
                        Container(
                          width: 4.5,
                          height: 4.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.white
                                : (dayData.isPurnima
                                    ? const Color(0xFFD4AF37)
                                    : (dayData.isEkadashi
                                        ? AppColors.saffronPrimary
                                        : (dayData.isAmavasya
                                            ? (isDark ? Colors.white70 : Colors.black87)
                                            : AppColors.saffronPrimary))),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 4. Selected Day Summary & Festival Details Banner (Center Aligned, Highlighted Tehvars)
          if (selectedDayData != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(colors: [Color(0xFF381B14), Color(0xFF220E09)])
                    : const LinearGradient(colors: [Color(0xFFFFF8EC), Color(0xFFFFECC8)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selectedDayData.isMajorTehvar
                      ? const Color(0xFFFF9800)
                      : (isDark ? AppColors.cardBorderDark : AppColors.gold.withAlpha(120)),
                  width: selectedDayData.isMajorTehvar ? 1.4 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_available_rounded, size: 18, color: AppColors.saffronPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isGujarati
                              ? '${DateFormat('d MMMM yyyy').format(selectedDayData.date)} — ${selectedDayData.tithiNameGu}'
                              : '${DateFormat('d MMMM yyyy').format(selectedDayData.date)} — ${selectedDayData.tithiNameHi}',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.maroonPrimary,
                                ),
                        ),
                      ),
                    ],
                  ),
                  if ((isGujarati ? selectedDayData.festivalGu : selectedDayData.festivalHi) != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          selectedDayData.isMajorTehvar ? Icons.celebration_rounded : Icons.stars_rounded,
                          size: 17,
                          color: selectedDayData.isMajorTehvar ? const Color(0xFFFF9800) : AppColors.gold,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isGujarati
                                ? '${selectedDayData.isMajorTehvar ? 'તહેવાર' : 'વ્રત'}: ${selectedDayData.festivalGu}'
                                : '${selectedDayData.isMajorTehvar ? 'त्योहार' : 'व्रत'}: ${selectedDayData.festivalHi}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 12.8,
                                    fontWeight: FontWeight.bold,
                                    color: selectedDayData.isMajorTehvar
                                        ? (isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100))
                                        : AppColors.saffronPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 12.8,
                                    fontWeight: FontWeight.bold,
                                    color: selectedDayData.isMajorTehvar
                                        ? (isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100))
                                        : AppColors.saffronPrimary,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthYearPickerSheet extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final bool isDark;
  final bool isGujarati;
  final void Function(int year, int month) onApply;

  const _MonthYearPickerSheet({
    required this.initialYear,
    required this.initialMonth,
    required this.isDark,
    required this.isGujarati,
    required this.onApply,
  });

  @override
  State<_MonthYearPickerSheet> createState() => _MonthYearPickerSheetState();
}

class _MonthYearPickerSheetState extends State<_MonthYearPickerSheet> {
  late int _selectedYear;
  late int _selectedMonth;

  static const List<String> _monthsHi = [
    'जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
    'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
  ];

  static const List<String> _monthsGu = [
    'જાન્યુઆરી', 'ફેબ્રુઆરી', 'માર્ચ', 'એપ્રિલ', 'મે', 'જૂન',
    'જુલાઈ', 'ઓગસ્ટ', 'સપ્ટેમ્બર', 'ઓક્ટોબર', 'નવેમ્બર', 'ડિસેમ્બર'
  ];

  static const List<String> _monthsEnShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _selectedMonth = widget.initialMonth;
  }

  void _showYearPickerDialog() async {
    final pickedYear = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: widget.isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            widget.isGujarati ? 'વર્ષ પસંદ કરો (1900 - 2100)' : 'वर्ष चुनें (1900 - 2100)',
            style: widget.isGujarati
                ? GoogleFonts.notoSerifGujarati(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.saffronPrimary)
                : GoogleFonts.notoSerifDevanagari(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.saffronPrimary),
          ),
          content: SizedBox(
            width: 300,
            height: 320,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              selectedDate: DateTime(_selectedYear, _selectedMonth, 1),
              onChanged: (DateTime dateTime) {
                Navigator.pop(ctx, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null) {
      setState(() {
        _selectedYear = pickedYear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isGujarati = widget.isGujarati;
    final now = DateTime.now();

    // Generate sample preview of Vikram Samvat for the selected month/year
    final previewCal = MonthTithiCalendarData.generateMonthCalendar(
      year: _selectedYear,
      month: _selectedMonth,
      city: context.read<PanchangProvider>().selectedCity,
    );

    // Quick year list around selected year
    final quickYears = <int>{
      now.year - 2,
      now.year - 1,
      now.year,
      now.year + 1,
      now.year + 2,
      _selectedYear,
    }.toList()..sort();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title & Samvat Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGujarati ? 'માસ અને વર્ષ પસંદ કરો' : 'माह एवं वर्ष चुनें',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.maroonPrimary,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.maroonPrimary,
                          ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGujarati
                        ? '${previewCal.lunarMonthGu} • સંવત ${previewCal.vikramSamvat}'
                        : '${previewCal.lunarMonthHi} • संवत् ${previewCal.vikramSamvat}',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.saffronPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Year Selector Stepper + Full Picker Dialog Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withAlpha(40) : AppColors.saffronPale,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withAlpha(90)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 24, color: AppColors.saffronPrimary),
                  onPressed: () {
                    setState(() {
                      _selectedYear--;
                    });
                  },
                  tooltip: isGujarati ? 'અગાઉનું વર્ષ' : 'पिछला वर्ष',
                ),
                InkWell(
                  onTap: _showYearPickerDialog,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.saffronPrimary.withAlpha(100)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_calendar_rounded, size: 16, color: AppColors.saffronPrimary),
                        const SizedBox(width: 8),
                        Text(
                          '$_selectedYear',
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.maroonPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded, size: 20, color: AppColors.saffronPrimary),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.saffronPrimary),
                  onPressed: () {
                    setState(() {
                      _selectedYear++;
                    });
                  },
                  tooltip: isGujarati ? 'આગામી વર્ષ' : 'अगला वर्ष',
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Quick Year Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quickYears.map((yr) {
                final isSelected = yr == _selectedYear;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      '$yr',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textSecondaryLight),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.saffronPrimary,
                    backgroundColor: isDark ? Colors.black.withAlpha(30) : AppColors.bgLight,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedYear = yr;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // 12 Months Grid (4 rows x 3 columns)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.3,
            ),
            itemBuilder: (context, idx) {
              final monthNum = idx + 1;
              final isSelected = monthNum == _selectedMonth;
              final isCurrent = monthNum == now.month && _selectedYear == now.year;
              final monthName = isGujarati ? _monthsGu[idx] : _monthsHi[idx];
              final enShort = _monthsEnShort[idx];

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedMonth = monthNum;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.saffronPrimary, AppColors.maroonPrimary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected
                        ? null
                        : (isDark ? Colors.black.withAlpha(40) : AppColors.bgLight),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gold
                          : (isCurrent
                              ? AppColors.saffronPrimary
                              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)),
                      width: isSelected ? 1.5 : (isCurrent ? 1.2 : 0.8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        monthName,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : AppColors.textPrimaryLight),
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : AppColors.textPrimaryLight),
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$monthNum • $enShort',
                        style: GoogleFonts.outfit(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.goldLight : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Bottom Action Buttons
          Row(
            children: [
              // Today / Current Month Quick Jump
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedYear = now.year;
                      _selectedMonth = now.month;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.saffronPrimary,
                    side: const BorderSide(color: AppColors.saffronPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.today_rounded, size: 16),
                  label: Text(
                    isGujarati ? 'આ મહિનો' : 'यह माह',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 12.5, fontWeight: FontWeight.bold)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Apply Button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(_selectedYear, _selectedMonth);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maroonPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.check_circle_rounded, color: AppColors.goldLight, size: 18),
                  label: Text(
                    isGujarati ? 'લાગુ કરો' : 'लागू करें',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 13.5, fontWeight: FontWeight.bold)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 13.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
