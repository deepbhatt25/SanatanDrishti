import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';

class SpiritualBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const SpiritualBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 25),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left Tab: Panchang
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.wb_sunny_rounded,
                unselectedIcon: Icons.wb_sunny_outlined,
                labelRegional: AppStrings.navPanchang(currentLang),
                labelEnglish: AppStrings.navPanchangEnglish,
                isSelected: currentIndex == 0,
                isDark: isDark,
                isGujarati: isGujarati,
              ),

              // Center Tab: Bhagavad Geeta (Elevated & Distinct)
              _buildCenterGeetaItem(
                context,
                isSelected: currentIndex == 1,
                isDark: isDark,
                labelRegional: AppStrings.navGeeta(currentLang),
                isGujarati: isGujarati,
              ),

              // Right Tab: Rashi Bhavishya
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.stars_rounded,
                unselectedIcon: Icons.stars_outlined,
                labelRegional: AppStrings.navRashi(currentLang),
                labelEnglish: AppStrings.navRashiEnglish,
                isSelected: currentIndex == 2,
                isDark: isDark,
                isGujarati: isGujarati,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData unselectedIcon,
    required String labelRegional,
    required String labelEnglish,
    required bool isSelected,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : unselectedIcon,
              size: 24,
              color: isSelected
                  ? (isDark ? AppColors.goldLight : AppColors.saffronPrimary)
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
            ),
            const SizedBox(height: 3),
            Text(
              labelRegional,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
                    ),
            ),
            Text(
              labelEnglish,
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.goldLight : AppColors.saffronPrimary)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterGeetaItem(
    BuildContext context, {
    required bool isSelected,
    required bool isDark,
    required String labelRegional,
    required bool isGujarati,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.saffronGradient
                    : (isDark ? AppColors.maroonGradient : AppColors.headerGradientLight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffronPrimary.withAlpha(isSelected ? 90 : 40),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? AppColors.goldLight : AppColors.gold.withAlpha(120),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isGujarati ? 'ૐ' : 'ॐ',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    labelRegional,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Geeta',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.goldLight : AppColors.saffronPrimary)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
