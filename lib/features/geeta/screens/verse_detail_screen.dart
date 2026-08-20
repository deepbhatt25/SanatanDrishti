import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/verse_model.dart';
import '../providers/geeta_provider.dart';
import '../widgets/commentator_selector.dart';
import '../widgets/font_size_sheet.dart';
import '../widgets/tts_controls_bar.dart';

class VerseDetailScreen extends StatefulWidget {
  final int chapterNumber;
  final int initialVerseNumber;

  const VerseDetailScreen({
    super.key,
    required this.chapterNumber,
    required this.initialVerseNumber,
  });

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeetaProvider>().selectVerse(
            widget.chapterNumber,
            widget.initialVerseNumber,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentVerse = geetaProvider.currentVerseModel;
    final ch = geetaProvider.currentChapter;
    final v = geetaProvider.currentVerse;
    final isBookmarked = geetaProvider.isVerseBookmarked(ch, v);
    final fontScale = geetaProvider.fontScale;
    final maxVerses = ChapterMetadata.getVerseCount(ch);
    final chapterMeta = ChapterMetadata.getChapter(ch);

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: isGujarati
            ? '${AppStrings.chapter(langProvider.currentLanguage)} ${langProvider.formatNumber(ch)}, ${AppStrings.verse(langProvider.currentLanguage)} ${langProvider.formatNumber(v)}'
            : 'अध्याय $ch, श्लोक $v',
        subtitle: isGujarati ? chapterMeta.nameGujarati : chapterMeta.nameEnglish,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.gold : AppColors.goldLight,
            ),
            onPressed: () => geetaProvider.toggleBookmark(ch, v),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Sloka',
          ),
          IconButton(
            icon: const Icon(Icons.format_size_rounded, color: AppColors.goldLight),
            onPressed: () => FontSizeBottomSheet.show(context),
            tooltip: 'Adjust Font Size',
          ),
        ],
      ),
      body: geetaProvider.isLoadingVerse
          ? const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  LoadingSkeletonCard(height: 180),
                  SizedBox(height: 16),
                  LoadingSkeletonCard(height: 120),
                  SizedBox(height: 16),
                  LoadingSkeletonCard(height: 200),
                ],
              ),
            )
          : geetaProvider.verseError != null || currentVerse == null
              ? ErrorStateView(
                  message: geetaProvider.verseError,
                  onRetry: () => geetaProvider.selectVerse(ch, v),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Main Slok Sacred Card
                            _buildMainSlokCard(context, currentVerse, isDark, fontScale),

                            const SizedBox(height: 16),

                            // Commentator Selection Dropdown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'भाष्यकार / Commentator',
                                    style: GoogleFonts.cinzel(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${currentVerse.commentators.length} Scholars',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            CommentatorSelector(
                              commentators: currentVerse.commentators,
                              selectedKey: geetaProvider.preferredCommentator,
                              onSelected: (key) => geetaProvider.setPreferredCommentator(key),
                            ),

                            const SizedBox(height: 16),

                            // Translation & Commentary Content
                            _buildCommentaryCard(context, currentVerse, geetaProvider, isDark, fontScale, isGujarati),
                          ],
                        ),
                      ),
                    ),

                    // Persistent TTS Controls Bar
                    const TtsControlsBar(),

                    // Previous / Next Navigation Row
                    _buildNavigationRow(context, geetaProvider, ch, v, maxVerses, isDark),

                    // Bottom Banner Ad
                    const AdBannerWidget(),
                  ],
                ),
    );
  }

  Widget _buildMainSlokCard(BuildContext context, dynamic currentVerse, bool isDark, double fontScale) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Decorative Sanskrit Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 32,
                color: isDark ? AppColors.gold.withAlpha(100) : AppColors.saffronMedium.withAlpha(120),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '॥ श्रीमद्भगवद्गीता ॥',
                  style: GoogleFonts.notoSerifDevanagari(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Container(
                height: 1,
                width: 32,
                color: isDark ? AppColors.gold.withAlpha(100) : AppColors.saffronMedium.withAlpha(120),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sanskrit Shlok Text
          SelectableText(
            currentVerse.slok,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifDevanagari(
              fontSize: 19 * fontScale,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 14),

          // Transliteration
          if (currentVerse.transliteration.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                currentVerse.transliteration,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14 * fontScale,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentaryCard(
    BuildContext context,
    dynamic currentVerse,
    GeetaProvider geetaProvider,
    bool isDark,
    double fontScale,
    bool isGujarati,
  ) {
    final commentator = currentVerse.getCommentator(geetaProvider.preferredCommentator);
    if (commentator == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 18,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        commentator.author,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                onPressed: () {
                  final text = currentVerse.getDisplayTranslation(
                    preferredCommentatorKey: geetaProvider.preferredCommentator,
                  );
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Commentary copied to clipboard')),
                  );
                },
                tooltip: 'Copy',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const Divider(height: 20),

          // Localized Hindi / Gujarati Translation
          if (commentator.hindiTranslation != null && commentator.hindiTranslation!.isNotEmpty) ...[
            Text(
              isGujarati ? 'અનુવાદ (Gujarati Translation):' : 'हिन्दी अनुवाद (Hindi Translation):',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              isGujarati
                  ? VerseModel.convertToGujaratiScript(commentator.hindiTranslation!)
                  : commentator.hindiTranslation!,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 15 * fontScale,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.6,
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 15 * fontScale,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.6,
                    ),
            ),
            const SizedBox(height: 14),
          ],

          // English Translation
          if (commentator.englishTranslation != null && commentator.englishTranslation!.isNotEmpty) ...[
            Text(
              'English Translation:',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              commentator.englishTranslation!,
              style: GoogleFonts.outfit(
                fontSize: 14 * fontScale,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Localized Hindi / Gujarati Commentary
          if (commentator.hindiCommentary != null && commentator.hindiCommentary!.isNotEmpty) ...[
            Text(
              isGujarati ? 'વિસ્તૃત ભાષ્ય (Gujarati Purport):' : 'विस्तृत व्याख्या (Hindi Purport):',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              isGujarati
                  ? VerseModel.convertToGujaratiScript(commentator.hindiCommentary!)
                  : commentator.hindiCommentary!,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 14 * fontScale,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.6,
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 14 * fontScale,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.6,
                    ),
            ),
            const SizedBox(height: 14),
          ],

          // English Commentary
          if (commentator.englishCommentary != null && commentator.englishCommentary!.isNotEmpty) ...[
            Text(
              'Commentary / Purport:',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              commentator.englishCommentary!,
              style: GoogleFonts.outfit(
                fontSize: 14 * fontScale,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationRow(
    BuildContext context,
    GeetaProvider geetaProvider,
    int ch,
    int v,
    int maxVerses,
    bool isDark,
  ) {
    final hasPrev = !(ch == 1 && v == 1);
    final hasNext = !(ch == 18 && v == ChapterMetadata.getVerseCount(18));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: hasPrev
                  ? () {
                      geetaProvider.previousVerse();
                      AdService.instance.recordActionAndCheckInterstitial();
                    }
                  : null,
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
              label: const Text('Previous'),
            ),
            Text(
              '$v / $maxVerses',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
            ),
            ElevatedButton.icon(
              onPressed: hasNext
                  ? () {
                      geetaProvider.nextVerse();
                      AdService.instance.recordActionAndCheckInterstitial();
                    }
                  : null,
              label: const Text('Next'),
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}
