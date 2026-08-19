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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.goldLight.withAlpha(180),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withAlpha(35),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hindi option
            _buildLangSegment(
              label: 'हिं',
              isSelected: !isGujarati,
              fontStyle: GoogleFonts.notoSerifDevanagari(
                fontSize: 10.5,
                fontWeight: !isGujarati ? FontWeight.bold : FontWeight.w500,
                color: !isGujarati ? AppColors.maroonDark : Colors.white70,
              ),
            ),
            Container(
              width: 1,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: AppColors.goldLight.withAlpha(90),
            ),
            // Gujarati option
            _buildLangSegment(
              label: 'ગુજ',
              isSelected: isGujarati,
              fontStyle: GoogleFonts.notoSerifGujarati(
                fontSize: 10.5,
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
    required bool isSelected,
    required TextStyle fontStyle,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.goldLight : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: fontStyle,
      ),
    );
  }
}

