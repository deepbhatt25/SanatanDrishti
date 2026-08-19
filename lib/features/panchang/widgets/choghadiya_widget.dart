import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/location_service.dart';
import '../models/choghadiya_model.dart';
import '../repositories/panchang_repository.dart';

class ChoghadiyaWidget extends StatefulWidget {
  final DateTime selectedDate;
  final CityLocation selectedCity;

  const ChoghadiyaWidget({
    super.key,
    required this.selectedDate,
    required this.selectedCity,
  });

  @override
  State<ChoghadiyaWidget> createState() => _ChoghadiyaWidgetState();
}

class _ChoghadiyaWidgetState extends State<ChoghadiyaWidget> {
  bool _isDaySelected = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    final choghadiya = PanchangRepository.calculateDayNightChoghadiya(
      widget.selectedDate,
      widget.selectedCity,
    );

    final currentList = _isDaySelected ? choghadiya.dayChoghadiya : choghadiya.nightChoghadiya;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.saffronPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.choghadiyaTitle(currentLang),
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                    ),
                    Text(
                      'DAY & NIGHT CHOGHADIYA',
                      style: GoogleFonts.cinzel(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Day / Night Toggle Selector
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isDaySelected = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: _isDaySelected ? AppColors.saffronGradient : null,
                        color: _isDaySelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny_rounded,
                            size: 14,
                            color: _isDaySelected ? Colors.white : AppColors.saffronPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.dayChoghadiya(currentLang),
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _isDaySelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isDaySelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isDaySelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: !_isDaySelected ? AppColors.maroonGradient : null,
                        color: !_isDaySelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nights_stay_rounded,
                            size: 14,
                            color: !_isDaySelected ? Colors.white : AppColors.gold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.nightChoghadiya(currentLang),
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !_isDaySelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !_isDaySelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Choghadiya 8 Periods List
          ...currentList.map((period) => _buildChoghadiyaRow(context, period, isDark, isGujarati, currentLang)),
        ],
      ),
    );
  }

  Widget _buildChoghadiyaRow(
    BuildContext context,
    ChoghadiyaPeriod period,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang,
  ) {
    Color badgeBg;
    Color badgeText;
    Color dotColor;
    Color rowBg;

    switch (period.quality) {
      case ChoghadiyaQuality.shubh:
        badgeBg = const Color(0xFF2E7D32).withAlpha(isDark ? 50 : 25);
        badgeText = isDark ? const Color(0xFF81C784) : const Color(0xFF1B5E20);
        dotColor = const Color(0xFF2E7D32);
        rowBg = isDark ? const Color(0xFF1E2D1E) : const Color(0xFFF1F8F1);
        break;
      case ChoghadiyaQuality.char:
        badgeBg = const Color(0xFFF57F17).withAlpha(isDark ? 50 : 25);
        badgeText = isDark ? const Color(0xFFFFD54F) : const Color(0xFFE65100);
        dotColor = const Color(0xFFF57F17);
        rowBg = isDark ? const Color(0xFF2E261A) : const Color(0xFFFFF9EE);
        break;
      case ChoghadiyaQuality.ashubh:
        badgeBg = const Color(0xFFC62828).withAlpha(isDark ? 50 : 20);
        badgeText = isDark ? const Color(0xFFEF9A9A) : const Color(0xFFB71C1C);
        dotColor = const Color(0xFFC62828);
        rowBg = isDark ? const Color(0xFF2D1E1E) : const Color(0xFFFDF2F2);
        break;
    }

    final nameLocalized = isGujarati ? period.nameGujarati : period.nameHindi;
    final qualityLocalized = isGujarati ? period.qualityLabelGujarati : period.qualityLabelHindi;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: period.isCurrent ? (isDark ? AppColors.gold.withAlpha(30) : AppColors.goldLight.withAlpha(60)) : rowBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: period.isCurrent
              ? AppColors.gold
              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          width: period.isCurrent ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Quality Status Dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),

          // Name and Quality
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '$nameLocalized (${period.nameEn})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                      ),
                    ),
                    if (period.isCurrent) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppStrings.activeNow(currentLang),
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  qualityLocalized,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 10,
                          color: badgeText,
                          fontWeight: FontWeight.w600,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 10.5,
                          color: badgeText,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Timings
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${period.startTime} – ${period.endTime}',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
