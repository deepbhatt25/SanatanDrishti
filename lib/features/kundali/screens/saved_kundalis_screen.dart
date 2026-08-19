import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../providers/kundali_provider.dart';
import 'create_kundali_screen.dart';
import 'kundali_preview_screen.dart';

class SavedKundalisScreen extends StatelessWidget {
  const SavedKundalisScreen({super.key});

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
              padding: const EdgeInsets.all(16),
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
                    trailing: IconButton(
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
