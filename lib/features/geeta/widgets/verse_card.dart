import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../models/verse_model.dart';

class VerseCard extends StatelessWidget {
  final VerseModel verse;
  final String preferredCommentatorKey;
  final double fontScale;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onPlayTts;
  final VoidCallback onTap;
  final bool isPlaying;

  const VerseCard({
    super.key,
    required this.verse,
    required this.preferredCommentatorKey,
    this.fontScale = 1.0,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onPlayTts,
    required this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    final commentator = verse.getCommentator(preferredCommentatorKey);
    final translationText = verse.getDisplayTranslationForLanguage(
      currentLang,
      preferredCommentatorKey: preferredCommentatorKey,
    );

    final badgeText = isGujarati
        ? '॥ ${langProvider.formatNumber(verse.chapter)}.${langProvider.formatNumber(verse.verse)} ॥'
        : '॥ ${verse.chapter}.${verse.verse} ॥';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isPlaying
                ? AppColors.gold
                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
            width: isPlaying ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isPlaying
                  ? AppColors.gold.withAlpha(40)
                  : Colors.black.withAlpha(isDark ? 40 : 10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Chapter.Verse Badge & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.saffronMedium.withAlpha(90) : AppColors.saffronLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        badgeText,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                              ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onPlayTts,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? (isDark ? AppColors.saffronPrimary.withAlpha(50) : AppColors.saffronPale)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPlaying ? AppColors.saffronPrimary : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPlaying ? Icons.pause_circle_filled_rounded : Icons.volume_up_rounded,
                              size: 20,
                              color: isPlaying
                                  ? AppColors.saffronPrimary
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                            if (isPlaying) ...[
                              const SizedBox(width: 4),
                              Text(
                                isGujarati ? 'વિરામ' : 'Pause',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.saffronPrimary,
                                      )
                                    : GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.saffronPrimary,
                                      ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        size: 20,
                        color: isBookmarked
                            ? AppColors.gold
                            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      ),
                      onPressed: onBookmarkToggle,
                      tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Sloka',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: '${verse.slok}\n\n${verse.transliteration}\n\nTranslation: $translationText',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sloka copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      tooltip: 'Copy Sloka',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Sanskrit Slok Text
            Center(
              child: Text(
                verse.slok,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifDevanagari(
                  fontSize: 17 * fontScale,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Transliteration
            if (verse.transliteration.isNotEmpty) ...[
              Center(
                child: Text(
                  verse.transliteration,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13 * fontScale,
                    fontStyle: FontStyle.italic,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            const Divider(height: 16),

            // Commentator Translation
            if (translationText.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${commentator?.author ?? (isGujarati ? 'અર્થ' : 'अर्थ')}: ',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 12 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          )
                        : GoogleFonts.outfit(
                            fontSize: 12 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          ),
                  ),
                  Expanded(
                    child: Text(
                      translationText,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 13.5 * fontScale,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              height: 1.5,
                            )
                          : GoogleFonts.outfit(
                              fontSize: 13 * fontScale,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              height: 1.45,
                            ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
