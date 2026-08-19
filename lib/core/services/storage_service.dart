import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/kundali/models/kundali_model.dart';

class StorageService {
  static const String _boxVerses = 'verses_cache_box';
  static const String _boxPanchang = 'panchang_cache_box';
  static const String _boxRashi = 'rashi_cache_box';
  static const String _boxKundali = 'kundali_saved_box';

  // SharedPreferences Keys
  static const String keyBookmarks = 'geeta_bookmarks';
  static const String keyLastChapter = 'geeta_last_chapter';
  static const String keyLastVerse = 'geeta_last_verse';
  static const String keyDefaultRashi = 'rashi_default_id';
  static const String keyPreferredCommentator = 'geeta_preferred_commentator';
  static const String keyFontSizeScale = 'app_font_size_scale';
  static const String keyIsDarkMode = 'app_is_dark_mode';
  static const String keyTtsSpeed = 'tts_speech_rate';
  static const String keyTtsAutoAdvance = 'tts_auto_advance';
  static const String keySelectedCity = 'panchang_selected_city';
  static const String keyAppLanguage = 'app_selected_language';
  static const String keySavedKundalis = 'kundali_saved_profiles_list';

  late Box _versesBox;
  late Box _panchangBox;
  late Box _rashiBox;
  late Box _kundaliBox;
  late SharedPreferences _prefs;
  bool _isTestMode = false;

  Future<void> init() async {
    await Hive.initFlutter();
    _versesBox = await Hive.openBox(_boxVerses);
    _panchangBox = await Hive.openBox(_boxPanchang);
    _rashiBox = await Hive.openBox(_boxRashi);
    _kundaliBox = await Hive.openBox(_boxKundali);
    _prefs = await SharedPreferences.getInstance();
  }

  void initForTesting(SharedPreferences prefs) {
    _prefs = prefs;
    _isTestMode = true;
  }

  // --- Verses Hive Cache ---
  Future<void> cacheVerse(int chapter, int verse, Map<String, dynamic> data) async {
    if (_isTestMode) return;
    final key = '${chapter}_$verse';
    await _versesBox.put(key, jsonEncode(data));
  }

