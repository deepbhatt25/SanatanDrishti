import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../models/panchang_model.dart';

class PanchangCard extends StatelessWidget {
  final PanchangModel panchang;

  const PanchangCard({super.key, required this.panchang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    final tithiLocalized = panchang.getLocalizedTithi(currentLang);
    final prevTithiLocalized = panchang.getLocalizedPrevTithi(currentLang);
    final nextTithiLocalized = panchang.getLocalizedNextTithi(currentLang);

    final pakshaLocalized = panchang.getLocalizedPaksha(currentLang);

    final nakshatraLocalized = panchang.getLocalizedNakshatra(currentLang);
    final prevNakshatraLocalized = panchang.getLocalizedPrevNakshatra(currentLang);
    final nextNakshatraLocalized = panchang.getLocalizedNextNakshatra(currentLang);

    final yogaLocalized = panchang.getLocalizedYoga(currentLang);
    final prevYogaLocalized = panchang.getLocalizedPrevYoga(currentLang);
    final nextYogaLocalized = panchang.getLocalizedNextYoga(currentLang);

    final karanaLocalized = panchang.getLocalizedKarana(currentLang);
    final prevKaranaLocalized = panchang.getLocalizedPrevKarana(currentLang);
    final nextKaranaLocalized = panchang.getLocalizedNextKarana(currentLang);

    final rashiLocalized = panchang.getLocalizedRashi(currentLang);
    final prevRashiLocalized = panchang.getLocalizedPrevRashi(currentLang);
    final nextRashiLocalized = panchang.getLocalizedNextRashi(currentLang);

    final sunRashiLocalized = panchang.getLocalizedSunRashi(currentLang);
    final prevSunRashiLocalized = panchang.getLocalizedPrevSunRashi(currentLang);
    final nextSunRashiLocalized = panchang.getLocalizedNextSunRashi(currentLang);

    final vaarLocalized = panchang.getLocalizedVaar(currentLang);
    final prevVaarLocalized = panchang.getLocalizedPrevVaar(currentLang);
    final nextVaarLocalized = panchang.getLocalizedNextVaar(currentLang);

    final samvatLocalized = isGujarati
        ? 'સંવત ${langProvider.formatNumber(int.tryParse(panchang.vikramSamvat) ?? 2083)}'
        : 'संवत् ${panchang.vikramSamvat}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Vikram Samvat & Paksha Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.saffronMedium.withAlpha(90) : AppColors.saffronLight,
                  ),
                ),
                child: Text(
                  pakshaLocalized,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                        ),
                ),
              ),
              Text(
                '$samvatLocalized • ${panchang.lunarMonth.split(' ').first}',
                style: isGujarati
                    ? GoogleFonts.notoSerifGujarati(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      )
                    : GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Primary Tithi Highlight with Timing & Previous/Upcoming Flow
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        AppColors.maroonDark.withAlpha(120),
                        AppColors.cardDark,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : LinearGradient(
                      colors: [
                        AppColors.saffronPale.withAlpha(150),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.gold.withAlpha(80) : AppColors.saffronLight,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${AppStrings.tithi(currentLang)} (Tithi)',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tithiLocalized,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                  textAlign: TextAlign.center,
                ),

                // Tithi Start & End Time
                if (panchang.tithiEndTime.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withAlpha(60) : Colors.white.withAlpha(200),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.gold.withAlpha(50) : AppColors.saffronLight.withAlpha(120),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppColors.saffronPrimary),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            panchang.tithiStartTime.isNotEmpty
                                ? '${panchang.tithiStartTime} – ${panchang.tithiEndTime}'
                                : '${isGujarati ? 'સમાપ્તિ' : 'समाप्ति'}: ${panchang.tithiEndTime}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Previous & Upcoming Tithi Transition
                if (prevTithiLocalized.isNotEmpty || nextTithiLocalized.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (prevTithiLocalized.isNotEmpty)
                          Expanded(
                            child: Text(
                              '${isGujarati ? 'પહેલાં' : 'पूर्व'}: ${_cleanName(prevTithiLocalized)}',
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 10,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    )
                                  : GoogleFonts.notoSerifDevanagari(
                                      fontSize: 10,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (nextTithiLocalized.isNotEmpty)
                          Expanded(
                            child: Text(
                              '${isGujarati ? 'આગામી' : 'आगामी'}: ${_cleanName(nextTithiLocalized)}',
                              textAlign: TextAlign.end,
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    )
                                  : GoogleFonts.notoSerifDevanagari(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 2x2 Grid: Nakshatra, Yoga, Karana, Weekday
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAngaCell(
                  context,
                  title: '${AppStrings.nakshatra(currentLang)} (Nakshatra)',
                  value: nakshatraLocalized,
                  startTime: panchang.nakshatraStartTime,
                  endTime: panchang.nakshatraEndTime,
                  prevValue: prevNakshatraLocalized,
                  nextValue: nextNakshatraLocalized,
                  icon: Icons.auto_awesome_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAngaCell(
                  context,
                  title: '${AppStrings.yoga(currentLang)} (Yoga)',
                  value: yogaLocalized,
                  startTime: panchang.yogaStartTime,
                  endTime: panchang.yogaEndTime,
                  prevValue: prevYogaLocalized,
                  nextValue: nextYogaLocalized,
                  icon: Icons.spa_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAngaCell(
                  context,
                  title: '${AppStrings.karana(currentLang)} (Karana)',
                  value: karanaLocalized,
                  startTime: panchang.karanaStartTime,
                  endTime: panchang.karanaEndTime,
                  prevValue: prevKaranaLocalized,
                  nextValue: nextKaranaLocalized,
                  icon: Icons.adjust_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAngaCell(
                  context,
                  title: '${AppStrings.vaar(currentLang)} (Weekday)',
                  value: vaarLocalized,
                  startTime: panchang.vaarStartTime,
                  endTime: panchang.vaarEndTime,
                  prevValue: prevVaarLocalized,
                  nextValue: nextVaarLocalized,
                  icon: Icons.calendar_today_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Moon Rashi & Sun Rashi Transition Strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chandra Rashi (Moon Sign)
                Row(
                  children: [
                    const Icon(Icons.nightlight_round, size: 14, color: AppColors.saffronPrimary),
                    const SizedBox(width: 6),
                    Text(
                      isGujarati ? 'ચંદ્ર રાશિ (Moon Sign):' : 'चन्द्र राशि (Moon Sign):',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        rashiLocalized,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (panchang.rashiStartTime.isNotEmpty || panchang.rashiEndTime.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${panchang.rashiStartTime} – ${panchang.rashiEndTime}',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
                if (prevRashiLocalized.isNotEmpty || nextRashiLocalized.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prevRashiLocalized.isNotEmpty)
                        Flexible(
                          child: Text(
                            '${isGujarati ? 'પહેલાં' : 'पूर्व'}: ${_cleanName(prevRashiLocalized)}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(fontSize: 9.5, color: isDark ? Colors.white54 : Colors.black45)
                                : GoogleFonts.notoSerifDevanagari(fontSize: 9.5, color: isDark ? Colors.white54 : Colors.black45),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (nextRashiLocalized.isNotEmpty)
                        Flexible(
                          child: Text(
                            '${isGujarati ? 'આગામી' : 'आगामी'}: ${_cleanName(nextRashiLocalized)}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(fontSize: 9.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                                : GoogleFonts.notoSerifDevanagari(fontSize: 9.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),

                // Surya Rashi (Sun Sign)
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_rounded, size: 14, color: AppColors.saffronPrimary),
                    const SizedBox(width: 6),
                    Text(
                      isGujarati ? 'સૂર્ય રાશિ (Sun Sign):' : 'सूर्य राशि (Sun Sign):',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        sunRashiLocalized,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (prevSunRashiLocalized.isNotEmpty || nextSunRashiLocalized.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prevSunRashiLocalized.isNotEmpty)
                        Flexible(
                          child: Text(
                            '${isGujarati ? 'પહેલાં' : 'पूर्व'}: ${_cleanName(prevSunRashiLocalized)}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(fontSize: 9.5, color: isDark ? Colors.white54 : Colors.black45)
                                : GoogleFonts.notoSerifDevanagari(fontSize: 9.5, color: isDark ? Colors.white54 : Colors.black45),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (nextSunRashiLocalized.isNotEmpty)
                        Flexible(
                          child: Text(
                            '${isGujarati ? 'આગામી' : 'आगामी'}: ${_cleanName(nextSunRashiLocalized)}',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(fontSize: 9.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                                : GoogleFonts.notoSerifDevanagari(fontSize: 9.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAngaCell(
    BuildContext context, {
    required String title,
    required String value,
    required String startTime,
    required String endTime,
    required String prevValue,
    required String nextValue,
    required IconData icon,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.saffronPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (endTime.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              startTime.isNotEmpty
                  ? '$startTime – $endTime'
                  : '${isGujarati ? 'સમાપ્તિ' : 'समाप्ति'}: $endTime',
              style: GoogleFonts.outfit(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.goldLight.withAlpha(200) : AppColors.maroonPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (prevValue.isNotEmpty || nextValue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (prevValue.isNotEmpty)
                  Flexible(
                    child: Text(
                      '${isGujarati ? 'પહેલાં' : 'पूर्व'}: ${_cleanName(prevValue)}',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(fontSize: 9, color: isDark ? Colors.white54 : Colors.black45)
                          : GoogleFonts.notoSerifDevanagari(fontSize: 9, color: isDark ? Colors.white54 : Colors.black45),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (nextValue.isNotEmpty)
                  Flexible(
                    child: Text(
                      '${isGujarati ? 'આગામી' : 'आगामी'}: ${_cleanName(nextValue)}',
                      textAlign: TextAlign.end,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(fontSize: 9, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                          : GoogleFonts.notoSerifDevanagari(fontSize: 9, fontWeight: FontWeight.w600, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _cleanName(String raw) {
    if (raw.contains('(')) {
      return raw.split('(').first.trim();
    }
    return raw;
  }
}
