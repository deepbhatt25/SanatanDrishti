import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/language_provider.dart';

class OfflineBanner extends StatelessWidget {
  final String? customMessage;

  const OfflineBanner({super.key, this.customMessage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = context.watch<LanguageProvider>().currentLanguage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3E2412) : const Color(0xFFFFF3E0),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.saffronDark.withAlpha(100) : AppColors.saffronLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 14,
            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              customMessage ?? AppStrings.offlineMessage(currentLang),
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
