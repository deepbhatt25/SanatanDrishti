import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/config/api_config.dart';
import 'core/network/api_client.dart';
import 'core/providers/language_provider.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/location_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/tts_service.dart';
import 'core/theme/app_theme.dart';
import 'features/geeta/providers/geeta_provider.dart';
import 'features/geeta/repositories/geeta_repository.dart';
import 'features/panchang/providers/panchang_provider.dart';
import 'features/panchang/repositories/panchang_repository.dart';
import 'features/rashi/providers/rashi_provider.dart';
import 'features/rashi/repositories/rashi_repository.dart';
import 'features/settings/providers/theme_provider.dart';
import 'features/splash/screens/spiritual_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Config & Services
  await ApiConfig.initialize();

  final storageService = StorageService();
  await storageService.init();

  final apiClient = ApiClient();

  final ttsService = TtsService();
  await ttsService.init(initialRate: storageService.getTtsSpeed());

  final locationService = LocationService();

  final connectivityService = ConnectivityService();
  await connectivityService.init();

  // Initialize Repositories
  final geetaRepository = GeetaRepository(
    apiClient: apiClient,
    storageService: storageService,
  );

  final panchangRepository = PanchangRepository(
    apiClient: apiClient,
    storageService: storageService,
  );

  final rashiRepository = RashiRepository(
    apiClient: apiClient,
    storageService: storageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(storageService: storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService: storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => GeetaProvider(
            repository: geetaRepository,
            storageService: storageService,
            ttsService: ttsService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PanchangProvider(
            repository: panchangRepository,
            storageService: storageService,
            locationService: locationService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RashiProvider(
            repository: rashiRepository,
            storageService: storageService,
          ),
        ),
      ],
      child: const BhagvatGeetaApp(),
    ),
  );
}

class BhagvatGeetaApp extends StatelessWidget {
  const BhagvatGeetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: '॥ श्रीमद्भगवद्गीता ॥ • पञ्चाङ्ग • राशि',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeProvider.themeMode,
      home: const SpiritualSplashScreen(),
    );
  }
}
