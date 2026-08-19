import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/rashi_symbol_widget.dart';
import '../models/rashi_model.dart';
import '../providers/rashi_provider.dart';

class RashiDetailScreen extends StatefulWidget {
  final RashiInfo rashi;

  const RashiDetailScreen({super.key, required this.rashi});

  @override
  State<RashiDetailScreen> createState() => _RashiDetailScreenState();
}

class _RashiDetailScreenState extends State<RashiDetailScreen> {
  int _chantCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RashiProvider>().loadReadingForRashi(widget.rashi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rashiProvider = context.watch<RashiProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rashi = widget.rashi;
    final reading = rashiProvider.currentReading;
    final isDefault = rashiProvider.isDefaultRashi(rashi.id);
    final selectedDate = rashiProvider.selectedDate;

    final rashiName = isGujarati ? rashi.gujaratiName : rashi.hindiName;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: isGujarati ? '$rashiName રાશિ' : '$rashiName राशि',
        subtitle: '${rashi.englishName} • ${DateFormat('d MMMM yyyy').format(selectedDate)}',
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: AppColors.goldLight),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2050),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.maroonPrimary,
                        onPrimary: Colors.white,
                        surface: isDark ? AppColors.surfaceDark : Colors.white,
                        onSurface: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                rashiProvider.selectDate(picked, rashi: rashi);
              }
            },
            tooltip: 'Choose Date',
          ),
          IconButton(
            icon: Icon(
              isDefault ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isDefault ? AppColors.gold : AppColors.goldLight,
            ),
            onPressed: () {
              rashiProvider.setDefaultRashi(rashi.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${rashi.hindiName} set as your default Rashi'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: isDefault ? 'Default Rashi' : 'Pin as Default Rashi',
          ),
        ],
      ),
      body: Column(
        children: [
          // Dynamic Day Segment Bar (Yesterday, Today, Tomorrow)
          _buildDaySelectorBar(context, rashiProvider, rashi, selectedDate, isDark, isGujarati, currentLang),

          // Scrollable Astrological Content
          Expanded(
            child: rashiProvider.isLoading
                ? const SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        LoadingSkeletonCard(height: 140),
                        SizedBox(height: 16),
                        LoadingSkeletonCard(height: 220),
                        SizedBox(height: 16),
                        LoadingSkeletonCard(height: 140),
                      ],
                    ),
                  )
                : rashiProvider.error != null && reading == null
                    ? ErrorStateView(
                        message: rashiProvider.error,
                        onRetry: () => rashiProvider.loadReadingForRashi(rashi, force: true),
                      )
                    : RefreshIndicator(
                        color: AppColors.saffronPrimary,
                        onRefresh: () => rashiProvider.loadReadingForRashi(rashi, force: true),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                          children: [
                            // Hero Rashi Profile Card
                            _buildProfileCard(context, rashi, isDark, isDefault, isGujarati, currentLang),

                            const SizedBox(height: 16),

                            // Daily Guidance / Main Horoscope Card
                            if (reading != null) ...[
                              _buildHoroscopeCard(context, rashi, reading, isDark),
                              const SizedBox(height: 16),

                              // Domain Specific Cards (Career, Family, Health)
                              _buildDomainGuidanceCard(context, reading, isDark),
                              const SizedBox(height: 16),

                              // Auspicious Attributes Grid
                              _buildLuckyTraitsGrid(context, rashi, reading, isDark),
                              const SizedBox(height: 16),
                            ],

                            // Sacred Mantra & Interactive Japa Counter Card
                            _buildMantraCard(context, rashi, isDark),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelectorBar(
    BuildContext context,
    RashiProvider provider,
    RashiInfo rashi,
    DateTime selectedDate,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDayChip(AppStrings.yesterday(currentLang), yesterday, selectedDate, provider, rashi, isDark, isGujarati),
          const SizedBox(width: 8),
          _buildDayChip(AppStrings.today(currentLang), today, selectedDate, provider, rashi, isDark, isGujarati),
          const SizedBox(width: 8),
          _buildDayChip(AppStrings.tomorrow(currentLang), tomorrow, selectedDate, provider, rashi, isDark, isGujarati),
        ],
      ),
    );
  }

  Widget _buildDayChip(
    String label,
    DateTime targetDate,
    DateTime selectedDate,
    RashiProvider provider,
    RashiInfo rashi,
    bool isDark,
    bool isGujarati,
  ) {
    final isSelected = DateUtils.isSameDay(targetDate, selectedDate);

    return Expanded(
      child: InkWell(
        onTap: () => provider.selectDate(targetDate, rashi: rashi),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.saffronPrimary
                : (isDark ? AppColors.cardDark : AppColors.bgLight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.goldLight
                  : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.saffronPrimary.withAlpha(80),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    RashiInfo rashi,
    bool isDark,
    bool isDefault,
    bool isGujarati,
    AppLanguage currentLang,
  ) {
    final rashiName = isGujarati ? rashi.gujaratiName : rashi.hindiName;
    final rulingPlanet = isGujarati ? rashi.rulingPlanetGujarati : rashi.rulingPlanet;

    return Container(
      padding: const EdgeInsets.all(18),
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
          RashiAvatarEmblem(rashi: rashi, diameter: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        rashiName,
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  '${rashi.englishName} • ${rashi.dateRange}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.goldLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.rulingPlanetLabel(currentLang)}: $rulingPlanet',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 11,
                          color: Colors.white.withAlpha(220),
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 12,
                          color: Colors.white.withAlpha(220),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeCard(
    BuildContext context,
    RashiInfo rashi,
    RashiReadingModel reading,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, color: AppColors.saffronPrimary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'दैनिक राशिफल / Daily Reading',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                onPressed: () {
                  final text = '${reading.horoscopeTextHindi ?? ''}\n\n${reading.horoscopeText}';
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reading copied to clipboard')),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            reading.date,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),

          const Divider(height: 20),

          // Hindi Guidance
          if (reading.horoscopeTextHindi != null) ...[
            Text(
              'दैनिक मार्गदर्शन (Hindi Prediction):',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.saffronDark,
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              reading.horoscopeTextHindi!,
              style: GoogleFonts.notoSerifDevanagari(
                fontSize: 15,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // English Horoscope
          Text(
            'Daily Astrological Outlook:',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldLight : AppColors.saffronDark,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            reading.horoscopeText,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainGuidanceCard(
    BuildContext context,
    RashiReadingModel reading,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_graph_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'जीवन के प्रमुख क्षेत्र / Key Life Spheres',
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Career & Finance
          if (reading.careerOutlookHindi != null)
            _buildDomainRow(
              icon: Icons.work_outline_rounded,
              title: 'कार्यक्षेत्र एवं वित्त (Career & Finance)',
              textHindi: reading.careerOutlookHindi!,
              textEn: reading.careerOutlook,
              isDark: isDark,
            ),

          const SizedBox(height: 12),

          // Family & Relationships
          if (reading.loveOutlookHindi != null)
            _buildDomainRow(
              icon: Icons.favorite_outline_rounded,
              title: 'पारिवारिक जीवन (Family & Harmony)',
              textHindi: reading.loveOutlookHindi!,
              textEn: reading.loveOutlook,
              isDark: isDark,
            ),

          const SizedBox(height: 12),

          // Health & Well-being
          if (reading.healthOutlookHindi != null)
            _buildDomainRow(
              icon: Icons.spa_outlined,
              title: 'स्वास्थ्य एवं ऊर्जा (Health & Energy)',
              textHindi: reading.healthOutlookHindi!,
              textEn: reading.healthOutlook,
              isDark: isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildDomainRow({
    required IconData icon,
    required String title,
    required String textHindi,
    String? textEn,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
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
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            textHindi,
            style: GoogleFonts.notoSerifDevanagari(
              fontSize: 13,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              height: 1.4,
            ),
          ),
          if (textEn != null) ...[
            const SizedBox(height: 4),
            Text(
              textEn,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLuckyTraitsGrid(
    BuildContext context,
    RashiInfo rashi,
    RashiReadingModel reading,
    bool isDark,
  ) {
    return Container(
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
          Text(
            'शुभ संकेत एवं गुण / Auspicious Attributes',
            style: GoogleFonts.cinzel(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTraitItem(
                  'भाग्यशाली अंक (Number)',
                  reading.luckyNumber ?? '${rashi.luckyNumber}',
                  Icons.numbers_rounded,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTraitItem(
                  'शुभ रंग (Color)',
                  reading.luckyColor ?? rashi.luckyColor,
                  Icons.palette_rounded,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTraitItem(
                  'शुभ रत्न (Gemstone)',
                  reading.luckyGemstone ?? 'माणिक्य (Ruby)',
                  Icons.diamond_rounded,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTraitItem(
                  'शुभ दिशा (Direction)',
                  reading.luckyDirection ?? 'उत्तर (North)',
                  Icons.explore_rounded,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTraitItem(
                  'तत्व (Element)',
                  rashi.element,
                  Icons.local_fire_department_rounded,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTraitItem(
                  'अनुकूल राशि (Match)',
                  reading.compatibility ?? 'कर्क, मीन',
                  Icons.favorite_rounded,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTraitItem(String title, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.saffronPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMantraCard(BuildContext context, RashiInfo rashi, bool isDark) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.self_improvement_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'ईष्टदेव एवं राशीय महामंत्र',
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                    ),
                  ),
                ],
              ),
              if (_chantCount > 0)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.goldLight),
                  onPressed: () => setState(() => _chantCount = 0),
                  tooltip: 'Reset Mala Counter',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'आराध्य देव: ${rashi.deity}',
            style: GoogleFonts.notoSerifDevanagari(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gold.withAlpha(isDark ? 50 : 80),
              ),
            ),
            child: SelectableText(
              rashi.mantra,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Japa Mala Counter (108 chants)
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                if (_chantCount < 108) {
                  _chantCount++;
                } else {
                  _chantCount = 1;
                }
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.touch_app_rounded, size: 18, color: AppColors.goldLight),
                      const SizedBox(width: 8),
                      Text(
                        'मंत्र जप माला (Tap to Chant):',
                        style: GoogleFonts.notoSerifDevanagari(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_chantCount / 108',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
