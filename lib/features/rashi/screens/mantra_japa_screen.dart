import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/ad_reward_dialog.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/constants/rashi_data.dart';

/// Full-screen interactive Mantra Japa Mala screen.
/// Allows devotees to perform 108 sacred mantra chants with tactile haptic feedback,
/// progress ring, completed mala counter, and integrated ads.
class MantraJapaScreen extends StatefulWidget {
  final RashiInfo rashi;
  final int initialCount;

  const MantraJapaScreen({
    super.key,
    required this.rashi,
    this.initialCount = 0,
  });

  @override
  State<MantraJapaScreen> createState() => _MantraJapaScreenState();
}

class _MantraJapaScreenState extends State<MantraJapaScreen>
    with SingleTickerProviderStateMixin {
  late int _chantCount;
  int _completedMalas = 0;
  int _targetChants = 108;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _chantCount = widget.initialCount;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.94,
      upperBound: 1.0,
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _pulseController.value = 1.0;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onChantTapped() {
    HapticFeedback.lightImpact();
    _pulseController.forward(from: 0.94);

    setState(() {
      if (_chantCount < _targetChants) {
        _chantCount++;
      } else {
        _completedMalas++;
        _chantCount = 1;
        _showMalaCompletionDialog();
      }
    });
  }

  void _showMalaCompletionDialog() {
    HapticFeedback.heavyImpact();
    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

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
              isGujarati ? 'માલા પૂર્ણ!' : 'माला पूर्ण!',
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
              ? 'તમે $_targetChants મંત્ર જાપની ૧ માલા સફળતાપૂર્વક પૂર્ણ કરી છે. ભગવાન ${widget.rashi.deity} તમારા પર કૃપા બનાવી રાખે.'
              : 'आपने $_targetChants मन्त्र जप की १ माला सफलतापूर्वक पूर्ण की है। भगवान ${widget.rashi.deity} की कृपा आप पर बनी रहे।',
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14, height: 1.5),
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
              isGujarati ? 'નવી માલા શરૂ કરો' : 'नई माला प्रारम्भ करें',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _resetCounter() {
    setState(() {
      _chantCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rashi = widget.rashi;
    final rashiName = isGujarati ? rashi.gujaratiName : rashi.hindiName;
    final progress = _targetChants > 0 ? (_chantCount / _targetChants).clamp(0.0, 1.0) : 0.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _chantCount);
        }
      },
      child: Scaffold(
        appBar: CustomSpiritualAppBar(
          title: isGujarati ? '$rashiName મંત્ર જાપ માલા' : '$rashiName मन्त्र जप माला',
          subtitle: 'आराध्य देव: ${rashi.deity}',
          showLanguageToggle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.goldLight),
              tooltip: 'Reset Count',
              onPressed: _resetCounter,
            ),
            IconButton(
              icon: const Icon(Icons.star_rounded, color: AppColors.gold),
              tooltip: 'Siddhi Sankalp',
              onPressed: () {
                AdRewardDialog.show(
                  context,
                  title: isGujarati ? '૧૦૦૮ મહાસંકલ્પ સિદ્ધિ' : '१००८ महासंकલ્પ सिद्धि',
                  description: isGujarati
                      ? 'વિશેષ મંત્ર સિદ્ધિ અને વૈદિક અનુષ્ઠાન સંકલ્પ અનલૉક કરવા માટે એક નાનો વિડિઓ જુઓ.'
                      : 'विशेष मन्त्र सिद्धि एवं वैदिक अनुष्ठान संकल्प अनलॉक करने के लिए एक छोटा वीडियो देखें।',
                  rewardDescription: isGujarati ? 'મંત્ર સિદ્ધિ સંકલ્પ અનલૉક થશે' : 'मन्त्र सिद्धि संकल्प अनलॉक होगा',
                  onRewardGranted: () {
                    setState(() {
                      _targetChants = 1008;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isGujarati
                              ? '૧૦૦૮ મહામંત્ર સંકલ્પ સફળતાપૂર્વક સેટ થયો!'
                              : '१००८ महामन्त्र संकल्प सफलतापूर्वक सेट हुआ!',
                        ),
                        backgroundColor: AppColors.saffronPrimary,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Target Selector Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isGujarati ? 'જાપ લક્ષ્ય:' : 'जप लक्ष्य:',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                            ),
                          ),
                          Wrap(
                            spacing: 6,
                            children: [11, 21, 54, 108, 1008].map((target) {
                              final isSelected = _targetChants == target;
                              return ChoiceChip(
                                label: Text('$target'),
                                selected: isSelected,
                                onSelected: (sel) {
                                  if (sel) {
                                    setState(() {
                                      _targetChants = target;
                                      if (_chantCount > target) _chantCount = target;
                                    });
                                  }
                                },
                                labelStyle: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                ),
                                selectedColor: AppColors.saffronPrimary,
                                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Sacred Mantra Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.maroonPrimary.withAlpha(50),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '॥ राशीय बीज महामंत्र ॥',
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.goldLight,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SelectableText(
                            rashi.mantra,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerifDevanagari(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.1,
                              shadows: [
                                Shadow(
                                  color: AppColors.gold.withAlpha(160),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ग्रह स्वामी: ${isGujarati ? rashi.rulingPlanetGujarati : rashi.rulingPlanet}  •  तत्व: ${isGujarati ? rashi.elementGujarati : rashi.element}',
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Giant Tap-to-Chant Interactive Mala Wheel
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: GestureDetector(
                        onTap: _onChantTapped,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: isDark
                                  ? [
                                      AppColors.maroonPrimary.withAlpha(180),
                                      const Color(0xFF1E0404),
                                    ]
                                  : [
                                      AppColors.saffronPrimary.withAlpha(200),
                                      const Color(0xFF8B2500),
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.saffronPrimary.withAlpha(90),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: AppColors.gold.withAlpha(60),
                                blurRadius: 18,
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.gold,
                              width: 3.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Progress Ring
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.white.withAlpha(30),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                                ),
                              ),

                              // Center Count & Tap Indicator
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.touch_app_rounded, color: AppColors.goldLight, size: 28),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$_chantCount',
                                    style: GoogleFonts.cinzel(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: AppColors.gold.withAlpha(180),
                                          blurRadius: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '/ $_targetChants',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.goldLight,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(100),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isGujarati ? 'સ્પર્શ કરો (Tap)' : 'स्पर्श करें (Tap)',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
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

                    const SizedBox(height: 20),

                    // Completed Malas Counter Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.gold.withAlpha(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isGujarati
                                ? 'પૂર્ણ માલા: $_completedMalas'
                                : 'पूर्ण माला: $_completedMalas',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
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
            ),

            // Bottom Banner Ad
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }
}
