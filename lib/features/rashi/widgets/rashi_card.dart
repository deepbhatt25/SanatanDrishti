import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/widgets/rashi_symbol_widget.dart';

class RashiCard extends StatelessWidget {
  final RashiInfo rashi;
  final bool isSelected;
  final bool isDefault;
  final bool isGujarati;
  final VoidCallback onTap;

  const RashiCard({
    super.key,
    required this.rashi,
    this.isSelected = false,
    this.isDefault = false,
    this.isGujarati = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rashiName = isGujarati ? rashi.gujaratiName : rashi.hindiName;
    final elementName = isGujarati
        ? rashi.elementGujarati.split(' ').first
        : rashi.element.split(' ').first;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? const Color(0xFF381E10) : const Color(0xFFFFF3E0))
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? AppColors.saffronPrimary
              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.saffronPrimary.withAlpha(40)
                : Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Tag: Default indicator if pinned
                if (isDefault)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.gold, width: 0.8),
                    ),
                    child: Text(
                      isGujarati ? 'મુખ્ય રાશિ' : 'MY RASHI',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            )
                          : GoogleFonts.outfit(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                    ),
                  ),

                // Zodiac Symbol & Sanskrit Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RashiSymbolWidget(
                      rashi: rashi,
                      size: 22,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        rashiName,
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // English Name
                Text(
                  rashi.englishName,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),

                const SizedBox(height: 4),

                // Ruling Planet & Element
                Text(
                  elementName,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
