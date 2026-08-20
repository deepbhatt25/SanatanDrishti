import 'dart:io';
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

  Future<void> _downloadKundaliPdf(BuildContext context, KundaliResult k, bool isGujarati) async {
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

  Future<void> _shareKundali(BuildContext context, KundaliResult k, bool isGujarati) async {
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
        kundali: k,
        isGujarati: isGujarati,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final box = context.findRenderObject() as RenderBox?;
      final origin = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
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
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 64,
                      color: isDark ? AppColors.goldLight.withAlpha(120) : AppColors.maroonPrimary.withAlpha(120),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noSavedKundalis(currentLang),
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGujarati
                          ? 'નવી જન્મ કુંડળી બનાવીને અહીં સાચવો'
                          : 'नई जन्म कुंडली बनाकर यहां सहेजें',
                      style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateKundaliScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: Text(AppStrings.createKundali(currentLang)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.saffronPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final k = savedList[index];
                final lagnaInfo = RashiData.getRashiById(k.lagnaRashiId);
                final moonInfo = RashiData.getRashiById(k.moonRashiId);
                final lagnaName = isGujarati ? lagnaInfo.gujaratiName : lagnaInfo.hindiName;
                final moonName = isGujarati ? moonInfo.gujaratiName : moonInfo.hindiName;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                        border: Border.all(color: AppColors.goldLight, width: 1.2),
                      ),
                      child: Center(
                        child: Text(
                          k.profile.name.isNotEmpty ? k.profile.name[0] : 'ૐ',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      k.profile.name,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          '${DateFormat('dd MMM yyyy').format(k.profile.dateOfBirth)} • ${k.profile.formattedTime} • ${k.profile.cityName}',
                          style: GoogleFonts.outfit(fontSize: 11.5, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${isGujarati ? 'લગ્ન' : 'लग्न'}: $lagnaName | ${isGujarati ? 'રાશિ' : 'राशि'}: $moonName',
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (btnCtx) => IconButton(
                            icon: const Icon(Icons.share_rounded, color: AppColors.goldLight, size: 20),
                            tooltip: isGujarati ? 'કુંડળી શેર કરો' : 'कुंडली शेयर करें',
                            onPressed: () => _shareKundali(btnCtx, k, isGujarati),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.goldLight, size: 22),
                          tooltip: isGujarati ? 'PDF ડાઉનલોડ કરો' : 'PDF डाउनलोड करें',
                          onPressed: () => _promptDownloadPdf(context, k, isGujarati),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                          tooltip: 'Delete',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(AppStrings.deleteConfirm(currentLang)),
                                content: Text(
                                  isGujarati
                                      ? '${k.profile.name} ની કુંડળી કાઢી નાખવી છે?'
                                      : 'क्या आप ${k.profile.name} की कुंडली हटाना चाहते हैं?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(isGujarati ? 'રદ કરો' : 'रद्द करें'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                    onPressed: () {
                                      kundaliProvider.deleteKundali(k.profile.id);
                                      Navigator.pop(ctx);
                                    },
                                    child: Text(isGujarati ? 'કાઢી નાખો' : 'हटाएं', style: const TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KundaliPreviewScreen(kundali: k),
                        ),
                      );
                    },
                  ),
                );
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
}
