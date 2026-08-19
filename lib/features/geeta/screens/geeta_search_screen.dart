import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../providers/geeta_provider.dart';
import 'verse_detail_screen.dart';

class GeetaSearchScreen extends StatefulWidget {
  const GeetaSearchScreen({super.key});

  @override
  State<GeetaSearchScreen> createState() => _GeetaSearchScreenState();
}

class _GeetaSearchScreenState extends State<GeetaSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedChapter = 1;
  int _selectedVerse = 1;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geetaProvider = context.watch<GeetaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVerses = ChapterMetadata.getVerseCount(_selectedChapter);

    final filteredChapters = ChapterMetadata.chapters.where((ch) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return ch.nameHindi.toLowerCase().contains(q) ||
          ch.nameEnglish.toLowerCase().contains(q) ||
          ch.transliteration.toLowerCase().contains(q) ||
          ch.meaningEnglish.toLowerCase().contains(q) ||
          ch.summaryEnglish.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: const CustomSpiritualAppBar(
        title: 'श्लोक खोज एवं गन्तव्य',
        subtitle: 'Jump to Verse or Search Chapters',
        showOm: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Jump Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on_rounded, color: AppColors.saffronPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'त्वरित श्लोक गन्तव्य / Quick Jump',
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Chapter Picker
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'अध्याय (Chapter)',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedChapter,
                                  isExpanded: true,
                                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                  items: List.generate(18, (i) => i + 1).map((ch) {
                                    return DropdownMenuItem(
                                      value: ch,
                                      child: Text(
                                        'Chapter $ch',
                                        style: GoogleFonts.outfit(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedChapter = val;
                                        if (_selectedVerse > ChapterMetadata.getVerseCount(val)) {
                                          _selectedVerse = 1;
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Verse Picker
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'श्लोक (Verse 1-$maxVerses)',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedVerse.clamp(1, maxVerses),
                                  isExpanded: true,
                                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                  items: List.generate(maxVerses, (i) => i + 1).map((v) {
                                    return DropdownMenuItem(
                                      value: v,
                                      child: Text('Verse $v', style: GoogleFonts.outfit(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedVerse = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        geetaProvider.selectVerse(_selectedChapter, _selectedVerse);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerseDetailScreen(
                              chapterNumber: _selectedChapter,
                              initialVerseNumber: _selectedVerse,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text('Open Chapter $_selectedChapter, Verse $_selectedVerse'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Bar for Chapters & Concepts
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chapters by name, yoga, or theme...',
                hintStyle: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMutedLight),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.saffronPrimary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),

            const SizedBox(height: 16),

            Text(
              'अध्याय परिणाम / Search Results (${filteredChapters.length})',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
            ),

            const SizedBox(height: 8),

            ...filteredChapters.map((ch) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.saffronPrimary,
                    foregroundColor: Colors.white,
                    child: Text('${ch.chapterNumber}'),
                  ),
                  title: Text(
                    ch.nameHindi,
                    style: GoogleFonts.notoSerifDevanagari(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${ch.nameEnglish} • ${ch.versesCount} verses',
                    style: GoogleFonts.outfit(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    geetaProvider.selectVerse(ch.chapterNumber, 1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerseDetailScreen(
                          chapterNumber: ch.chapterNumber,
                          initialVerseNumber: 1,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
