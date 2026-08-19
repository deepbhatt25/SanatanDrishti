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

  @override
  void initState() {
    super.initState();
    final provider = context.read<PanchangProvider>();
    _viewMonth = DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
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

  @override
  Widget build(BuildContext context) {
    final panchangProvider = context.watch<PanchangProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedDate = panchangProvider.selectedDate;

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
          // 1. Header: Month Navigation & Vikram Samvat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 28, color: AppColors.saffronPrimary),
                onPressed: _previousMonth,
                tooltip: isGujarati ? 'અગાઉનો મહિનો' : 'पिछला महीना',
              ),
              Expanded(
                child: Column(
                  children: [
                    // Lunar Month & Vikram Samvat
                    Text(
                      isGujarati
                          ? '${monthData.lunarMonthGu} • સંવત ${monthData.vikramSamvat}'
                          : '${monthData.lunarMonthHi} • संवत् ${monthData.vikramSamvat}',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    // Gregorian Month Year
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
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 28, color: AppColors.saffronPrimary),
                onPressed: _nextMonth,
                tooltip: isGujarati ? 'આગામી મહિનો' : 'अगला महीना',
              ),
            ],
          ),

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
