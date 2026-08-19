import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/rashi_data.dart';

class RashiSymbolWidget extends StatelessWidget {
  final RashiInfo rashi;
  final double size;
  final Color? color;

  const RashiSymbolWidget({
    super.key,
    required this.rashi,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      rashi.symbol,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamilyFallback: const [
          'Apple Color Emoji',
          'Noto Color Emoji',
          'Segoe UI Emoji',
          'Noto Sans Symbols',
          'Arial Unicode MS',
          'sans-serif',
        ],
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
    this.diameter = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold.withAlpha(40),
        border: Border.all(color: AppColors.goldLight, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rashi.symbol,
              style: TextStyle(
                fontSize: diameter * 0.38,
                color: Colors.white,
                fontFamilyFallback: const [
                  'Apple Color Emoji',
                  'Noto Color Emoji',
                  'Segoe UI Emoji',
                  'Noto Sans Symbols',
                  'Arial Unicode MS',
                  'sans-serif',
                ],
              ),
            ),
            Text(
              rashi.shortName,
              style: GoogleFonts.notoSerifDevanagari(
                fontSize: diameter * 0.18,
                fontWeight: FontWeight.bold,
                color: AppColors.goldLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
