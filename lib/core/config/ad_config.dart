import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Centralized configuration for AdMob Ads in SanatanDrishti with
/// dynamic Firebase Remote Config synchronization.
class AdConfig {
  /// Toggle to switch between Test Ad Units and Production Ad Units.
  /// Set to `false` when building for production release.
  static const bool useTestAds = false;

  /// AdMob Android App ID
  static const String androidAppId = 'ca-app-pub-7315215850217970~7676438284';

  /// AdMob iOS App ID
  static const String iosAppId = 'ca-app-pub-7315215850217970~3891487976';

  /// Platform-specific App ID
  static String get appId => Platform.isIOS ? iosAppId : androidAppId;

  // ---------------------------------------------------------------------------
  // Global & Individual Ad Toggles (Controlled by Remote Config)
  // ---------------------------------------------------------------------------

  /// Master switch for all ads across the entire app.
  /// If `false`, NO ads are loaded or displayed anywhere in the app.
  static bool isAdsVisible = true;

  /// Reactive notifier that triggers UI updates whenever ad visibility settings change
  static final ValueNotifier<bool> adsVisibilityNotifier = ValueNotifier<bool>(isAdsVisible);

  /// Individual ad format switches
  static bool isAppOpenEnabled = true;
  static bool isNativeCardEnabled = true;
  static bool isBannerEnabled = true;
  static bool isInterstitialEnabled = true;
  static bool isRewardedEnabled = true;
  static bool isRewardedInterstitialEnabled = true;

  // ---------------------------------------------------------------------------
  // Active Dynamic Ad Unit IDs (Android)
  // ---------------------------------------------------------------------------
  static String _androidAppOpen = 'ca-app-pub-7315215850217970/2176699592';
  static String _androidNative = 'ca-app-pub-7315215850217970/6115944604';
  static String _androidBanner = 'ca-app-pub-7315215850217970/8490826501';
  static String _androidInterstitial = 'ca-app-pub-7315215850217970/4168438119';
  static String _androidRewarded = 'ca-app-pub-7315215850217970/7074532008';
  static String _androidRewardedInterstitial = 'ca-app-pub-7315215850217970/3462590054';

  // ---------------------------------------------------------------------------
  // Active Dynamic Ad Unit IDs (iOS)
  // ---------------------------------------------------------------------------
  static String _iosAppOpen = 'ca-app-pub-7315215850217970/5012997955';
  static String _iosNative = 'ca-app-pub-7315215850217970/1014043195';
  static String _iosBanner = 'ca-app-pub-7315215850217970/1265324632';
  static String _iosInterstitial = 'ca-app-pub-7315215850217970/7639161294';
  static String _iosRewarded = 'ca-app-pub-7315215850217970/8453549514';
  static String _iosRewardedInterstitial = 'ca-app-pub-7315215850217970/2079712852';

  // ---------------------------------------------------------------------------
  // Google Official Test Ad Unit IDs
  // ---------------------------------------------------------------------------
  static const String _testAndroidAppOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testAndroidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testAndroidNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testAndroidRewardedInterstitial = 'ca-app-pub-3940256099942544/5354046379';
  static const String _testAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  static const String _testIosAppOpen = 'ca-app-pub-3940256099942544/5575463023';
  static const String _testIosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testIosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testIosNative = 'ca-app-pub-3940256099942544/3986624511';
  static const String _testIosRewardedInterstitial = 'ca-app-pub-3940256099942544/6978759866';
  static const String _testIosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  /// Whether test ads should be served
  static bool get isTestMode => useTestAds;

  // ---------------------------------------------------------------------------
  // Condition Checkers (Master Switch + Format Toggle)
  // ---------------------------------------------------------------------------
  static bool get canShowAppOpen => isAdsVisible && isAppOpenEnabled;
  static bool get canShowNativeCard => isAdsVisible && isNativeCardEnabled;
  static bool get canShowBanner => isAdsVisible && isBannerEnabled;
  static bool get canShowInterstitial => isAdsVisible && isInterstitialEnabled;
  static bool get canShowRewarded => isAdsVisible && isRewardedEnabled;
  static bool get canShowRewardedInterstitial => isAdsVisible && isRewardedInterstitialEnabled;

