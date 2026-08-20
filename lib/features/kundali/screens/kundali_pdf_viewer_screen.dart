import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/kundali_model.dart';
import '../services/kundali_pdf_service.dart';
import '../widgets/kundali_chart_painter.dart';

/// Full-featured, complete Vedic Kundali Report & PDF Viewer with pinch-to-zoom,
/// 3-page comprehensive Vedic manuscript rendering containing every single preview detail.
class KundaliPdfViewerScreen extends StatefulWidget {
  final KundaliResult kundali;
  final File? pdfFile;
  final bool isGujarati;

  const KundaliPdfViewerScreen({
    super.key,
    required this.kundali,
    this.pdfFile,
    this.isGujarati = false,
  });

  @override
  State<KundaliPdfViewerScreen> createState() => _KundaliPdfViewerScreenState();
}

class _KundaliPdfViewerScreenState extends State<KundaliPdfViewerScreen> {
  int _currentPage = 0;
  int _selectedChartType = 0; // 0: Lagna (D1), 1: Navamsha (D9), 2: Chandra
  File? _savedFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _savedFile = widget.pdfFile;
  }

  Future<void> _handleSaveOrShare({bool isShare = false}) async {
    if (_savedFile == null || !(await _savedFile!.exists())) {
      setState(() => _isSaving = true);
      try {
        final file = await KundaliPdfService.instance.generateAndSaveKundaliPdf(
          kundali: widget.kundali,
          isGujarati: widget.isGujarati,
        );
        if (mounted) {
          setState(() {
            _savedFile = file;
            _isSaving = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
          );
        }
        return;
      }
    }

    if (!mounted) return;

    if (_savedFile != null) {
      Rect? origin;
      try {
        final ro = context.findRenderObject();
        if (ro is RenderBox && ro.hasSize) {
          origin = ro.localToGlobal(Offset.zero) & ro.size;
        }
      } catch (_) {}
      await KundaliPdfService.instance.sharePdf(
        _savedFile!.path,
        sharePositionOrigin: origin,
        subject: widget.isGujarati
            ? '${widget.kundali.profile.name} ની જન્મ કુંડળી'
            : '${widget.kundali.profile.name} की जन्म कुंडली',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.maroonPrimary,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.goldLight, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.isGujarati
                        ? 'કુંડળી PDF સફળતાપૂર્વક સાચવવામાં આવી!'
                        : 'कुंडली PDF सफलतापूर्वक सहेजी गई!',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final k = widget.kundali;
    final isGu = widget.isGujarati;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF140808) : const Color(0xFFF7F2EA),
      appBar: CustomSpiritualAppBar(
        title: isGu ? '${k.profile.name} - જન્મ કુંડળી' : '${k.profile.name} - जन्म कुंडली',
        subtitle: isGu ? 'સંપૂર્ણ વૈદિક જન્માક્ષર રિપોર્ટ' : 'सम्पूर्ण वैदिक जन्माक्षर रिपोर्ट',
        showOm: false,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.share_rounded, color: AppColors.goldLight),
              tooltip: isGu ? 'શેર / સેવ કરો' : 'शेयर / सहेजें',
              onPressed: () => _handleSaveOrShare(isShare: true),
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded, color: AppColors.goldLight),
              tooltip: isGu ? 'PDF ડાઉનલોડ' : 'PDF डाउनलोड',
              onPressed: () => _handleSaveOrShare(isShare: false),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // 3-Page Tab Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withAlpha(80)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildPageTab(
                    index: 0,
                    label: isGu ? 'પૃષ્ઠ ૧: કુંડળી & ગ્રહ' : 'पृष्ठ १: कुंडली & ग्रह',
                    icon: Icons.auto_awesome_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildPageTab(
                    index: 1,
                    label: isGu ? 'પૃષ્ઠ ૨: દેખાવ & ફળ' : 'पृष्ठ २: रूप & फल',
                    icon: Icons.psychology_outlined,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildPageTab(
                    index: 2,
                    label: isGu ? 'પૃષ્ઠ ૩: યોગ & દશા' : 'पृष्ठ ३: योग & दशा',
                    icon: Icons.menu_book_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),

          // Main Interactive Zoomable Manuscript
          Expanded(
            child: InteractiveViewer(
              minScale: 0.85,
              maxScale: 3.5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 28),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _currentPage == 0
                        ? _buildPage1(context, k, isDark, isGu)
                        : (_currentPage == 1
                            ? _buildPage2(context, k, isDark, isGu)
                            : _buildPage3(context, k, isDark, isGu)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: AdBannerWidget(
          margin: EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }

  Widget _buildPageTab({
    required int index,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _currentPage == index;
    return InkWell(
      onTap: () => setState(() => _currentPage = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.saffronDark : AppColors.maroonPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : (isDark ? AppColors.goldLight : AppColors.maroonPrimary),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PAGE 1: Profile, 3 Vedic Charts & Planetary Positions =================
  Widget _buildPage1(BuildContext context, KundaliResult k, bool isDark, bool isGu) {
    final lagnaRashi = RashiData.getRashiById(k.lagnaRashiId);
    final moonRashi = RashiData.getRashiById(k.moonRashiId);
    final sunRashi = RashiData.getRashiById(k.sunRashiId);

    return _buildParchmentPage(
      key: const ValueKey('page_1'),
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          _buildParchmentHeader(
            title: isGu ? 'વૈદિક જન્મ કુંડળી રિપોર્ટ' : 'वैदिक जन्म कुंडली रिपोर्ट',
            subtitle: 'SANATANDRISHTI VEDIC ASTROLOGICAL SYSTEM',
            pageNumber: 'Page 1 of 3',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Profile Details Grid (Full text without truncation)
          _buildSectionCard(
            title: isGu ? 'જાતક પરિચય (Birth Details)' : 'जातक विवरण (Birth Details)',
            icon: Icons.person_rounded,
            isDark: isDark,
            child: Column(
              children: [
                _buildInfoTile(
                  label1: isGu ? 'નામ (Name):' : 'नाम (Name):',
                  value1: k.profile.name,
                  label2: isGu ? 'જન્મ તારીખ (DOB):' : 'जन्म तिथि (DOB):',
                  value2: DateFormat('dd MMMM yyyy').format(k.profile.dateOfBirth),
                  isDark: isDark,
                  isGu: isGu,
                ),
                const Divider(height: 12, thickness: 0.5),
                _buildInfoTile(
                  label1: isGu ? 'જન્મ સમય (Time):' : 'जन्म समय (Time):',
                  value1: k.profile.formattedTime,
                  label2: isGu ? 'જન્મ સ્થળ (Place):' : 'जन्म स्थान (Place):',
                  value2: k.profile.cityName,
                  isDark: isDark,
                  isGu: isGu,
                ),
                const Divider(height: 12, thickness: 0.5),
                _buildInfoTile(
                  label1: isGu ? 'અક્ષાંશ/રેખાંશ:' : 'अक्षांश/रेखांश:',
                  value1: '${k.profile.latitude.toStringAsFixed(2)}°N, ${k.profile.longitude.toStringAsFixed(2)}°E',
                  label2: isGu ? 'અયનાંશ:' : 'अयनांश:',
                  value2: 'Lahiri 23°51\'22"',
                  isDark: isDark,
                  isGu: isGu,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3-Way Chart Switcher (Lagna D1, Navamsha D9, Chandra)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF5ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withAlpha(50)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildChartSelectorBtn(0, isGu ? 'લગ્ન (D1)' : 'लग्न (D1)', isDark),
                    _buildChartSelectorBtn(1, isGu ? 'નવાંશ (D9)' : 'नवांश (D9)', isDark),
                    _buildChartSelectorBtn(2, isGu ? 'ચંદ્ર કુંડળી' : 'चन्द्र कुंडली', isDark),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 220,
                    width: 220,
                    child: KundaliChartWidget(
                      kundali: k,
                      isGujarati: isGu,
                      isNavamsha: _selectedChartType == 1,
                      isChandra: _selectedChartType == 2,
                      size: 220,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Planet Abbreviation Legend
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: k.planets.map((p) {
                    final name = isGu ? p.nameGu : p.nameHi;
                    final short = isGu ? p.shortGu : p.shortHi;
                    return Text(
                      '$short: $name',
                      style: GoogleFonts.outfit(
                        fontSize: 9.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Avakahada & Panchang Chakra
          _buildSectionCard(
            title: isGu ? 'પંચાંગ અને અવકહડા ચક્ર (Avakahada Chakra)' : 'पंचांग एवं अवकहड़ा चक्र (Avakahada Chakra)',
            icon: Icons.explore_rounded,
            isDark: isDark,
            child: Column(
              children: [
                _buildInfoTile(
                  label1: isGu ? 'લગ્ન રાશિ (Lagna):' : 'लग्न राशि (Lagna):',
                  value1: '${isGu ? lagnaRashi.gujaratiName : lagnaRashi.hindiName} (${lagnaRashi.englishName})',
                  label2: isGu ? 'ચંદ્ર રાશિ (Moon):' : 'चन्द्र राशि (Moon):',
                  value2: '${isGu ? moonRashi.gujaratiName : moonRashi.hindiName} (${moonRashi.englishName})',
                  isDark: isDark,
                  isGu: isGu,
                ),
                const Divider(height: 12, thickness: 0.5),
                _buildInfoTile(
                  label1: isGu ? 'જન્મ નક્ષત્ર:' : 'जन्म नक्षत्र:',
                  value1: '${isGu ? k.nakshatraGu : k.nakshatraHi} (પદ ${k.charan})',
                  label2: isGu ? 'સૂર્ય રાશિ (Sun):' : 'सूर्य राशि (Sun):',
                  value2: '${isGu ? sunRashi.gujaratiName : sunRashi.hindiName} (${sunRashi.englishName})',
                  isDark: isDark,
                  isGu: isGu,
                ),
                const Divider(height: 12, thickness: 0.5),
                _buildInfoTile(
                  label1: isGu ? 'ગણ / નાડી:' : 'गण / नाड़ी:',
                  value1: '${isGu ? k.ganaGu : k.ganaHi} / ${isGu ? k.nadiGu : k.nadiHi}',
                  label2: isGu ? 'યોનિ / વર્ણ:' : 'योनि / वर्ण:',
                  value2: '${isGu ? k.yoniGu : k.yoniHi} / ${isGu ? k.varnaGu : k.varnaHi}',
                  isDark: isDark,
                  isGu: isGu,
                ),
                const Divider(height: 12, thickness: 0.5),
                _buildInfoTile(
                  label1: isGu ? 'શુભ રત્ન:' : 'शुभ रत्न:',
                  value1: isGu ? k.luckyGemstoneGu : k.luckyGemstoneHi,
                  label2: isGu ? 'શુભ રંગ & દિશા:' : 'शुभ रंग & दिशा:',
                  value2: '${k.luckyColor} | ${k.lifePrediction.luckyDirection}',
                  isDark: isDark,
                  isGu: isGu,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Planetary Positions Table
          _buildPlanetaryTable(k, isDark, isGu),
        ],
      ),
    );
  }

  // ================= PAGE 2: Physical Appearance, Nature, Marriage & Career =================
  Widget _buildPage2(BuildContext context, KundaliResult k, bool isDark, bool isGu) {
    final pred = k.lifePrediction;

    return _buildParchmentPage(
      key: const ValueKey('page_2'),
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          _buildParchmentHeader(
            title: isGu ? 'વ્યક્તિત્વ, દાંપત્ય & ભાગ્યોદય વિશ્લેષણ' : 'व्यक्तित्व, दांपत्य & भाग्योदय विश्लेषण',
            subtitle: 'LIFE PREDICTIONS, TIMING & FORTUNE FORECAST',
            pageNumber: 'Page 2 of 3',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 1. Physical Appearance Card
          _buildDetailedAspectCard(
            title: isGu ? pred.physicalAppearance.titleGu : pred.physicalAppearance.titleHi,
            description: isGu ? pred.physicalAppearance.descriptionGu : pred.physicalAppearance.descriptionHi,
            highlights: isGu ? pred.physicalAppearance.highlightsGu : pred.physicalAppearance.highlightsHi,
            icon: Icons.face_retouching_natural_rounded,
            iconColor: AppColors.saffronPrimary,
            isDark: isDark,
            isGu: isGu,
          ),
          const SizedBox(height: 12),

          // 2. Swabhav & Nature Card
          _buildDetailedAspectCard(
            title: isGu ? pred.personalitySwabhav.titleGu : pred.personalitySwabhav.titleHi,
            description: isGu ? pred.personalitySwabhav.descriptionGu : pred.personalitySwabhav.descriptionHi,
            highlights: isGu ? pred.personalitySwabhav.highlightsGu : pred.personalitySwabhav.highlightsHi,
            icon: Icons.psychology_rounded,
            iconColor: AppColors.gold,
            isDark: isDark,
            isGu: isGu,
          ),
          const SizedBox(height: 12),

          // 3. Health & Well-being Card
          _buildDetailedAspectCard(
            title: isGu ? pred.healthPrediction.titleGu : pred.healthPrediction.titleHi,
            description: isGu ? pred.healthPrediction.descriptionGu : pred.healthPrediction.descriptionHi,
            highlights: isGu ? pred.healthPrediction.highlightsGu : pred.healthPrediction.highlightsHi,
            icon: Icons.health_and_safety_rounded,
            iconColor: Colors.tealAccent.shade700,
            isDark: isDark,
            isGu: isGu,
          ),
          const SizedBox(height: 12),

          // 4. Marriage & Relationship Yoga
          _buildDetailedAspectCard(
            title: isGu ? pred.marriagePrediction.titleGu : pred.marriagePrediction.titleHi,
            timingBadge: pred.marriagePrediction.timingOrAge,
            description: isGu ? pred.marriagePrediction.descriptionGu : pred.marriagePrediction.descriptionHi,
            highlights: isGu ? pred.marriagePrediction.highlightsGu : pred.marriagePrediction.highlightsHi,
            icon: Icons.favorite_rounded,
            iconColor: Colors.pinkAccent,
            isDark: isDark,
            isGu: isGu,
          ),
          const SizedBox(height: 12),

          // 5. Bhagyodaya, Career & Wealth Card
          _buildDetailedAspectCard(
            title: isGu ? pred.careerBhagyodaya.titleGu : pred.careerBhagyodaya.titleHi,
            timingBadge: pred.careerBhagyodaya.timingOrAge,
            description: isGu ? pred.careerBhagyodaya.descriptionGu : pred.careerBhagyodaya.descriptionHi,
            highlights: isGu ? pred.careerBhagyodaya.highlightsGu : pred.careerBhagyodaya.highlightsHi,
            icon: Icons.trending_up_rounded,
            iconColor: Colors.amber.shade700,
            isDark: isDark,
            isGu: isGu,
          ),
        ],
      ),
    );
  }

  // ================= PAGE 3: Raja Yogas, Doshas, Vimshottari Dasha & Sacred Remedies =================
  Widget _buildPage3(BuildContext context, KundaliResult k, bool isDark, bool isGu) {
    final pred = k.lifePrediction;
    final dosha = k.mangalDosha;
    final yogas = isGu ? pred.rajaYogasGu : pred.rajaYogasHi;

    return _buildParchmentPage(
      key: const ValueKey('page_3'),
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          _buildParchmentHeader(
            title: isGu ? 'વિંશોત્તરી મહાદશા, રાજયોગ & દોષ નિવારણ' : 'विंशोत्तरी महादशा, राजयोग & दोष निवारण',
            subtitle: 'VIMSHOTTARI DASHA, RAJA YOGAS & REMEDIES',
            pageNumber: 'Page 3 of 3',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 1. Special Raja Yogas & Dhan Yogas Card
          _buildSectionCard(
            title: isGu ? 'કુંડળીના વિશેષ રાજયોગ અને ધન યોગ' : 'कुंडली के विशेष राजयोग एवं धन योग',
            icon: Icons.stars_rounded,
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: yogas.map((yoga) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.saffronPrimary.withAlpha(isDark ? 30 : 15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold.withAlpha(90)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          yoga,
                          style: isGu
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Manglik Dosha Analysis Card
          _buildSectionCard(
            title: isGu ? 'માંગલિક દોષ વિશ્લેષણ (Manglik Dosha)' : 'मांगलिक दोष विश्लेषण (Manglik Dosha)',
            icon: Icons.shield_outlined,
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoshaBadge(
                  title: isGu ? dosha.doshaTypeGu : dosha.doshaTypeHi,
                  status: dosha.hasDosha
                      ? (isGu ? 'દોષ પ્રભાવિત' : 'दोष प्रभावित')
                      : (isGu ? 'દોષ મુક્ત / નિર્દોષ' : 'दोष मुक्त / निर्दोष'),
                  isAlert: dosha.hasDosha,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                Text(
                  isGu ? dosha.descriptionGu : dosha.descriptionHi,
                  style: isGu
                      ? GoogleFonts.notoSerifGujarati(fontSize: 12, height: 1.4, color: isDark ? Colors.white70 : Colors.black87)
                      : GoogleFonts.notoSerifDevanagari(fontSize: 12, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.saffronPrimary.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${isGu ? 'શાંતિ ઉપાય:' : 'दोष निवारण:'} ${isGu ? dosha.remedyGu : dosha.remedyHi}',
                    style: isGu
                        ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Kaal Sarp & Shani Sade Sati Deep Analysis Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A1010) : const Color(0xFFFFF0E0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.goldLight, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isGu ? 'વિશેષ કાળસર્પ & સાડાસાતી વિશ્લેષણ' : 'विशेष कालसर्प एवं साढ़ेसाती विश्लेषण',
                        style: GoogleFonts.cinzel(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isGu
                      ? '• કાળસર્પ સ્થિતિ: રાહુ-કેતુ અક્ષમાં ગ્રહોની સ્થિતિ અનુકૂળ છે. આર્થિક ઉતાર-ચઢાવથી બચવા શિવ આરાધના શ્રેષ્ઠ રહેશે.\n• શનિ સાડાસાતી: પરિશ્રમનું ઉત્તમ ફળ મળશે, ધીરજ અને સદાચાર જાળવવો.'
                      : '• कालसर्प स्थिति: राहु-केतु अक्ष में ग्रहों की स्थिति अनुकूल है। आर्थिक उतार-चढ़ाव से बचाव हेतु शिव आराधना करें।\n• शनि साढ़ेसाती: परिश्रम का उत्तम फल मिलेगा, धैर्य एवं सदाचार बनाए रखें।',
                  style: isGu
                      ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, height: 1.4, color: isDark ? Colors.white70 : Colors.black87)
                      : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  isGu
                      ? '• વૈદિક મંત્ર: "ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्" (દરરોજ ૧૧ વાર જાપ કરવો) | રુદ્રાક્ષ: ૭ અથવા ૮ મુખી'
                      : '• वैदिक मन्त्र: "ॐ त्र्यम्बकं यजामहे सुगन्धिं पुष्टिवर्धनम्" (नित्य ११ बार जप करें) | रुद्राक्ष: ७ अथवा ८ मुखी',
                  style: isGu
                      ? GoogleFonts.notoSerifGujarati(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                      : GoogleFonts.notoSerifDevanagari(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.goldLight : AppColors.maroonPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. 120-Year Vimshottari Mahadasha Table
          _buildDashaTable(k, isDark, isGu),
          const SizedBox(height: 12),

          // 5. Sacred Vedic Remedies & Ishta Devata
          _buildRemedyCard(k, isDark, isGu),
        ],
      ),
    );
  }

  // --- REUSABLE UI BUILDERS ---

  Widget _buildChartSelectorBtn(int index, String label, bool isDark) {
    final isSelected = _selectedChartType == index;
    return InkWell(
      onTap: () => setState(() => _selectedChartType = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.gold : AppColors.maroonPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gold.withAlpha(100)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? (isDark ? Colors.black87 : Colors.white) : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedAspectCard({
    required String title,
    String? timingBadge,
    required String description,
    required List<String> highlights,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    required bool isGu,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF5ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (timingBadge != null && timingBadge.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(30),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded, size: 12, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    timingBadge,
                    style: isGu
                        ? GoogleFonts.notoSerifGujarati(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.amber.shade900)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            description,
            softWrap: true,
            style: isGu
                ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, height: 1.45, color: isDark ? Colors.white70 : Colors.black87)
                : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, height: 1.45, color: isDark ? Colors.white70 : Colors.black87),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: highlights.map((h) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.saffronPrimary.withAlpha(isDark ? 25 : 15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.gold.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 11, color: AppColors.saffronPrimary),
                      const SizedBox(width: 3),
                      Text(
                        h,
                        style: isGu
                            ? GoogleFonts.notoSerifGujarati(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)
                            : GoogleFonts.notoSerifDevanagari(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87),
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

  Widget _buildParchmentPage({
    required Key key,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 580),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E0E0E) : const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withAlpha(isDark ? 150 : 200),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildParchmentHeader({
    required String title,
    required String subtitle,
    required String pageNumber,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.maroonDark : const Color(0xFFF6ECE0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withAlpha(90)),
      ),
      child: Row(
        children: [
          Text(
            'ૐ',
            style: GoogleFonts.notoSerifDevanagari(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 8.5,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              pageNumber,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF5ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: AppColors.saffronPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
    required bool isDark,
    required bool isGu,
  }) {
    final valueStyle = isGu
        ? GoogleFonts.notoSerifGujarati(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.maroonPrimary,
          )
        : GoogleFonts.notoSerifDevanagari(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.maroonPrimary,
          );

    final labelStyle = GoogleFonts.outfit(
      fontSize: 10.5,
      color: isDark ? Colors.white60 : Colors.black54,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: labelStyle),
              const SizedBox(height: 1),
              Text(value1, style: valueStyle, softWrap: true),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2, style: labelStyle),
              const SizedBox(height: 1),
              Text(value2, style: valueStyle, softWrap: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetaryTable(KundaliResult k, bool isDark, bool isGu) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF5ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.maroonDark : AppColors.maroonPrimary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'ગ્રહ (Planet)' : 'ग्रह (Planet)')),
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'રાશિ (Sign)' : 'राशि (Sign)')),
                Expanded(flex: 2, child: _buildTableHeader(isGu ? 'અંશ (Deg)' : 'अंश (Deg)')),
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'નક્ષત્ર' : 'नक्षत्र')),
                Expanded(flex: 2, child: _buildTableHeader(isGu ? 'સ્થિતિ' : 'स्थिति')),
              ],
            ),
          ),
          ...k.planets.map((p) {
            final rashi = RashiData.getRashiById(p.rashiId);
            final isSunMoon = p.nameHi == 'सूर्य' || p.nameHi == 'चन्द्र';
            final signText = isGu
                ? '${rashi.gujaratiName} (${rashi.id})'
                : '${rashi.hindiName} (${rashi.id})';

            final planetStyle = isGu
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.maroonPrimary,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.maroonPrimary,
                  );

            final signStyle = isGu
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 10.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 10.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  );

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.gold.withAlpha(30), width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      isGu ? p.nameGu : p.nameHi,
                      style: planetStyle,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      signText,
                      style: signStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${p.degree.toStringAsFixed(1)}°',
                      style: GoogleFonts.outfit(
                        fontSize: 10.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${p.nakshatra} (${p.pada})',
                      style: isGu
                          ? GoogleFonts.notoSerifGujarati(fontSize: 10, color: isDark ? Colors.white70 : Colors.black87)
                          : GoogleFonts.notoSerifDevanagari(fontSize: 10, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      p.isRetrograde
                          ? (isGu ? 'વક્રી' : 'वक्री')
                          : (isSunMoon ? (isGu ? 'પ્રત્યક્ષ' : 'प्रत्यक्ष') : (isGu ? 'માર્ગી' : 'मार्गी')),
                      style: isGu
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: p.isRetrograde ? Colors.orangeAccent : Colors.green,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: p.isRetrograde ? Colors.orangeAccent : Colors.green,
                            ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildDashaTable(KundaliResult k, bool isDark, bool isGu) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAF5ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.maroonDark : AppColors.maroonPrimary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'મહાદશા ગ્રહ' : 'महादशा ग्रह')),
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'પ્રારંભ' : 'प्रारंभ')),
                Expanded(flex: 3, child: _buildTableHeader(isGu ? 'સમાપ્તિ' : 'समाप्ति')),
                Expanded(flex: 2, child: _buildTableHeader(isGu ? 'સ્થિતિ' : 'स्थिति')),
              ],
            ),
          ),
          ...k.dashas.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final d = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: d.isCurrent ? AppColors.gold.withAlpha(isDark ? 30 : 50) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: AppColors.gold.withAlpha(30), width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '$idx. ${isGu ? d.planetNameGu : d.planetNameHi} (${d.durationYears} yrs)',
                      style: isGu
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 11,
                              fontWeight: d.isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: d.isCurrent ? AppColors.gold : (isDark ? Colors.white : Colors.black87),
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 11,
                              fontWeight: d.isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: d.isCurrent ? AppColors.gold : (isDark ? Colors.white : Colors.black87),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(d.startDate),
                      style: GoogleFonts.outfit(fontSize: 10.5, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(d.endDate),
                      style: GoogleFonts.outfit(fontSize: 10.5, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: d.isCurrent ? Colors.green.withAlpha(40) : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        d.isCurrent ? (isGu ? 'ચાલુ છે' : 'सक्रिय') : (isGu ? 'સામાન્ય' : 'सामान्य'),
                        style: isGu
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: d.isCurrent ? Colors.green : Colors.grey,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: d.isCurrent ? Colors.green : Colors.grey,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDoshaBadge({
    required String title,
    required String status,
    required bool isAlert,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.outfit(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isAlert ? Colors.redAccent.withAlpha(30) : Colors.green.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isAlert ? Colors.redAccent.withAlpha(80) : Colors.green.withAlpha(80),
            ),
          ),
          child: Text(
            status,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: isAlert ? Colors.redAccent : Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemedyCard(KundaliResult k, bool isDark, bool isGu) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.self_improvement_rounded, size: 18, color: AppColors.goldLight),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isGu ? 'ઇષ્ટદેવ અને વૈદિક કલ્યાણ મંત્ર' : 'इष्टदेव एवं वैदिक कल्याण मन्त्र',
                  style: GoogleFonts.cinzel(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${isGu ? 'ઇષ્ટદેવ' : 'इष्टदेव'}: ${isGu ? k.lifePrediction.ishtaDevataGu : k.lifePrediction.ishtaDevataHi}',
            style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.goldLight),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${isGu ? 'મહામંત્ર' : 'महामंत्र'}: ${isGu ? k.lifePrediction.sacredMantraGu : k.lifePrediction.sacredMantraHi}',
                  style: isGu
                      ? GoogleFonts.notoSerifGujarati(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
                      : GoogleFonts.notoSerifDevanagari(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, color: AppColors.goldLight, size: 16),
                tooltip: isGu ? 'મંત્ર કૉપિ કરો' : 'मन्त्र कॉपी करें',
                onPressed: () {
                  final mantra = isGu ? k.lifePrediction.sacredMantraGu : k.lifePrediction.sacredMantraHi;
                  Clipboard.setData(ClipboardData(text: mantra));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isGu ? 'મંત્ર કૉપિ થયો' : 'मन्त्र कॉपी किया गया'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${isGu ? 'શુભ દિશા' : 'शुभ दिशा'}: ${k.lifePrediction.luckyDirection} | ${isGu ? 'રત્ન' : 'रत्न'}: ${isGu ? k.luckyGemstoneGu : k.luckyGemstoneHi}',
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
