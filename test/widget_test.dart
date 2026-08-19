import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhagvat_geeta_app/core/providers/language_provider.dart';
import 'package:bhagvat_geeta_app/core/services/storage_service.dart';
import 'package:bhagvat_geeta_app/core/theme/app_theme.dart';
import 'package:bhagvat_geeta_app/features/shell/widgets/spiritual_bottom_nav.dart';
import 'package:bhagvat_geeta_app/features/splash/screens/spiritual_splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService();
    storageService.initForTesting(prefs);
  });

  testWidgets('SpiritualBottomNavBar renders all 3 tabs with Geeta center elevated', (WidgetTester tester) async {
    int selectedIndex = 1;

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LanguageProvider(storageService: storageService),
        child: MaterialApp(
          theme: AppTheme.lightTheme(),
          home: Scaffold(
            bottomNavigationBar: SpiritualBottomNavBar(
              currentIndex: selectedIndex,
              onTabSelected: (idx) => selectedIndex = idx,
            ),
          ),
        ),
      ),
    );

    // Verify all 3 tabs are present in Hindi by default
    expect(find.text('पञ्चाङ्ग'), findsOneWidget);
    expect(find.text('Panchang'), findsOneWidget);

    expect(find.text('गीता'), findsOneWidget);
    expect(find.text('Geeta'), findsOneWidget);

    expect(find.text('राशि'), findsOneWidget);
    expect(find.text('Rashi'), findsOneWidget);
  });

  testWidgets('SpiritualSplashScreen renders sacred Om and title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme(),
        home: const SpiritualSplashScreen(),
      ),
    );

    // Initial frame check
    expect(find.text('ॐ'), findsOneWidget);
    expect(find.text('॥ श्रीमद्भगवद्गीता ॥'), findsOneWidget);
    expect(find.text('॥ ॐ नमो भगवते वासुदेवाय ॥'), findsOneWidget);
    expect(find.text('॥ यतो धर्मस्ततो जयः ॥'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('SHREEMAD BHAGAVAD GITA'), findsOneWidget);
  });
}
