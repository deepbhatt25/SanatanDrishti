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
    final pakshaLocalized = panchang.getLocalizedPaksha(currentLang);
    final nakshatraLocalized = panchang.getLocalizedNakshatra(currentLang);
    final yogaLocalized = panchang.getLocalizedYoga(currentLang);
    final karanaLocalized = panchang.getLocalizedKarana(currentLang);
    final vaarLocalized = panchang.getLocalizedVaar(currentLang);
    final samvatLocalized = isGujarati
        ? 'સંવત ${langProvider.formatNumber(int.tryParse(panchang.vikramSamvat) ?? 2083)}'
        : 'संवत् ${panchang.vikramSamvat}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
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

          const SizedBox(height: 16),

          // Primary Tithi Highlight
          Center(
            child: Column(
              children: [
                Text(
                  '${AppStrings.tithi(currentLang)} (Tithi)',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
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
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // 2x2 Grid: Nakshatra, Yoga, Karana, Vaar
          Row(
            children: [
              Expanded(
                child: _buildInfoCell(
                  context,
                  title: '${AppStrings.nakshatra(currentLang)} (Nakshatra)',
                  value: nakshatraLocalized,
                  icon: Icons.auto_awesome_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCell(
                  context,
                  title: '${AppStrings.yoga(currentLang)} (Yoga)',
                  value: yogaLocalized,
                  icon: Icons.spa_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildInfoCell(
                  context,
                  title: '${AppStrings.karana(currentLang)} (Karana)',
                  value: karanaLocalized,
                  icon: Icons.adjust_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCell(
                  context,
                  title: '${AppStrings.vaar(currentLang)} (Weekday)',
                  value: vaarLocalized,
                  icon: Icons.calendar_today_rounded,
                  isDark: isDark,
                  isGujarati: isGujarati,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCell(
    BuildContext context, {
    required String title,
    required String value,
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
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
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
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
