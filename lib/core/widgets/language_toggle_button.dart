import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';

class LanguageToggleButton extends StatelessWidget {
  final bool isCompact;

  const LanguageToggleButton({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    return InkWell(
      onTap: () => langProvider.toggleLanguage(),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(50),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.goldLight.withAlpha(180),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withAlpha(40),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hindi option
            _buildLangSegment(
              label: 'हिं',
              fullLabel: 'हिन्दी',
              isSelected: !isGujarati,
              fontStyle: GoogleFonts.notoSerifDevanagari(
                fontSize: 11,
                fontWeight: !isGujarati ? FontWeight.bold : FontWeight.w500,
                color: !isGujarati ? AppColors.maroonDark : Colors.white70,
              ),
            ),
            const SizedBox(width: 3),
            Container(
              width: 1,
              height: 12,
              color: AppColors.goldLight.withAlpha(100),
            ),
            const SizedBox(width: 3),
            // Gujarati option
            _buildLangSegment(
              label: 'ગુજ',
              fullLabel: 'ગુજરાતી',
              isSelected: isGujarati,
              fontStyle: GoogleFonts.notoSerifGujarati(
                fontSize: 11,
                fontWeight: isGujarati ? FontWeight.bold : FontWeight.w500,
                color: isGujarati ? AppColors.maroonDark : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangSegment({
    required String label,
    required String fullLabel,
    required bool isSelected,
    required TextStyle fontStyle,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.goldLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: fontStyle,
      ),
    );
  }
}
