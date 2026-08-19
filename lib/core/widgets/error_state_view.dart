import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/language_provider.dart';

class ErrorStateView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorStateView({
    super.key,
    this.message,
    required this.onRetry,
    this.icon = Icons.refresh_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = context.watch<LanguageProvider>().currentLanguage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.saffronDark : AppColors.saffronPale).withAlpha(120),
                border: Border.all(color: AppColors.saffronMedium.withAlpha(80), width: 1.5),
              ),
              child: Icon(
                Icons.wb_sunny_outlined,
                size: 44,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'त्रुटि / Notice',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? AppStrings.errorGeneric(currentLang),
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(icon, size: 18),
              label: Text(AppStrings.retry(currentLang)),
            ),
          ],
        ),
      ),
    );
  }
}