  Map<String, dynamic>? getCachedVerse(int chapter, int verse) {
    if (_isTestMode) return null;
    final key = '${chapter}_$verse';
    final raw = _versesBox.get(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // --- Panchang Hive Cache ---
  Future<void> cachePanchang(String dateKey, Map<String, dynamic> data) async {
    if (_isTestMode) return;
    await _panchangBox.put(dateKey, jsonEncode(data));
  }

  Map<String, dynamic>? getCachedPanchang(String dateKey) {
    if (_isTestMode) return null;
    final raw = _panchangBox.get(dateKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // --- Rashi Hive Cache ---
  Future<void> cacheRashiReading(String rashiParam, String dateKey, Map<String, dynamic> data) async {
    if (_isTestMode) return;
    final key = '${rashiParam}_$dateKey';
    await _rashiBox.put(key, jsonEncode(data));
  }

  Map<String, dynamic>? getCachedRashiReading(String rashiParam, String dateKey) {
    if (_isTestMode) return null;
    final key = '${rashiParam}_$dateKey';
    final raw = _rashiBox.get(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw as String) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // --- Saved Kundalis Storage ---
  Future<void> saveKundaliResult(KundaliResult result) async {
    final id = result.profile.id;
    final jsonStr = jsonEncode(result.toJson());

    if (!_isTestMode) {
      await _kundaliBox.put(id, jsonStr);
    }

    final idList = getSavedKundaliIds();
    if (!idList.contains(id)) {
      idList.insert(0, id);
      await _prefs.setStringList(keySavedKundalis, idList);
    }
    await _prefs.setString('kundali_data_$id', jsonStr);
  }

  List<String> getSavedKundaliIds() {
    return _prefs.getStringList(keySavedKundalis) ?? [];
  }

  List<KundaliResult> getSavedKundalis() {
    final ids = getSavedKundaliIds();
    final results = <KundaliResult>[];
    for (final id in ids) {
      String? raw;
      if (!_isTestMode && _kundaliBox.isOpen) {
        raw = _kundaliBox.get(id) as String?;
      }
      raw ??= _prefs.getString('kundali_data_$id');

      if (raw != null) {
        try {
          final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
          results.add(KundaliResult.fromJson(jsonMap));
        } catch (_) {}
      }
    }
    return results;
  }

  KundaliResult? getKundaliById(String id) {
    String? raw;
    if (!_isTestMode && _kundaliBox.isOpen) {
      raw = _kundaliBox.get(id) as String?;
    }
    raw ??= _prefs.getString('kundali_data_$id');

    if (raw == null) return null;
    try {
      final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
      return KundaliResult.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteKundali(String id) async {
    if (!_isTestMode && _kundaliBox.isOpen) {
      await _kundaliBox.delete(id);
    }
    final list = getSavedKundaliIds();
    list.remove(id);
    await _prefs.setStringList(keySavedKundalis, list);
    await _prefs.remove('kundali_data_$id');
  }

  // --- Bookmarks (SharedPreferences) ---
  List<String> getBookmarks() {
    return _prefs.getStringList(keyBookmarks) ?? [];
  }

  Future<void> toggleBookmark(int chapter, int verse) async {
    final id = '${chapter}_$verse';
    final list = getBookmarks();
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await _prefs.setStringList(keyBookmarks, list);
  }

  bool isBookmarked(int chapter, int verse) {
    final id = '${chapter}_$verse';
    return getBookmarks().contains(id);
  }

  // --- Last Position ---
  int getLastChapter() => _prefs.getInt(keyLastChapter) ?? 1;
  int getLastVerse() => _prefs.getInt(keyLastVerse) ?? 1;

  Future<void> saveLastRead(int chapter, int verse) async {
    await _prefs.setInt(keyLastChapter, chapter);
    await _prefs.setInt(keyLastVerse, verse);
  }

  // --- Pinned Default Rashi ---
  int getDefaultRashiId() => _prefs.getInt(keyDefaultRashi) ?? 1;
  Future<void> setDefaultRashiId(int id) async => await _prefs.setInt(keyDefaultRashi, id);

  // --- Preferred Commentator ---
  String getPreferredCommentator() => _prefs.getString(keyPreferredCommentator) ?? 'tej';
  Future<void> setPreferredCommentator(String commentatorKey) async =>
      await _prefs.setString(keyPreferredCommentator, commentatorKey);

  // --- Settings (Theme, Font Scale, TTS) ---
  double getFontScale() => _prefs.getDouble(keyFontSizeScale) ?? 1.0;
  Future<void> setFontScale(double scale) async => await _prefs.setDouble(keyFontSizeScale, scale);

  bool? getIsDarkMode() {
    if (!_prefs.containsKey(keyIsDarkMode)) return null; // Follow system by default
    return _prefs.getBool(keyIsDarkMode);
  }

  Future<void> setIsDarkMode(bool? isDark) async {
    if (isDark == null) {
      await _prefs.remove(keyIsDarkMode);
    } else {
      await _prefs.setBool(keyIsDarkMode, isDark);
    }
  }

  double getTtsSpeed() => _prefs.getDouble(keyTtsSpeed) ?? 0.5;
  Future<void> setTtsSpeed(double speed) async => await _prefs.setDouble(keyTtsSpeed, speed);

  bool getTtsAutoAdvance() => _prefs.getBool(keyTtsAutoAdvance) ?? false;
  Future<void> setTtsAutoAdvance(bool val) async => await _prefs.setBool(keyTtsAutoAdvance, val);

  String getSelectedCity() => _prefs.getString(keySelectedCity) ?? 'New Delhi';
  Future<void> setSelectedCity(String cityName) async =>
      await _prefs.setString(keySelectedCity, cityName);

  String getAppLanguage() => _prefs.getString(keyAppLanguage) ?? 'hi';
  Future<void> setAppLanguage(String langCode) async =>
      await _prefs.setString(keyAppLanguage, langCode);
}
