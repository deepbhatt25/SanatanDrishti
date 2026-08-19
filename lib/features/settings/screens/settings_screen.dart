import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../geeta/providers/geeta_provider.dart';
import '../../rashi/providers/rashi_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final geetaProvider = context.watch<GeetaProvider>();
    final rashiProvider = context.watch<RashiProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: AppStrings.settings(currentLang),
        subtitle: AppStrings.settingsSubtitle(currentLang),
        showOm: false,
        showLanguageToggle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Language Selection
          _buildSectionHeader(AppStrings.languageSelection(currentLang), isDark, isGujarati),
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
                // Hindi Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (!isGujarati)
                          ? (isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('🇮🇳', style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(
                    'हिन्दी (Hindi)',
                    style: GoogleFonts.notoSerifDevanagari(
                      fontSize: 15,
                      fontWeight: !isGujarati ? FontWeight.bold : FontWeight.w500,
                      color: !isGujarati
                          ? (isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    ),
                  ),
                  subtitle: Text(
                    'सम्पूर्ण गीता, पञ्चाङ्ग एवं राशिफल हिन्दी में',
                    style: GoogleFonts.notoSerifDevanagari(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  trailing: !isGujarati
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 22)
                      : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey, size: 20),
                  onTap: () {
                    if (isGujarati) {
                      langProvider.setLanguage(AppLanguage.hindi);
                    }
                  },
                ),
                const Divider(height: 1),
                // Gujarati Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isGujarati
                          ? (isDark ? AppColors.saffronDark.withAlpha(80) : AppColors.saffronPale)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('🇮🇳', style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(
                    'ગુજરાતી (Gujarati)',
                    style: GoogleFonts.notoSerifGujarati(
                      fontSize: 15,
                      fontWeight: isGujarati ? FontWeight.bold : FontWeight.w500,
                      color: isGujarati
                          ? (isDark ? AppColors.goldLight : AppColors.maroonPrimary)
                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    ),
                  ),
                  subtitle: Text(
                    'સંપૂર્ણ ગીતા, પંચાંગ અને રાશિફળ ગુજરાતીમાં',
                    style: GoogleFonts.notoSerifGujarati(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  trailing: isGujarati
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 22)
                      : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey, size: 20),
                  onTap: () {
                    if (!isGujarati) {
                      langProvider.setLanguage(AppLanguage.gujarati);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Appearance & Theming
          _buildSectionHeader(AppStrings.appearance(currentLang), isDark, isGujarati),
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
                SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.saffronPrimary,
                  ),
                  title: Text(
                    AppStrings.darkMode(currentLang),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.w600, fontSize: 14)
                        : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    themeProvider.themeMode == ThemeMode.system
                        ? (isGujarati ? 'સિસ્ટમ થીમ મુજબ કામ કરે છે' : 'सिस्टम थीम के अनुसार सक्रिय')
                        : isDark
                            ? (isGujarati ? 'ડાર્ક થીમ સક્રિય છે' : 'डार्क थीम सक्रिय')
                            : (isGujarati ? 'લાઇટ થીમ સક્રિય છે' : 'लाइट थीम सक्रिय'),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 11.5)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 11.5),
                  ),
                  value: isDark,
                  activeTrackColor: AppColors.saffronPrimary,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_brightness_rounded, color: AppColors.saffronPrimary),
                  title: Text(
                    AppStrings.resetSystemTheme(currentLang),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 13.5)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 13.5),
                  ),
                  trailing: const Icon(Icons.refresh_rounded, size: 18),
                  onTap: () => themeProvider.setSystemTheme(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Bhagavad Geeta Audio & Reading
          _buildSectionHeader(AppStrings.geetaAndAudio(currentLang), isDark, isGujarati),
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.speechSpeed(currentLang)}: ${geetaProvider.ttsSpeed.toStringAsFixed(2)}x',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.w500, fontSize: 13)
                          : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ],
                ),
                Slider(
                  value: geetaProvider.ttsSpeed,
                  min: 0.2,
                  max: 0.9,
                  divisions: 7,
                  activeColor: AppColors.saffronPrimary,
                  onChanged: (val) => geetaProvider.setTtsSpeed(val),
                ),
                const Divider(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppStrings.autoAdvanceTitle(currentLang),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.w600, fontSize: 13.5)
                        : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.w600, fontSize: 13.5),
                  ),
                  subtitle: Text(
                    AppStrings.autoAdvanceSubtitle(currentLang),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(fontSize: 11)
                        : GoogleFonts.notoSerifDevanagari(fontSize: 11),
                  ),
                  value: geetaProvider.autoAdvance,
                  activeTrackColor: AppColors.saffronPrimary,
                  onChanged: (val) => geetaProvider.toggleAutoAdvance(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Pinned Rashi Preference
          _buildSectionHeader(AppStrings.defaultRashiTitle(currentLang), isDark, isGujarati),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: rashiProvider.defaultRashiId,
                isExpanded: true,
                dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                items: RashiData.rashis.map((r) {
                  return DropdownMenuItem(
                    value: r.id,
                    child: Row(
                      children: [
                        Text(r.symbol, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isGujarati
                              ? '${r.gujaratiName} (${r.englishName})'
                              : '${r.hindiName} (${r.englishName})',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    rashiProvider.setDefaultRashi(val);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Footer with Sacred Om
          Center(
            child: Column(
              children: [
                Text(
                  isGujarati ? '॥ ૐ તત્ સત્ ॥' : '॥ ॐ तत् सत् ॥',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          letterSpacing: 1.2,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                          letterSpacing: 1.2,
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  isGujarati
                      ? 'શ્રીમદ્ભગવદ્ગીતા • પંચાંગ • રાશિ ભવિષ્ય v1.0.0'
                      : 'श्रीमद्भगवद्गीता • पञ्चाङ्ग • राशि भविष्य v1.0.0',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 11,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 11,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark, bool isGujarati) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: isGujarati
            ? GoogleFonts.notoSerifGujarati(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              )
            : GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
      ),
    );
  }
}
