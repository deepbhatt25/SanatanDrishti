import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/widgets/ad_banner_widget.dart';
import '../../../core/widgets/ad_reward_dialog.dart';
import '../../../core/widgets/custom_app_bar.dart';

enum MalaBeadType {
  rudraksha,
  tulsi,
  sphatik,
  kamalgatta,
  chandan,
}

class GrahMantraInfo {
  final int id;
  final String gujaratiName;
  final String hindiName;
  final String englishName;
  final String beejMantraGu;
  final String beejMantraHi;
  final String deityGu;
  final String deityHi;
  final List<int> targetCounts;
  final MalaBeadType recommendedMala;
  final Color primaryColor;
  final Color secondaryColor;

  const GrahMantraInfo({
    required this.id,
    required this.gujaratiName,
    required this.hindiName,
    required this.englishName,
    required this.beejMantraGu,
    required this.beejMantraHi,
    required this.deityGu,
    required this.deityHi,
    required this.targetCounts,
    required this.recommendedMala,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class NavagrahaMantraData {
  static const List<GrahMantraInfo> grahs = [
    // 0: Surya
    GrahMantraInfo(
      id: 0,
      gujaratiName: 'સૂર્ય',
      hindiName: 'सूर्य',
      englishName: 'Sun (Surya)',
      beejMantraGu: 'ॐ સૂર્યાય નમઃ',
      beejMantraHi: 'ॐ सूर्याय नमः',
      deityGu: 'ભગવાન સૂર્યનારાયણ / વિષ્ણુ',
      deityHi: 'भगवान सूर्यनारायण / विष्णु',
      targetCounts: [7000, 14000, 21000, 28000, 125000],
      recommendedMala: MalaBeadType.chandan,
      primaryColor: Color(0xFFD35400),
      secondaryColor: Color(0xFFE67E22),
    ),
    // 1: Chandra
    GrahMantraInfo(
      id: 1,
      gujaratiName: 'ચંદ્ર',
      hindiName: 'चंद्र',
      englishName: 'Moon (Chandra)',
      beejMantraGu: 'ॐ સોમાય નમઃ',
      beejMantraHi: 'ॐ सोमाय नमः',
      deityGu: 'ભગવાન શિવ / ચંદ્રદેવ',
      deityHi: 'भगवान शिव / चंद्रदेव',
      targetCounts: [11000, 22000, 33000, 44000, 125000],
      recommendedMala: MalaBeadType.sphatik,
      primaryColor: Color(0xFF4A6984),
      secondaryColor: Color(0xFF85A5CC),
    ),
    // 2: Mangal
    GrahMantraInfo(
      id: 2,
      gujaratiName: 'મંગળ',
      hindiName: 'मंगल',
      englishName: 'Mars (Mangal)',
      beejMantraGu: 'ॐ ભૌમાય નમઃ',
      beejMantraHi: 'ॐ भौमाय नमः',
      deityGu: 'ભગવાન હનુમાનજી / કાર્તિકેય',
      deityHi: 'भगवान हनुमान जी / कार्तिकेय',
      targetCounts: [10000, 20000, 30000, 40000, 125000],
      recommendedMala: MalaBeadType.chandan,
      primaryColor: Color(0xFFC0392B),
      secondaryColor: Color(0xFFE74C3C),
    ),
    // 3: Budh
    GrahMantraInfo(
      id: 3,
      gujaratiName: 'બુધ',
      hindiName: 'बुध',
      englishName: 'Mercury (Budh)',
      beejMantraGu: 'ॐ બુધાય નમઃ',
      beejMantraHi: 'ॐ बुधाय नमः',
      deityGu: 'ભગવાન ગણેશજી / વિષ્ણુ',
      deityHi: 'भगवान गणेश जी / विष्णु',
      targetCounts: [4000, 8000, 12000, 16000, 125000],
      recommendedMala: MalaBeadType.tulsi,
      primaryColor: Color(0xFF27AE60),
      secondaryColor: Color(0xFF2ECC71),
    ),
    // 4: Guru
    GrahMantraInfo(
      id: 4,
      gujaratiName: 'ગુરૂ',
      hindiName: 'गुरू',
      englishName: 'Jupiter (Guru)',
      beejMantraGu: 'ॐ ગુરવે નમઃ',
      beejMantraHi: 'ॐ गुरवे नमः',
      deityGu: 'ભગવાન વિષ્ણુ / ગુરુ બૃહસ્પતિ',
      deityHi: 'भगवान विष्णु / गुरु बृहस्पति',
      targetCounts: [19000, 38000, 57000, 76000, 125000],
      recommendedMala: MalaBeadType.tulsi,
      primaryColor: Color(0xFFD4AC0D),
      secondaryColor: Color(0xFFF1C40F),
    ),
    // 5: Shukra
    GrahMantraInfo(
      id: 5,
      gujaratiName: 'શુક્ર',
      hindiName: 'शुक्र',
      englishName: 'Venus (Shukra)',
      beejMantraGu: 'ॐ શુક્રાય નમઃ',
      beejMantraHi: 'ॐ शुक्राय नमः',
      deityGu: 'માતા મહાલક્ષ્મી / શુક્રાચાર્ય',
      deityHi: 'माता महालक्ष्मी / शुक्राचार्य',
      targetCounts: [16000, 32000, 48000, 64000, 125000],
      recommendedMala: MalaBeadType.kamalgatta,
      primaryColor: Color(0xFF8E44AD),
      secondaryColor: Color(0xFF9B59B6),
    ),
    // 6: Shani
    GrahMantraInfo(
      id: 6,
      gujaratiName: 'શનિ',
      hindiName: 'शनि',
      englishName: 'Saturn (Shani)',
      beejMantraGu: 'ॐ શનૈશ્ચરાય નમઃ',
      beejMantraHi: 'ॐ शनैश्चराय नमः',
      deityGu: 'ભગવાન શનિદેવ / કાલભૈરવ / હનુમાનજી',
      deityHi: 'भगवान शनिदेव / कालभैरव / हनुमान जी',
      targetCounts: [23000, 46000, 69000, 92000, 125000],
      recommendedMala: MalaBeadType.rudraksha,
      primaryColor: Color(0xFF2C3E50),
      secondaryColor: Color(0xFF34495E),
    ),
    // 7: Rahu
    GrahMantraInfo(
      id: 7,
      gujaratiName: 'રાહુ',
      hindiName: 'राहु',
      englishName: 'Rahu (North Node)',
      beejMantraGu: 'ॐ રાહવે નમઃ',
      beejMantraHi: 'ॐ राहवे नमः',
      deityGu: 'માતા સરસ્વતી / ભૈરવ / શિવ',
      deityHi: 'माता सरस्वती / भैरव / शिव',
      targetCounts: [18000, 36000, 54000, 72000, 125000],
      recommendedMala: MalaBeadType.rudraksha,
      primaryColor: Color(0xFF1B2631),
      secondaryColor: Color(0xFF283747),
    ),
    // 8: Ketu
    GrahMantraInfo(
      id: 8,
      gujaratiName: 'કેતુ',
      hindiName: 'केतु',
      englishName: 'Ketu (South Node)',
      beejMantraGu: 'ॐ કેતવે નમઃ',
      beejMantraHi: 'ॐ केतवे नमः',
      deityGu: 'ભગવાન ગણેશજી / મત્સ્ય અવતાર',
      deityHi: 'भगवान गणेश जी / मत्स्य अवतार',
      targetCounts: [17000, 34000, 51000, 68000, 125000],
      recommendedMala: MalaBeadType.rudraksha,
      primaryColor: Color(0xFF6E2C00),
      secondaryColor: Color(0xFF873600),
    ),
  ];

  static int getGrahIndexForRashi(RashiInfo rashi) {
    final planet = rashi.rulingPlanet.toLowerCase();
    if (planet.contains('sun') || planet.contains('surya')) return 0;
    if (planet.contains('moon') || planet.contains('chandra')) return 1;
    if (planet.contains('mars') || planet.contains('mangal')) return 2;
    if (planet.contains('mercury') || planet.contains('budh')) return 3;
    if (planet.contains('jupiter') || planet.contains('guru') || planet.contains('brihaspati')) return 4;
    if (planet.contains('venus') || planet.contains('shukra')) return 5;
    if (planet.contains('saturn') || planet.contains('shani')) return 6;
    return 4; // default Guru
  }
}

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

class _MantraJapaScreenState extends State<MantraJapaScreen> with TickerProviderStateMixin {
  late int _selectedGrahIndex;
  late MalaBeadType _selectedMalaBead;
  late int _chantCount;
  int _completedMalas = 0;
  late int _targetChants;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _beadSlideKey = 0;

  @override
  void initState() {
    super.initState();
    _selectedGrahIndex = NavagrahaMantraData.getGrahIndexForRashi(widget.rashi);
    final initialGrah = NavagrahaMantraData.grahs[_selectedGrahIndex];
    _selectedMalaBead = initialGrah.recommendedMala;
    _targetChants = initialGrah.targetCounts.first;
    _chantCount = widget.initialCount;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
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
    // Ultra smooth low-level tactile vibration
    HapticFeedback.selectionClick();
    _pulseController.forward(from: 0.96);

    setState(() {
      _beadSlideKey++;
      _chantCount++;
      if (_chantCount % 108 == 0) {
        _completedMalas++;
      }
      if (_chantCount >= _targetChants) {
        _showMalaCompletionDialog();
      }
    });
  }

  void _showMalaCompletionDialog() {
    HapticFeedback.mediumImpact();
    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final grah = NavagrahaMantraData.grahs[_selectedGrahIndex];
    final grahName = isGujarati ? grah.gujaratiName : grah.hindiName;

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
              isGujarati ? 'મંત્ર અનુષ્ઠાન પૂર્ણ!' : 'मन्त्र अनुष्ठान पूर्ण!',
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(fontWeight: FontWeight.bold, color: AppColors.goldLight)
                  : GoogleFonts.notoSerifDevanagari(fontWeight: FontWeight.bold, color: AppColors.goldLight),
            ),
          ],
        ),
        content: Text(
          isGujarati
              ? 'તમે $grahName ગ્રહના $_targetChants મંત્ર જાપનું પવિત્ર અનુષ્ઠાન સફળતાપૂર્વક પૂર્ણ કર્યું છે. ${grah.deityGu} તમારા પર સદા સુખ-શાંતિની કૃપા વરસાવે.'
              : 'आपने $grahName ग्रह के $_targetChants मन्त्र जप का पवित्र अनुष्ठान सफलतापूर्वक पूर्ण किया है। ${grah.deityHi} आप पर सदैव कृपा बनाए रखें।',
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
              isGujarati ? 'નવો સંકલ્પ શરૂ કરો' : 'नया संकल्प प्रारम्भ करें',
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
      _completedMalas = 0;
      _beadSlideKey = 0;
    });
  }

  void _selectGrah(int index) {
    setState(() {
      _selectedGrahIndex = index;
      final grah = NavagrahaMantraData.grahs[index];
      _targetChants = grah.targetCounts.first;
      _selectedMalaBead = grah.recommendedMala;
    });
  }

  String _getMalaName(MalaBeadType type, bool isGujarati) {
    switch (type) {
      case MalaBeadType.rudraksha:
        return isGujarati ? 'રૂદ્રાક્ષ માળા' : 'रुद्राक्ष माला';
      case MalaBeadType.tulsi:
        return isGujarati ? 'તુલસી માળા' : 'तुलसी माला';
      case MalaBeadType.sphatik:
        return isGujarati ? 'સ્ફટિક માળા' : 'स्फटिक माला';
      case MalaBeadType.kamalgatta:
        return isGujarati ? 'કમલગટ્ટા માળા' : 'कमलगट्टा माला';
      case MalaBeadType.chandan:
        return isGujarati ? 'લાલ ચંદન' : 'लाल चंदन';
    }
  }

  String _getBeadAsset(MalaBeadType type) {
    switch (type) {
      case MalaBeadType.rudraksha:
        return 'assets/images/rudraksha_bead.jpg';
      case MalaBeadType.tulsi:
        return 'assets/images/tulsi_bead.jpg';
      case MalaBeadType.sphatik:
        return 'assets/images/sphatik_bead.jpg';
      case MalaBeadType.kamalgatta:
        return 'assets/images/kamalgatta_bead.jpg';
      case MalaBeadType.chandan:
        return 'assets/images/chandan_bead.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final grah = NavagrahaMantraData.grahs[_selectedGrahIndex];
    final grahName = isGujarati ? grah.gujaratiName : grah.hindiName;
    final beejMantra = isGujarati ? grah.beejMantraGu : grah.beejMantraHi;
    final deity = isGujarati ? grah.deityGu : grah.deityHi;
    final progress = _targetChants > 0 ? (_chantCount / _targetChants).clamp(0.0, 1.0) : 0.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _chantCount);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        appBar: CustomSpiritualAppBar(
          title: isGujarati ? '$grahName ગ્રહ મંત્ર જાપ માળા' : '$grahName ग्रह मन्त्र जप माला',
          subtitle: 'આરાધ્ય: $deity',
          showLanguageToggle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.goldLight),
              tooltip: 'Reset Count',
              onPressed: _resetCounter,
            ),
            IconButton(
              icon: const Icon(Icons.star_rounded, color: AppColors.gold),
              tooltip: '1.25 Lakh Maha Sankalp',
              onPressed: () {
                AdRewardDialog.show(
                  context,
                  title: isGujarati ? '૧,૨૫,૦૦૦ મહા અનુષ્ઠાન સંકલ્પ' : '१,२५,००० महा अनुष्ठान संकल्प',
                  description: isGujarati
                      ? 'ગ્રહ દોષ નિવારણ અને મહાસિદ્ધિ માટે ૧.૨૫ લાખ મંત્ર જાપ સંકલ્પ અનલૉક કરવા માટે એક નાનો વિડિઓ જુઓ.'
                      : 'ग्रह दोष निवारण एवं महासिद्धि हेतु १.२५ लाख मन्त्र जप संकल्प अनलॉक करने के लिए एक छोटा वीडियो देखें।',
                  rewardDescription: isGujarati ? '૧,૨૫,૦૦૦ જાપ સંકલ્પ સેટ થશે' : '१,२५,००० जप संकल्प सेट होगा',
                  onRewardGranted: () {
                    setState(() {
                      _targetChants = 125000;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isGujarati
                              ? '૧,૨૫,૦૦૦ મહામંત્ર સંકલ્પ સફળતાપૂર્વક સેટ થયો!'
                              : '१,२५,००० महामन्त्र संकल्प सफलतापूर्वक सेट हुआ!',
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Column(
                  children: [
                    // 1. NAVAGRAHA HORIZONTAL SELECTOR STRIP
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 30 : 8),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.stars_rounded, size: 15, color: AppColors.gold),
                                const SizedBox(width: 5),
                                Text(
                                  isGujarati ? 'નવગ્રહ પસંદગી (Select Grah):' : 'नवग्रह चयन (Select Grah):',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(NavagrahaMantraData.grahs.length, (idx) {
                                final g = NavagrahaMantraData.grahs[idx];
                                final isSel = _selectedGrahIndex == idx;
                                final name = isGujarati ? g.gujaratiName : g.hindiName;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: ChoiceChip(
                                    label: Text(name),
                                    selected: isSel,
                                    onSelected: (_) => _selectGrah(idx),
                                    labelStyle: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(
                                            fontSize: 12,
                                            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                            color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                          )
                                        : GoogleFonts.notoSerifDevanagari(
                                            fontSize: 12.5,
                                            fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                            color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                          ),
                                    selectedColor: g.primaryColor,
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: isSel ? g.secondaryColor : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 2. MALA BEAD TYPE SELECTOR (With Miniature Bead Images)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isGujarati ? 'માળા:' : 'माला:',
                            style: GoogleFonts.outfit(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: MalaBeadType.values.map((type) {
                                  final isSel = _selectedMalaBead == type;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ChoiceChip(
                                      avatar: ClipOval(
                                        child: Image.asset(
                                          _getBeadAsset(type),
                                          width: 16,
                                          height: 16,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      label: Text(_getMalaName(type, isGujarati)),
                                      selected: isSel,
                                      onSelected: (val) {
                                        if (val) setState(() => _selectedMalaBead = type);
                                      },
                                      labelStyle: GoogleFonts.outfit(
                                        fontSize: 10.5,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                        color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                                      selectedColor: AppColors.maroonPrimary,
                                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 3. GRAH SPECIFIC TARGET CHANTS SELECTOR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isGujarati ? 'લક્ષ્ય:' : 'लक्ष्य:',
                            style: GoogleFonts.outfit(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: grah.targetCounts.map((target) {
                                  final isSelected = _targetChants == target;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ChoiceChip(
                                      label: Text(
                                        isGujarati ? _toGujaratiDigits('$target') : '$target',
                                      ),
                                      selected: isSelected,
                                      onSelected: (sel) {
                                        if (sel) {
                                          setState(() {
                                            _targetChants = target;
                                          });
                                        }
                                      },
                                      labelStyle: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                                      selectedColor: AppColors.saffronPrimary,
                                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 4. SACRED BEEJ MANTRA DISPLAY CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [grah.primaryColor, grah.secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: grah.primaryColor.withAlpha(70),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isGujarati ? '॥ $grahName મહામંત્ર ॥' : '॥ $grahName महामन्त्र ॥',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldLight,
                                    letterSpacing: 1.1,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldLight,
                                    letterSpacing: 1.1,
                                  ),
                          ),
                          const SizedBox(height: 2),
                          SelectableText(
                            beejMantra,
                            textAlign: TextAlign.center,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.05,
                                    shadows: [
                                      Shadow(color: Colors.black.withAlpha(140), blurRadius: 6),
                                    ],
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.05,
                                    shadows: [
                                      Shadow(color: Colors.black.withAlpha(140), blurRadius: 6),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${isGujarati ? 'આરાધ્ય:' : 'आराध्य:'} $deity',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(fontSize: 10.5, color: Colors.white)
                                : GoogleFonts.notoSerifDevanagari(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 5. SLIM COMPACT COUNT & TARGET DISPLAY
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.gold.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isGujarati ? _toGujaratiDigits('$_chantCount') : '$_chantCount',
                            style: GoogleFonts.cinzel(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                          ),
                          Text(
                            ' / ${isGujarati ? _toGujaratiDigits('$_targetChants') : '$_targetChants'}',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 16,
                            color: isDark ? Colors.white24 : Colors.black12,
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            isGujarati
                                ? 'માલા: ${_toGujaratiDigits('$_completedMalas')}'
                                : 'माला: $_completedMalas',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.saffronPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 6. REALISTIC SLIDING MALA BEAD (PULL/SLIDE BEAD ONE-BY-ONE TO THE LEFT)
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: GestureDetector(
                        onTap: _onChantTapped,
                        onHorizontalDragEnd: (details) {
                          if ((details.primaryVelocity ?? 0) < 0) {
                            _onChantTapped();
                          }
                        },
                        child: Container(
                          width: 166,
                          height: 166,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.black87,
                                const Color(0xFF140700),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: grah.primaryColor.withAlpha(100),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                              const BoxShadow(
                                color: AppColors.gold,
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Progress Ring around the Bead
                              SizedBox(
                                width: 164,
                                height: 164,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.white.withAlpha(25),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                                ),
                              ),

                              // REALISTIC SLIDING BEAD (SLIDES LEFT ONE BY ONE)
                              ClipOval(
                                child: Container(
                                  width: 148,
                                  height: 148,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.gold.withAlpha(200),
                                      width: 2,
                                    ),
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 260),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeInCubic,
                                    transitionBuilder: (child, animation) {
                                      final inAnimation = Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation);

                                      final outAnimation = Tween<Offset>(
                                        begin: const Offset(-1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation);

                                      if (child.key == ValueKey<int>(_beadSlideKey)) {
                                        return SlideTransition(
                                          position: inAnimation,
                                          child: child,
                                        );
                                      } else {
                                        return SlideTransition(
                                          position: outAnimation,
                                          child: child,
                                        );
                                      }
                                    },
                                    child: Container(
                                      key: ValueKey<int>(_beadSlideKey),
                                      width: 148,
                                      height: 148,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: Image.asset(
                                        _getBeadAsset(_selectedMalaBead),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Tap/Slide Instruction Hint
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.saffronPrimary.withAlpha(isDark ? 140 : 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swipe_left_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            isGujarati ? 'મણકો ડાબી તરફ સરકાવો / સ્પર્શ કરો' : 'मनका बाईं ओर सरकाएं / स्पर्श करें',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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

  String _toGujaratiDigits(String input) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const gu = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
    var res = input;
    for (int i = 0; i < 10; i++) {
      res = res.replaceAll(en[i], gu[i]);
    }
    return res;
  }
}
