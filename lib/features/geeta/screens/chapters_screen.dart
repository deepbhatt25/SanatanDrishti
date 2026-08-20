import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/ad_native_card.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/chapter_model.dart';
import '../providers/geeta_provider.dart';
import 'bookmarks_screen.dart';
import 'chapter_detail_screen.dart';
import 'geeta_search_screen.dart';
import 'verse_detail_screen.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGujarati = langProvider.isGujarati;
    final chapters = geetaProvider.chapters;

    final lastChapterNum = geetaProvider.currentChapter;
    final lastVerseNum = geetaProvider.currentVerse;
    final lastChapterMeta = ChapterMetadata.getChapter(lastChapterNum);

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: AppStrings.geetaHomeTitle(langProvider.currentLanguage),
        subtitle: AppStrings.geetaSubtitle(langProvider.currentLanguage),
        showOm: true,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.goldLight),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GeetaSearchScreen()),
              );
            },
            tooltip: AppStrings.searchVerses(langProvider.currentLanguage),
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_rounded, color: AppColors.goldLight),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
            tooltip: AppStrings.bookmarks(langProvider.currentLanguage),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Last Read Banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.maroonPrimary.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold.withAlpha(50),
                            border: Border.all(color: AppColors.goldLight, width: 1),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: AppColors.goldLight,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isGujarati ? 'વાચન ચાલુ રાખો' : 'CONTINUE READING',
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.goldLight,
                                            letterSpacing: 0.8,
                                          )
                                        : GoogleFonts.outfit(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.goldLight,
                                            letterSpacing: 1.1,
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isGujarati
                                    ? 'અધ્યાય ${langProvider.formatNumber(lastChapterNum)} • શ્લોક ${langProvider.formatNumber(lastVerseNum)}'
                                    : 'अध्याय $lastChapterNum • श्लोक $lastVerseNum',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                              ),
                              Text(
                                isGujarati ? lastChapterMeta.nameGujarati : lastChapterMeta.nameHindi,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.goldLight, size: 36),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VerseDetailScreen(
                                  chapterNumber: lastChapterNum,
                                  initialVerseNumber: lastVerseNum,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Daily Divine Wisdom Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_rounded, color: AppColors.gold, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              isGujarati ? 'આજનું દિવ્ય જ્ઞાન' : 'आज का दिव्य ज्ञान',
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
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isGujarati
                              ? 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nમા ફલેષુ કદાચન, મા કર્મફલહેતુર્ભૂર્મા તે સંગોડસ્ત્વકર્મણિ॥'
                              : 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
                          style: GoogleFonts.notoSerifDevanagari(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Chapters List Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isGujarati ? 'બધા ૧૮ અધ્યાય' : 'सभी १८ अध्याय',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                ),
                        ),
                        Text(
                          isGujarati ? '૭૦૦ શ્લોક' : '७०० श्लोक',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Chapters List with Integrated Native Ads
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final chapter = chapters[index];
                        final item = _ChapterListItem(
                          chapter: chapter,
                          isGujarati: isGujarati,
                          langProvider: langProvider,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChapterDetailScreen(chapter: chapter),
                              ),
                            );
                          },
                        );

                        // Insert Native Ad after Chapter 6 and Chapter 12
                        if (chapter.chapterNumber == 6 || chapter.chapterNumber == 12) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              item,
                              const AdNativeCard(),
                            ],
                          );
                        }

                        return item;
                      },
                      childCount: chapters.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Banner Ad
          const AdBannerWidget(),
        ],
      ),
    );
  }
}

class _ChapterListItem extends StatelessWidget {
  final ChapterModel chapter;
  final bool isGujarati;
  final LanguageProvider langProvider;
  final VoidCallback onTap;

  const _ChapterListItem({
    required this.chapter,
    required this.isGujarati,
    required this.langProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = ChapterMetadata.getChapter(chapter.chapterNumber);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Chapter Number Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.saffronGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.saffronPrimary.withAlpha(50),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      langProvider.formatNumber(chapter.chapterNumber),
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          : GoogleFonts.cinzel(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Chapter Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              isGujarati ? meta.nameGujarati : chapter.name,
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    )
                                  : GoogleFonts.notoSerifDevanagari(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gold.withAlpha(30)
                                  : AppColors.saffronPale,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isGujarati
                                  ? '${langProvider.formatNumber(chapter.versesCount)} શ્લોક'
                                  : '${chapter.versesCount} श्लोक',
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                                    )
                                  : GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        chapter.translation,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isGujarati
                            ? meta.meaningGujarati
                            : (chapter.meaningHi.isNotEmpty ? chapter.meaningHi : chapter.meaningEn),
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              )
                            : GoogleFonts.outfit(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark ? AppColors.goldLight.withAlpha(150) : AppColors.textMutedLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
