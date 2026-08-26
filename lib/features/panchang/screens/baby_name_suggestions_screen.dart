import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../data/baby_names_database.dart';

class BabyNameSuggestionsScreen extends StatefulWidget {
  final int initialRashiIndex;

  const BabyNameSuggestionsScreen({
    super.key,
    this.initialRashiIndex = 9, // default to Capricorn / selected
  });

  @override
  State<BabyNameSuggestionsScreen> createState() => _BabyNameSuggestionsScreenState();
}

class _BabyNameSuggestionsScreenState extends State<BabyNameSuggestionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedRashiIndex;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<BabyNameItem> _savedFavorites = [];
  static const String _prefFavJsonListKey = 'saved_fav_baby_names_json_v2';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedRashiIndex = widget.initialRashiIndex;
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_prefFavJsonListKey) ?? [];
      final List<BabyNameItem> loaded = [];
      for (final str in jsonList) {
        try {
          final Map<String, dynamic> map = jsonDecode(str);
          loaded.add(BabyNameItem(
            gujarati: map['gu'] ?? '',
            hindi: map['hi'] ?? '',
            english: map['en'] ?? '',
            meaningGu: map['mGu'] ?? '',
            meaningHi: map['mHi'] ?? '',
            meaningEn: map['mEn'] ?? '',
            rashiIndex: map['rIdx'] ?? 0,
            startingLetter: map['letter'] ?? '',
            isBoy: map['isBoy'] ?? true,
          ));
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _savedFavorites.clear();
          _savedFavorites.addAll(loaded);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveFavoritesToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _savedFavorites.map((item) {
        return jsonEncode({
          'gu': item.gujarati,
          'hi': item.hindi,
          'en': item.english,
          'mGu': item.meaningGu,
          'mHi': item.meaningHi,
          'mEn': item.meaningEn,
          'rIdx': item.rashiIndex,
          'letter': item.startingLetter,
          'isBoy': item.isBoy,
        });
      }).toList();
      await prefs.setStringList(_prefFavJsonListKey, jsonList);
    } catch (_) {}
  }

  bool _isItemFavorited(BabyNameItem item) {
    return _savedFavorites.any((f) =>
        f.english.toLowerCase() == item.english.toLowerCase() &&
        f.isBoy == item.isBoy &&
        f.rashiIndex == item.rashiIndex);
  }

  Future<void> _toggleFavorite(BabyNameItem item) async {
    setState(() {
      final existingIndex = _savedFavorites.indexWhere((f) =>
          f.english.toLowerCase() == item.english.toLowerCase() &&
          f.isBoy == item.isBoy &&
          f.rashiIndex == item.rashiIndex);

      if (existingIndex >= 0) {
        _savedFavorites.removeAt(existingIndex);
      } else {
        _savedFavorites.add(item);
      }
    });
    await _saveFavoritesToDisk();
  }

  void _showSavedFavoritesSheet(BuildContext context, bool isDark, bool isGujarati) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDark : AppColors.bgLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Sheet Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              isGujarati ? 'પસંદ કરેલા નામો (Saved Names)' : 'पसंदीदा नाम (Saved Names)',
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    )
                                  : GoogleFonts.notoSerifDevanagari(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                    ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // List of saved names
                  Expanded(
                    child: _savedFavorites.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite_border_rounded,
                                    size: 54,
                                    color: isDark ? Colors.white24 : Colors.black26,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    isGujarati ? 'કોઈ નામ સેવ કરેલ નથી' : 'कोई नाम सहेजा नहीं गया',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white60 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isGujarati
                                        ? 'નામ સેવ કરવા માટે લિસ્ટમાંથી ફેવરિટ આઈકન પર ટૅપ કરો'
                                        : 'नाम सहेजने के लिए सूची से पसंदीदा आइकन पर टैप करें',
                                    style: isGujarati
                                        ? GoogleFonts.notoSerifGujarati(fontSize: 11.5, color: isDark ? Colors.white38 : Colors.black38)
                                        : GoogleFonts.notoSerifDevanagari(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            itemCount: _savedFavorites.length,
                            itemBuilder: (context, idx) {
                              final item = _savedFavorites[idx];
                              final nameStr = isGujarati ? item.gujarati : item.hindi;
                              final meaningStr = isGujarati ? item.meaningGu : item.meaningHi;
                              final rashiName = isGujarati
                                  ? BabyNamesDatabase.rashiNamesGu[item.rashiIndex].split(' ')[0]
                                  : BabyNamesDatabase.rashiNamesHi[item.rashiIndex].split(' ')[0];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        gradient: item.isBoy ? AppColors.maroonGradient : AppColors.saffronGradient,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          item.gujarati.isNotEmpty ? item.gujarati.substring(0, 1) : '',
                                          style: GoogleFonts.notoSerifGujarati(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                nameStr,
                                                style: isGujarati
                                                    ? GoogleFonts.notoSerifGujarati(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                                      )
                                                    : GoogleFonts.notoSerifDevanagari(
                                                        fontSize: 15.5,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                                      ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '(${item.english})',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11,
                                                  color: isDark ? Colors.white60 : Colors.black54,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                                decoration: BoxDecoration(
                                                  color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  rashiName,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.saffronPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            meaningStr,
                                            style: isGujarati
                                                ? GoogleFonts.notoSerifGujarati(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)
                                                : GoogleFonts.notoSerifDevanagari(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.saffronPrimary),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: '$nameStr (${item.english}) - $meaningStr'));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(isGujarati ? '$nameStr કૉપી થયું!' : '$nameStr कॉपी हुआ!'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 19, color: Colors.redAccent),
                                      onPressed: () async {
                                        await _toggleFavorite(item);
                                        setSheetState(() {});
                                      },
                                    ),
                                  ],
                                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    final boyNames = BabyNamesDatabase.getNamesForRashi(
      rashiIndex: _selectedRashiIndex,
      isBoy: true,
      searchQuery: _searchQuery,
    );

    final girlNames = BabyNamesDatabase.getNamesForRashi(
      rashiIndex: _selectedRashiIndex,
      isBoy: false,
      searchQuery: _searchQuery,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(106),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.maroonGradient : AppColors.saffronGradient,
            ),
          ),
          title: Text(
            isGujarati ? 'બાળકના શુભ નામો' : 'शिशु नामकरण',
            style: isGujarati
                ? GoogleFonts.notoSerifGujarati(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                : GoogleFonts.notoSerifDevanagari(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 2,
          actions: [
            // Saved Favorite Names Icon in AppBar with Badge
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.white, size: 24),
                  tooltip: isGujarati ? 'પસંદ કરેલા નામો' : 'सहेजे गए नाम',
                  onPressed: () => _showSavedFavoritesSheet(context, isDark, isGujarati),
                ),
                if (_savedFavorites.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_savedFavorites.length}',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 6),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.goldLight,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: const Icon(Icons.face_rounded, size: 20),
                text: isGujarati ? 'બાળક' : 'बालक',
              ),
              Tab(
                icon: const Icon(Icons.face_3_rounded, size: 20),
                text: isGujarati ? 'બાળકી' : 'बालिका',
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Rashi Selector & Search Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 40 : 15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Rashi Dropdown Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedRashiIndex,
                      isExpanded: true,
                      dropdownColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.saffronPrimary),
                      items: List.generate(12, (index) {
                        final rashiText = isGujarati
                            ? BabyNamesDatabase.rashiNamesGu[index]
                            : BabyNamesDatabase.rashiNamesHi[index];
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text(
                            rashiText,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  ),
                          ),
                        );
                      }),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedRashiIndex = val;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: isGujarati ? 'નામ અથવા અર્થ શોધો...' : 'नाम या अर्थ खोजें...',
                    hintStyle: GoogleFonts.outfit(fontSize: 12.5, color: isDark ? Colors.white38 : Colors.black38),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.saffronPrimary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : AppColors.bgLight,
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
                  ),
                ),
              ],
            ),
          ),

          // Name List Views for Boy & Girl Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNamesList(boyNames, isBoy: true, isDark: isDark, isGujarati: isGujarati),
                _buildNamesList(girlNames, isBoy: false, isDark: isDark, isGujarati: isGujarati),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesList(
    List<BabyNameItem> names, {
    required bool isBoy,
    required bool isDark,
    required bool isGujarati,
  }) {
    if (names.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isBoy ? Icons.face_rounded : Icons.face_3_rounded,
                size: 48,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
              const SizedBox(height: 12),
              Text(
                isGujarati ? 'કોઈ નામ મળ્યું નથી' : 'कोई नाम नहीं मिला',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: names.length,
      itemBuilder: (context, index) {
        final item = names[index];
        final nameStr = isGujarati ? item.gujarati : item.hindi;
        final meaningStr = isGujarati ? item.meaningGu : item.meaningHi;
        final isFav = _isItemFavorited(item);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 8),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Initial Badge Circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: isBoy ? AppColors.maroonGradient : AppColors.saffronGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.gujarati.isNotEmpty ? item.gujarati.substring(0, 1) : '',
                    style: GoogleFonts.notoSerifGujarati(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name & Meaning
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            nameStr,
                            style: isGujarati
                                ? GoogleFonts.notoSerifGujarati(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  )
                                : GoogleFonts.notoSerifDevanagari(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.english,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isGujarati ? 'અર્થ:' : 'अर्थ:'} $meaningStr (${item.meaningEn})',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 11.5,
                              color: isDark ? Colors.white70 : Colors.black87,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                    ),
                  ],
                ),
              ),

              // Action Buttons: Copy & Favorite
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.redAccent : (isDark ? Colors.white38 : Colors.black38),
                      size: 22,
                    ),
                    onPressed: () => _toggleFavorite(item),
                    tooltip: isGujarati ? 'પસંદીદા' : 'पसंदीदा',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      color: isDark ? AppColors.goldLight : AppColors.saffronPrimary,
                      size: 20,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '$nameStr (${item.english}) - $meaningStr'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isGujarati ? '$nameStr કૉપી થયું!' : '$nameStr कॉपी हुआ!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: isGujarati ? 'કૉપી કરો' : 'कॉपी करें',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
