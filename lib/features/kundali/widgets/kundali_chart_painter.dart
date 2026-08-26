import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        color: isDark ? const Color(0xFF1E0E0E) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5A93C),
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFFE5A93C)).withAlpha(isDark ? 90 : 35),
            blurRadius: 14,
            offset: const Offset(0, 3),
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
    final canvasWidth = size.width;
    final canvasHeight = size.height;

    // Sacred Vedic Gold Colors for Chart Lines
    const goldLineColor = Color(0xFFE5A93C);

    final borderPaint = Paint()
      ..color = goldLineColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = goldLineColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1C100B) : const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    // 1. Draw Canvas Background
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasWidth, canvasHeight), bgPaint);

    // 2. Draw Outer Border
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasWidth, canvasHeight), borderPaint);

    // 3. Draw Main Diagonals (X)
    canvas.drawLine(const Offset(0, 0), Offset(canvasWidth, canvasHeight), linePaint);
    canvas.drawLine(Offset(canvasWidth, 0), Offset(0, canvasHeight), linePaint);

    // 4. Draw Inner Diamond (connecting midpoints of all 4 edges)
    final pathDiamond = Path()
      ..moveTo(canvasWidth / 2, 0)
      ..lineTo(0, canvasHeight / 2)
      ..lineTo(canvasWidth / 2, canvasHeight)
      ..lineTo(canvasWidth, canvasHeight / 2)
      ..close();
    canvas.drawPath(pathDiamond, linePaint);

    // 5. Precise North Indian Kundali Sign Number Positions
    final signNumberOffsets = <int, Offset>{
      1: Offset(canvasWidth * 0.50, canvasHeight * 0.27),
      2: Offset(canvasWidth * 0.26, canvasHeight * 0.19),
      3: Offset(canvasWidth * 0.19, canvasHeight * 0.26),
      4: Offset(canvasWidth * 0.27, canvasHeight * 0.50),
      5: Offset(canvasWidth * 0.19, canvasHeight * 0.74),
      6: Offset(canvasWidth * 0.26, canvasHeight * 0.81),
      7: Offset(canvasWidth * 0.50, canvasHeight * 0.73),
      8: Offset(canvasWidth * 0.74, canvasHeight * 0.81),
      9: Offset(canvasWidth * 0.81, canvasHeight * 0.74),
      10: Offset(canvasWidth * 0.73, canvasHeight * 0.50),
      11: Offset(canvasWidth * 0.81, canvasHeight * 0.26),
      12: Offset(canvasWidth * 0.74, canvasHeight * 0.19),
    };

    // 6. Precise North Indian Kundali House Planet Target Centers
    final housePlanetCenters = <int, Offset>{
      1: Offset(canvasWidth * 0.50, canvasHeight * 0.13),
      2: Offset(canvasWidth * 0.18, canvasHeight * 0.08),
      3: Offset(canvasWidth * 0.08, canvasHeight * 0.18),
      4: Offset(canvasWidth * 0.14, canvasHeight * 0.50),
      5: Offset(canvasWidth * 0.08, canvasHeight * 0.82),
      6: Offset(canvasWidth * 0.18, canvasHeight * 0.92),
      7: Offset(canvasWidth * 0.50, canvasHeight * 0.87),
      8: Offset(canvasWidth * 0.82, canvasHeight * 0.92),
      9: Offset(canvasWidth * 0.92, canvasHeight * 0.82),
      10: Offset(canvasWidth * 0.86, canvasHeight * 0.50),
      11: Offset(canvasWidth * 0.92, canvasHeight * 0.18),
      12: Offset(canvasWidth * 0.82, canvasHeight * 0.08),
    };

    // Determine Base Sign for House 1
    int baseSign = kundali.lagnaRashiId;
    if (isNavamsha) {
      baseSign = kundali.lagnaNavamshaRashiId;
    } else if (isChandra) {
      baseSign = kundali.moonRashiId;
    }

    // Map of Planets per house
    Map<int, List<PlanetPosition>> housePlanets;
    if (isNavamsha) {
      housePlanets = kundali.navamshaHousePlanetsMap;
    } else if (isChandra) {
      housePlanets = kundali.chandraHousePlanetsMap;
    } else {
      housePlanets = kundali.housePlanetsMap;
    }

    // 7. Draw Rashi Sign Numbers and Planets for all 12 Houses
    for (int house = 1; house <= 12; house++) {
      int sign = (baseSign + house - 2) % 12 + 1;

      // Draw Rashi Sign Number in bold crisp style
      final signOffset = signNumberOffsets[house]!;
      _drawSignNumber(
        canvas: canvas,
        number: sign,
        offset: signOffset,
        isDark: isDark,
      );

      // Collect planet entries for this house
      final planetsInHouse = housePlanets[house] ?? [];
      final entries = <_PlanetDisplayEntry>[];

      // If House 1 and Lagna D1 chart, add Lagna entry
      if (house == 1 && !isChandra) {
        entries.add(
          _PlanetDisplayEntry(
            id: 0,
            symbol: isGujarati ? 'લ' : 'लग्न',
            degreeStr: kundali.lagnaDegree.round().toString().padLeft(2, '0'),
            isRetrograde: false,
          ),
        );
      }

      for (final p in planetsInHouse) {
        final sym = isGujarati ? p.shortGu : p.shortHi;
        final degStr = p.degree.round().toString().padLeft(2, '0');
        entries.add(
          _PlanetDisplayEntry(
            id: p.id,
            symbol: sym,
            degreeStr: degStr,
            isRetrograde: p.isRetrograde,
          ),
        );
      }

      // Draw Planets in this house with elegant formatting
      if (entries.isNotEmpty) {
        final center = housePlanetCenters[house]!;
        _drawHousePlanets(
          canvas: canvas,
          houseNumber: house,
          entries: entries,
          center: center,
          isDark: isDark,
          canvasWidth: canvasWidth,
          canvasHeight: canvasHeight,
        );
      }
    }
  }

  void _drawSignNumber({
    required Canvas canvas,
    required int number,
    required Offset offset,
    required bool isDark,
  }) {
    final textSpan = TextSpan(
      text: '$number',
      style: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF333333),
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

  void _drawHousePlanets({
    required Canvas canvas,
    required int houseNumber,
    required List<_PlanetDisplayEntry> entries,
    required Offset center,
    required bool isDark,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    // If house 1 or 7 (center diamonds), we can arrange vertically or horizontally
    if (houseNumber == 1) {
      _drawHouse1Planets(canvas, entries, center, isDark, canvasWidth, canvasHeight);
      return;
    }

    if (entries.length == 1) {
      _drawSinglePlanet(canvas, entries[0], center, isDark);
    } else if (entries.length == 2) {
      // 2 planets: top/bottom or side-by-side based on house orientation
      if (houseNumber == 4 || houseNumber == 10) {
        // Vertical stack in side diamonds
        _drawSinglePlanet(canvas, entries[0], Offset(center.dx, center.dy - 10), isDark);
        _drawSinglePlanet(canvas, entries[1], Offset(center.dx, center.dy + 10), isDark);
      } else {
        // Side by side in corner/triangles
        _drawSinglePlanet(canvas, entries[0], Offset(center.dx - 12, center.dy), isDark);
        _drawSinglePlanet(canvas, entries[1], Offset(center.dx + 12, center.dy), isDark);
      }
    } else {
      // 3 or 4 planets: 2x2 compact grid
      for (int i = 0; i < entries.length; i++) {
        final row = i ~/ 2;
        final col = i % 2;
        final x = center.dx + (col == 0 ? -12.0 : 12.0);
        final y = center.dy + (row == 0 ? -9.0 : 9.0);
        _drawSinglePlanet(canvas, entries[i], Offset(x, y), isDark, compact: true);
      }
    }
  }

  void _drawHouse1Planets(
    Canvas canvas,
    List<_PlanetDisplayEntry> entries,
    Offset center,
    bool isDark,
    double canvasWidth,
    double canvasHeight,
  ) {
    if (entries.length == 1) {
      _drawSinglePlanet(canvas, entries[0], Offset(canvasWidth * 0.50, canvasHeight * 0.13), isDark);
    } else if (entries.length == 2) {
      _drawSinglePlanet(canvas, entries[0], Offset(canvasWidth * 0.40, canvasHeight * 0.12), isDark);
      _drawSinglePlanet(canvas, entries[1], Offset(canvasWidth * 0.60, canvasHeight * 0.12), isDark);
    } else if (entries.length == 3) {
      _drawSinglePlanet(canvas, entries[0], Offset(canvasWidth * 0.38, canvasHeight * 0.12), isDark);
      _drawSinglePlanet(canvas, entries[1], Offset(canvasWidth * 0.62, canvasHeight * 0.12), isDark);
      _drawSinglePlanet(canvas, entries[2], Offset(canvasWidth * 0.50, canvasHeight * 0.38), isDark);
    } else {
      // 4+ planets
      _drawSinglePlanet(canvas, entries[0], Offset(canvasWidth * 0.38, canvasHeight * 0.11), isDark, compact: true);
      _drawSinglePlanet(canvas, entries[1], Offset(canvasWidth * 0.62, canvasHeight * 0.11), isDark, compact: true);
      _drawSinglePlanet(canvas, entries[2], Offset(canvasWidth * 0.38, canvasHeight * 0.37), isDark, compact: true);
      _drawSinglePlanet(canvas, entries[3], Offset(canvasWidth * 0.62, canvasHeight * 0.37), isDark, compact: true);
    }
  }

  void _drawSinglePlanet(
    Canvas canvas,
    _PlanetDisplayEntry entry,
    Offset pos,
    bool isDark, {
    bool compact = false,
  }) {
    final color = _getPlanetColor(entry.id, isDark);
    final symbolStyle = isGujarati
        ? GoogleFonts.notoSerifGujarati(
            fontSize: compact ? 10.5 : 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          )
        : GoogleFonts.notoSerifDevanagari(
            fontSize: compact ? 10.5 : 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          );

    final degreeStyle = GoogleFonts.outfit(
      fontSize: compact ? 7.5 : 8.5,
      fontWeight: FontWeight.w600,
      color: color.withAlpha(210),
    );

    // Text Span with Symbol + Retrograde mark + Degree
    final textSpan = TextSpan(
      children: [
        TextSpan(
          text: entry.symbol + (entry.isRetrograde ? '*' : ''),
          style: symbolStyle,
        ),
        const TextSpan(text: ' '),
        TextSpan(
          text: entry.degreeStr,
          style: degreeStyle,
        ),
      ],
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(pos.dx - (textPainter.width / 2), pos.dy - (textPainter.height / 2)),
    );
  }

  Color _getPlanetColor(int id, bool isDark) {
    if (isDark) {
      switch (id) {
        case 1:
          return const Color(0xFFFF8A80); // Sun (Red)
        case 2:
          return const Color(0xFF90CAF9); // Moon (Blue)
        case 3:
          return const Color(0xFFFFAB91); // Mars (Rust Vermillion)
        case 4:
          return const Color(0xFFA5D6A7); // Mercury (Green)
        case 5:
          return const Color(0xFFFFE082); // Jupiter (Gold Amber)
        case 6:
          return const Color(0xFFCE93D8); // Venus (Lilac Violet)
        case 7:
          return const Color(0xFFB0BEC5); // Saturn (Slate Steel)
        case 8:
          return const Color(0xFFBCAAA4); // Rahu (Brown)
        case 9:
          return const Color(0xFFBCAAA4); // Ketu (Brown)
        case 10:
          return const Color(0xFF80DEEA); // Uranus (Cyan/Teal)
        case 11:
          return const Color(0xFF9FA8DA); // Neptune (Indigo/Blue)
        case 12:
          return const Color(0xFFD1C4E9); // Pluto (Deep Lavender)
        case 0:
          return const Color(0xFFFFCC80); // Lagna (Orange)
        default:
          return Colors.white;
      }
    } else {
      switch (id) {
        case 1:
          return const Color(0xFFC62828); // Sun
        case 2:
          return const Color(0xFF1565C0); // Moon
        case 3:
          return const Color(0xFFD84315); // Mars
        case 4:
          return const Color(0xFF2E7D32); // Mercury
        case 5:
          return const Color(0xFFE65100); // Jupiter
        case 6:
          return const Color(0xFF6A1B9A); // Venus
        case 7:
          return const Color(0xFF37474F); // Saturn
        case 8:
          return const Color(0xFF5D4037); // Rahu
        case 9:
          return const Color(0xFF5D4037); // Ketu
        case 10:
          return const Color(0xFF00838F); // Uranus (Cyan/Teal)
        case 11:
          return const Color(0xFF283593); // Neptune (Indigo/Navy)
        case 12:
          return const Color(0xFF4A148C); // Pluto (Deep Purple)
        case 0:
          return const Color(0xFFB71C1C); // Lagna
        default:
          return const Color(0xFF2D1E12);
      }
    }
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

class _PlanetDisplayEntry {
  final int id;
  final String symbol;
  final String degreeStr;
  final bool isRetrograde;

  const _PlanetDisplayEntry({
    required this.id,
    required this.symbol,
    required this.degreeStr,
    required this.isRetrograde,
  });
}
