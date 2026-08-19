import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/kundali_model.dart';

class KundaliChartWidget extends StatelessWidget {
  final KundaliResult kundali;
  final bool isGujarati;
  final bool isNavamsha;
  final bool isChandra;
  final double size;

  const KundaliChartWidget({
    super.key,
    required this.kundali,
    this.isGujarati = false,
    this.isNavamsha = false,
    this.isChandra = false,
    this.size = 340,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E0E0E) : const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gold,
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroonPrimary.withAlpha(isDark ? 90 : 40),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size - 16, size - 16),
        painter: KundaliChartPainter(
          kundali: kundali,
          isGujarati: isGujarati,
          isNavamsha: isNavamsha,
          isChandra: isChandra,
          isDark: isDark,
        ),
      ),
    );
  }
}

class KundaliChartPainter extends CustomPainter {
  final KundaliResult kundali;
  final bool isGujarati;
  final bool isNavamsha;
  final bool isChandra;
  final bool isDark;

  KundaliChartPainter({
    required this.kundali,
    required this.isGujarati,
    required this.isNavamsha,
    required this.isChandra,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final linePaint = Paint()
      ..color = isDark ? AppColors.goldLight : AppColors.maroonPrimary
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF2A1212) : const Color(0xFFFFF8EE)
      ..style = PaintingStyle.fill;

    // Fill canvas background
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 1. Draw Outer Border
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), linePaint);

    // 2. Draw Main Diagonals
    canvas.drawLine(const Offset(0, 0), Offset(w, h), linePaint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), linePaint);

    // 3. Draw Inner Diamond
    final pathDiamond = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(0, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(w, h / 2)
      ..close();
    canvas.drawPath(pathDiamond, linePaint);

    // 4. House Centers and Sign Positions (North Indian 12 Bhavas)
    // House 1 (Top Center Diamond)
    // House 2 (Top Left Upper Triangle)
    // House 3 (Top Left Side Triangle)
    // House 4 (Left Center Diamond)
    // House 5 (Bottom Left Side Triangle)
    // House 6 (Bottom Left Lower Triangle)
    // House 7 (Bottom Center Diamond)
    // House 8 (Bottom Right Lower Triangle)
    // House 9 (Bottom Right Side Triangle)
    // House 10 (Right Center Diamond)
    // House 11 (Top Right Side Triangle)
    // House 12 (Top Right Upper Triangle)

    final houseCenters = <int, Offset>{
      1: Offset(w * 0.50, h * 0.25),
      2: Offset(w * 0.25, h * 0.12),
      3: Offset(w * 0.12, h * 0.25),
      4: Offset(w * 0.25, h * 0.50),
      5: Offset(w * 0.12, h * 0.75),
      6: Offset(w * 0.25, h * 0.88),
      7: Offset(w * 0.50, h * 0.75),
      8: Offset(w * 0.75, h * 0.88),
      9: Offset(w * 0.88, h * 0.75),
      10: Offset(w * 0.75, h * 0.50),
      11: Offset(w * 0.88, h * 0.25),
      12: Offset(w * 0.75, h * 0.12),
    };

    final signNumberOffsets = <int, Offset>{
      1: Offset(w * 0.50, h * 0.38),
      2: Offset(w * 0.35, h * 0.20),
      3: Offset(w * 0.20, h * 0.35),
      4: Offset(w * 0.38, h * 0.50),
      5: Offset(w * 0.20, h * 0.65),
      6: Offset(w * 0.35, h * 0.80),
      7: Offset(w * 0.50, h * 0.62),
      8: Offset(w * 0.65, h * 0.80),
      9: Offset(w * 0.80, h * 0.65),
      10: Offset(w * 0.62, h * 0.50),
      11: Offset(w * 0.80, h * 0.35),
      12: Offset(w * 0.65, h * 0.20),
    };

    // Determine Base Sign for House 1
    int baseSign = kundali.lagnaRashiId;
    if (isChandra) {
      baseSign = kundali.moonRashiId;
    }

    // Map of Planets per house
    Map<int, List<PlanetPosition>> housePlanets;
    if (isNavamsha) {
      housePlanets = kundali.navamshaHousePlanetsMap;
    } else if (isChandra) {
      housePlanets = <int, List<PlanetPosition>>{};
      for (int h = 1; h <= 12; h++) {
        housePlanets[h] = [];
      }
      for (final p in kundali.planets) {
        int chandraHouse = ((p.rashiId - kundali.moonRashiId + 12) % 12) + 1;
        housePlanets[chandraHouse]?.add(p);
      }
    } else {
      housePlanets = kundali.housePlanetsMap;
    }

    // Draw Rashi Sign Numbers & Planets in each house
    for (int h = 1; h <= 12; h++) {
      int sign = (baseSign + h - 2) % 12 + 1;

      // Draw Sign Number in gold
      final signOffset = signNumberOffsets[h]!;
      _drawText(
        canvas: canvas,
        text: '$sign',
        offset: signOffset,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.goldLight.withAlpha(200) : AppColors.saffronDark,
      );

      // Draw Planets in this house
      final planets = housePlanets[h] ?? [];
      if (planets.isNotEmpty) {
        final center = houseCenters[h]!;
        final planetNames = planets.map((p) {
          final name = isGujarati ? p.shortGu : p.shortHi;
          return p.isRetrograde ? '$name(વ)' : name;
        }).toList();

        // If multiple planets, format nicely in column / wrap
        _drawPlanetsInHouse(
          canvas: canvas,
          planets: planetNames,
          center: center,
          isDark: isDark,
        );
      }
    }
  }

  void _drawPlanetsInHouse({
    required Canvas canvas,
    required List<String> planets,
    required Offset center,
    required bool isDark,
  }) {
    final textStyle = TextStyle(
      fontSize: planets.length > 3 ? 9 : 10.5,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : AppColors.maroonDark,
    );

    if (planets.length <= 2) {
      final joined = planets.join(' ');
      final textSpan = TextSpan(text: joined, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - (textPainter.width / 2), center.dy - (textPainter.height / 2)),
      );
    } else {
      // 2 lines
      final row1 = planets.take((planets.length / 2).ceil()).join(' ');
      final row2 = planets.skip((planets.length / 2).ceil()).join(' ');

      final textSpan1 = TextSpan(text: row1, style: textStyle);
      final tp1 = TextPainter(text: textSpan1, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout();
      tp1.paint(canvas, Offset(center.dx - (tp1.width / 2), center.dy - tp1.height));

      final textSpan2 = TextSpan(text: row2, style: textStyle);
      final tp2 = TextPainter(text: textSpan2, textDirection: TextDirection.ltr, textAlign: TextAlign.center)..layout();
      tp2.paint(canvas, Offset(center.dx - (tp2.width / 2), center.dy + 2));
    }
  }

  void _drawText({
    required Canvas canvas,
    required String text,
    required Offset offset,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(offset.dx - (textPainter.width / 2), offset.dy - (textPainter.height / 2)),
    );
  }

  @override
  bool shouldRepaint(covariant KundaliChartPainter oldDelegate) {
    return oldDelegate.kundali != kundali ||
        oldDelegate.isGujarati != isGujarati ||
        oldDelegate.isNavamsha != isNavamsha ||
        oldDelegate.isChandra != isChandra ||
        oldDelegate.isDark != isDark;
  }
}
