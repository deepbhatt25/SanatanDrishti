import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/location_service.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../models/kundali_model.dart';
import '../providers/kundali_provider.dart';
import 'kundali_preview_screen.dart';
import 'saved_kundalis_screen.dart';

class CreateKundaliScreen extends StatefulWidget {
  const CreateKundaliScreen({super.key});

  @override
  State<CreateKundaliScreen> createState() => _CreateKundaliScreenState();
}

class _CreateKundaliScreenState extends State<CreateKundaliScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  Gender _selectedGender = Gender.male;
  DateTime _selectedDate = DateTime(1995, 8, 15);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30);
  CityLocation _selectedCity = LocationService.defaultCity;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final langProvider = context.read<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;
    final name = _nameController.text.trim();

    final profile = KundaliProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.isNotEmpty ? name : (isGujarati ? 'જાતક' : 'जातक'),
      gender: _selectedGender,
      dateOfBirth: _selectedDate,
      birthTimeHour: _selectedTime.hour,
      birthTimeMinute: _selectedTime.minute,
      cityName: _selectedCity.getLocalizedName(langProvider.currentLanguage),
      latitude: _selectedCity.latitude,
      longitude: _selectedCity.longitude,
      timezone: _selectedCity.timezone,
      createdAt: DateTime.now(),
    );

    final kundaliProvider = context.read<KundaliProvider>();
    final result = await kundaliProvider.generateKundali(profile);

    if (!mounted) return;

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KundaliPreviewScreen(kundali: result),
        ),
      );
    } else if (kundaliProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(kundaliProvider.errorMessage!),
          backgroundColor: AppColors.maroonDark,
        ),
      );
    }
  }

  void _openCitySearch() {
    final langProvider = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGujarati = langProvider.isGujarati;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String searchQuery = '';
        bool isSearchingOnline = false;
        List<CityLocation> onlineResults = [];
        Timer? debounceTimer;
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final query = searchQuery.trim().toLowerCase();
            final filteredPreset = LocationService.presetCities.where((c) {
              if (query.isEmpty) return true;
              return c.name.toLowerCase().contains(query) ||
                  c.nameHindi.toLowerCase().contains(query) ||
                  (c.nameGujarati?.toLowerCase().contains(query) ?? false);
            }).toList();

            final combinedCities = <CityLocation>[...filteredPreset];
            for (final online in onlineResults) {
              final alreadyExists = combinedCities.any((c) =>
                  c.name.toLowerCase() == online.name.toLowerCase() ||
                  ((c.latitude - online.latitude).abs() < 0.05 &&
                      (c.longitude - online.longitude).abs() < 0.05));
              if (!alreadyExists) {
                combinedCities.add(online);
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(120),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.selectCity(langProvider.currentLanguage),
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          debounceTimer?.cancel();
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: isGujarati
                          ? 'શહેર, ગામ અથવા તાલુકો શોધો (Search online)'
                          : 'शहर, गांव या कस्बा खोजें (Search online)',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.saffronPrimary),
                      suffixIcon: isSearchingOnline
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.saffronPrimary,
                                ),
                              ),
                            )
                          : (searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    debounceTimer?.cancel();
                                    searchController.clear();
                                    setSheetState(() {
                                      searchQuery = '';
                                      onlineResults = [];
                                      isSearchingOnline = false;
                                    });
                                  },
                                )
                              : null),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      debounceTimer?.cancel();
                      setSheetState(() {
                        searchQuery = val;
                        if (val.trim().length >= 2) {
                          isSearchingOnline = true;
                        } else {
                          isSearchingOnline = false;
                          onlineResults = [];
                        }
                      });

                      if (val.trim().length >= 2) {
                        debounceTimer = Timer(const Duration(milliseconds: 380), () async {
                          final results = await LocationService.searchCitiesOnline(val);
                          setSheetState(() {
                            onlineResults = results;
                            isSearchingOnline = false;
                          });
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: combinedCities.isEmpty && !isSearchingOnline
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off_rounded,
                                    size: 48,
                                    color: Colors.grey.withAlpha(120),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    isGujarati
                                        ? '"$searchQuery" માટે કોઈ સ્થાન મળ્યું નથી'
                                        : '"$searchQuery" के लिए कोई स्थान नहीं मिला',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 14),
                                  if (searchQuery.trim().isNotEmpty)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final customCity = CityLocation(
                                          name: searchQuery.trim(),
                                          nameHindi: searchQuery.trim(),
                                          nameGujarati: searchQuery.trim(),
                                          latitude: 23.0225,
                                          longitude: 72.5714,
                                          timezone: 5.5,
                                        );
                                        setState(() => _selectedCity = customCity);
                                        debounceTimer?.cancel();
                                        Navigator.pop(ctx);
                                      },
                                      icon: const Icon(Icons.add_location_alt_rounded, size: 16),
                                      label: Text(
                                        isGujarati
                                            ? '"$searchQuery" પસંદ કરો'
                                            : '"$searchQuery" चुनें',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.saffronPrimary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: combinedCities.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final city = combinedCities[index];
                              final isSelected = city.name.toLowerCase() == _selectedCity.name.toLowerCase();
                              final isFromOnline = !LocationService.presetCities.any((c) => c.name == city.name);

                              return ListTile(
                                leading: Icon(
                                  city.isSacred
                                      ? Icons.temple_hindu_rounded
                                      : (isFromOnline ? Icons.travel_explore_rounded : Icons.location_city_rounded),
                                  color: isSelected ? AppColors.saffronPrimary : (isFromOnline ? AppColors.gold : Colors.grey),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        city.getLocalizedName(langProvider.currentLanguage),
                                        style: GoogleFonts.outfit(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.saffronPrimary
                                              : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                        ),
                                      ),
                                    ),
                                    if (isFromOnline)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.saffronPrimary.withAlpha(25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Online',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.saffronPrimary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${city.name} (${city.latitude.toStringAsFixed(2)}°N, ${city.longitude.toStringAsFixed(2)}°E)',
                                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary)
                                    : null,
                                onTap: () {
                                  debounceTimer?.cancel();
                                  setState(() => _selectedCity = city);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final kundaliProvider = context.watch<KundaliProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomSpiritualAppBar(
        title: AppStrings.createKundali(currentLang),
        subtitle: AppStrings.createKundaliSubtitle(currentLang),
        showOm: false,
        showLanguageToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_shared_rounded, color: AppColors.goldLight),
            tooltip: AppStrings.savedKundalis(currentLang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedKundalisScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sacred Header Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.maroonGradient : AppColors.headerGradientLight,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.maroonPrimary.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withAlpha(45),
                        border: Border.all(color: AppColors.goldLight, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.goldLight,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGujarati ? 'વૈદિક જન્મ કુંડળી વિશ્લેષણ' : 'वैदिक जन्म कुंडली विश्लेषण',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isGujarati
                                ? 'લગ્ન ચક્ર, નવમાંશ, ૧૨ ભાવ અને વિંશોત્તરી દશા'
                                : 'लग्न चक्र, नवमांश, १२ भाव एवं विंशोत्तरी दशा',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.goldLight.withAlpha(220),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Form Section 1: Name & Gender
              _buildSectionCard(
                title: isGujarati ? '૧. વ્યક્તિગત વિગત' : '१. व्यक्तिगत विवरण',
                isDark: isDark,
                isGujarati: isGujarati,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.fullName(currentLang),
                      prefixIcon: const Icon(Icons.person_rounded, color: AppColors.saffronPrimary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return isGujarati ? 'કૃપા કરીને નામ દાખલ કરો' : 'कृपया नाम दर्ज करें';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        AppStrings.gender(currentLang),
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Spacer(),
                      SegmentedButton<Gender>(
                        segments: [
                          ButtonSegment(
                            value: Gender.male,
                            label: Text(isGujarati ? 'પુરુષ' : 'पुरुष'),
                            icon: const Icon(Icons.male_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: Gender.female,
                            label: Text(isGujarati ? 'સ્ત્રી' : 'स्त्री'),
                            icon: const Icon(Icons.female_rounded, size: 16),
                          ),
                        ],
                        selected: {_selectedGender},
                        onSelectionChanged: (val) {
                          setState(() => _selectedGender = val.first);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Form Section 2: Date & Time of Birth
              _buildSectionCard(
                title: isGujarati ? '૨. જન્મ તારીખ અને સમય' : '२. जन्म तिथि एवं समय',
                isDark: isDark,
                isGujarati: isGujarati,
                children: [
                  // Date Picker Tile
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    tileColor: isDark ? AppColors.surfaceDark : Colors.white,
                    leading: const Icon(Icons.calendar_month_rounded, color: AppColors.saffronPrimary),
                    title: Text(
                      AppStrings.dateOfBirthLabel(currentLang),
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMMM yyyy (EEEE)').format(_selectedDate),
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    trailing: const Icon(Icons.edit_calendar_rounded, color: AppColors.gold, size: 20),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  // Time Picker Tile
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    tileColor: isDark ? AppColors.surfaceDark : Colors.white,
                    leading: const Icon(Icons.access_time_rounded, color: AppColors.saffronPrimary),
                    title: Text(
                      AppStrings.birthTimeLabel(currentLang),
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                    ),
                    subtitle: Text(
                      _selectedTime.format(context),
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    trailing: const Icon(Icons.schedule_rounded, color: AppColors.gold, size: 20),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() => _selectedTime = picked);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Form Section 3: Birth Place
              _buildSectionCard(
                title: isGujarati ? '૩. જન્મ સ્થાન (શહેર)' : '३. जन्म स्थान (शहर)',
                isDark: isDark,
                isGujarati: isGujarati,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    tileColor: isDark ? AppColors.surfaceDark : Colors.white,
                    leading: const Icon(Icons.location_on_rounded, color: AppColors.saffronPrimary),
                    title: Text(
                      _selectedCity.getLocalizedName(currentLang),
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    subtitle: Text(
                      '${_selectedCity.name} (${_selectedCity.latitude.toStringAsFixed(2)}°N, ${_selectedCity.longitude.toStringAsFixed(2)}°E)',
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.saffronPrimary.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isGujarati ? 'બદલો' : 'बदलें',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffronPrimary,
                        ),
                      ),
                    ),
                    onTap: _openCitySearch,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Generate Button
              ElevatedButton(
                onPressed: kundaliProvider.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.saffronPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: AppColors.saffronPrimary.withAlpha(90),
                ),
                child: kundaliProvider.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.generateKundaliBtn(currentLang),
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required bool isDark,
    required bool isGujarati,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            title,
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  )
                : GoogleFonts.notoSerifDevanagari(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                  ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
