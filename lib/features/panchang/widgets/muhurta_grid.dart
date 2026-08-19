import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../models/panchang_model.dart';

class MuhurtaGrid extends StatelessWidget {
  final PanchangModel panchang;

  const MuhurtaGrid({super.key, required this.panchang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    // Handle localized prohibited text for Abhijit on Wednesdays
    final abhijitText = (panchang.abhijitMuhurta.contains('वर्जित') ||
            panchang.abhijitMuhurta.contains('Inauspicious') ||
            panchang.abhijitMuhurta.contains('વર્જિત'))
        ? AppStrings.abhijitProhibited(currentLang)
        : panchang.abhijitMuhurta;

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
                  Icons.access_time_filled_rounded,
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
                      AppStrings.muhurtaSectionTitle(currentLang),
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
                      'MUHURTA TIMINGS',
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

          const SizedBox(height: 16),

          // Auspicious Timings Section
          _buildTimingRow(
            title: AppStrings.abhijitLabel(currentLang),
            time: abhijitText,
            isAuspicious: true,
            isDark: isDark,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 10),
          _buildTimingRow(
            title: AppStrings.brahmaLabel(currentLang),
            time: panchang.brahmaMuhurta,
            isAuspicious: true,
            isDark: isDark,
            isGujarati: isGujarati,
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Inauspicious Timings Section
          _buildTimingRow(
            title: AppStrings.rahuKaalLabel(currentLang),
            time: panchang.rahuKaal,
            isAuspicious: false,
            isDark: isDark,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 10),
          _buildTimingRow(
            title: AppStrings.yamagandaLabel(currentLang),
            time: panchang.yamaganda,
            isAuspicious: false,
            isDark: isDark,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 10),
          _buildTimingRow(
            title: AppStrings.gulikaiLabel(currentLang),
            time: panchang.gulikaiKaal,
            isAuspicious: false,
            isDark: isDark,
            isGujarati: isGujarati,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingRow({
    required String title,
    required String time,
    required bool isAuspicious,
    required bool isDark,
    required bool isGujarati,
  }) {
    final statusColor = isAuspicious ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withAlpha(isDark ? 60 : 35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 5,
            child: Text(
              time,
              textAlign: TextAlign.end,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