  // ---------------------------------------------------------------------------
  // Active Ad Unit Resolvers (Platform + Remote Config + Test Fallback)
  // ---------------------------------------------------------------------------

  /// App Open Ad Unit ID
  static String get appOpenAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosAppOpen : _testAndroidAppOpen;
    }
    return Platform.isIOS ? _iosAppOpen : _androidAppOpen;
  }

  /// Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosBanner : _testAndroidBanner;
    }
    return Platform.isIOS ? _iosBanner : _androidBanner;
  }

  /// Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosInterstitial : _testAndroidInterstitial;
    }
    return Platform.isIOS ? _iosInterstitial : _androidInterstitial;
  }

  /// Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosNative : _testAndroidNative;
    }
    return Platform.isIOS ? _iosNative : _androidNative;
  }

  /// Rewarded Interstitial Ad Unit ID
  static String get rewardedInterstitialAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosRewardedInterstitial : _testAndroidRewardedInterstitial;
    }
    return Platform.isIOS ? _iosRewardedInterstitial : _androidRewardedInterstitial;
  }

  /// Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosRewarded : _testAndroidRewarded;
    }
    return Platform.isIOS ? _iosRewarded : _androidRewarded;
  }

  // ---------------------------------------------------------------------------
  // Remote Config Parser & Updater
  // ---------------------------------------------------------------------------

  /// Updates AdConfig with Remote Config JSON string or Map
  static void updateFromRemoteConfig({
    String? adsConfigRawJson,
    bool? remoteIsAdsVisible,
  }) {
    if (remoteIsAdsVisible != null) {
      isAdsVisible = remoteIsAdsVisible;
    }

    if (adsConfigRawJson != null && adsConfigRawJson.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(adsConfigRawJson);
        if (decoded is Map<String, dynamic>) {
          parseAndApplyMap(decoded);
        }
      } catch (e) {
        debugPrint('AdConfig: Error parsing ads_config JSON from Remote Config: $e');
      }
    }

    adsVisibilityNotifier.value = isAdsVisible;

    debugPrint('AdConfig: Updated config -> isAdsVisible: $isAdsVisible, '
        'appOpen: $isAppOpenEnabled, banner: $isBannerEnabled, '
        'native: $isNativeCardEnabled, interstitial: $isInterstitialEnabled, '
        'rewarded: $isRewardedEnabled, rewardedInterstitial: $isRewardedInterstitialEnabled');
  }

  /// Parses and applies Map values to AdConfig
  static void parseAndApplyMap(Map<String, dynamic> data) {
    if (data.containsKey('isAdsVisible')) {
      if (data['isAdsVisible'] is bool) {
        isAdsVisible = data['isAdsVisible'] as bool;
      } else if (data['isAdsVisible'] is String) {
        isAdsVisible = (data['isAdsVisible'] as String).toLowerCase() == 'true';
      }
    }

    // Android ad units
    if (data['android'] is Map<String, dynamic>) {
      final androidMap = data['android'] as Map<String, dynamic>;
      if (androidMap['appOpenAdUnitId'] is String) _androidAppOpen = androidMap['appOpenAdUnitId'] as String;
      if (androidMap['nativeCardAdUnitId'] is String) _androidNative = androidMap['nativeCardAdUnitId'] as String;
      if (androidMap['bannerAdUnitId'] is String) _androidBanner = androidMap['bannerAdUnitId'] as String;
      if (androidMap['interstitialAdUnitId'] is String) _androidInterstitial = androidMap['interstitialAdUnitId'] as String;
      if (androidMap['rewardedVideoAdUnitId'] is String) _androidRewarded = androidMap['rewardedVideoAdUnitId'] as String;
      if (androidMap['rewardedInterstitialAdUnitId'] is String) _androidRewardedInterstitial = androidMap['rewardedInterstitialAdUnitId'] as String;
    }

    // iOS ad units
    if (data['ios'] is Map<String, dynamic>) {
      final iosMap = data['ios'] as Map<String, dynamic>;
      if (iosMap['appOpenAdUnitId'] is String) _iosAppOpen = iosMap['appOpenAdUnitId'] as String;
      if (iosMap['nativeCardAdUnitId'] is String) _iosNative = iosMap['nativeCardAdUnitId'] as String;
      if (iosMap['bannerAdUnitId'] is String) _iosBanner = iosMap['bannerAdUnitId'] as String;
      if (iosMap['interstitialAdUnitId'] is String) _iosInterstitial = iosMap['interstitialAdUnitId'] as String;
      if (iosMap['rewardedVideoAdUnitId'] is String) _iosRewarded = iosMap['rewardedVideoAdUnitId'] as String;
      if (iosMap['rewardedInterstitialAdUnitId'] is String) _iosRewardedInterstitial = iosMap['rewardedInterstitialAdUnitId'] as String;
    }

    // Individual Toggles
    if (data['individualToggles'] is Map<String, dynamic>) {
      final toggles = data['individualToggles'] as Map<String, dynamic>;
      if (toggles.containsKey('appOpen') && toggles['appOpen'] is bool) {
        isAppOpenEnabled = toggles['appOpen'] as bool;
      }
      if (toggles.containsKey('nativeCard') && toggles['nativeCard'] is bool) {
        isNativeCardEnabled = toggles['nativeCard'] as bool;
      }
      if (toggles.containsKey('banner') && toggles['banner'] is bool) {
        isBannerEnabled = toggles['banner'] as bool;
      }
      if (toggles.containsKey('interstitial') && toggles['interstitial'] is bool) {
        isInterstitialEnabled = toggles['interstitial'] as bool;
      }
      if (toggles.containsKey('rewarded') && toggles['rewarded'] is bool) {
        isRewardedEnabled = toggles['rewarded'] as bool;
      }
      if (toggles.containsKey('rewardedInterstitial') && toggles['rewardedInterstitial'] is bool) {
        isRewardedInterstitialEnabled = toggles['rewardedInterstitial'] as bool;
      }
    }
  }

  /// Default JSON string representation
  static const String defaultRemoteConfigJson = '''
{
  "android": {
    "appOpenAdUnitId": "ca-app-pub-7315215850217970/2176699592",
    "nativeCardAdUnitId": "ca-app-pub-7315215850217970/6115944604",
    "bannerAdUnitId": "ca-app-pub-7315215850217970/8490826501",
    "interstitialAdUnitId": "ca-app-pub-7315215850217970/4168438119",
    "rewardedVideoAdUnitId": "ca-app-pub-7315215850217970/7074532008",
    "rewardedInterstitialAdUnitId": "ca-app-pub-7315215850217970/3462590054"
  },
  "ios": {
    "appOpenAdUnitId": "ca-app-pub-7315215850217970/5012997955",
    "nativeCardAdUnitId": "ca-app-pub-7315215850217970/1014043195",
    "bannerAdUnitId": "ca-app-pub-7315215850217970/1265324632",
    "interstitialAdUnitId": "ca-app-pub-7315215850217970/7639161294",
    "rewardedVideoAdUnitId": "ca-app-pub-7315215850217970/8453549514",
    "rewardedInterstitialAdUnitId": "ca-app-pub-7315215850217970/2079712852"
  },
  "individualToggles": {
    "appOpen": true,
    "nativeCard": true,
    "banner": true,
    "interstitial": true,
    "rewarded": true,
    "rewardedInterstitial": true
  }
}
''';
}
