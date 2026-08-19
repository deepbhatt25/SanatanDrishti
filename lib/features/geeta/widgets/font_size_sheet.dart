import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/geeta_provider.dart';

class FontSizeBottomSheet extends StatelessWidget {
  const FontSizeBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const FontSizeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 90 : 30),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'श्लोक फ़ॉन्ट आकार / Text Size',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.bgLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Text(
                'धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः ।',
                style: GoogleFonts.notoSerifDevanagari(
                  fontSize: 18 * geetaProvider.fontScale,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('A', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: geetaProvider.fontScale,
                    min: 0.85,
                    max: 1.5,
                    divisions: 13,
                    activeColor: AppColors.saffronPrimary,
                    inactiveColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    onChanged: (val) => geetaProvider.setFontScale(val),
                  ),
                ),
                Text('A', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => geetaProvider.setFontScale(1.0),
                  child: const Text('Reset Default (100%)'),
                ),
                Text(
                  '${(geetaProvider.fontScale * 100).toInt()}%',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
