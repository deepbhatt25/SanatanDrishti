import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/tts_service.dart';
import '../providers/geeta_provider.dart';

class TtsControlsBar extends StatefulWidget {
  const TtsControlsBar({super.key});

  @override
  State<TtsControlsBar> createState() => _TtsControlsBarState();
}

class _TtsControlsBarState extends State<TtsControlsBar> {
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPlaying = geetaProvider.isTtsPlaying;
    final speakTranslation = geetaProvider.speakTranslation;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying ? AppColors.gold : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying ? AppColors.gold.withAlpha(50) : Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Play/Pause Action
              GestureDetector(
                onTap: () {
                  if (isPlaying) {
                    geetaProvider.pauseSpeech();
                  } else {
                    geetaProvider.playCurrentVerseSpeech();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isPlaying ? AppColors.maroonGradient : AppColors.saffronGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.saffronPrimary.withAlpha(70),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Stop Button if playing
              if (isPlaying || geetaProvider.ttsState == TtsState.paused) ...[
                IconButton(
                  icon: const Icon(Icons.stop_rounded, color: AppColors.error),
                  onPressed: () => geetaProvider.stopSpeech(),
                  tooltip: 'Stop Audio',
                ),
              ],

              // Slok vs Translation toggle
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            geetaProvider.setSpeakTranslation(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: !speakTranslation
                                  ? (isDark ? AppColors.saffronDark : AppColors.saffronPrimary)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              'श्लोक (Slok)',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: !speakTranslation
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            geetaProvider.setSpeakTranslation(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: speakTranslation
                                  ? (isDark ? AppColors.saffronDark : AppColors.saffronPrimary)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              'अनुवाद (Mean)',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: speakTranslation
                                    ? Colors.white
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Expand Audio Settings Button
              IconButton(
                icon: Icon(
                  _showSettings ? Icons.tune_rounded : Icons.tune_outlined,
                  color: _showSettings
                      ? (isDark ? AppColors.goldLight : AppColors.saffronPrimary)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                onPressed: () => setState(() => _showSettings = !_showSettings),
                tooltip: 'TTS Audio Settings',
              ),
            ],
          ),

          // Expanded Settings (Speed & Auto-Advance)
          if (_showSettings) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.speed_rounded,
                  size: 16,
                  color: isDark ? AppColors.goldLight : AppColors.saffronPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Speed: ${geetaProvider.ttsSpeed.toStringAsFixed(2)}x',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: geetaProvider.ttsSpeed,
                    min: 0.2,
                    max: 0.9,
                    divisions: 7,
                    activeColor: isDark ? AppColors.goldLight : AppColors.saffronPrimary,
                    inactiveColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    onChanged: (val) => geetaProvider.setTtsSpeed(val),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.skip_next_rounded,
                      size: 16,
                      color: isDark ? AppColors.goldLight : AppColors.saffronPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Auto-play Next Verse',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: geetaProvider.autoAdvance,
                  activeTrackColor: AppColors.saffronPrimary,
                  onChanged: (val) => geetaProvider.toggleAutoAdvance(val),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
