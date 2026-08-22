import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 2),
      height: 66,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left Tab: Panchang (Vedic Calendar & Cosmic Tithis)
          _buildPanchangTab(
            context,
            isSelected: currentIndex == 0,
            isDark: isDark,
            isGujarati: isGujarati,
            labelRegional: AppStrings.navPanchang(currentLang),
            labelEnglish: AppStrings.navPanchangEnglish,
          ),

          // Center Tab: Bhagavad Geeta (Elevated & Distinct ॐ Sacred Badge)
          _buildGeetaTab(
            context,
            isSelected: currentIndex == 1,
            isDark: isDark,
            isGujarati: isGujarati,
            labelRegional: AppStrings.navGeeta(currentLang),
            labelEnglish: 'Geeta',
          ),

          // Right Tab: Rashi Bhavishya (Vedic Zodiac & Kundali Insight)
          _buildRashiTab(
            context,
            isSelected: currentIndex == 2,
            isDark: isDark,
            isGujarati: isGujarati,
            labelRegional: AppStrings.navRashi(currentLang),
            labelEnglish: AppStrings.navRashiEnglish,
          ),
        ],
      ),
    );
  }

  Widget _buildPanchangTab(
    BuildContext context, {
    required bool isSelected,
    required bool isDark,
    required bool isGujarati,
    required String labelRegional,
    required String labelEnglish,
  }) {
    return _buildNavTab(
      context,
      index: 0,
      isSelected: isSelected,
      isDark: isDark,
      isGujarati: isGujarati,
      labelRegional: labelRegional,
      labelEnglish: labelEnglish,
      selectedIcon: SvgPicture.asset(
        'assets/icons/panchang_selected.svg',
        width: 22,
        height: 18,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      unselectedIcon: SvgPicture.asset(
        'assets/icons/panchang_unselected.svg',
        width: 28,
        height: 24,
        colorFilter: ColorFilter.mode(
          isDark ? const Color(0xFFD1C7B7) : const Color(0xFF554438),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildGeetaTab(
    BuildContext context, {
    required bool isSelected,
    required bool isDark,
    required bool isGujarati,
    required String labelRegional,
    required String labelEnglish,
  }) {
    return _buildNavTab(
      context,
      index: 1,
      isSelected: isSelected,
      isDark: isDark,
      isGujarati: isGujarati,
      labelRegional: labelRegional,
      labelEnglish: labelEnglish,
      selectedLeadingText: isGujarati ? 'ૐ' : 'ॐ',
      unselectedIcon: Text(
        isGujarati ? 'ૐ' : 'ॐ',
        style: isGujarati
            ? GoogleFonts.notoSerifGujarati(
                fontSize: 22,
                height: 1.0,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFD1C7B7) : const Color(0xFF554438),
              )
            : GoogleFonts.notoSerifDevanagari(
                fontSize: 22,
                height: 1.0,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFD1C7B7) : const Color(0xFF554438),
              ),
      ),
    );
  }

  Widget _buildRashiTab(
    BuildContext context, {
    required bool isSelected,
    required bool isDark,
    required bool isGujarati,
    required String labelRegional,
    required String labelEnglish,
  }) {
    return _buildNavTab(
      context,
      index: 2,
      isSelected: isSelected,
      isDark: isDark,
      isGujarati: isGujarati,
      labelRegional: labelRegional,
      labelEnglish: labelEnglish,
      selectedIcon: SvgPicture.asset(
        'assets/icons/rashi_selected.svg',
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      unselectedIcon: SvgPicture.asset(
        'assets/icons/rashi_unselected.svg',
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(
          isDark ? const Color(0xFFD1C7B7) : const Color(0xFF554438),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context, {
    required int index,
    required bool isSelected,
    required bool isDark,
    required bool isGujarati,
    required String labelRegional,
    required String labelEnglish,
    Widget? selectedIcon,
    String? selectedLeadingText,
    required Widget unselectedIcon,
  }) {
    const selectedColor = Color(0xFFE8622E);
    final activeColor = isDark ? AppColors.goldLight : selectedColor;
    final inactiveTextColor = isDark ? const Color(0xFFB8ACA0) : const Color(0xFF635347);
    final inactiveSubtitleColor = isDark ? const Color(0xFF9E9285) : const Color(0xFF7E6E62);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onTabSelected(index),
          splashColor: const Color(0xFFE8622E).withAlpha(35),
          highlightColor: const Color(0xFFE8622E).withAlpha(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  // Selected State: Radiant Glowing Saffron Gradient Pill with White Text/Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.saffronGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8622E).withAlpha(120),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.goldLight,
                        width: 1.3,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedLeadingText != null) ...[
                          Text(
                            selectedLeadingText,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 15,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 15,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                          ),
                          const SizedBox(width: 4),
                        ] else if (selectedIcon != null) ...[
                          selectedIcon,
                          const SizedBox(width: 5),
                        ],
                        Text(
                          labelRegional,
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 12.5,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  )
                              : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 12.5,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    labelEnglish,
                    style: GoogleFonts.outfit(
                      fontSize: 8.5,
                      height: 1.05,
                      fontWeight: FontWeight.bold,
                      color: activeColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ] else ...[
                  // Unselected State: Clean Large Icon + Regional Text + English Subtitle (No Pill)
                  SizedBox(
                    height: 35,
                    child: Center(child: unselectedIcon),
                  ),
                  Text(
                    labelRegional,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 10.5,
                            height: 1.15,
                            fontWeight: FontWeight.w600,
                            color: inactiveTextColor,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 10.5,
                            height: 1.15,
                            fontWeight: FontWeight.w600,
                            color: inactiveTextColor,
                          ),
                  ),
                  Text(
                    labelEnglish,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 8.5,
                      height: 1.05,
                      fontWeight: FontWeight.w500,
                      color: inactiveSubtitleColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
