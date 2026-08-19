import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../providers/geeta_provider.dart';
import 'verse_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarks = geetaProvider.bookmarks;

    return Scaffold(
      appBar: const CustomSpiritualAppBar(
        title: 'संग्रहित श्लोक',
        subtitle: 'Saved Slokas & Verses',
        showOm: false,
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 56,
                      color: isDark ? AppColors.goldLight.withAlpha(120) : AppColors.maroonPrimary.withAlpha(120),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'कोई श्लोक संग्रहित नहीं है',
                      style: GoogleFonts.notoSerifDevanagari(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on any verse card to save your favorite slokas here for quick access.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final parts = bookmarks[index].split('_');
                final ch = int.tryParse(parts.first) ?? 1;
                final v = int.tryParse(parts.last) ?? 1;
                final chapterMeta = ChapterMetadata.getChapter(ch);

                return Dismissible(
                  key: Key('bookmark_${ch}_$v'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.error,
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => geetaProvider.toggleBookmark(ch, v),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.gold.withAlpha(40) : AppColors.saffronPale,
                        ),
                        child: Text(
                          '$ch.$v',
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          ),
                        ),
                      ),
                      title: Text(
                        'अध्याय $ch (${chapterMeta.nameHindi}), श्लोक $v',
                        style: GoogleFonts.notoSerifDevanagari(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                      ),
                      subtitle: Text(
                        chapterMeta.nameEnglish,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {
                        geetaProvider.selectVerse(ch, v);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerseDetailScreen(
                              chapterNumber: ch,
                              initialVerseNumber: v,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
