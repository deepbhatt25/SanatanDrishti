import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/ad_reward_dialog.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/kundali_model.dart';
import '../services/kundali_pdf_service.dart';
import '../widgets/kundali_chart_painter.dart';
import 'kundali_pdf_viewer_screen.dart';

class KundaliPreviewScreen extends StatefulWidget {
  final KundaliResult kundali;

  const KundaliPreviewScreen({super.key, required this.kundali});

  @override
  State<KundaliPreviewScreen> createState() => _KundaliPreviewScreenState();
}

class _KundaliPreviewScreenState extends State<KundaliPreviewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedChartType = 0; // 0: Lagna (D1), 1: Navamsha (D9), 2: Chandra
  bool _isDoshaUnlocked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _downloadKundali() {
    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    AdRewardDialog.show(
      context,
      title: isGujarati ? 'સંપૂર્ણ કુંડળી PDF ડાઉનલોડ' : 'सम्पूर्ण कुंडली PDF डाउनलोड',
      description: isGujarati
          ? 'સંપૂર્ણ જન્મકુંડળી વિશ્લેષણ, ગ્રહ સ્થિતિ અને દશા ફળની PDF તમારા ફોનના Downloads ફોલ્ડરમાં સાચવવા માટે એક નાનો પ્રાયોજિત વિડિઓ જુઓ.'
          : 'सम्पूर्ण जन्मकुंडली विश्लेषण, ग्रह स्थिति एवं दशा फल की PDF अपने फोन के Downloads फोल्डर में सहेजने के लिए एक छोटा प्रायोजित वीडियो देखें।',
      rewardDescription: isGujarati ? 'સંપૂર્ણ કુંડળી PDF ડાઉનલોડ થશે' : 'सम्पूर्ण कुंडली PDF डाउनलोड होगी',
      icon: Icons.picture_as_pdf_rounded,
      onRewardGranted: () async {
        if (!mounted) return;
        await _generateAndShowPdfDialog(context, widget.kundali, isGujarati);
      },
    );
  }

  Future<void> _generateAndShowPdfDialog(BuildContext context, KundaliResult k, bool isGujarati) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.gold),
              const SizedBox(height: 16),
              Text(
                isGujarati ? 'પીડીએફ તૈયાર થઈ રહી છે...' : 'PDF तैयार की जा रही है...',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final file = await KundaliPdfService.instance.generateAndSaveKundaliPdf(
        kundali: k,
        isGujarati: isGujarati,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.cardDark,
          title: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: AppColors.gold, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isGujarati ? 'PDF ડાઉનલોડ પૂર્ણ!' : 'PDF डाउनलोड पूर्ण!',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, color: AppColors.goldLight)
                      : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, color: AppColors.goldLight),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Platform.isIOS
                    ? (isGujarati
                        ? 'કુંડળી PDF સફળતાપૂર્વક સાચવવામાં આવી છે!\n\n📁 ફાઈલ જોવા માટે: Files એપ -> Browse (નીચે) -> On My iPhone -> SanatanDrishti / Downloads ખોલો.'
                        : 'कुंडली PDF सफलतापूर्वक सहेजी गई है!\n\n📁 फाइल देखने के लिए: Files ऐप -> Browse (नीचे) -> On My iPhone -> SanatanDrishti / Downloads खोलें।')
                    : (isGujarati
                        ? 'કુંડળી PDF સફળતાપૂર્વક તમારા ફોનના Downloads ફોલ્ડરમાં સાચવવામાં આવી છે (/storage/emulated/0/Download/):'
                        : 'कुंडली PDF सफलतापूर्वक आपके फोन के Downloads फोल्डर में सहेजी गई है (/storage/emulated/0/Download/):'),
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withAlpha(60)),
                ),
                child: SelectableText(
                  file.path,
                  style: GoogleFonts.outfit(color: AppColors.goldLight, fontSize: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isGujarati ? 'બંધ કરો' : 'बंद करें', style: const TextStyle(color: Colors.white70)),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.goldLight,
                side: const BorderSide(color: AppColors.gold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final box = ctx.findRenderObject() as RenderBox?;
                final origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
                KundaliPdfService.instance.sharePdf(
                  file.path,
                  sharePositionOrigin: origin,
                  subject: isGujarati ? '${k.profile.name} ની જન્મ કુંડળી' : '${k.profile.name} की जन्म कुंडली',
                );
              },
              icon: const Icon(Icons.share_rounded, size: 16),
              label: Text(
                isGujarati ? 'શેર / સેવ કરો' : 'शेयर / सहेजें',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffronPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KundaliPdfViewerScreen(
                      kundali: k,
                      pdfFile: file,
                      isGujarati: isGujarati,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility_rounded, size: 18),
              label: Text(
                isGujarati ? 'પીડીએફ જુઓ' : 'PDF देखें',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _shareKundali(BuildContext context) async {
    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.gold),
              const SizedBox(height: 16),
              Text(
                isGujarati ? 'પીડીએફ શેરિંગ તૈયાર થઈ રહી છે...' : 'PDF शेयरिंग तैयार की जा रही है...',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final file = await KundaliPdfService.instance.generateAndSaveKundaliPdf(
        kundali: widget.kundali,
        isGujarati: isGujarati,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final box = context.findRenderObject() as RenderBox?;
      final origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
      await KundaliPdfService.instance.sharePdf(
        file.path,
        sharePositionOrigin: origin,
        subject: isGujarati
            ? '${widget.kundali.profile.name} ની જન્મ કુંડળી'
            : '${widget.kundali.profile.name} की जन्म कुंडली',
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final k = widget.kundali;

    final lagnaRashiInfo = RashiData.getRashiById(k.lagnaRashiId);
    final moonRashiInfo = RashiData.getRashiById(k.moonRashiId);

    final lagnaName = isGujarati ? lagnaRashiInfo.gujaratiName : lagnaRashiInfo.hindiName;
    final moonName = isGujarati ? moonRashiInfo.gujaratiName : moonRashiInfo.hindiName;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: k.profile.name,
        subtitle: '${DateFormat('dd/MM/yyyy').format(k.profile.dateOfBirth)} • ${k.profile.cityName}',
        showOm: false,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.goldLight),
            tooltip: isGujarati ? 'કુંડળી શેર કરો' : 'कुंडली शेयर करें',
            onPressed: () => _shareKundali(context),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.goldLight),
            tooltip: AppStrings.downloadKundaliBtn(currentLang),
            onPressed: _downloadKundali,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: isDark ? AppColors.goldLight : Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.gold,
          indicatorWeight: 3,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: isGujarati ? 'કુંડળી ચક્ર' : 'कुंडली चक्र'),
            Tab(text: isGujarati ? 'દેખાવ & સ્વભાવ' : 'रूप-रंग एवं स्वभाव'),
            Tab(text: isGujarati ? 'વિવાહ & ભાગ્યોદય' : 'विवाह एवं भाग्योदय'),
            Tab(text: isGujarati ? 'રાજયોગ & દોષ' : 'राजयोग एवं दोष'),
            Tab(text: isGujarati ? 'ગ્રહ સ્થિતિ' : 'ग्रह स्थिति'),
            Tab(text: isGujarati ? 'વિંશોત્તરી દશા' : 'विंशोत्तरी दशा'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hero Mini Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF241010) : const Color(0xFFFFF3E0),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeroBadge(
                  label: isGujarati ? 'લગ્ન' : 'लग्न',
                  value: '$lagnaName (${k.lagnaDegree.toStringAsFixed(1)}°)',
                  isDark: isDark,
                ),
                Container(width: 1, height: 24, color: Colors.grey.withAlpha(80)),
                _buildHeroBadge(
                  label: isGujarati ? 'ચંદ્ર રાશિ' : 'चन्द्र राशि',
                  value: moonName,
                  isDark: isDark,
                ),
                Container(width: 1, height: 24, color: Colors.grey.withAlpha(80)),
                _buildHeroBadge(
                  label: isGujarati ? 'નક્ષત્ર' : 'नक्षत्र',
                  value: '${isGujarati ? k.nakshatraGu : k.nakshatraHi} (${k.charan})',
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // Main Tabs View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Charts
                _buildChartTab(isDark, isGujarati),

                // Tab 2: Appearance & Swabhav (How they look & Behaviour)
                _buildAppearanceSwabhavTab(isDark, isGujarati),

                // Tab 3: Marriage & Bhagyodaya (Marriage Time & Bhagya Yog)
                _buildMarriageBhagyodayaTab(isDark, isGujarati),

                // Tab 4: Raja Yogas & Doshas
                _buildRajaYogaDoshaTab(isDark, isGujarati),

                // Tab 5: Graha Sthiti & Avakahada
                _buildPlanetsTab(isDark, isGujarati),

                // Tab 6: Vimshottari Dasha & Spiritual Remedies
                _buildDashaTab(isDark, isGujarati),
              ],
            ),
          ),

          // Bottom Banner Ad
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildHeroBadge({required String label, required String value, required bool isDark}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
          ),
        ),
      ],
    );
  }

  // --- TAB 1: Charts ---
  Widget _buildChartTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text(isGujarati ? 'લગ્ન કુંડળી (D1)' : 'लग्न कुंडली (D1)'),
              ),
              ButtonSegment(
                value: 1,
                label: Text(isGujarati ? 'નવમાંશ (D9)' : 'नवमांश (D9)'),
              ),
              ButtonSegment(
                value: 2,
                label: Text(isGujarati ? 'ચંદ્ર કુંડળી' : 'चन्द्र कुंडली'),
              ),
            ],
            selected: {_selectedChartType},
            onSelectionChanged: (val) {
              setState(() => _selectedChartType = val.first);
            },
          ),

          const SizedBox(height: 18),

          Center(
            child: KundaliChartWidget(
              kundali: k,
              isGujarati: isGujarati,
              isNavamsha: _selectedChartType == 1,
              isChandra: _selectedChartType == 2,
              size: MediaQuery.of(context).size.width - 32,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati ? 'ગ્રહ સંક્ષેપ સૂચિ:' : 'ग्रह संक्षिप्त विवरण:',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: k.planets.map((p) {
                    final name = isGujarati ? p.nameGu : p.nameHi;
                    final short = isGujarati ? p.shortGu : p.shortHi;
                    return Text(
                      '$short: $name',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: Appearance & Swabhav ---
  Widget _buildAppearanceSwabhavTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    final pred = k.lifePrediction;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Physical Appearance Card
        _buildPredictionCard(
          icon: Icons.face_retouching_natural_rounded,
          iconColor: AppColors.saffronPrimary,
          title: isGujarati ? pred.physicalAppearance.titleGu : pred.physicalAppearance.titleHi,
          description: isGujarati ? pred.physicalAppearance.descriptionGu : pred.physicalAppearance.descriptionHi,
          highlights: isGujarati ? pred.physicalAppearance.highlightsGu : pred.physicalAppearance.highlightsHi,
          isDark: isDark,
          isGujarati: isGujarati,
        ),

        const SizedBox(height: 16),

        // 2. Swabhav & Behaviour Card
        _buildPredictionCard(
          icon: Icons.psychology_rounded,
          iconColor: AppColors.gold,
          title: isGujarati ? pred.personalitySwabhav.titleGu : pred.personalitySwabhav.titleHi,
          description: isGujarati ? pred.personalitySwabhav.descriptionGu : pred.personalitySwabhav.descriptionHi,
          highlights: isGujarati ? pred.personalitySwabhav.highlightsGu : pred.personalitySwabhav.highlightsHi,
          isDark: isDark,
          isGujarati: isGujarati,
        ),

        const SizedBox(height: 16),

        // 3. Health & Well-being Card
        _buildPredictionCard(
          icon: Icons.health_and_safety_rounded,
          iconColor: Colors.tealAccent.shade700,
          title: isGujarati ? pred.healthPrediction.titleGu : pred.healthPrediction.titleHi,
          description: isGujarati ? pred.healthPrediction.descriptionGu : pred.healthPrediction.descriptionHi,
          highlights: isGujarati ? pred.healthPrediction.highlightsGu : pred.healthPrediction.highlightsHi,
          isDark: isDark,
          isGujarati: isGujarati,
        ),
      ],
    );
  }

  // --- TAB 3: Marriage & Bhagyodaya ---
  Widget _buildMarriageBhagyodayaTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    final pred = k.lifePrediction;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Marriage Timing & Spouse Card
        _buildPredictionCard(
          icon: Icons.favorite_rounded,
          iconColor: Colors.pinkAccent,
          title: isGujarati ? pred.marriagePrediction.titleGu : pred.marriagePrediction.titleHi,
          timingBadge: pred.marriagePrediction.timingOrAge,
          description: isGujarati ? pred.marriagePrediction.descriptionGu : pred.marriagePrediction.descriptionHi,
          highlights: isGujarati ? pred.marriagePrediction.highlightsGu : pred.marriagePrediction.highlightsHi,
          isDark: isDark,
          isGujarati: isGujarati,
        ),

        const SizedBox(height: 16),

        // 2. Bhagyodaya, Career & Wealth Card
        _buildPredictionCard(
          icon: Icons.trending_up_rounded,
          iconColor: Colors.amber.shade700,
          title: isGujarati ? pred.careerBhagyodaya.titleGu : pred.careerBhagyodaya.titleHi,
          timingBadge: pred.careerBhagyodaya.timingOrAge,
          description: isGujarati ? pred.careerBhagyodaya.descriptionGu : pred.careerBhagyodaya.descriptionHi,
          highlights: isGujarati ? pred.careerBhagyodaya.highlightsGu : pred.careerBhagyodaya.highlightsHi,
          isDark: isDark,
          isGujarati: isGujarati,
        ),
      ],
    );
  }

  // --- TAB 4: Raja Yogas & Doshas ---
  Widget _buildRajaYogaDoshaTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    final pred = k.lifePrediction;
    final dosha = k.mangalDosha;
    final yogas = isGujarati ? pred.rajaYogasGu : pred.rajaYogasHi;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Raja Yogas Section
        Container(
          padding: const EdgeInsets.all(16),
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
                  const Icon(Icons.stars_rounded, color: AppColors.goldLight, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isGujarati ? 'કુંડળીના વિશેષ રાજયોગ અને ધન યોગ' : 'कुंडली के विशेष राजयोग एवं धन योग',
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...yogas.map((yoga) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.saffronPrimary.withAlpha(isDark ? 30 : 15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withAlpha(100)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          yoga,
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Mangal Dosha Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dosha.hasDosha
                  ? (dosha.doshaTypeHi.contains('पूर्ण') ? Colors.redAccent : AppColors.gold)
                  : Colors.green,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    dosha.hasDosha ? Icons.warning_amber_rounded : Icons.verified_rounded,
                    color: dosha.hasDosha ? Colors.orangeAccent : Colors.green,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isGujarati ? dosha.doshaTypeGu : dosha.doshaTypeHi,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isGujarati ? dosha.descriptionGu : dosha.descriptionHi,
                style: isGujarati
                    ? GoogleFonts.notoSerifGujarati(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      )
                    : GoogleFonts.notoSerifDevanagari(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.saffronPrimary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGujarati ? 'શાંતિ ઉપાય / નિવારણ:' : 'दोष निवारण उपाय:',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isGujarati ? dosha.remedyGu : dosha.remedyHi,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12.5,
                              color: isDark ? Colors.white : Colors.black87,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12.5,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Deep Dosha Analysis Unlock Card (Rewarded Interstitial)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.maroonPrimary.withAlpha(40),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                    child: const Icon(Icons.stars_rounded, color: Colors.black87, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isGujarati ? 'વિશેષ કાળસર્પ & સાડાસાતી વિશ્લેષણ' : 'विशेष कालसर्प एवं साढ़ेसाती विश्लेषण',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _isDoshaUnlocked
                    ? (isGujarati
                        ? 'તમારી કુંડળીનું વિશેષ કાળસર્પ, શનિ સાડાસાતી અને મંત્ર ઉપાય વિશ્લેષણ સફળતાપૂર્વક અનલૉક થઈ ગયું છે.'
                        : 'आपकी कुंडली का विशेष कालसर्प, शनि साढ़ेसाती एवं मन्त्र उपाय विश्लेषण सफलतापूर्वक अनलॉक हो चुका है।')
                    : (isGujarati
                        ? 'તમારી જન્મકુંડળીમાં કાળસર્પ યોગ અને શનિ સાડાસાતીનો પ્રભાવ તથા વૈદિક મંત્ર ઉપાય જાણવા માટે વિડિઓ જુઓ.'
                        : 'अपनी जन्मकुंडली में कालसर्प योग एवं शनि साढ़ेसाती का प्रभाव तथा वैदिक मन्त्र उपाय जानने के लिए वीडियो देखें।'),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white.withAlpha(220),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              if (_isDoshaUnlocked) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withAlpha(80),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isGujarati ? '★ પ્રીમિયમ દોષ નિવારણ વિશ્લેષણ સક્રિય ★' : '★ प्रीमियम दोष निवारण विश्लेषण सक्रिय ★',
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 12),

                // 1. Kaal Sarp & Shani Sade Sati Deep Analysis
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withAlpha(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: AppColors.goldLight, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            isGujarati ? 'દોષ વિશ્લેષણ & ગ્રહ પ્રભાવ' : 'दोष विश्लेषण एवं ग्रह प्रभाव',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isGujarati
                            ? '• કાળસર્પ સ્થિતિ: રાહુ-કેતુ અક્ષમાં ગ્રહોની સ્થિતિ સામાન્ય છે. આર્થિક ઉતાર-ચઢાવથી બચવા શિવ આરાધના શ્રેષ્ઠ છે.\n• શનિ સાડાસાતી/ઢૈય્યા: શનિદેવનું ગોચર પરિશ્રમનું ઉત્તમ ફળ આપશે, પરંતુ ધીરજ અને સદાચાર જાળવવો આવશ્યક છે.'
                            : '• कालसर्प स्थिति: राहु-केतु अक्ष में ग्रहों की स्थिति सामान्य है। आर्थिक उतार-चढ़ाव से बचने हेतु शिव आराधना श्रेष्ठ है।\n• शनि साढ़ेसाती/ढैया: शनिदेव का गोचर परिश्रम का उत्तम फल देगा, किन्तु धैर्य एवं सदाचार बनाए रखना आवश्यक है।',
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5)
                            : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 2. Sacred Vedic Remedies
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withAlpha(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.spa_rounded, color: AppColors.goldLight, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            isGujarati ? 'વૈદિક મંત્ર & રુદ્રાક્ષ ઉપાય' : 'वैदिक मन्त्र एवं रुद्राक्ष उपाय',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isGujarati
                            ? '• મંત્ર: "ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्" (દરરોજ ૧૧ વાર જાપ કરવો)\n• ઉપાય: શનિવારે પીપળાના વૃક્ષ નીચે સરસવના તેલનો દીવો પ્રગટાવવો.\n• રુદ્રાક્ષ: ૭ મુખી અથવા ૮ મુખી રુદ્રાક્ષ ધારણ કરવો શ્રેષ્ઠ રહેશે.'
                            : '• मन्त्र: "ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्" (नित्य ११ बार जप करें)\n• उपाय: शनिवार को पीपल वृक्ष के नीचे सरसों के तेल का दीपक प्रज्वलित करें।\n• रुद्राक्ष: ७ मुखी अथवा ८ मुखी रुद्राक्ष धारण करना सर्वोत्तम रहेगा।',
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5)
                            : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5),
                      ),
                    ],
                  ),
                ),
              ] else
                ElevatedButton.icon(
                  onPressed: () {
                    AdRewardDialog.show(
                      context,
                      title: isGujarati ? 'દોષ નિવારણ વિશ્લેષણ' : 'दोष निवारण विश्लेषण',
                      description: isGujarati
                          ? 'કાળસર્પ યોગ, માંગલિક દોષ અને શનિ સાડાસાતીના વિસ્તૃત મંત્ર ઉપાય અનલૉક કરવા માટે એક નાનો વિડિઓ જુઓ.'
                          : 'कालसर्प योग, मांगलिक दोष एवं शनि साढ़ेसाती के विस्तृत मन्त्र उपाय अनलॉक करने के लिए एक छोटा वीडियो देखें।',
                      rewardDescription: isGujarati ? 'દોષ નિવારણ વિશ્લેષણ અનલૉક થશે' : 'दोष निवारण विश्लेषण अनलॉक होगा',
                      isRewardedInterstitial: true,
                      onRewardGranted: () {
                        setState(() {
                          _isDoshaUnlocked = true;
                        });
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            backgroundColor: AppColors.cardDark,
                            title: Row(
                              children: [
                                const Icon(Icons.stars_rounded, color: AppColors.gold, size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  isGujarati ? 'વિશેષ વિશ્લેષણ અનલૉક!' : 'विशेष विश्लेषण अनलॉक!',
                                  style: isGujarati
                                      ? GoogleFonts.notoSerifGujarati(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.goldLight,
                                        )
                                      : GoogleFonts.notoSerifDevanagari(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.goldLight,
                                        ),
                                ),
                              ],
                            ),
                            content: Text(
                              isGujarati
                                  ? 'તમારી જન્મકુંડળીનું વિશેષ કાળસર્પ, શનિ સાડાસાતી અને વૈદિક મંત્ર ઉપાય વિશ્લેષણ સફળતાપૂર્વક અનલૉક થઈ ગયું છે. નીચે આપેલા કાર્ડમાં સંપૂર્ણ વિગતો જુઓ.'
                                  : 'आपकी जन्मकुंडली का विशेष कालसर्प, शनि साढ़ेसाती एवं वैदिक मन्त्र उपाय विश्लेषण सफलतापूर्वक अनलॉक हो चुका है। नीचे दिए गए कार्ड में सम्पूर्ण विवरण देखें।',
                              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13.5, height: 1.45),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.saffronPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text(
                                  isGujarati ? 'વિશ્લેષણ જુઓ' : 'विश्लेषण देखें',
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                  label: Text(
                    isGujarati ? 'વિડિઓ જોઈ અનલૉક કરો' : 'वीडियो देखकर अनलॉक करें',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 5: Graha Sthiti & Avakahada ---
  Widget _buildPlanetsTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Planetary Table
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            ),
          ),
          child: DataTable(
            columnSpacing: 16,
            horizontalMargin: 12,
            columns: [
              DataColumn(
                label: Text(
                  isGujarati ? 'ગ્રહ' : 'ग्रह',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, fontSize: 13)
                      : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              DataColumn(
                label: Text(
                  isGujarati ? 'રાશિ' : 'राशि',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, fontSize: 13)
                      : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              DataColumn(
                label: Text(
                  isGujarati ? 'અંશ' : 'अंश',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, fontSize: 13)
                      : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              DataColumn(
                label: Text(
                  isGujarati ? 'ભાવ' : 'भाव',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, fontSize: 13)
                      : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
            rows: k.planets.map((p) {
              final rashiInfo = RashiData.getRashiById(p.rashiId);
              final rashiName = isGujarati ? rashiInfo.gujaratiName : rashiInfo.hindiName;
              final planetName = isGujarati ? p.nameGu : p.nameHi;

              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          planetName,
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                        ),
                        if (p.isRetrograde)
                          Text(
                            ' (R)',
                            style: GoogleFonts.outfit(
                              color: AppColors.saffronPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                  DataCell(Text(
                    rashiName,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 13)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 13),
                  )),
                  DataCell(Text(p.formattedDegree, style: GoogleFonts.outfit(fontSize: 12.5))),
                  DataCell(Text('${p.houseNumber}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 18),

        // Avakahada Chakra
        _buildInfoCard(
          title: isGujarati ? 'અવકહડા ચક્ર & પંચાંગ વિવરણ' : 'अवकहड़ा चक्र एवं पञ्चाङ्ग विवरण',
          isDark: isDark,
          isGujarati: isGujarati,
          items: [
            {'label': isGujarati ? 'લગ્ન રાશિ' : 'लग्न राशि', 'val': isGujarati ? RashiData.getRashiById(k.lagnaRashiId).gujaratiName : RashiData.getRashiById(k.lagnaRashiId).hindiName},
            {'label': isGujarati ? 'ચંદ્ર રાશિ' : 'चन्द्र राशि', 'val': isGujarati ? RashiData.getRashiById(k.moonRashiId).gujaratiName : RashiData.getRashiById(k.moonRashiId).hindiName},
            {'label': isGujarati ? 'સૂર્ય રાશિ' : 'सूर्य राशि', 'val': isGujarati ? RashiData.getRashiById(k.sunRashiId).gujaratiName : RashiData.getRashiById(k.sunRashiId).hindiName},
            {'label': isGujarati ? 'જન્મ નક્ષત્ર' : 'जन्म नक्षत्र', 'val': isGujarati ? k.nakshatraGu : k.nakshatraHi},
            {'label': isGujarati ? 'ચરણ (પાદ)' : 'चरण (पाद)', 'val': '${k.charan}'},
            {'label': isGujarati ? 'ગણ' : 'गण', 'val': isGujarati ? k.ganaGu : k.ganaHi},
            {'label': isGujarati ? 'નાડી' : 'नाड़ी', 'val': isGujarati ? k.nadiGu : k.nadiHi},
            {'label': isGujarati ? 'યોનિ' : 'योनि', 'val': isGujarati ? k.yoniGu : k.yoniHi},
            {'label': isGujarati ? 'વર્ણ' : 'वर्ण', 'val': isGujarati ? k.varnaGu : k.varnaHi},
            {'label': isGujarati ? 'શુભ રત્ન' : 'शुभ रत्न', 'val': isGujarati ? k.luckyGemstoneGu : k.luckyGemstoneHi},
            {'label': isGujarati ? 'શુભ રંગ' : 'शुभ रंग', 'val': k.luckyColor},
            {'label': isGujarati ? 'શુભ અંક' : 'शुभ अंक', 'val': '${k.luckyNumber}'},
          ],
        ),
      ],
    );
  }

  // --- TAB 6: Vimshottari Dasha & Spiritual Remedies ---
  Widget _buildDashaTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    final pred = k.lifePrediction;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Spiritual Remedies & Ishta Devata Card
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.maroonPrimary.withAlpha(40),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.temple_hindu_rounded, color: AppColors.goldLight, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    isGujarati ? 'ઈષ્ટદેવ અને વૈદિક કલ્યાણ મંત્ર' : 'इष्टदेव एवं वैदिक कल्याण मंत्र',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isGujarati ? 'તમારા ઈષ્ટદેવ:' : 'आपके इष्टदेव:',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(color: AppColors.goldLight, fontSize: 13)
                        : GoogleFonts.notoSerifDevanagari(color: AppColors.goldLight, fontSize: 13),
                  ),
                  Text(
                    isGujarati ? pred.ishtaDevataGu : pred.ishtaDevataHi,
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                        : GoogleFonts.notoSerifDevanagari(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isGujarati ? 'શુભ દિશા:' : 'शुभ दिशा:',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(color: AppColors.goldLight, fontSize: 13)
                        : GoogleFonts.notoSerifDevanagari(color: AppColors.goldLight, fontSize: 13),
                  ),
                  Text(
                    pred.luckyDirection,
                    style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withAlpha(120)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isGujarati ? pred.sacredMantraGu : pred.sacredMantraHi,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                              ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: AppColors.goldLight, size: 18),
                      tooltip: 'Copy Mantra',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: isGujarati ? pred.sacredMantraGu : pred.sacredMantraHi,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isGujarati ? 'મંત્ર કૉપી થયો!' : 'मंत्र कॉपी हुआ!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Section Title: Vimshottari Dasha Timeline
        Text(
          isGujarati ? '૧૨૦ વર્ષ વિંશોત્તરી મહાદશા ચક્ર' : '१२० वर्ष विंशोत्तरी महादशा चक्र',
          style: isGujarati
              ? GoogleFonts.notoSerifGujarati(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                )
              : GoogleFonts.notoSerifDevanagari(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                ),
        ),
        const SizedBox(height: 10),

        ...k.dashas.asMap().entries.map((entry) {
          final index = entry.key;
          final d = entry.value;
          final dashaName = isGujarati ? d.planetNameGu : d.planetNameHi;
          final startFmt = DateFormat('dd/MM/yyyy').format(d.startDate);
          final endFmt = DateFormat('dd/MM/yyyy').format(d.endDate);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: d.isCurrent
                  ? (isDark ? const Color(0xFF381D10) : const Color(0xFFFFF3E0))
                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: d.isCurrent
                    ? AppColors.saffronPrimary
                    : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                width: d.isCurrent ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: d.isCurrent ? AppColors.saffronPrimary : Colors.grey.withAlpha(40),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: d.isCurrent ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            dashaName,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: d.isCurrent
                                        ? AppColors.saffronPrimary
                                        : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: d.isCurrent
                                        ? AppColors.saffronPrimary
                                        : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                  ),
                          ),
                          if (d.isCurrent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.saffronPrimary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isGujarati ? 'ચાલુ છે' : 'सक्रिय',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$startFmt — $endFmt (${d.durationYears} ${isGujarati ? 'વર્ષ' : 'वर्ष'})',
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)
                            : GoogleFonts.notoSerifDevanagari(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPredictionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? timingBadge,
    required String description,
    required List<String> highlights,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                ),
              ),
            ],
          ),
          if (timingBadge != null && timingBadge.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.saffronPrimary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.saffronPrimary.withAlpha(100)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_filled_rounded, size: 14, color: AppColors.saffronPrimary),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      timingBadge,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            description,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 14,
                    height: 1.55,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 14,
                    height: 1.55,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                  ),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: highlights.map((h) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withAlpha(80) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 14, color: AppColors.saffronPrimary),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          h,
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required bool isDark,
    bool isGujarati = false,
    required List<Map<String, String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
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
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label']!,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                    ),
                    Text(
                      item['val']!,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
