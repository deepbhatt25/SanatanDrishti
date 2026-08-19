import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/widgets/rashi_symbol_widget.dart';

class RashiWheel extends StatelessWidget {
  final List<RashiInfo> rashis;
  final RashiInfo selectedRashi;
  final ValueChanged<RashiInfo> onSelected;

  const RashiWheel({
    super.key,
    required this.rashis,
    required this.selectedRashi,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const size = 300.0;
    const radius = size / 2 - 38;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Decorative Golden Sacred Ring
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark ? AppColors.gold : AppColors.saffronPrimary).withAlpha(40),
                  width: 2,
                ),
              ),
            ),
            Container(
              width: size - 36,
              height: size - 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark ? AppColors.gold : AppColors.saffronPrimary).withAlpha(25),
                  width: 1,
                ),
              ),
            ),

            // Center Selected Rashi Card
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffronPrimary.withAlpha(70),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppColors.goldLight, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RashiSymbolWidget(
                    rashi: selectedRashi,
                    size: 26,
                    color: Colors.white,
                  ),
                  Text(
                    selectedRashi.hindiName,
                    style: GoogleFonts.notoSerifDevanagari(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldLight,
                    ),
                  ),
                  Text(
                    selectedRashi.englishName,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // 12 Rashi Spokes positioned circularly
            ...List.generate(rashis.length, (index) {
              final rashi = rashis[index];
              final isSelected = rashi.id == selectedRashi.id;
              final angle = (index * 2 * math.pi / rashis.length) - (math.pi / 2);
              final x = radius * math.cos(angle);
              final y = radius * math.sin(angle);

              return Transform.translate(
                offset: Offset(x, y),
                child: GestureDetector(
                  onTap: () => onSelected(rashi),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.saffronPrimary
                          : (isDark ? AppColors.cardDark : AppColors.cardLight),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.goldLight
                            : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.saffronPrimary.withAlpha(90)
                              : Colors.black.withAlpha(isDark ? 50 : 15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: RashiSymbolWidget(
                        rashi: rashi,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
