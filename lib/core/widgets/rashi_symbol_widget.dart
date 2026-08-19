import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/rashi_data.dart';

class RashiThemeColors {
  /// Returns a themed spiritual gradient based on the Rashi ID / Element
  static List<Color> getGradient(int id) {
    switch (id) {
      case 1: // Aries (Fire - Mars)
        return const [Color(0xFFE64A19), Color(0xFFFF7043), Color(0xFFFFB74D)];
      case 2: // Taurus (Earth - Venus)
        return const [Color(0xFF2E7D32), Color(0xFF43A047), Color(0xFF81C784)];
      case 3: // Gemini (Air - Mercury)
        return const [Color(0xFF00838F), Color(0xFF00ACC1), Color(0xFF4DD0E1)];
      case 4: // Cancer (Water - Moon)
        return const [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF64B5F6)];
      case 5: // Leo (Fire - Sun)
        return const [Color(0xFFD84315), Color(0xFFF4511E), Color(0xFFFFB300)];
      case 6: // Virgo (Earth - Mercury)
        return const [Color(0xFF388E3C), Color(0xFF4CAF50), Color(0xFFAED581)];
      case 7: // Libra (Air - Venus)
        return const [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFBA68C8)];
      case 8: // Scorpio (Water - Mars)
        return const [Color(0xFFAD1457), Color(0xFFD81B60), Color(0xFFFF4081)];
      case 9: // Sagittarius (Fire - Jupiter)
        return const [Color(0xFFEF6C00), Color(0xFFF57C00), Color(0xFFFFD54F)];
      case 10: // Capricorn (Earth - Saturn)
        return const [Color(0xFF4E342E), Color(0xFF6D4C41), Color(0xFFA1887F)];
      case 11: // Aquarius (Air - Saturn)
        return const [Color(0xFF0277BD), Color(0xFF0288D1), Color(0xFF4FC3F7)];
      case 12: // Pisces (Water - Jupiter)
        return const [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF80D8FF)];
      default:
        return const [Color(0xFF800000), Color(0xFFFF8C00)];
    }
  }

  static IconData getElementIcon(int id) {
    switch (id) {
      case 1:
      case 5:
      case 9:
        return Icons.local_fire_department_rounded; // Fire
      case 2:
      case 6:
      case 10:
        return Icons.spa_rounded; // Earth
      case 3:
      case 7:
      case 11:
        return Icons.air_rounded; // Air
      case 4:
      case 8:
      case 12:
        return Icons.water_drop_rounded; // Water
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  static Color getElementColor(int id) {
    switch (id) {
      case 1:
      case 5:
      case 9:
        return const Color(0xFFE64A19);
      case 2:
      case 6:
      case 10:
        return const Color(0xFF2E7D32);
      case 3:
      case 7:
      case 11:
        return const Color(0xFF00838F);
      case 4:
      case 8:
      case 12:
        return const Color(0xFF1565C0);
      default:
        return AppColors.gold;
    }
  }
}

/// Authentic Vector Painter for 12 Vedic Rashi (Zodiac) symbols
class RashiZodiacVectorPainter extends CustomPainter {
  final int rashiId;
  final Color color;
  final double strokeWidth;

  const RashiZodiacVectorPainter({
    required this.rashiId,
    this.color = Colors.white,
    this.strokeWidth = 2.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();

    switch (rashiId) {
      case 1: // 1. Aries / Mesha (Ram Horns)
        // Center stem
        path.moveTo(w * 0.50, h * 0.85);
        path.lineTo(w * 0.50, h * 0.38);
        // Left horn arch
        path.moveTo(w * 0.50, h * 0.38);
        path.cubicTo(w * 0.38, h * 0.12, w * 0.12, h * 0.16, w * 0.14, h * 0.42);
        path.cubicTo(w * 0.16, h * 0.58, w * 0.32, h * 0.56, w * 0.35, h * 0.46);
        // Right horn arch
        path.moveTo(w * 0.50, h * 0.38);
        path.cubicTo(w * 0.62, h * 0.12, w * 0.88, h * 0.16, w * 0.86, h * 0.42);
        path.cubicTo(w * 0.84, h * 0.58, w * 0.68, h * 0.56, w * 0.65, h * 0.46);
        break;

      case 2: // 2. Taurus / Vrishabha (Bull Head & Upward Horns)
        // Crescent horns
        path.moveTo(w * 0.16, h * 0.20);
        path.cubicTo(w * 0.28, h * 0.44, w * 0.72, h * 0.44, w * 0.84, h * 0.20);
        // Bull head circle
        path.addOval(Rect.fromCircle(center: Offset(w * 0.50, h * 0.62), radius: w * 0.25));
        break;

      case 3: // 3. Gemini / Mithuna (The Twins / Dual Pillars)
        // Top connecting arch
        path.moveTo(w * 0.18, h * 0.20);
        path.quadraticBezierTo(w * 0.50, h * 0.30, w * 0.82, h * 0.20);
        // Bottom connecting arch
        path.moveTo(w * 0.18, h * 0.80);
        path.quadraticBezierTo(w * 0.50, h * 0.70, w * 0.82, h * 0.80);
        // Left pillar
        path.moveTo(w * 0.36, h * 0.25);
        path.lineTo(w * 0.36, h * 0.75);
        // Right pillar
        path.moveTo(w * 0.64, h * 0.25);
        path.lineTo(w * 0.64, h * 0.75);
        break;

      case 4: // 4. Cancer / Karka (Crab Claws)
        // Upper claw circle & tail
        path.addOval(Rect.fromCircle(center: Offset(w * 0.36, h * 0.35), radius: w * 0.13));
        path.moveTo(w * 0.49, h * 0.35);
        path.cubicTo(w * 0.55, h * 0.18, w * 0.82, h * 0.18, w * 0.82, h * 0.38);
        // Lower claw circle & tail
        path.addOval(Rect.fromCircle(center: Offset(w * 0.64, h * 0.65), radius: w * 0.13));
        path.moveTo(w * 0.51, h * 0.65);
        path.cubicTo(w * 0.45, h * 0.82, w * 0.18, h * 0.82, w * 0.18, h * 0.62);
        break;

      case 5: // 5. Leo / Simha (Lion Mane & Regal Tail)
        // Mane head circle
        path.addOval(Rect.fromCircle(center: Offset(w * 0.30, h * 0.66), radius: w * 0.13));
        // Crest arch & sweeping tail
        path.moveTo(w * 0.42, h * 0.60);
        path.cubicTo(w * 0.40, h * 0.16, w * 0.75, h * 0.16, w * 0.75, h * 0.52);
        path.cubicTo(w * 0.75, h * 0.86, w * 0.94, h * 0.84, w * 0.90, h * 0.68);
        break;

      case 6: // 6. Virgo / Kanya (The Maiden)
        path.moveTo(w * 0.16, h * 0.76);
        path.lineTo(w * 0.16, h * 0.34);
        path.cubicTo(w * 0.16, h * 0.18, w * 0.38, h * 0.18, w * 0.38, h * 0.36);
        path.lineTo(w * 0.38, h * 0.74);
        path.moveTo(w * 0.38, h * 0.36);
        path.cubicTo(w * 0.38, h * 0.18, w * 0.60, h * 0.18, w * 0.60, h * 0.36);
        path.lineTo(w * 0.60, h * 0.74);
        path.cubicTo(w * 0.60, h * 0.88, w * 0.80, h * 0.88, w * 0.80, h * 0.66);
        path.cubicTo(w * 0.80, h * 0.45, w * 0.50, h * 0.54, w * 0.88, h * 0.82);
        break;

      case 7: // 7. Libra / Tula (Balance Scales)
        // Bottom level beam
        path.moveTo(w * 0.15, h * 0.80);
        path.lineTo(w * 0.85, h * 0.80);
        // Top scale beam with arch
        path.moveTo(w * 0.15, h * 0.48);
        path.lineTo(w * 0.35, h * 0.48);
        path.arcToPoint(
          Offset(w * 0.65, h * 0.48),
          radius: Radius.circular(w * 0.15),
          clockwise: false,
        );
        path.lineTo(w * 0.85, h * 0.48);
        break;

      case 8: // 8. Scorpio / Vrishchika (Scorpion & Stinger)
        path.moveTo(w * 0.14, h * 0.76);
        path.lineTo(w * 0.14, h * 0.34);
        path.cubicTo(w * 0.14, h * 0.18, w * 0.36, h * 0.18, w * 0.36, h * 0.36);
        path.lineTo(w * 0.36, h * 0.74);
        path.moveTo(w * 0.36, h * 0.36);
        path.cubicTo(w * 0.36, h * 0.18, w * 0.58, h * 0.18, w * 0.58, h * 0.36);
        path.lineTo(w * 0.58, h * 0.74);
        // Stinger extending and barbed arrow
        path.lineTo(w * 0.82, h * 0.74);
        path.lineTo(w * 0.88, h * 0.60);
        path.moveTo(w * 0.77, h * 0.64);
        path.lineTo(w * 0.88, h * 0.60);
        path.lineTo(w * 0.89, h * 0.72);
        break;

      case 9: // 9. Sagittarius / Dhanu (Archer's Divine Arrow)
        // Arrow shaft
        path.moveTo(w * 0.18, h * 0.82);
        path.lineTo(w * 0.82, h * 0.18);
        // Arrowhead
        path.moveTo(w * 0.56, h * 0.18);
        path.lineTo(w * 0.82, h * 0.18);
        path.lineTo(w * 0.82, h * 0.44);
        // Central bow crossbar
        path.moveTo(w * 0.32, h * 0.52);
        path.lineTo(w * 0.48, h * 0.68);
        break;

      case 10: // 10. Capricorn / Makara (Sea-Goat & Tail)
        path.moveTo(w * 0.18, h * 0.22);
        path.lineTo(w * 0.36, h * 0.74);
        path.lineTo(w * 0.54, h * 0.22);
        path.cubicTo(w * 0.68, h * 0.22, w * 0.76, h * 0.44, w * 0.66, h * 0.65);
        path.cubicTo(w * 0.54, h * 0.88, w * 0.80, h * 0.92, w * 0.86, h * 0.72);
        break;

      case 11: // 11. Aquarius / Kumbha (Water Waves & Amrit)
        // Wave 1
        path.moveTo(w * 0.15, h * 0.38);
        path.lineTo(w * 0.32, h * 0.24);
        path.lineTo(w * 0.50, h * 0.38);
        path.lineTo(w * 0.68, h * 0.24);
        path.lineTo(w * 0.85, h * 0.38);
        // Wave 2
        path.moveTo(w * 0.15, h * 0.68);
        path.lineTo(w * 0.32, h * 0.54);
        path.lineTo(w * 0.50, h * 0.68);
        path.lineTo(w * 0.68, h * 0.54);
        path.lineTo(w * 0.85, h * 0.68);
        break;

      case 12: // 12. Pisces / Meena (Two Swimming Twin Fishes)
        // Left fish crescent
        path.moveTo(w * 0.32, h * 0.16);
        path.cubicTo(w * 0.16, h * 0.38, w * 0.16, h * 0.62, w * 0.32, h * 0.84);
        // Right fish crescent
        path.moveTo(w * 0.68, h * 0.16);
        path.cubicTo(w * 0.84, h * 0.38, w * 0.84, h * 0.62, w * 0.68, h * 0.84);
        // Central connecting cord
        path.moveTo(w * 0.16, h * 0.50);
        path.lineTo(w * 0.84, h * 0.50);
        break;

      default:
        path.addOval(Rect.fromCircle(center: Offset(w * 0.50, h * 0.50), radius: w * 0.35));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RashiZodiacVectorPainter oldDelegate) {
    return oldDelegate.rashiId != rashiId ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class RashiSymbolWidget extends StatelessWidget {
  final RashiInfo rashi;
  final double size;
  final Color? color;
  final bool isCircle;

  const RashiSymbolWidget({
    super.key,
    required this.rashi,
    this.size = 38,
    this.color,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = RashiThemeColors.getGradient(rashi.id);

    if (!isCircle) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: RashiZodiacVectorPainter(
            rashiId: rashi.id,
            color: color ?? AppColors.goldLight,
            strokeWidth: size * 0.08,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(color: AppColors.goldLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withAlpha(80),
            blurRadius: size * 0.22,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        width: size * 0.58,
        height: size * 0.58,
        child: CustomPaint(
          painter: RashiZodiacVectorPainter(
            rashiId: rashi.id,
            color: Colors.white,
            strokeWidth: (size * 0.58) * 0.11,
          ),
        ),
      ),
    );
  }
}

class RashiAvatarEmblem extends StatelessWidget {
  final RashiInfo rashi;
  final double diameter;

  const RashiAvatarEmblem({
    super.key,
    required this.rashi,
    this.diameter = 52,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = RashiThemeColors.getGradient(rashi.id);

    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(color: AppColors.goldLight, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        width: diameter * 0.58,
        height: diameter * 0.58,
        child: CustomPaint(
          painter: RashiZodiacVectorPainter(
            rashiId: rashi.id,
            color: Colors.white,
            strokeWidth: (diameter * 0.58) * 0.11,
          ),
        ),
      ),
    );
  }
}
