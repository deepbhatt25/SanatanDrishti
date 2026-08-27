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
import '../services/kundali_calculator.dart';
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
  final Set<int> _expandedDashaIndices = {0}; // default expand the current/first Mahadasha

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

  Rect? _getSafeOrigin(BuildContext ctx) {
    try {
      final ro = ctx.findRenderObject();
      if (ro is RenderBox && ro.hasSize) {
        return ro.localToGlobal(Offset.zero) & ro.size;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _generateAndShowPdfDialog(BuildContext context, KundaliResult k, bool isGujarati) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.gold),
                const SizedBox(height: 18),
                Text(
                  isGujarati ? 'પીડીએફ તૈયાર થઈ રહી છે...' : 'PDF तैयार की जा रही है...',
                  textAlign: TextAlign.center,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                ),
              ],
            ),
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
                isGujarati
                    ? 'કુંડળી PDF સફળતાપૂર્વક સાચવવામાં આવી છે!'
                    : 'कुंडली PDF सफलतापूर्वक सहेजी गई है!',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 13.5, height: 1.4),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_rounded, color: AppColors.goldLight, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file.path.split('/').last,
                        style: GoogleFonts.outfit(color: AppColors.goldLight, fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                final origin = _getSafeOrigin(ctx);
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
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.gold),
                const SizedBox(height: 18),
                Text(
                  isGujarati ? 'પીડીએફ શેરિંગ તૈયાર થઈ રહી છે...' : 'PDF शेयरिंग तैयार की जा रही है...',
                  textAlign: TextAlign.center,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                ),
              ],
            ),
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

      final origin = _getSafeOrigin(context);
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
    final auspiciousYogas = pred.yogas.where((y) => y.isAuspicious).toList();
    final inauspiciousYogas = pred.yogas.where((y) => !y.isAuspicious).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Shubha Raja Yogas & Dhan Yogas Section
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
                      isGujarati ? 'કુંડળીના શુભ રાજયોગ અને ધન યોગ' : 'कुंडली के शुभ राजयोग एवं धन योग',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(isDark ? 50 : 25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withAlpha(100)),
                    ),
                    child: Text(
                      '${auspiciousYogas.isNotEmpty ? auspiciousYogas.length : pred.rajaYogasGu.length} ${isGujarati ? 'યોગ' : 'योग'}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (auspiciousYogas.isNotEmpty)
                ...auspiciousYogas.map((yoga) => _buildYogaCard(yoga, isDark, isGujarati))
              else
                ...pred.rajaYogasGu.map((yoga) {
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

        // 2. Inauspicious / Dosha Combinations Section (if any detected)
        if (inauspiciousYogas.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.orange.withAlpha(isDark ? 100 : 140),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isGujarati ? 'દોષ & સાવધાની વિશ્લેષણ' : 'दोष एवं सावधानी विश्लेषण',
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.orangeAccent : Colors.deepOrange,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.orangeAccent : Colors.deepOrange,
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(isDark ? 50 : 25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withAlpha(100)),
                      ),
                      child: Text(
                        isGujarati ? 'ઉપાય જરૂરી' : 'उपाय आवश्यक',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...inauspiciousYogas.map((yoga) => _buildYogaCard(yoga, isDark, isGujarati)),
              ],
            ),
          ),
        ],

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
                Builder(
                  builder: (context) {
                    final doshaAnalysis = KundaliCalculator.calculateDoshaAnalysis(
                      planets: k.planets,
                      moonRashiId: k.moonRashiId,
                      lagnaRashiId: k.lagnaRashiId,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                    ? '• કાળસર્પ સ્થિતિ: [${doshaAnalysis.kaalSarpNameGu}] ${doshaAnalysis.kaalSarpDescGu}\n\n• શનિ સાડાસાતી/ઢૈય્યા: [${doshaAnalysis.shaniStatusGu}] ${doshaAnalysis.shaniDescGu}'
                                    : '• कालसर्प स्थिति: [${doshaAnalysis.kaalSarpNameHi}] ${doshaAnalysis.kaalSarpDescHi}\n\n• शनि साढ़ेसाती/ढैया: [${doshaAnalysis.shaniStatusHi}] ${doshaAnalysis.shaniDescHi}',
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
                                    isGujarati ? 'વૈદિક મંત્ર, રુદ્રાક્ષ & ગ્રહ રત્ન ઉપાય' : 'वैदिक मन्त्र, रुद्राक्ष एवं ग्रह रत्न उपाय',
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
                                    ? '${doshaAnalysis.vedicMantraGu}\n\n${doshaAnalysis.upayGu}\n\n${doshaAnalysis.rudrakshaGu}\n\n${doshaAnalysis.gemstoneGu}\n\n${doshaAnalysis.powerfulGemstoneGu}\n\n${doshaAnalysis.avoidGemstoneGu}'
                                    : '${doshaAnalysis.vedicMantraHi}\n\n${doshaAnalysis.upayHi}\n\n${doshaAnalysis.rudrakshaHi}\n\n${doshaAnalysis.gemstoneHi}\n\n${doshaAnalysis.powerfulGemstoneHi}\n\n${doshaAnalysis.avoidGemstoneHi}',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, color: Colors.white.withAlpha(225), height: 1.55)
                                    : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, color: Colors.white.withAlpha(225), height: 1.55),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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

  Widget _buildYogaCard(AstrologicalYogaItem yoga, bool isDark, bool isGujarati) {
    final title = isGujarati ? yoga.nameGu : yoga.nameHi;
    final desc = isGujarati ? yoga.descriptionGu : yoga.descriptionHi;
    final impact = isGujarati ? yoga.impactGu : yoga.impactHi;
    final remedy = isGujarati ? yoga.remedyGu : yoga.remedyHi;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: yoga.isAuspicious
            ? AppColors.saffronPrimary.withAlpha(isDark ? 30 : 15)
            : Colors.orange.withAlpha(isDark ? 25 : 12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: yoga.isAuspicious ? AppColors.gold.withAlpha(100) : Colors.orange.withAlpha(100),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                yoga.isAuspicious ? Icons.verified_rounded : Icons.info_outline_rounded,
                color: yoga.isAuspicious ? AppColors.saffronPrimary : Colors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? (yoga.isAuspicious ? AppColors.goldLight : Colors.orangeAccent) : AppColors.textPrimaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? (yoga.isAuspicious ? AppColors.goldLight : Colors.orangeAccent) : AppColors.textPrimaryLight,
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12.5,
                              height: 1.45,
                              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12.5,
                              height: 1.45,
                              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (impact.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(isDark ? 60 : 15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    yoga.isAuspicious ? Icons.auto_awesome : Icons.shield_outlined,
                    size: 14,
                    color: yoga.isAuspicious ? AppColors.goldLight : Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${isGujarati ? 'પ્રભાવ:' : 'प्रभाव:'} $impact',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (remedy.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.saffronPrimary.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.saffronPrimary.withAlpha(60)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.spa_rounded, size: 14, color: AppColors.saffronPrimary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${isGujarati ? 'શાંતિ ઉપાય:' : 'उपाय:'} $remedy',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 11.5,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              fontWeight: FontWeight.w600,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 11.5,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 5: Graha Sthiti & Avakahada ---
  Widget _buildPlanetsTab(bool isDark, bool isGujarati) {
    final k = widget.kundali;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Interactive Tap Hint Banner
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF381D10), const Color(0xFF241010)]
                  : [const Color(0xFFFFF3E0), const Color(0xFFFDE8D0)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.saffronPrimary.withAlpha(90)),
          ),
          child: Row(
            children: [
              const Icon(Icons.touch_app_rounded, color: AppColors.saffronPrimary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isGujarati
                      ? 'કોઈપણ ગ્રહ પર ટેપ કરી વિગતવાર ગ્રહ ફળ, રાશિ પ્રભાવ, ભાવ ફળ અને વૈદિક મંત્ર જુઓ.'
                      : 'किसी भी ग्रह पर टैप करके विस्तृत ग्रह फल, राशि प्रभाव, भाव फल एवं वैदिक मंत्र देखें।',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Planetary Cards / Table
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            ),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withAlpha(60) : Colors.grey.withAlpha(20),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        isGujarati ? 'ગ્રહ / અંશ' : 'ग्रह / अंश',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        isGujarati ? 'રાશિ / ભાવ' : 'राशि / भाव',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        isGujarati ? 'સ્થિતિ / ફળ' : 'स्थिति / फल',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),

              // Rows
              ...k.planets.map((p) {
                final rashiInfo = RashiData.getRashiById(p.rashiId);
                final rashiName = isGujarati ? rashiInfo.gujaratiName : rashiInfo.hindiName;
                final planetName = isGujarati ? p.nameGu : p.nameHi;
                final dignity = KundaliCalculator.getPlanetDignity(p);
                final dignityLabel = isGujarati ? (dignity['labelGu'] as String) : (dignity['labelHi'] as String);
                final dignityType = dignity['dignity'] as String;

                Color dignityColor;
                if (dignityType == 'Exalted') {
                  dignityColor = Colors.amber.shade700;
                } else if (dignityType == 'Own') {
                  dignityColor = Colors.green.shade600;
                } else if (dignityType == 'Friend') {
                  dignityColor = Colors.teal.shade600;
                } else if (dignityType == 'Neutral') {
                  dignityColor = Colors.blueGrey;
                } else if (dignityType == 'Enemy') {
                  dignityColor = Colors.deepOrange;
                } else {
                  dignityColor = Colors.redAccent;
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showGrahaFalModal(p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.cardBorderDark.withAlpha(50) : AppColors.cardBorderLight,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      planetName,
                                      style: isGujarati
                                          ? GoogleFonts.notoSerifGujarati(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                            )
                                          : GoogleFonts.notoSerifDevanagari(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                            ),
                                    ),
                                    if (p.isRetrograde) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.saffronPrimary.withAlpha(40),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'R',
                                          style: GoogleFonts.outfit(
                                            color: AppColors.saffronPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.formattedDegree,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rashiName,
                                  style: isGujarati
                                      ? GoogleFonts.notoSerifGujarati(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                        )
                                      : GoogleFonts.notoSerifDevanagari(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                        ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${isGujarati ? 'ભાવ:' : 'भाव:'} ${p.houseNumber}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    color: dignityColor.withAlpha(isDark ? 40 : 25),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: dignityColor.withAlpha(120), width: 0.8),
                                  ),
                                  child: Text(
                                    dignityLabel.split(' ').first,
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: dignityColor,
                                          )
                                        : GoogleFonts.notoSerifDevanagari(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: dignityColor,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade500),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
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
    final doshaAnalysis = KundaliCalculator.calculateDoshaAnalysis(
      planets: k.planets,
      moonRashiId: k.moonRashiId,
      lagnaRashiId: k.lagnaRashiId,
    );

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
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isGujarati ? 'ધારણ રત્ન:' : 'धारण रत्न:',
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(color: AppColors.goldLight, fontSize: 13)
                        : GoogleFonts.notoSerifDevanagari(color: AppColors.goldLight, fontSize: 13),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isGujarati ? k.luckyGemstoneGu : k.luckyGemstoneHi,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
              if (doshaAnalysis.powerfulGemstoneGu.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati ? 'પાવરફુલ રત્ન:' : 'पावरफुल रत्न:',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(color: AppColors.goldLight, fontSize: 13)
                          : GoogleFonts.notoSerifDevanagari(color: AppColors.goldLight, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isGujarati
                            ? doshaAnalysis.powerfulGemstoneGu.replaceAll('• સૌથી પાવરફુલ કારક રત્ન: ', '')
                            : doshaAnalysis.powerfulGemstoneHi.replaceAll('• सर्वाधिक शक्तिशाली कारक रत्न: ', ''),
                        textAlign: TextAlign.end,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5)
                            : GoogleFonts.notoSerifDevanagari(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ],
              if (doshaAnalysis.avoidGemstoneGu.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati ? 'વર્જ્ય રત્ન:' : 'वर्ज्य रत्न:',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(color: const Color(0xFFFFB4AB), fontSize: 12.5)
                          : GoogleFonts.notoSerifDevanagari(color: const Color(0xFFFFB4AB), fontSize: 12.5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isGujarati
                            ? doshaAnalysis.avoidGemstoneGu.replaceAll('• વર્જ્ય/નિષેધ રત્ન: ', '')
                            : doshaAnalysis.avoidGemstoneHi.replaceAll('• वर्ज्य/निषेध रत्न: ', ''),
                        textAlign: TextAlign.end,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(color: const Color(0xFFFFDAD6), fontSize: 11)
                            : GoogleFonts.notoSerifDevanagari(color: const Color(0xFFFFDAD6), fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
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

        // Section Title: Vimshottari Dasha Timeline with Antardasha
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isGujarati ? '૧૨૦ વર્ષ વિંશોત્તરી મહાદશા & દશાંતર' : '१२० वर्ष विंशोत्तरी महादशा एवं दशांतर',
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
            Text(
              isGujarati ? 'ટેપ કરી ફળ જુઓ' : 'फल देखें',
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: AppColors.saffronPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...k.dashas.asMap().entries.map((entry) {
          final index = entry.key;
          final d = entry.value;
          final dashaName = isGujarati ? d.planetNameGu : d.planetNameHi;
          final startFmt = DateFormat('dd/MM/yyyy').format(d.startDate);
          final endFmt = DateFormat('dd/MM/yyyy').format(d.endDate);
          final isExpanded = _expandedDashaIndices.contains(index);

          // Get 9 Antardashas (from model or on-demand calculator)
          final antardashas = d.antardashas.isNotEmpty
              ? d.antardashas
              : KundaliCalculator.getAntardashasForDasha(d.planetNameGu, d.startDate, d.endDate);

          // Find associated planet in planets list
          final planet = k.planets.firstWhere(
            (p) => p.nameGu == d.planetNameGu || p.nameHi == d.planetNameHi,
            orElse: () => k.planets.first,
          );

          // Find associated yogas for this dasha lord
          final associatedYogas = pred.yogas.where((y) =>
              y.associatedPlanets.any((pName) =>
                  pName == d.planetNameGu ||
                  pName == d.planetNameHi ||
                  pName == planet.nameEn)).toList();

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: d.isCurrent
                  ? (isDark ? const Color(0xFF381D10) : const Color(0xFFFFF3E0))
                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: d.isCurrent
                    ? AppColors.saffronPrimary
                    : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                width: d.isCurrent ? 1.8 : 1.0,
              ),
            ),
            child: Column(
              children: [
                // Mahadasha Header Card
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedDashaIndices.remove(index);
                      } else {
                        _expandedDashaIndices.add(index);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                        '$dashaName ${isGujarati ? 'મહાદશા' : 'महादशा'}',
                                        style: isGujarati
                                            ? GoogleFonts.notoSerifGujarati(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.bold,
                                                color: d.isCurrent
                                                    ? AppColors.saffronPrimary
                                                    : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                              )
                                            : GoogleFonts.notoSerifDevanagari(
                                                fontSize: 14.5,
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
                                            isGujarati ? 'ચાલુ છે' : 'સક્રિય',
                                            style: isGujarati
                                                ? GoogleFonts.notoSerifGujarati(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  )
                                                : GoogleFonts.notoSerifDevanagari(
                                                    fontSize: 9.5,
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
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 12,
                                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                                          )
                                        : GoogleFonts.notoSerifDevanagari(
                                            fontSize: 12,
                                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.goldLight,
                                size: 20,
                              ),
                              tooltip: isGujarati ? 'ગ્રહ ફળ & મંત્ર' : 'ग्रह फल एवं मंत्र',
                              onPressed: () => _showGrahaFalModal(planet, dashaItem: d),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: isExpanded ? AppColors.saffronPrimary : Colors.grey.shade500,
                            ),
                          ],
                        ),

                        // Yoga Badges on Mahadasha card
                        if (associatedYogas.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: associatedYogas.map((y) {
                              final yogaName = isGujarati ? y.nameGu : y.nameHi;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: y.isAuspicious
                                      ? AppColors.gold.withAlpha(isDark ? 40 : 25)
                                      : Colors.orange.withAlpha(isDark ? 40 : 25),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: y.isAuspicious ? AppColors.gold.withAlpha(120) : Colors.orange.withAlpha(120),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      y.isAuspicious ? Icons.stars_rounded : Icons.warning_amber_rounded,
                                      size: 11,
                                      color: y.isAuspicious ? AppColors.goldLight : Colors.orangeAccent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      yogaName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: y.isAuspicious ? (isDark ? AppColors.goldLight : AppColors.maroonPrimary) : Colors.orangeAccent,
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
                  ),
                ),

                // Expanded Antardasha (દશાંતર) Cycle Breakdown
                if (isExpanded && antardashas.isNotEmpty) ...[
                  const Divider(height: 1, thickness: 0.8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: isDark ? Colors.black.withAlpha(40) : Colors.grey.withAlpha(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isGujarati ? 'અંતર્દશા (દશાંતર) સાયકલ:' : 'अंतर्दशा (दशांतर) विवरण:',
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => _showGrahaFalModal(planet, dashaItem: d),
                              icon: const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.saffronPrimary),
                              label: Text(
                                isGujarati ? 'સંપૂર્ણ ફળાદેશ' : 'सम्पूर्ण फलादेश',
                                style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.saffronPrimary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...antardashas.map((antar) {
                          final aStart = DateFormat('dd/MM/yy').format(antar.startDate);
                          final aEnd = DateFormat('dd/MM/yy').format(antar.endDate);
                          final aName = isGujarati ? antar.planetNameGu : antar.planetNameHi;
                          final aFal = isGujarati ? antar.antardashaFalGu : antar.antardashaFalHi;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: antar.isCurrent
                                  ? AppColors.saffronPrimary.withAlpha(isDark ? 40 : 20)
                                  : (isDark ? AppColors.cardDark : Colors.white),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: antar.isCurrent
                                    ? AppColors.saffronPrimary
                                    : (isDark ? AppColors.cardBorderDark.withAlpha(60) : Colors.grey.withAlpha(60)),
                                width: antar.isCurrent ? 1.2 : 0.6,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            aName,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: antar.isCurrent
                                                  ? AppColors.saffronPrimary
                                                  : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                            ),
                                          ),
                                          if (antar.isCurrent) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                              decoration: BoxDecoration(
                                                color: AppColors.saffronPrimary,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                isGujarati ? 'ચાલુ છે' : 'सक्रिय',
                                                style: GoogleFonts.outfit(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '$aStart — $aEnd',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: isDark ? Colors.white60 : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                if (aFal.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    aFal,
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 11,
                                            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                            height: 1.35,
                                          )
                                        : GoogleFonts.notoSerifDevanagari(
                                            fontSize: 11,
                                            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                            height: 1.35,
                                          ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showGrahaFalModal(PlanetPosition planet, {VimshottariDashaItem? dashaItem}) {
    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final k = widget.kundali;

    final rashiInfo = RashiData.getRashiById(planet.rashiId);
    final rashiName = isGujarati ? rashiInfo.gujaratiName : rashiInfo.hindiName;
    final planetName = isGujarati ? planet.nameGu : planet.nameHi;
    final dignity = KundaliCalculator.getPlanetDignity(planet);
    final dignityLabel = isGujarati ? (dignity['labelGu'] as String) : (dignity['labelHi'] as String);
    final dignityType = dignity['dignity'] as String;
    final grahaFal = KundaliCalculator.getGrahaFal(planet, k.lagnaRashiId);
    final lordships = KundaliCalculator.getPlanetLordships(planet.id, k.lagnaRashiId);
    final spiritualInfo = KundaliCalculator.getPlanetSpiritualInfo(planet.id);

    // Find dasha item if not passed
    final matchingDasha = dashaItem ??
        k.dashas.firstWhere(
          (d) => d.planetNameGu == planet.nameGu || d.planetNameHi == planet.nameHi,
          orElse: () => k.dashas.first,
        );

    Color dignityColor;
    if (dignityType == 'Exalted') {
      dignityColor = Colors.amber.shade700;
    } else if (dignityType == 'Own') {
      dignityColor = Colors.green.shade600;
    } else if (dignityType == 'Friend') {
      dignityColor = Colors.teal.shade600;
    } else if (dignityType == 'Neutral') {
      dignityColor = Colors.blueGrey;
    } else if (dignityType == 'Enemy') {
      dignityColor = Colors.deepOrange;
    } else {
      dignityColor = Colors.redAccent;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Card with Planet & Dignity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.saffronGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.saffronPrimary.withAlpha(60),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        isGujarati ? planet.shortGu : planet.shortHi,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                                '$planetName ${isGujarati ? 'વિશ્લેષણ' : 'विश्लेषण'}',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                      ),
                              ),
                              if (planet.isRetrograde) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.saffronPrimary.withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'વક્રી (Retro)',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.saffronPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$rashiName (${planet.formattedDegree}) • ${isGujarati ? '${planet.houseNumber} મો ભાવ' : '${planet.houseNumber} वां भाव'}',
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: dignityColor.withAlpha(isDark ? 40 : 25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: dignityColor.withAlpha(120), width: 1.2),
                      ),
                      child: Text(
                        dignityLabel,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: dignityColor,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: dignityColor,
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 0.8),

              // Scrollable Details
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Lordships Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF381D10) : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.saffronPrimary.withAlpha(isDark ? 80 : 120),
                          width: 1.1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_rounded, color: AppColors.saffronPrimary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isGujarati ? 'ભાવ સ્વામીત્વ (House Lordship):' : 'भाव स्वामित्व (House Lordship):',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white60 : Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isGujarati ? (lordships['titleGu'] as String) : (lordships['titleHi'] as String),
                                  style: isGujarati
                                      ? GoogleFonts.notoSerifGujarati(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                        )
                                      : GoogleFonts.notoSerifDevanagari(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Section 1: Rashi-wise & House-wise Graha Fal (કઈ રાશિ અને ભાવમાંથી શું ફળ આપશે)
                    _buildModalSectionCard(
                      icon: Icons.auto_awesome_rounded,
                      iconColor: AppColors.gold,
                      title: isGujarati ? 'ગ્રહ ફળાદેશ (Graha Fal Analysis)' : 'ग्रह फलादेश (Graha Fal Analysis)',
                      isDark: isDark,
                      isGujarati: isGujarati,
                      children: [
                        // Rashi Fal
                        _buildSubFalRow(
                          label: isGujarati ? 'રાશિ સ્થિતિ પ્રભાવ:' : 'राशि स्थिति प्रभाव:',
                          content: isGujarati ? grahaFal['rashiFalGu']! : grahaFal['rashiFalHi']!,
                          isDark: isDark,
                          isGujarati: isGujarati,
                        ),
                        const SizedBox(height: 10),
                        // House Fal
                        _buildSubFalRow(
                          label: isGujarati ? 'ભાવ સ્થિતિ પ્રભાવ:' : 'भाव स्थिति प्रभाव:',
                          content: isGujarati ? grahaFal['houseFalGu']! : grahaFal['houseFalHi']!,
                          isDark: isDark,
                          isGujarati: isGujarati,
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Section 2: Mahadasha & Antardasha Cycle & Antardasha Fal (દશાંતર ફળાદેશ)
                    _buildModalSectionCard(
                      icon: Icons.timelapse_rounded,
                      iconColor: AppColors.saffronPrimary,
                      title: isGujarati
                          ? '$planetName મહાદશા & દશાંતર ફળાદેશ'
                          : '$planetName महादशा एवं दशांतर फलादेश',
                      isDark: isDark,
                      isGujarati: isGujarati,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: matchingDasha.isCurrent
                                ? (isDark ? const Color(0xFF381D10) : const Color(0xFFFFF3E0))
                                : (isDark ? Colors.black.withAlpha(50) : const Color(0xFFFBF8F4)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: matchingDasha.isCurrent
                                  ? AppColors.saffronPrimary
                                  : (isDark ? AppColors.cardBorderDark : const Color(0xFFE8DCCF)),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 15,
                                    color: matchingDasha.isCurrent ? AppColors.saffronPrimary : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${DateFormat('dd/MM/yyyy').format(matchingDasha.startDate)} — ${DateFormat('dd/MM/yyyy').format(matchingDasha.endDate)}',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              if (matchingDasha.isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.saffronPrimary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isGujarati ? 'ચાલુ મહાદશા' : 'સક્રિય મહાદશા',
                                    style: GoogleFonts.outfit(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...(matchingDasha.antardashas.isNotEmpty
                                ? matchingDasha.antardashas
                                : KundaliCalculator.getAntardashasForDasha(
                                    matchingDasha.planetNameGu,
                                    matchingDasha.startDate,
                                    matchingDasha.endDate,
                                  ))
                            .map((antar) {
                          final aName = isGujarati ? antar.planetNameGu : antar.planetNameHi;
                          final aFal = isGujarati ? antar.antardashaFalGu : antar.antardashaFalHi;
                          final aStart = DateFormat('dd/MM/yy').format(antar.startDate);
                          final aEnd = DateFormat('dd/MM/yy').format(antar.endDate);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: antar.isCurrent
                                  ? AppColors.saffronPrimary.withAlpha(isDark ? 35 : 18)
                                  : (isDark ? Colors.black.withAlpha(40) : Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: antar.isCurrent
                                    ? AppColors.saffronPrimary
                                    : (isDark ? AppColors.cardBorderDark.withAlpha(50) : Colors.grey.withAlpha(40)),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          aName,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.5,
                                            color: antar.isCurrent
                                                ? AppColors.saffronPrimary
                                                : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                          ),
                                        ),
                                        if (antar.isCurrent) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.saffronPrimary,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              isGujarati ? 'ચાલુ છે' : 'सक्रिय',
                                              style: GoogleFonts.outfit(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      '$aStart — $aEnd',
                                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                if (aFal.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    aFal,
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 11.5,
                                            height: 1.4,
                                            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                          )
                                        : GoogleFonts.notoSerifDevanagari(
                                            fontSize: 11.5,
                                            height: 1.4,
                                            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                          ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Section 3: Sacred Vedic Beej Mantra & Remedies
                    _buildModalSectionCard(
                      icon: Icons.spa_rounded,
                      iconColor: AppColors.saffronPrimary,
                      title: isGujarati ? 'પવિત્ર વૈદિક મંત્ર અને ઉપાય' : 'पवित्र वैदिक मंत्र एवं उपाय',
                      isDark: isDark,
                      isGujarati: isGujarati,
                      children: [
                        // Vedic Beej Mantra Plaque (High-Contrast Rich Spiritual Gradient)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A1010), Color(0xFF6B1818), Color(0xFF380C0C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.gold, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome, color: AppColors.goldLight, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        isGujarati ? 'તાંત્રિક બીજ મંત્ર' : 'तांत्रिक बीज मंत्र',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.goldLight,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final text = isGujarati ? spiritualInfo['beejMantraGu'] as String : spiritualInfo['beejMantraHi'] as String;
                                      Clipboard.setData(ClipboardData(text: text));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isGujarati ? 'મંત્ર કૉપી થયો!' : 'मंत्र कॉपी हुआ!'),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: AppColors.maroonPrimary,
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(25),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.goldLight.withAlpha(120), width: 0.8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.copy_rounded, color: AppColors.goldLight, size: 13),
                                          const SizedBox(width: 4),
                                          Text(
                                            isGujarati ? 'કૉપી કરો' : 'कॉपी करें',
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.goldLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(60),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.gold.withAlpha(80)),
                                ),
                                child: Text(
                                  isGujarati ? spiritualInfo['beejMantraGu'] as String : spiritualInfo['beejMantraHi'] as String,
                                  textAlign: TextAlign.center,
                                  style: isGujarati
                                      ? GoogleFonts.notoSerifGujarati(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.4,
                                        )
                                      : GoogleFonts.notoSerifDevanagari(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.4,
                                        ),
                                ),
                              ),
                              if (spiritualInfo['vedicMantraGu'] != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      isGujarati ? 'વૈદિક મંત્ર:' : 'वैदिक मंत्र:',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.goldLight.withAlpha(200),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        isGujarati ? spiritualInfo['vedicMantraGu'] as String : spiritualInfo['vedicMantraHi'] as String,
                                        style: isGujarati
                                            ? GoogleFonts.notoSerifGujarati(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white70,
                                              )
                                            : GoogleFonts.notoSerifDevanagari(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white70,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Deity & Gemstone (Dual Cards with Rich Contrast)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildMiniSpiritualBadge(
                                icon: Icons.temple_hindu_rounded,
                                iconColor: AppColors.saffronPrimary,
                                label: isGujarati ? 'ઉપાસ્ય દેવ' : 'उपास्य देव',
                                value: isGujarati ? spiritualInfo['deityGu'] as String : spiritualInfo['deityHi'] as String,
                                isDark: isDark,
                                isGujarati: isGujarati,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMiniSpiritualBadge(
                                icon: Icons.diamond_rounded,
                                iconColor: Colors.amber.shade700,
                                label: isGujarati ? 'શુભ રત્ન' : 'शुभ रत्न',
                                value: isGujarati ? spiritualInfo['gemstoneGu'] as String : spiritualInfo['gemstoneHi'] as String,
                                isDark: isDark,
                                isGujarati: isGujarati,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Remedies (ઉપાય) Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF381D10) : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.saffronPrimary.withAlpha(isDark ? 80 : 120),
                              width: 1.1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.volunteer_activism_rounded, size: 16, color: AppColors.saffronPrimary),
                                  const SizedBox(width: 6),
                                  Text(
                                    isGujarati ? 'જ્યોતિષીય ઉપાય & દાન:' : 'ज्योतिषीय उपाय एवं दान:',
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
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isGujarati ? spiritualInfo['remedyGu'] as String : spiritualInfo['remedyHi'] as String,
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 12.5,
                                        height: 1.5,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                        fontWeight: FontWeight.w500,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 12.5,
                                        height: 1.5,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isDark,
    required bool isGujarati,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSubFalRow({
    required String label,
    required String content,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          content,
          style: isGujarati
              ? GoogleFonts.notoSerifGujarati(
                  fontSize: 13,
                  height: 1.45,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                )
              : GoogleFonts.notoSerifDevanagari(
                  fontSize: 13,
                  height: 1.45,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
        ),
      ],
    );
  }

  Widget _buildMiniSpiritualBadge({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withAlpha(60) : const Color(0xFFFBF8F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE8DCCF),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    height: 1.3,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    height: 1.3,
                  ),
          ),
        ],
      ),
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
