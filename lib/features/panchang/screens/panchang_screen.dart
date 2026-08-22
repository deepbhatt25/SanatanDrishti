import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_native_card.dart';
import '../../../core/widgets/ad_reward_dialog.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/offline_banner.dart';
import '../providers/panchang_provider.dart';
import '../widgets/choghadiya_widget.dart';
import '../widgets/muhurta_grid.dart';
import '../widgets/panchang_card.dart';
import '../widgets/sun_moon_tracker.dart';
import '../widgets/tithi_calendar_widget.dart';
import 'baby_rashi_sheet.dart';
import 'city_selector_dialog.dart';

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  // 0: Daily Panchang, 1: Monthly Tithi Calendar
  int _activeViewIndex = 0;
  bool _isMuhurtaUnlocked = false;

  @override
  Widget build(BuildContext context) {
    final panchangProvider = context.watch<PanchangProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panchang = panchangProvider.panchang;
    final selectedDate = panchangProvider.selectedDate;
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());

    final formattedDateEn = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: _activeViewIndex == 0
            ? AppStrings.panchangTitle(currentLang)
            : (isGujarati ? 'ગુજરાતી તિથિ કેલેન્ડર' : 'मासिक तिथि पंचांग कैलेंडर'),
        subtitle: formattedDateEn,
        showOm: true,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: Icon(
              _activeViewIndex == 1 ? Icons.view_day_rounded : Icons.calendar_month_rounded,
              color: AppColors.goldLight,
            ),
            onPressed: () {
              setState(() {
                _activeViewIndex = _activeViewIndex == 0 ? 1 : 0;
              });
            },
            tooltip: _activeViewIndex == 0
                ? (isGujarati ? 'માસિક કેલેન્ડર' : 'मासिक कैलेंडर')
                : (isGujarati ? 'દૈનિક પંચાંગ' : 'दैनिक पंचांग'),
          ),
          IconButton(
            icon: const Icon(Icons.location_on_rounded, color: AppColors.goldLight),
            onPressed: () => CitySelectorDialog.show(context),
            tooltip: 'Change City',
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.saffronPrimary.withAlpha(90),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            BabyRashiSheet.show(
              context,
              initialDate: panchangProvider.selectedDate,
              city: panchangProvider.selectedCity,
            );
          },
          backgroundColor: AppColors.saffronPrimary,
          elevation: 4,
          icon: const Icon(Icons.child_care_rounded, color: Colors.white, size: 20),
          label: Text(
            AppStrings.babyBornFab(currentLang),
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.saffronPrimary,
        onRefresh: () => panchangProvider.loadPanchang(forceRefresh: true),
        child: Column(
          children: [
            if (panchang?.isFromCache ?? false)
              OfflineBanner(customMessage: AppStrings.offlineMessage(currentLang)),

            // Sub Header: Date & City bar with quick navigation
            _buildLocationDateBar(context, panchangProvider, isToday, formattedDateEn, isDark, isGujarati, currentLang),

            // Spiritual Segmented Tab Switcher (Daily vs Monthly Calendar)
            _buildViewSegmentBar(isDark, isGujarati),

            // Main Content Area
            Expanded(
              child: _activeViewIndex == 1
                  ? ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        TithiCalendarWidget(
                          onDateSelectedCallback: () {
                            // User picked date in calendar
                          },
                        ),
                        // Action card to switch to full daily view for selected date
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _activeViewIndex = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.maroonPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            icon: const Icon(Icons.auto_stories_rounded, color: AppColors.goldLight, size: 18),
                            label: Text(
                              isGujarati
                                  ? 'આ દિવસનું સંપૂર્ણ દૈનિક પંચાંગ જુઓ'
                                  : 'इस दिन का सम्पूर्ण दैनिक पंचांग देखें',
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(fontSize: 13, fontWeight: FontWeight.bold)
                                  : GoogleFonts.notoSerifDevanagari(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : panchangProvider.isLoading
                      ? const SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              LoadingSkeletonCard(height: 240),
                              SizedBox(height: 12),
                              LoadingSkeletonCard(height: 120),
                              SizedBox(height: 12),
                              LoadingSkeletonCard(height: 200),
                            ],
                          ),
                        )
                      : panchang == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.wb_sunny_rounded, size: 48, color: AppColors.saffronPrimary),
                                  const SizedBox(height: 12),
                                  Text(
                                    isGujarati ? 'પંચાંગ ગણતરી ચાલુ છે...' : 'Calculating sacred calendar...',
                                    style: isGujarati ? GoogleFonts.notoSerifGujarati() : GoogleFonts.outfit(),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => panchangProvider.loadPanchang(forceRefresh: true),
                                    child: Text(AppStrings.retry(currentLang)),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.only(bottom: 80),
                              children: [
                                // Primary Panchang Card
                                PanchangCard(panchang: panchang),

                                // Sun and Moon times tracker
                                SunMoonTracker(panchang: panchang),

                                // Muhurtas (Auspicious & Inauspicious)
                                MuhurtaGrid(panchang: panchang),

                                // Day and Night Choghadiya Section
                                ChoghadiyaWidget(
                                  selectedDate: panchangProvider.selectedDate,
                                  selectedCity: panchangProvider.selectedCity,
                                ),

                                // Embedded Quick Monthly Calendar Preview Card
                                _buildMonthlyCalendarBanner(context, isDark, isGujarati),

                                // Native Ad Card
                                const AdNativeCard(),

                                // Rewarded Ad: Special Muhurat & Rahu Kaal Guidance
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.maroonPrimary.withAlpha(40),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.gold,
                                            ),
                                            child: const Icon(Icons.stars_rounded, color: Colors.black87, size: 22),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isGujarati ? 'વિશેષ શુભ મુહૂર્ત & હોરા ચક્ર' : 'विशेष शुभ मुहूर्त एवं होरा चक्र',
                                              style: isGujarati
                                                  ? GoogleFonts.notoSerifGujarati(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    )
                                                  : GoogleFonts.notoSerifDevanagari(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _isMuhurtaUnlocked
                                                  ? (isGujarati ? 'વિશેષ મુહૂર્ત સફળતાપૂર્વક અનલૉક થયેલ છે' : 'विशेष मुहूर्त सफलतापूर्वक अनलॉक हो चुका है')
                                                  : (isGujarati
                                                      ? 'આજના દિવસનું સંપૂર્ણ હોરા ચક્ર અને શુભ કાર્ય મુહૂર્ત જોવા માટે વિડિઓ જુઓ'
                                                      : 'आज के दिन का सम्पूर्ण होरा चक्र एवं शुभ कार्य मुहूर्त देखने के लिए वीडियो देखें'),
                                              style: GoogleFonts.outfit(fontSize: 11, color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_isMuhurtaUnlocked)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.gold.withAlpha(40),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: AppColors.gold, width: 1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 15),
                                              const SizedBox(width: 4),
                                              Text(
                                                isGujarati ? 'અનલૉક' : 'अनलॉक',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.goldLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        ElevatedButton(
                                          onPressed: () {
                                            AdRewardDialog.show(
                                              context,
                                              title: isGujarati ? 'હોરા ચક્ર & વિશેષ મુહૂર્ત' : 'होरा चक्र एवं विशेष मुहूर्त',
                                              description: isGujarati
                                                  ? 'આજના દિવસના શ્રેષ્ઠ હોરા અને શુભ ચોઘડિયા અનલૉક કરવા માટે એક નાનો વિડિઓ જુઓ.'
                                                  : 'आज के दिन के श्रेष्ठ होरा एवं शुभ चौघड़िया अनलॉक करने के लिए एक छोटा वीडियो देखें।',
                                              rewardDescription: isGujarati ? 'વિશેષ મુહૂર્ત અનલૉક થશે' : 'विशेष मुहूर्त अनलॉक होगा',
                                              onRewardGranted: () {
                                                setState(() {
                                                  _isMuhurtaUnlocked = true;
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
                                                          isGujarati ? 'મુહૂર્ત અનલૉક!' : 'मुहूर्त अनलॉक!',
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
                                                          ? 'આજના દિવસનું સંપૂર્ણ હોરા ચક્ર, અભિજિત મુહૂર્ત અને વિશેષ ચોઘડિયા સફળતાપૂર્વક અનલૉક થઈ ગયું છે.'
                                                          : 'आज के दिन का सम्पूर्ण होरा चक्र, अभिजित मुहूर्त एवं विशेष चौघड़िया सफलतापूर्वक अनलॉक हो चुका है।',
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
                                                          isGujarati ? 'જોવો' : 'देखें',
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
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: Text(
                                            isGujarati ? 'અનલૉક' : 'अनलॉक',
                                            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),

                                  // Expanded Unlocked Hora Chakra & Special Muhurat Guidance
                                  if (_isMuhurtaUnlocked) ...[
                                    const SizedBox(height: 14),
                                    const Divider(color: Colors.white24, height: 1),
                                    const SizedBox(height: 12),

                                    // 1. Special Auspicious Muhurats
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
                                                isGujarati ? 'આજના સર્વશ્રેષ્ઠ શુભ મુહૂર્ત' : 'आज के सर्वश्रेष्ठ शुभ मुहूर्त',
                                                style: GoogleFonts.cinzel(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.goldLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 6,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.saffronPrimary.withAlpha(80),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppColors.goldLight, width: 0.8),
                                                ),
                                                child: Text(
                                                  isGujarati ? 'અભિજિત: 12:05 - 12:55 PM' : 'अभिजित: 12:05 - 12:55 PM',
                                                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.saffronPrimary.withAlpha(80),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppColors.goldLight, width: 0.8),
                                                ),
                                                child: Text(
                                                  isGujarati ? 'વિજય: 02:35 - 03:25 PM' : 'विजय: 02:35 - 03:25 PM',
                                                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.saffronPrimary.withAlpha(80),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppColors.goldLight, width: 0.8),
                                                ),
                                                child: Text(
                                                  isGujarati ? 'બ્રહ્મ મુહૂર્ત: 04:45 - 05:30 AM' : 'ब्रह्म मुहूर्त: 04:45 - 05:30 AM',
                                                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // 2. 24-Hour Hora Chakra
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
                                              const Icon(Icons.schedule_rounded, color: AppColors.goldLight, size: 16),
                                              const SizedBox(width: 6),
                                              Text(
                                                isGujarati ? 'દૈનિક મુખ્ય હોરા ચક્ર' : 'दैनिक मुख्य होरा चक्र',
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
                                                ? '• સૂર્ય હોરા: 06:15 - 07:15 AM (રાજ્ય કાર્ય, ઉચ્ચ અધિકારી મુલાકાત)\n• શુક્ર હોરા: 07:15 - 08:15 AM (કલા, સૌંદર્ય, વાહન ખરીદી)\n• બુધ હોરા: 08:15 - 09:15 AM (વેપાર આરંભ, હિસાબ-લેખા)\n• ચંદ્ર હોરા: 09:15 - 10:15 AM (યાત્રા, શાંતિ, જળ સંબંધિત કાર્ય)\n• ગુરુ હોરા: 11:15 - 12:15 PM (ધાર્મિક કાર્ય, સોનું, જ્ઞાન સાધના)'
                                                : '• सूर्य होरा: 06:15 - 07:15 AM (प्रशासनिक कार्य, उच्च अधिकारी भेंट)\n• शुक्र होरा: 07:15 - 08:15 AM (कला, सौंदर्य, वाहन क्रय)\n• बुध होरा: 08:15 - 09:15 AM (व्यापार आरम्भ, लेखा-जोखा)\n• चन्द्र होरा: 09:15 - 10:15 AM (यात्रा, शांति, जल सम्बन्धी कार्य)\n• गुरु होरा: 11:15 - 12:15 PM (धार्मिक अनुष्ठान, स्वर्ण, विद्या)',
                                            style: isGujarati
                                                ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5)
                                                : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, color: Colors.white.withAlpha(220), height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                                // Vedic Season & Cosmic Attributes Card
                                _buildCosmicAttributesCard(context, panchang, isDark, isGujarati, currentLang),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSegmentBar(bool isDark, bool isGujarati) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.saffronPrimary.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.gold.withAlpha(70),
        ),
      ),
      child: Row(
        children: [
          // Tab 0: Daily Panchang
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeViewIndex = 0),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  gradient: _activeViewIndex == 0
                      ? const LinearGradient(
                          colors: [AppColors.saffronPrimary, Color(0xFFE65100)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wb_sunny_rounded,
                      size: 16,
                      color: _activeViewIndex == 0 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isGujarati ? 'દૈનિક પંચાંગ' : 'दैनिक पंचांग',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: _activeViewIndex == 0 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: _activeViewIndex == 0 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab 1: Monthly Tithi Calendar
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeViewIndex = 1),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  gradient: _activeViewIndex == 1
                      ? const LinearGradient(
                          colors: [AppColors.saffronPrimary, Color(0xFFE65100)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 16,
                      color: _activeViewIndex == 1 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isGujarati ? 'તિથિ કેલેન્ડર' : 'तिथि कैलेंडर',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: _activeViewIndex == 1 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: _activeViewIndex == 1 ? Colors.white : (isDark ? Colors.white70 : AppColors.maroonPrimary),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendarBanner(BuildContext context, bool isDark, bool isGujarati) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroonPrimary.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(60),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_month_rounded, color: AppColors.goldLight, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati ? 'માસિક તિથિ પંચાંગ કેલેન્ડર' : 'मासिक तिथि पंचांग कैलेंडर',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                      : GoogleFonts.notoSerifDevanagari(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 2),
                Text(
                  isGujarati
                      ? 'સુદ, વદ, એકાદશી, પૂનમ અને તહેવારો જુઓ'
                      : 'शुक्ल, कृष्ण, एकादशी, पूर्णिमा एवं त्योहार देखें',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(fontSize: 11, color: Colors.white70)
                      : GoogleFonts.notoSerifDevanagari(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() => _activeViewIndex = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              isGujarati ? 'ખોલો' : 'खोलें',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDatePicker(
    BuildContext context,
    PanchangProvider provider,
    bool isDark,
    bool isGujarati,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: isGujarati ? 'તારીખ પસંદ કરો' : 'दिनांक चुनें',
      cancelText: isGujarati ? 'રદ કરો' : 'रद्द करें',
      confirmText: isGujarati ? 'પસંદ કરો' : 'चुनें',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.saffronPrimary,
                    onPrimary: Colors.white,
                    surface: AppColors.surfaceDark,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: AppColors.maroonPrimary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.textPrimaryLight,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      provider.selectDate(picked);
    }
  }

  Widget _buildLocationDateBar(
    BuildContext context,
    PanchangProvider provider,
    bool isToday,
    String formattedDateEn,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang,
  ) {
    final selectedDate = provider.selectedDate;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // City Badge button
          InkWell(
            onTap: () => CitySelectorDialog.show(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.saffronDark.withAlpha(50) : AppColors.saffronPale,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.saffronMedium.withAlpha(80) : AppColors.saffronLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_pin, size: 13, color: AppColors.saffronPrimary),
                  const SizedBox(width: 3),
                  Text(
                    provider.selectedCity.getLocalizedName(currentLang),
                    style: isGujarati
                        ? GoogleFonts.notoSerifGujarati(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          )
                        : GoogleFonts.notoSerifDevanagari(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                          ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Date Navigator Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                onPressed: () {
                  provider.selectDate(selectedDate.subtract(const Duration(days: 1)));
                },
                tooltip: 'Previous Day',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => _openDatePicker(context, provider, isDark, isGujarati),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isToday
                        ? (isDark ? AppColors.maroonPrimary.withAlpha(80) : AppColors.gold.withAlpha(40))
                        : (isDark ? AppColors.surfaceDark : AppColors.bgLight),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday ? AppColors.gold : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 13, color: AppColors.saffronPrimary),
                      const SizedBox(width: 4),
                      Text(
                        _getDateLabel(selectedDate, isGujarati),
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                              ),
                      ),
                      if (!isToday) ...[
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () => provider.selectDate(DateTime.now()),
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Icon(Icons.restore_rounded, size: 13, color: AppColors.saffronPrimary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                onPressed: () {
                  provider.selectDate(selectedDate.add(const Duration(days: 1)));
                },
                tooltip: 'Next Day',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date, bool isGujarati) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return isGujarati ? 'આજે (${DateFormat('d MMM').format(date)})' : 'आज (${DateFormat('d MMM').format(date)})';
    if (diff == 1) return isGujarati ? 'આવતીકાલે (${DateFormat('d MMM').format(date)})' : 'कल (${DateFormat('d MMM').format(date)})';
    if (diff == -1) return isGujarati ? 'ગઈકાલે (${DateFormat('d MMM').format(date)})' : 'बीता कल (${DateFormat('d MMM').format(date)})';
    return DateFormat('d MMM (E)').format(date);
  }

  Widget _buildCosmicAttributesCard(
    BuildContext context,
    dynamic panchang,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              const Icon(Icons.flare_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isGujarati ? 'કાળ અને સંવત વિગત' : 'काल एवं संवत् विवरण / Calendar Details',
                  style: isGujarati
                      ? GoogleFonts.notoSerifGujarati(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        )
                      : GoogleFonts.cinzel(
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
          _buildDetailRow(
            isGujarati ? 'ઋતુ (Ritu/Season):' : 'ऋतु (Ritu/Season):',
            panchang.getLocalizedRitu(currentLang),
            isDark,
            isGujarati,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            isGujarati ? 'અયન (Ayana):' : 'अयन (Ayana):',
            panchang.getLocalizedAyana(currentLang),
            isDark,
            isGujarati,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            isGujarati ? 'વિક્રમ સંવત:' : 'विक्रम संवत्:',
            panchang.vikramSamvat,
            isDark,
            isGujarati,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            isGujarati ? 'શક સંવત:' : 'शक संवत्:',
            panchang.shakaSamvat,
            isDark,
            isGujarati,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            isGujarati ? 'ચાંદ્ર માસ:' : 'चान्द्र मास:',
            panchang.lunarMonth,
            isDark,
            isGujarati,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, bool isGujarati) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
          ),
        ),
      ],
    );
  }
}
