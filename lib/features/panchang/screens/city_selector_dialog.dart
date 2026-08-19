import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/services/location_service.dart';
import '../providers/panchang_provider.dart';

class CitySelectorDialog extends StatefulWidget {
  const CitySelectorDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CitySelectorDialog(),
    );
  }

  @override
  State<CitySelectorDialog> createState() => _CitySelectorDialogState();
}

class _CitySelectorDialogState extends State<CitySelectorDialog> {
  String _searchQuery = '';
  bool _isDetecting = false;
  bool _isSearchingOnline = false;
  List<CityLocation> _onlineResults = [];
  Timer? _debounceTimer;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    setState(() {
      _searchQuery = val;
      if (val.trim().length >= 2) {
        _isSearchingOnline = true;
      } else {
        _isSearchingOnline = false;
        _onlineResults = [];
      }
    });

    if (val.trim().length >= 2) {
      _debounceTimer = Timer(const Duration(milliseconds: 380), () async {
        final results = await LocationService.searchCitiesOnline(val);
        if (mounted) {
          setState(() {
            _onlineResults = results;
            _isSearchingOnline = false;
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final panchangProvider = context.watch<PanchangProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLanguage;
    final isGujarati = langProvider.isGujarati;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCity = panchangProvider.selectedCity;

    final query = _searchQuery.trim().toLowerCase();
    final allCities = LocationService.presetCities.where((c) {
      if (query.isEmpty) return true;
      return c.name.toLowerCase().contains(query) ||
          c.nameHindi.toLowerCase().contains(query) ||
          (c.nameGujarati?.toLowerCase().contains(query) ?? false);
    }).toList();

    final sacredCities = allCities.where((c) => c.isSacred).toList();
    final otherCities = allCities.where((c) => !c.isSacred).toList();

    final onlineUniqueResults = _onlineResults.where((online) {
      return !allCities.any((c) =>
          c.name.toLowerCase() == online.name.toLowerCase() ||
          ((c.latitude - online.latitude).abs() < 0.05 &&
              (c.longitude - online.longitude).abs() < 0.05));
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.selectCity(currentLang),
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
                    Text(
                      'SELECT LOCATION & CITY',
                      style: GoogleFonts.cinzel(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Use GPS Location Button
            InkWell(
              onTap: _isDetecting
                  ? null
                  : () async {
                      final navigator = Navigator.of(context);
                      setState(() => _isDetecting = true);
                      await panchangProvider.detectLocation();
                      if (mounted) {
                        navigator.pop();
                      }
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: AppColors.saffronGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.saffronPrimary.withAlpha(80),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _isDetecting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.my_location_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isDetecting
                                ? (isGujarati ? 'ચોક્કસ સ્થાન શોધી રહ્યા છીએ...' : 'Detecting Precise Location...')
                                : (isGujarati ? 'હાલનું GPS સ્થાન વાપરો' : 'Use Current GPS Location'),
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )
                                : GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                          ),
                          Text(
                            _isDetecting
                                ? (isGujarati ? 'શહેર અને સૂર્યોદય સમય ગણી રહ્યા છીએ...' : 'Extracting city & calculating sunrise...')
                                : (isGujarati ? 'ઓટો-ડિટેક્ટ અક્ષાંશ-રેખાંશ અને સૂર્યોદય સમય' : 'Auto-detect exact city coordinates & solar timings'),
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 10.5,
                                    color: Colors.white.withAlpha(220),
                                  )
                                : GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: Colors.white.withAlpha(220),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Search Box
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    )
                  : GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
              decoration: InputDecoration(
                hintText: isGujarati
                    ? 'શહેર, ગામ અથવા તાલુકો શોધો (Online Search)...'
                    : 'शहर, गांव या कस्बा खोजें (Online Search)...',
                hintStyle: isGujarati
                    ? GoogleFonts.notoSerifGujarati(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      )
                    : GoogleFonts.notoSerifDevanagari(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.saffronPrimary),
                suffixIcon: _isSearchingOnline
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
                    : (_searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _debounceTimer?.cancel();
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _onlineResults = [];
                                _isSearchingOnline = false;
                              });
                            },
                          )
                        : null),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.bgLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.saffronPrimary),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: allCities.isEmpty && onlineUniqueResults.isEmpty && !_isSearchingOnline
                  ? Center(
                      child: Text(
                        isGujarati ? 'કોઈ સ્થાન મળ્યું નથી / No city found' : 'कोई स्थान नहीं मिला / No city found',
                        style: isGujarati
                            ? GoogleFonts.notoSerifGujarati(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              )
                            : GoogleFonts.notoSerifDevanagari(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                      ),
                    )
                  : ListView(
                      children: [
                        // Online Search Results
                        if (onlineUniqueResults.isNotEmpty) ...[
                          Text(
                            isGujarati ? 'ઓનલાઇન શોધ પરિણામો (Online Results)' : 'ऑनलाइन खोज परिणाम (Online Results)',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.saffronPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.saffronPrimary,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          ...onlineUniqueResults.map((city) => _buildCityTile(context, city, currentCity, panchangProvider, isDark, isGujarati, currentLang, isOnline: true)),
                          const SizedBox(height: 14),
                        ],

                        // Sacred Pilgrimage Cities
                        if (sacredCities.isNotEmpty) ...[
                          Text(
                            isGujarati ? 'તીર્થ અને પાવન ક્ષેત્રો (Sacred Cities)' : 'तीर्थ एवं पावन क्षेत्र (Sacred Cities)',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          ...sacredCities.map((city) => _buildCityTile(context, city, currentCity, panchangProvider, isDark, isGujarati, currentLang)),
                          const SizedBox(height: 14),
                        ],

                        // Major Metros & Cities
                        if (otherCities.isNotEmpty) ...[
                          Text(
                            isGujarati ? 'મુખ્ય નગરો (Major Cities)' : 'प्रमुख नगर (Major Cities)',
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          ...otherCities.map((city) => _buildCityTile(context, city, currentCity, panchangProvider, isDark, isGujarati, currentLang)),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityTile(
    BuildContext context,
    CityLocation city,
    CityLocation currentCity,
    PanchangProvider provider,
    bool isDark,
    bool isGujarati,
    AppLanguage currentLang, {
    bool isOnline = false,
  }) {

    final isSelected = currentCity.name.toLowerCase() == city.name.toLowerCase() ||
        currentCity.nameHindi == city.nameHindi;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.saffronDark.withAlpha(70) : AppColors.saffronPale)
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.saffronPrimary
              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          city.isSacred
              ? Icons.temple_hindu_rounded
              : (isOnline ? Icons.travel_explore_rounded : Icons.location_city_rounded),
          color: isSelected
              ? AppColors.saffronPrimary
              : (isOnline ? AppColors.gold : (isDark ? AppColors.goldLight : AppColors.maroonPrimary)),
          size: 20,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                city.getLocalizedName(currentLang),
                style: isGujarati
                    ? GoogleFonts.notoSerifGujarati(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      )
                    : GoogleFonts.notoSerifDevanagari(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
              ),
            ),
            if (isOnline)
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
          style: GoogleFonts.outfit(fontSize: 11),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: AppColors.saffronPrimary, size: 20)
            : null,
        onTap: () {
          provider.setCity(city);
          Navigator.pop(context);
        },
      ),
    );
  }
}

