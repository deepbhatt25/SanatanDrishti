import 'package:flutter/material.dart';
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
import '../providers/kundali_provider.dart';
import '../services/kundali_pdf_service.dart';
import 'create_kundali_screen.dart';
import 'kundali_pdf_viewer_screen.dart';
import 'kundali_preview_screen.dart';

class SavedKundalisScreen extends StatelessWidget {
  const SavedKundalisScreen({super.key});

  void _promptDownloadPdf(BuildContext context, KundaliResult k, bool isGujarati) {
    AdRewardDialog.show(
      context,
      title: isGujarati ? 'સંપૂર્ણ કુંડળી PDF ડાઉનલોડ' : 'सम्पूर्ण कुंडली PDF डाउनलोड',
      description: isGujarati
          ? 'સંપૂર્ણ જન્મકુંડળી વિશ્લેષણ, ગ્રહ સ્પષ્ટ અને દશા ફળની PDF તમારા ફોનના Downloads ફોલ્ડરમાં સાચવવા અને જોવા માટે એક નાનો પ્રાયોજિત વિડિઓ જુઓ.'
          : 'सम्पूर्ण जन्मकुंडली विश्लेषण, ग्रह स्थिति एवं दशा फल की PDF अपने फोन के Downloads फोल्डर में सहेजने एवं देखने के लिए एक छोटा प्रायोजित वीडियो देखें।',
      rewardDescription: isGujarati ? 'સંપૂર્ણ કુંડળી PDF અનલૉક થશે' : 'सम्पूर्ण कुंडली PDF अनलॉक होगी',
      icon: Icons.picture_as_pdf_rounded,
      onRewardGranted: () async {
        await _downloadKundaliPdf(context, k, isGujarati);
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

  Future<void> _downloadKundaliPdf(BuildContext context, KundaliResult k, bool isGujarati) async {
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

  Future<void> _shareKundali(BuildContext context, KundaliResult k, bool isGujarati) async {
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
        kundali: k,
        isGujarati: isGujarati,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final origin = _getSafeOrigin(context);
      await KundaliPdfService.instance.sharePdf(
        file.path,
        sharePositionOrigin: origin,
        subject: isGujarati ? '${k.profile.name} ની જન્મ કુંડળી' : '${k.profile.name} की जन्म कुंडली',
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
    final kundaliProvider = context.watch<KundaliProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savedList = kundaliProvider.savedKundalis;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: AppStrings.savedKundalis(currentLang),
        subtitle: AppStrings.savedKundalisSubtitle(currentLang),
        showOm: false,
        showLanguageToggle: true,
      ),
      body: savedList.isEmpty
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isDark
                            ? const LinearGradient(
                                colors: [Color(0xFF381500), Color(0xFF5A2200)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        border: Border.all(color: AppColors.gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withAlpha(isDark ? 60 : 40),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.folder_open_rounded,
                          size: 44,
                          color: AppColors.saffronPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.noSavedKundalis(currentLang),
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGujarati
                          ? 'તમારી અથવા પરિવારના સભ્યોની જન્મકુંડળી બનાવીને ભવિષ્ય માટે અહીં સાચવી રાખો.'
                          : 'अपनी अथवा परिवार के सदस्यों की जन्म कुंडली बनाकर भविष्य के लिए यहां सहेजें।',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : const Color(0xFF666666),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateKundaliScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                      label: Text(
                        AppStrings.createKundali(currentLang),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.saffronPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final k = savedList[index];
                return _buildKundaliCard(context, k, isDark, isGujarati, currentLang, kundaliProvider);
              },
            ),
      bottomNavigationBar: const SafeArea(
        child: AdBannerWidget(
          margin: EdgeInsets.symmetric(vertical: 4),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'saved_create_kundali_fab',
        backgroundColor: AppColors.saffronPrimary,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          AppStrings.createKundali(currentLang),
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateKundaliScreen()),
          );
        },
      ),
    );
  }

  Widget _buildKundaliCard(
    BuildContext context,
    KundaliResult k,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang,
    KundaliProvider kundaliProvider,
  ) {
    final lagnaInfo = RashiData.getRashiById(k.lagnaRashiId);
    final moonInfo = RashiData.getRashiById(k.moonRashiId);
    final lagnaName = isGujarati ? lagnaInfo.gujaratiName : lagnaInfo.hindiName;
    final moonName = isGujarati ? moonInfo.gujaratiName : moonInfo.hindiName;
    final nakshatraName = isGujarati ? k.nakshatraGu : k.nakshatraHi;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E140F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gold.withAlpha(60) : const Color(0xFFE8D7C3),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => KundaliPreviewScreen(kundali: k),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Header Row
                Row(
                  children: [
                    // Avatar with sacred gold border
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isDark
                            ? const LinearGradient(
                                colors: [Color(0xFF7A1C1C), Color(0xFF4A1010)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        border: Border.all(color: AppColors.gold, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withAlpha(50),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          k.profile.name.trim().isNotEmpty ? k.profile.name.trim()[0].toUpperCase() : 'ૐ',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name and Gender/Profile type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            k.profile.name,
                            style: GoogleFonts.outfit(
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF212121),
                              letterSpacing: 0.2,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: k.profile.gender == Gender.male
                                  ? (isDark ? const Color(0xFF102A45) : const Color(0xFFE3F2FD))
                                  : (isDark ? const Color(0xFF381424) : const Color(0xFFFCE4EC)),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: k.profile.gender == Gender.male
                                    ? const Color(0xFF64B5F6).withAlpha(100)
                                    : const Color(0xFFF06292).withAlpha(100),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  k.profile.gender == Gender.male ? Icons.man_rounded : Icons.woman_rounded,
                                  size: 15,
                                  color: k.profile.gender == Gender.male
                                      ? (isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2))
                                      : (isDark ? const Color(0xFFF48FB1) : const Color(0xFFC2185B)),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  k.profile.gender == Gender.male
                                      ? (isGujarati ? 'પુરુષ' : 'पुरुष')
                                      : (isGujarati ? 'સ્ત્રી' : 'स्त्री'),
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: k.profile.gender == Gender.male
                                        ? (isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2))
                                        : (isDark ? const Color(0xFFF48FB1) : const Color(0xFFC2185B)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                      tooltip: isGujarati ? 'કુંડળી કાઢી નાખો' : 'कुंडली हटाएं',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withAlpha(isDark ? 25 : 15),
                        padding: const EdgeInsets.all(8),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            title: Row(
                              children: [
                                const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.deleteConfirm(currentLang),
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            content: Text(
                              isGujarati
                                  ? '${k.profile.name} ની કુંડળી કાયમ માટે કાઢી નાખવી છે?'
                                  : 'क्या आप ${k.profile.name} की कुंडली हमेशा के लिए हटाना चाहते हैं?',
                              style: GoogleFonts.outfit(fontSize: 13.5),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(isGujarati ? 'રદ કરો' : 'रद्द करें'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  kundaliProvider.deleteKundali(k.profile.id);
                                  Navigator.pop(ctx);
                                },
                                child: Text(isGujarati ? 'કાઢી નાખો' : 'हटाएं', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 2. Birth Metadata Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withAlpha(80) : const Color(0xFFF9F6F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white.withAlpha(15) : const Color(0xFFEBE5DB),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.saffronPrimary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(k.profile.dateOfBirth),
                        style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF444444)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time_rounded, size: 13, color: AppColors.saffronPrimary),
                      const SizedBox(width: 4),
                      Text(
                        k.profile.formattedTime,
                        style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF444444)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on_rounded, size: 13, color: AppColors.saffronPrimary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          k.profile.cityName,
                          style: GoogleFonts.outfit(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : const Color(0xFF444444)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 3. Astrological Highlights Row (Pills)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildAstroBadge(
                      icon: Icons.flare_rounded,
                      label: '${isGujarati ? 'લગ્ન' : 'लग्न'}: $lagnaName',
                      bgColor: isDark ? const Color(0xFF38230D) : const Color(0xFFFFF3E0),
                      borderColor: const Color(0xFFFFB74D),
                      textColor: isDark ? const Color(0xFFFFCC80) : const Color(0xFFE65100),
                    ),
                    _buildAstroBadge(
                      icon: Icons.nightlight_round,
                      label: '${isGujarati ? 'ચંદ્ર રાશિ' : 'चंद्र राशि'}: $moonName',
                      bgColor: isDark ? const Color(0xFF1B233D) : const Color(0xFFEDE7F6),
                      borderColor: const Color(0xFF9FA8DA),
                      textColor: isDark ? const Color(0xFF90CAF9) : const Color(0xFF303F9F),
                    ),
                    _buildAstroBadge(
                      icon: Icons.auto_awesome_rounded,
                      label: '$nakshatraName (${isGujarati ? 'ચરણ' : 'चरण'} ${k.charan})',
                      bgColor: isDark ? const Color(0xFF0F2E1E) : const Color(0xFFE8F5E9),
                      borderColor: const Color(0xFF81C784),
                      textColor: isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32),
                    ),
                    _buildAstroBadge(
                      icon: k.mangalDosha.hasDosha ? Icons.warning_amber_rounded : Icons.verified_rounded,
                      label: k.mangalDosha.hasDosha
                          ? (isGujarati ? 'મંગળ દોષ' : 'मांगलिक')
                          : (isGujarati ? 'દોષ મુક્ત' : 'दोष मुक्त'),
                      bgColor: k.mangalDosha.hasDosha
                          ? (isDark ? const Color(0xFF3E1212) : const Color(0xFFFFEBEE))
                          : (isDark ? const Color(0xFF0F2E1E) : const Color(0xFFE8F5E9)),
                      borderColor: k.mangalDosha.hasDosha ? Colors.redAccent : const Color(0xFF81C784),
                      textColor: k.mangalDosha.hasDosha
                          ? Colors.redAccent
                          : (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32)),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 4. Action Buttons Footer Bar
                Row(
                  children: [
                    // View Kundali Primary Button
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE65100).withAlpha(60),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KundaliPreviewScreen(kundali: k),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility_rounded, size: 16),
                          label: Text(
                            isGujarati ? 'કુંડળી જુઓ' : 'कुंडली देखें',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // PDF Button
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.goldLight : const Color(0xFFBF360C),
                          side: BorderSide(
                            color: isDark ? AppColors.gold.withAlpha(150) : const Color(0xFFE65100),
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: isDark ? AppColors.gold.withAlpha(20) : const Color(0xFFFFF8E1),
                        ),
                        onPressed: () => _promptDownloadPdf(context, k, isGujarati),
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                        label: Text(
                          isGujarati ? 'PDF રિપોર્ટ' : 'PDF रिपोर्ट',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Share Button
                    Builder(
                      builder: (btnCtx) => InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _shareKundali(btnCtx, k, isGujarati),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white.withAlpha(40) : const Color(0xFFCCCCCC),
                            ),
                            color: isDark ? Colors.white.withAlpha(15) : const Color(0xFFF5F5F5),
                          ),
                          child: Icon(
                            Icons.share_rounded,
                            size: 18,
                            color: isDark ? AppColors.goldLight : const Color(0xFF444444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAstroBadge({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withAlpha(140), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
