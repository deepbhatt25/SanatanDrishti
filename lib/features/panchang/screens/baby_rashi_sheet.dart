import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/location_service.dart';
import '../models/baby_rashi_model.dart';
import '../repositories/panchang_repository.dart';

class BabyRashiSheet extends StatefulWidget {
  final DateTime initialDate;
  final CityLocation city;

  const BabyRashiSheet({
    super.key,
    required this.initialDate,
    required this.city,
  });

  static Future<void> show(BuildContext context, {required DateTime initialDate, required CityLocation city}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BabyRashiSheet(initialDate: initialDate, city: city),
    );
  }

  @override
  State<BabyRashiSheet> createState() => _BabyRashiSheetState();
}

class _BabyRashiSheetState extends State<BabyRashiSheet> {
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  DateTime get _combinedDateTime {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.saffronPrimary,
              onPrimary: Colors.white,
              surface: AppColors.cardLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.saffronPrimary,
              onPrimary: Colors.white,
              surface: AppColors.cardLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;

    final BabyRashiModel babyRashi = PanchangRepository.calculateBabyBornRashi(_combinedDateTime, widget.city);

    final rashiName = isGujarati ? babyRashi.rashiGujarati : babyRashi.rashiHindi;
    final nakshatraName = isGujarati ? babyRashi.nakshatraGujarati : babyRashi.nakshatraHindi;
    final rulingPlanet = isGujarati ? babyRashi.rulingPlanetGujarati : babyRashi.rulingPlanet;
    final element = isGujarati ? babyRashi.elementGujarati : babyRashi.element;
    final gana = isGujarati ? '${babyRashi.ganaGujarati} ગણ' : '${babyRashi.gana} गण';
    final nadi = isGujarati ? '${babyRashi.nadiGujarati} નાડી' : '${babyRashi.nadi} नाड़ी';
    final colors = isGujarati ? babyRashi.favorableColorsGujarati : babyRashi.favorableColors;
    final gemstone = isGujarati ? babyRashi.favorableGemstoneGujarati : babyRashi.favorableGemstone;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 100 : 40),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.saffronGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.child_care_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.babyBornTitle(currentLang),
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                ),
                        ),
                        Text(
                          'BABY BORN RASHI & NAMAKSHAR',
                          style: GoogleFonts.cinzel(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time Pickers Bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.saffronPrimary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.birthDate(currentLang),
                                          style: isGujarati
                                              ? GoogleFonts.notoSerifGujarati(
                                                  fontSize: 10,
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                )
                                              : GoogleFonts.notoSerifDevanagari(
                                                  fontSize: 10,
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                ),
                                        ),
                                        Text(
                                          DateFormat('dd MMM yyyy').format(_selectedDate),
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Time Picker
                        Expanded(
                          child: InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 16, color: AppColors.saffronPrimary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.birthTime(currentLang),
                                          style: isGujarati
                                              ? GoogleFonts.notoSerifGujarati(
                                                  fontSize: 10,
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                )
                                              : GoogleFonts.notoSerifDevanagari(
                                                  fontSize: 10,
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                                ),
                                        ),
                                        Text(
                                          _selectedTime.format(context),
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Calculated Janma Rashi Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? const LinearGradient(
                              colors: [Color(0xFF3D0C0C), Color(0xFF220808)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withAlpha(isDark ? 50 : 30),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Symbol Emblem
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.maroonGradient,
                            border: Border.all(color: AppColors.goldLight, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.saffronPrimary.withAlpha(90),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              babyRashi.rashiSymbol,
                              style: const TextStyle(fontSize: 34, color: AppColors.goldLight),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          '${AppStrings.janmaRashi(currentLang)} (Moon Sign)',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 12,
                                  color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                                  fontWeight: FontWeight.w600,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 12,
                                  color: isDark ? AppColors.goldLight : AppColors.saffronDark,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                        Text(
                          '$rashiName (${babyRashi.rashiEn})',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.maroonPrimary,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.maroonPrimary,
                                ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${AppStrings.janmaNakshatra(currentLang)}: $nakshatraName  •  ${AppStrings.charan(currentLang)} ${langProvider.formatNumber(babyRashi.pada)}',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.maroonLight,
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Auspicious Namakshar (Baby Name Syllables)
                  Text(
                    isGujarati ? 'નામકરણ માટેના શુભ અક્ષરો' : 'नामकरण के शुभ अक्षर (Auspicious Letters)',
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
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
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
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.saffronGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isGujarati
                                    ? 'સર્વોત્તમ નામાક્ષર (${AppStrings.charan(currentLang)} ${langProvider.formatNumber(babyRashi.pada)})'
                                    : 'सर्वोत्तम नामाक्षर (चरण ${babyRashi.pada})',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withAlpha(isDark ? 50 : 30),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.gold),
                              ),
                              child: Text(
                                babyRashi.recommendedLetter,
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Text(
                          isGujarati ? 'આ નક્ષત્રના તમામ ૪ ચરણના નામાક્ષર:' : 'इस नक्षत्र के सभी 4 चरणों के नामाक्षर:',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: babyRashi.allPadaNamakshar.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final syll = entry.value;
                            final isRecommended = (idx + 1) == babyRashi.pada;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isRecommended
                                    ? AppColors.saffronPrimary
                                    : (isDark ? AppColors.surfaceDark : AppColors.bgLight),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isRecommended ? AppColors.gold : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                                ),
                              ),
                              child: Text(
                                isGujarati
                                    ? 'ચરણ ${langProvider.formatNumber(idx + 1)}: $syll'
                                    : 'चरण ${idx + 1}: $syll',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 12,
                                        fontWeight: isRecommended ? FontWeight.bold : FontWeight.w500,
                                        color: isRecommended ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontSize: 12,
                                        fontWeight: isRecommended ? FontWeight.bold : FontWeight.w500,
                                        color: isRecommended ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Vedic Astrological Attributes Grid
                  Text(
                    isGujarati ? 'વૈદિક ગુણ અને તત્વ વિગત' : 'वैदिक गुण एवं तत्व विवरण',
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
                  const SizedBox(height: 8),
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
                      children: [
                        _buildAttributeRow(AppStrings.rulingPlanetLabel(currentLang), rulingPlanet, isDark, isGujarati),
                        const Divider(height: 14),
                        _buildAttributeRow(AppStrings.elementLabel(currentLang), element, isDark, isGujarati),
                        const Divider(height: 14),
                        _buildAttributeRow(AppStrings.gana(currentLang), gana, isDark, isGujarati),
                        const Divider(height: 14),
                        _buildAttributeRow(AppStrings.nadi(currentLang), nadi, isDark, isGujarati),
                        const Divider(height: 14),
                        _buildAttributeRow(AppStrings.luckyColors(currentLang), colors, isDark, isGujarati),
                        const Divider(height: 14),
                        _buildAttributeRow(AppStrings.luckyGem(currentLang), gemstone, isDark, isGujarati),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(String label, String value, bool isDark, bool isGujarati) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isGujarati
              ? GoogleFonts.notoSerifGujarati(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                )
              : GoogleFonts.notoSerifDevanagari(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
        ),
        Text(
          value,
          style: isGujarati
              ? GoogleFonts.notoSerifGujarati(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.goldLight : AppColors.textPrimaryLight,
                )
              : GoogleFonts.notoSerifDevanagari(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.goldLight : AppColors.textPrimaryLight,
                ),
        ),
      ],
    );
  }
}
