import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/ad_native_card.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/rashi_symbol_widget.dart';
import '../../kundali/screens/create_kundali_screen.dart';
import '../providers/rashi_provider.dart';
import '../widgets/rashi_card.dart';
import '../widgets/rashi_wheel.dart';
import 'rashi_detail_screen.dart';


class RashiScreen extends StatefulWidget {
  const RashiScreen({super.key});

  @override
  State<RashiScreen> createState() => _RashiScreenState();
}

class _RashiScreenState extends State<RashiScreen> {
  bool _isWheelView = false;

  @override
  Widget build(BuildContext context) {
    final rashiProvider = context.watch<RashiProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rashis = rashiProvider.rashis;
    final defaultRashi = RashiData.getRashiById(rashiProvider.defaultRashiId);

    final defaultRashiName = isGujarati ? defaultRashi.gujaratiName : defaultRashi.hindiName;
    final defaultRulingPlanet = isGujarati ? defaultRashi.rulingPlanetGujarati : defaultRashi.rulingPlanet;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: AppStrings.rashiTitle(currentLang),
        subtitle: '12 Vedic Zodiacs & Wisdom',
        showOm: true,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isWheelView ? Icons.grid_view_rounded : Icons.pie_chart_outline_rounded,
              color: AppColors.goldLight,
            ),
            onPressed: () => setState(() => _isWheelView = !_isWheelView),
            tooltip: _isWheelView ? 'Switch to Grid View' : 'Switch to Wheel View',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Pinned "My Rashi" Hero Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                      borderRadius: BorderRadius.circular(20),
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
                        RashiAvatarEmblem(rashi: defaultRashi, diameter: 52),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 14, color: AppColors.goldLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    isGujarati ? 'મારી મુખ્ય રાશિ' : 'MY DEFAULT RASHI',
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.goldLight,
                                            letterSpacing: 0.8,
                                          )
                                        : GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.goldLight,
                                            letterSpacing: 1.1,
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$defaultRashiName (${defaultRashi.englishName})',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                              ),
                              Text(
                                '${AppStrings.rulingPlanetLabel(currentLang)}: $defaultRulingPlanet',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 11,
                                        color: Colors.white70,
                                      )
                                    : GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            rashiProvider.selectRashi(defaultRashi);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RashiDetailScreen(rashi: defaultRashi),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            isGujarati ? 'વાંચો' : 'Reading',
                            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Native Ad Card
                const SliverToBoxAdapter(
                  child: AdNativeCard(),
                ),

          // Janam Kundali Discovery Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 40 : 10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.saffronPrimary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.saffronPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGujarati ? 'વૈદિક જન્મ કુંડળી' : 'वैदिक जन्म कुंडली',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                        ),
                        Text(
                          isGujarati
                              ? 'લગ્ન ચક્ર, ગ્રહ સ્થિતિ, દશા અને દોષ વિશ્લેષણ'
                              : 'लग्न चक्र, ग्रह स्थिति, दशा एवं दोष विश्लेषण',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateKundaliScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.saffronPrimary,
                      side: const BorderSide(color: AppColors.saffronPrimary, width: 1.2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isGujarati ? 'બનાવો' : 'बनाएं',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isWheelView
                        ? (isGujarati ? 'દ્વાદશ રાશિ ચક્ર' : 'द्वादश राशि चक्र / Zodiac Wheel')
                        : (isGujarati ? '૧૨ રાશિઓ' : 'द्वादश राशियाँ / 12 Rashis'),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          )
                        : GoogleFonts.cinzel(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          ),
                  ),
                  Text(
                    _isWheelView
                        ? (isGujarati ? 'સ્પર્શ કરી પસંદ કરો' : 'Tap to view')
                        : (isGujarati ? 'તમારી રાશિ પસંદ કરો' : 'Select your sign'),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 11,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          )
                        : GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Main View: Grid or Interactive Wheel
          if (_isWheelView)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: RashiWheel(
                  rashis: rashis,
                  selectedRashi: defaultRashi,
                  onSelected: (rashi) {
                    rashiProvider.selectRashi(rashi);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RashiDetailScreen(rashi: rashi),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final rashi = rashis[index];
                    final isDefault = rashi.id == rashiProvider.defaultRashiId;

                    return RashiCard(
                      rashi: rashi,
                      isDefault: isDefault,
                      isGujarati: isGujarati,
                      onTap: () {
                        rashiProvider.selectRashi(rashi);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RashiDetailScreen(rashi: rashi),
                          ),
                        );
                      },
                    );
                  },
                  childCount: rashis.length,
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
