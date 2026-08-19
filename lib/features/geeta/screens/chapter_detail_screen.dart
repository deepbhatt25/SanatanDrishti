import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';
import '../providers/geeta_provider.dart';
import '../widgets/font_size_sheet.dart';
import '../widgets/verse_card.dart';
import 'verse_detail_screen.dart';

class ChapterDetailScreen extends StatefulWidget {
  final ChapterModel chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  final Map<int, VerseModel> _versesMap = {};
  final Set<int> _loadingVerses = {};
  late PageController _pageController;
  int _currentSwipeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInitialVerses();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadInitialVerses() {
    final geetaProvider = context.read<GeetaProvider>();
    for (int i = 1; i <= widget.chapter.versesCount; i++) {
      _loadVerse(i, geetaProvider);
    }
  }

  Future<void> _loadVerse(int verseNumber, GeetaProvider provider) async {
    if (_versesMap.containsKey(verseNumber) || _loadingVerses.contains(verseNumber)) return;

    setState(() {
      _loadingVerses.add(verseNumber);
    });

    final verse = await provider.fetchVerseData(widget.chapter.chapterNumber, verseNumber);
    if (mounted && verse != null) {
      setState(() {
        _versesMap[verseNumber] = verse;
        _loadingVerses.remove(verseNumber);
      });
    } else if (mounted) {
      setState(() {
        _loadingVerses.remove(verseNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final currentLang = langProvider.currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isListView = geetaProvider.viewMode == GeetaViewMode.list;
    final isTtsActive = geetaProvider.isTtsPlaying || geetaProvider.ttsState == TtsState.paused;
    final meta = ChapterMetadata.getChapter(widget.chapter.chapterNumber);

    final chapterHeaderTitle = isGujarati ? meta.nameGujarati : (meta.meaningHindi.isNotEmpty ? meta.meaningHindi : widget.chapter.translation);
    final versesCountLabel = isGujarati
        ? '${langProvider.formatNumber(widget.chapter.versesCount)} શ્લોકો'
        : '${widget.chapter.versesCount} श्लोक';
    final chapterSummary = isGujarati
        ? meta.summaryGujarati
        : (widget.chapter.summaryHi.isNotEmpty ? widget.chapter.summaryHi : widget.chapter.summaryEn);

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: '${AppStrings.chapter(currentLang)} ${langProvider.formatNumber(widget.chapter.chapterNumber)}',
        subtitle: isGujarati ? meta.nameGujarati : widget.chapter.name,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: Icon(
              isListView ? Icons.view_carousel_rounded : Icons.view_list_rounded,
              color: AppColors.goldLight,
            ),
            onPressed: () {
              geetaProvider.setViewMode(
                isListView ? GeetaViewMode.swipe : GeetaViewMode.list,
              );
            },
            tooltip: isListView ? 'Switch to Swipe View' : 'Switch to List View',
          ),
          IconButton(
            icon: const Icon(Icons.format_size_rounded, color: AppColors.goldLight),
            onPressed: () => FontSizeBottomSheet.show(context),
            tooltip: 'Adjust Font Size',
          ),
        ],
      ),
      bottomNavigationBar: isTtsActive
          ? Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.gold,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffronPrimary.withAlpha(60),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      geetaProvider.isTtsPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: AppColors.saffronPrimary,
                      size: 32,
                    ),
                    onPressed: () {
                      if (geetaProvider.isTtsPlaying) {
                        geetaProvider.pauseSpeech();
                      } else {
                        geetaProvider.playCurrentVerseSpeech();
                      }
                    },
                    tooltip: geetaProvider.isTtsPlaying ? 'Pause Audio' : 'Resume Audio',
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGujarati
                              ? '${AppStrings.chapter(currentLang)} ${langProvider.formatNumber(geetaProvider.currentChapter)}, ${AppStrings.verse(currentLang)} ${langProvider.formatNumber(geetaProvider.currentVerse)}'
                              : 'अध्याय ${geetaProvider.currentChapter}, श्लोक ${geetaProvider.currentVerse}',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                ),
                        ),
                        Text(
                          geetaProvider.speakTranslation
                              ? (isGujarati ? 'અનુવાદ વાચન ચાલુ છે' : 'अनुवाद (Translation Playing)')
                              : (isGujarati ? 'શ્લોક ગાન ચાલુ છે' : 'श्लोक (Sanskrit Chanting)'),
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                )
                              : GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (geetaProvider.autoAdvance) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Auto On',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffronPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  IconButton(
                    icon: const Icon(Icons.stop_circle_outlined, color: AppColors.error, size: 26),
                    onPressed: () => geetaProvider.stopSpeech(),
                    tooltip: 'Stop Audio & Auto-Advance',
                  ),
                ],
              ),
            )
          : null,
      body: Column(
        children: [
          // Chapter Overview Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chapterHeaderTitle,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                              )
                            : GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      versesCountLabel,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            )
                          : GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  chapterSummary,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 12,
                          color: Colors.white.withAlpha(230),
                          height: 1.45,
                        )
                      : GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white.withAlpha(230),
                          height: 1.35,
                        ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Main Content (List View or Swipe View)
          Expanded(
            child: isListView ? _buildListView(geetaProvider) : _buildSwipeView(geetaProvider, isGujarati, currentLang),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(GeetaProvider geetaProvider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: widget.chapter.versesCount,
      itemBuilder: (context, index) {
        final verseNum = index + 1;
        final verse = _versesMap[verseNum];

        if (verse == null) {
          _loadVerse(verseNum, geetaProvider);
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LoadingSkeletonCard(height: 180),
          );
        }

        final isBookmarked = geetaProvider.isVerseBookmarked(widget.chapter.chapterNumber, verseNum);
        final isPlayingThis = (geetaProvider.isTtsPlaying || geetaProvider.ttsState == TtsState.paused) &&
            geetaProvider.currentChapter == widget.chapter.chapterNumber &&
            geetaProvider.currentVerse == verseNum;

        return VerseCard(
          verse: verse,
          preferredCommentatorKey: geetaProvider.preferredCommentator,
          fontScale: geetaProvider.fontScale,
          isBookmarked: isBookmarked,
          isPlaying: isPlayingThis,
          onBookmarkToggle: () => geetaProvider.toggleBookmark(widget.chapter.chapterNumber, verseNum),
          onPlayTts: () {
            if (isPlayingThis) {
              geetaProvider.stopSpeech();
            } else {
              geetaProvider.selectVerse(widget.chapter.chapterNumber, verseNum).then((_) {
                geetaProvider.playCurrentVerseSpeech();
              });
            }
          },
          onTap: () {
            geetaProvider.selectVerse(widget.chapter.chapterNumber, verseNum);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerseDetailScreen(
                  chapterNumber: widget.chapter.chapterNumber,
                  initialVerseNumber: verseNum,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSwipeView(GeetaProvider geetaProvider, bool isGujarati, AppLanguage currentLang) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();

    return Column(
      children: [
        // Swipe Header indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isGujarati
                    ? 'શ્લોક ${langProvider.formatNumber(_currentSwipeIndex + 1)} / ${langProvider.formatNumber(widget.chapter.versesCount)}'
                    : 'Verse ${_currentSwipeIndex + 1} of ${widget.chapter.versesCount}',
                style: isGujarati
                    ? GoogleFonts.notoSerifGujarati(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                      )
                    : GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                      ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _currentSwipeIndex > 0
                        ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _currentSwipeIndex < widget.chapter.versesCount - 1
                        ? () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.chapter.versesCount,
            onPageChanged: (idx) {
              setState(() => _currentSwipeIndex = idx);
              geetaProvider.selectVerse(widget.chapter.chapterNumber, idx + 1);
            },
            itemBuilder: (context, index) {
              final verseNum = index + 1;
              final verse = _versesMap[verseNum];

              if (verse == null) {
                _loadVerse(verseNum, geetaProvider);
                return const Center(child: LoadingSkeletonCard(height: 250));
              }

              final isBookmarked = geetaProvider.isVerseBookmarked(widget.chapter.chapterNumber, verseNum);
              final isPlayingThis = (geetaProvider.isTtsPlaying || geetaProvider.ttsState == TtsState.paused) &&
                  geetaProvider.currentChapter == widget.chapter.chapterNumber &&
                  geetaProvider.currentVerse == verseNum;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: VerseCard(
                  verse: verse,
                  preferredCommentatorKey: geetaProvider.preferredCommentator,
                  fontScale: geetaProvider.fontScale,
                  isBookmarked: isBookmarked,
                  isPlaying: isPlayingThis,
                  onBookmarkToggle: () => geetaProvider.toggleBookmark(widget.chapter.chapterNumber, verseNum),
                  onPlayTts: () {
                    if (isPlayingThis) {
                      geetaProvider.stopSpeech();
                    } else {
                      geetaProvider.selectVerse(widget.chapter.chapterNumber, verseNum).then((_) {
                        geetaProvider.playCurrentVerseSpeech();
                      });
                    }
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerseDetailScreen(
                          chapterNumber: widget.chapter.chapterNumber,
                          initialVerseNumber: verseNum,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
