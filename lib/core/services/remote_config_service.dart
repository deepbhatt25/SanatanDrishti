import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../config/ad_config.dart';

/// Service for initializing and syncing Firebase Remote Config.
class RemoteConfigService {
  static final RemoteConfigService instance = RemoteConfigService._internal();

  RemoteConfigService._internal();

  FirebaseRemoteConfig? _remoteConfig;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initializes Firebase and Remote Config with defaults and fetches latest values
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Ensure Firebase Core is initialized
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('RemoteConfigService: Firebase.initializeApp notice: $e');
      }

      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // Set default parameters
      await _remoteConfig!.setDefaults({
        'isAdsVisible': true,
        'ads_config': AdConfig.defaultRemoteConfigJson,
      });

      // Initial apply from current values (cache/defaults)
      _applyConfig();

      // Fetch and activate latest values from server
      final bool updated = await _remoteConfig!.fetchAndActivate();
      if (updated) {
        debugPrint('RemoteConfigService: Remote config updated and activated.');
      }
      _applyConfig();

      // Listen for real-time config updates (Firebase Remote Config Realtime)
      _remoteConfig!.onConfigUpdated.listen((RemoteConfigUpdate event) async {
        debugPrint('RemoteConfigService: Realtime config update received with keys: ${event.updatedKeys}');
        await _remoteConfig!.activate();
        _applyConfig();
      }, onError: (error) {
        debugPrint('RemoteConfigService: Realtime update error: $error');
      });

      _isInitialized = true;
      debugPrint('RemoteConfigService: Initialized successfully.');
    } catch (e) {
      debugPrint('RemoteConfigService: Initialization fallback error: $e');
      // AdConfig already has safe fallback defaults
    }
  }

  /// Extracts parameters from RemoteConfig and passes them to AdConfig
  void _applyConfig() {
    if (_remoteConfig == null) return;

    try {
      final String rawAdsConfig = _remoteConfig!.getString('ads_config');
      final bool remoteIsAdsVisible = _remoteConfig!.getBool('isAdsVisible');

      AdConfig.updateFromRemoteConfig(
        adsConfigRawJson: rawAdsConfig.isNotEmpty ? rawAdsConfig : null,
        remoteIsAdsVisible: remoteIsAdsVisible,
      );
    } catch (e) {
      debugPrint('RemoteConfigService: Error applying config: $e');
    }
  }
}
