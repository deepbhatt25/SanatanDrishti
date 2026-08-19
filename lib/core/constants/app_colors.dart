import 'package:flutter/material.dart';

class AppColors {
  // Primary Spiritual Saffron / Marigold
  static const Color saffronDark = Color(0xFFD35400);
  static const Color saffronPrimary = Color(0xFFE65100);
  static const Color saffronMedium = Color(0xFFFF7A00);
  static const Color saffronLight = Color(0xFFFFB347);
  static const Color saffronPale = Color(0xFFFFF3E0);

  // Secondary Deep Maroon / Vedic Crimson
  static const Color maroonDark = Color(0xFF5A1414);
  static const Color maroonPrimary = Color(0xFF7A1F1F);
  static const Color maroonMedium = Color(0xFF8B2E2E);
  static const Color maroonLight = Color(0xFFA83E3E);

  // Divine Gold Accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF4D06F);
  static const Color goldDark = Color(0xFFAA820A);
  static const Color goldMuted = Color(0xFFC5A059);

  // Light Theme Surfaces
  static const Color bgLight = Color(0xFFFFF8F0);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFDF9);
  static const Color cardBorderLight = Color(0xFFF0E5D8);
  static const Color textPrimaryLight = Color(0xFF2C1810);
  static const Color textSecondaryLight = Color(0xFF6E5D53);
  static const Color textMutedLight = Color(0xFF9E8E85);

  // Dark Theme Surfaces
  static const Color bgDark = Color(0xFF14100E);
  static const Color surfaceDark = Color(0xFF1E1714);
  static const Color cardDark = Color(0xFF261D19);
  static const Color cardBorderDark = Color(0xFF3E312B);
  static const Color textPrimaryDark = Color(0xFFFDF7F2);
  static const Color textSecondaryDark = Color(0xFFC7B8AF);
  static const Color textMutedDark = Color(0xFF8A7B73);

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFEF6C00);
  static const Color info = Color(0xFF1565C0);

  // Gradients
  static const LinearGradient saffronGradient = LinearGradient(
    colors: [saffronPrimary, saffronMedium, saffronLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient maroonGradient = LinearGradient(
    colors: [maroonDark, maroonPrimary, maroonMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, gold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradientLight = LinearGradient(
    colors: [Color(0xFF7A1F1F), Color(0xFF9B2A2A), Color(0xFFD35400)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradientDark = LinearGradient(
    colors: [Color(0xFF2A1010), Color(0xFF3B1515), Color(0xFF5A1E1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
