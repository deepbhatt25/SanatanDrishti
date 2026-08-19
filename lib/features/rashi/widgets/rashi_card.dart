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
    final planetName = isGujarati
        ? rashi.rulingPlanetGujarati.split(' ').first
        : rashi.rulingPlanet.split(' ').first;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isSelected || isDefault
              ? (isDark
                  ? [const Color(0xFF381B14), const Color(0xFF220E09)]
                  : [const Color(0xFFFFF7EA), const Color(0xFFFFECCB)])
              : (isDark
                  ? [const Color(0xFF241313), const Color(0xFF180A0A)]
                  : [const Color(0xFFFFFDF9), const Color(0xFFFFF8EE)]),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected || isDefault
              ? AppColors.saffronPrimary
              : (isDark ? AppColors.cardBorderDark : AppColors.gold.withAlpha(75)),
          width: isSelected || isDefault ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected || isDefault
                ? AppColors.saffronPrimary.withAlpha(45)
                : (isDark ? Colors.black.withAlpha(60) : AppColors.maroonPrimary.withAlpha(10)),
            blurRadius: isSelected || isDefault ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top: "MY RASHI" Pill if default
                if (isDefault) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.gold, AppColors.saffronPrimary],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withAlpha(60),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded, size: 9, color: Colors.white),
                        const SizedBox(width: 2),
                        Text(
                          isGujarati ? 'મુખ્ય રાશિ' : 'DEFAULT',
                          style: GoogleFonts.outfit(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],

                // Authentic Vector Zodiac Icon Emblem
                RashiSymbolWidget(
                  rashi: rashi,
                  size: 40,
                ),

                const SizedBox(height: 5),

                // Big & Prominent Localized Rashi Name
                Text(
                  rashiName,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          height: 1.15,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          height: 1.15,
                        ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 1),

                // English Name
                Text(
                  rashi.englishName,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),

                const SizedBox(height: 4),

                // Element & Ruling Lord Badge (No broken Unicode symbols)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withAlpha(80)
                        : AppColors.saffronPrimary.withAlpha(15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark
                          ? AppColors.cardBorderDark
                          : AppColors.gold.withAlpha(60),
                      width: 0.6,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RashiThemeColors.getElementIcon(rashi.id),
                        size: 9.5,
                        color: RashiThemeColors.getElementColor(rashi.id),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '$elementName • $planetName',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.textPrimaryLight,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
