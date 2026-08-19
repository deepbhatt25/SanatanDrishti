import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../models/panchang_model.dart';

class SunMoonTracker extends StatelessWidget {
  final PanchangModel panchang;

  const SunMoonTracker({super.key, required this.panchang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          // Sun Info
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E1C12) : const Color(0xFFFFF8E7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.saffronLight.withAlpha(isDark ? 50 : 120),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wb_sunny_rounded, color: AppColors.saffronPrimary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.sun(currentLang),
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                              )
                            : GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSubTiming(
                        label: AppStrings.sunriseLabel(currentLang),
                        time: panchang.sunrise,
                        isDark: isDark,
                        isGujarati: isGujarati,
                      ),
                      _buildSubTiming(
                        label: AppStrings.sunsetLabel(currentLang),
                        time: panchang.sunset,
                        isDark: isDark,
                        isGujarati: isGujarati,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Moon Info
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E212A) : const Color(0xFFF3F6FA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF90A4AE).withAlpha(isDark ? 50 : 100),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.nightlight_round, color: Color(0xFF78909C), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.moon(currentLang),
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF37474F),
                              )
                            : GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF37474F),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSubTiming(
                        label: AppStrings.moonriseLabel(currentLang),
                        time: panchang.moonrise,
                        isDark: isDark,
                        isGujarati: isGujarati,
                      ),
                      _buildSubTiming(
                        label: AppStrings.moonsetLabel(currentLang),
                        time: panchang.moonset,
                        isDark: isDark,
                        isGujarati: isGujarati,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTiming({
    required String label,
    required String time,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: isGujarati
              ? GoogleFonts.notoSerifGujarati(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                )
              : GoogleFonts.outfit(
                  fontSize: 10,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
