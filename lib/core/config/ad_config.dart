import 'dart:io';
import 'package:flutter/foundation.dart';

/// Centralized configuration for AdMob Ads in SanatanDrishti.
///
/// By default, [useTestAds] is set to `true` (or when in debug mode) so that
/// official Google Test Ad Unit IDs are used to strictly comply with Google AdMob
/// policies and prevent invalid traffic flags or account penalties during development.
class AdConfig {
  /// Toggle to switch between Test Ad Units and Production Ad Units.
  /// Set to `false` ONLY when building for final App Store / Play Store release.
  static const bool useTestAds = true;

  /// AdMob Android App ID
  static const String androidAppId = 'ca-app-pub-7315215850217970~7676438284';

  /// AdMob iOS App ID
  static const String iosAppId = 'ca-app-pub-7315215850217970~3891487976';

  /// Platform-specific App ID
  static String get appId => Platform.isIOS ? iosAppId : androidAppId;

  // ---------------------------------------------------------------------------
  // Android Production Ad Unit IDs (from AdMob Console)
  // ---------------------------------------------------------------------------
  static const String _prodAndroidAppOpen = 'ca-app-pub-7315215850217970/2176699592';
  static const String _prodAndroidNative = 'ca-app-pub-7315215850217970/6115944604';
  static const String _prodAndroidBanner = 'ca-app-pub-7315215850217970/8490826501';
  static const String _prodAndroidInterstitial = 'ca-app-pub-7315215850217970/4168438119';
  static const String _prodAndroidRewardedInterstitial = 'ca-app-pub-7315215850217970/3462590054';
  static const String _prodAndroidRewarded = 'ca-app-pub-7315215850217970/7074532008';

  // ---------------------------------------------------------------------------
  // iOS Production Ad Unit IDs (from AdMob Console)
  // ---------------------------------------------------------------------------
  static const String _prodIosAppOpen = 'ca-app-pub-7315215850217970/5012997955';
  static const String _prodIosNative = 'ca-app-pub-7315215850217970/1014043195';
  static const String _prodIosBanner = 'ca-app-pub-7315215850217970/1265324632';
  static const String _prodIosInterstitial = 'ca-app-pub-7315215850217970/7639161294';
  static const String _prodIosRewardedInterstitial = 'ca-app-pub-7315215850217970/2079712852';
  static const String _prodIosRewarded = 'ca-app-pub-7315215850217970/8453549514';

  // ---------------------------------------------------------------------------
  // Google Official Test Ad Unit IDs (Android)
  // ---------------------------------------------------------------------------
  static const String _testAndroidAppOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testAndroidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testAndroidNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testAndroidRewardedInterstitial = 'ca-app-pub-3940256099942544/5354046379';
  static const String _testAndroidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // ---------------------------------------------------------------------------
  // Google Official Test Ad Unit IDs (iOS)
  // ---------------------------------------------------------------------------
  static const String _testIosAppOpen = 'ca-app-pub-3940256099942544/5575463023';
  static const String _testIosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testIosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testIosNative = 'ca-app-pub-3940256099942544/3986624511';
  static const String _testIosRewardedInterstitial = 'ca-app-pub-3940256099942544/6978759866';
  static const String _testIosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  /// Whether test ads should be served.
  static bool get isTestMode => useTestAds || kDebugMode;

  // ---------------------------------------------------------------------------
  // Active Ad Unit Resolvers (Handles Platform & Test/Prod Switching)
  // ---------------------------------------------------------------------------

  /// App Open Ad Unit ID
  static String get appOpenAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosAppOpen : _testAndroidAppOpen;
    }
    return Platform.isIOS ? _prodIosAppOpen : _prodAndroidAppOpen;
  }

  /// Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosBanner : _testAndroidBanner;
    }
    return Platform.isIOS ? _prodIosBanner : _prodAndroidBanner;
  }

  /// Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosInterstitial : _testAndroidInterstitial;
    }
    return Platform.isIOS ? _prodIosInterstitial : _prodAndroidInterstitial;
  }

  /// Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosNative : _testAndroidNative;
    }
    return Platform.isIOS ? _prodIosNative : _prodAndroidNative;
  }

  /// Rewarded Interstitial Ad Unit ID
  static String get rewardedInterstitialAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosRewardedInterstitial : _testAndroidRewardedInterstitial;
    }
    return Platform.isIOS ? _prodIosRewardedInterstitial : _prodAndroidRewardedInterstitial;
  }

  /// Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (isTestMode) {
      return Platform.isIOS ? _testIosRewarded : _testAndroidRewarded;
    }
    return Platform.isIOS ? _prodIosRewarded : _prodAndroidRewarded;
  }
}
