import 'package:flutter/material.dart';
import '../services/storage_service.dart';

enum AppLanguage {
  hindi(code: 'hi', label: 'हिन्दी', shortLabel: 'हिं'),
  gujarati(code: 'gu', label: 'ગુજરાતી', shortLabel: 'ગુજ');

  final String code;
  final String label;
  final String shortLabel;

  const AppLanguage({
    required this.code,
    required this.label,
    required this.shortLabel,
  });

  static AppLanguage fromCode(String code) {
    if (code.toLowerCase().startsWith('gu')) {
      return AppLanguage.gujarati;
    }
    return AppLanguage.hindi;
  }
}

class LanguageProvider extends ChangeNotifier {
  final StorageService _storageService;

  late AppLanguage _currentLanguage;
  AppLanguage get currentLanguage => _currentLanguage;

  bool get isGujarati => _currentLanguage == AppLanguage.gujarati;
  bool get isHindi => _currentLanguage == AppLanguage.hindi;
  String get languageCode => _currentLanguage.code;

  LanguageProvider({required StorageService storageService})
      : _storageService = storageService {
    final savedCode = _storageService.getAppLanguage();
    _currentLanguage = AppLanguage.fromCode(savedCode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    await _storageService.setAppLanguage(language.code);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    if (_currentLanguage == AppLanguage.hindi) {
      await setLanguage(AppLanguage.gujarati);
    } else {
      await setLanguage(AppLanguage.hindi);
    }
  }

  /// Converts standard integer to localized digits (Gujarati: ૧, ૨, ૩ vs Hindi: १, २, ३)
  String formatNumber(int number) {
    final str = number.toString();
    if (isGujarati) {
      const guDigits = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
      return str.split('').map((char) {
        final d = int.tryParse(char);
        return d != null ? guDigits[d] : char;
      }).join('');
    } else {
      const hiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
      return str.split('').map((char) {
        final d = int.tryParse(char);
        return d != null ? hiDigits[d] : char;
      }).join('');
    }
  }
}
