import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;

  ThemeProvider({required StorageService storageService})
      : _storageService = storageService {
    _init();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _init() {
    final isDark = _storageService.getIsDarkMode();
    if (isDark == null) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _storageService.setIsDarkMode(isDark);
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    _storageService.setIsDarkMode(null);
    notifyListeners();
  }
}
