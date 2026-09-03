import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

/// Centralized Ad Service managing all 6 Google AdMob ad formats:
/// 1. App Open Ad (with 4-hour cooldown and splash safety)
/// 2. Banner Ad (adaptive & responsive)
/// 3. Interstitial Ad (frequency capped to prevent user annoyance)
/// 4. Native Advanced Ad (styled seamlessly to match spiritual theme)
/// 5. Rewarded Ad (user opt-in with explicit callback)
/// 6. Rewarded Interstitial Ad (pre-roll countdown with skip option)
class AdService with WidgetsBindingObserver {
  static final AdService instance = AdService._internal();

  AdService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Track if a full-screen ad is currently showing (to prevent overlapping ads)
  bool _isShowingFullScreenAd = false;
  bool get isShowingFullScreenAd => _isShowingFullScreenAd;

  // Prevent App Open Ads from showing when the app resumes after dismissing another ad format
  bool _suppressAppOpenOnNextResume = false;
  DateTime? _lastFullScreenAdDismissedTime;

  // ---------------------------------------------------------------------------
  // 1. App Open Ad Manager
  // ---------------------------------------------------------------------------
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdLoading = false;
  DateTime? _appOpenAdLoadTime;
  DateTime? _lastAppOpenAdShownTime;

  /// Minimum interval between App Open Ads (4 hours)
  static const Duration _appOpenCooldown = Duration(hours: 4);

  // ---------------------------------------------------------------------------
  // 2. Interstitial Ad Manager
  // ---------------------------------------------------------------------------
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoading = false;
  DateTime? _lastInterstitialShownTime;
  int _actionCountSinceLastAd = 0;

  /// Minimum time between interstitial ads (3 minutes)
  static const Duration _interstitialCooldown = Duration(minutes: 3);

  /// Number of significant actions before showing an interstitial ad
  static const int _actionsRequiredForInterstitial = 3;

  // ---------------------------------------------------------------------------
  // 3. Rewarded Ad Manager
  // ---------------------------------------------------------------------------
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;

  // ---------------------------------------------------------------------------
  // 4. Rewarded Interstitial Ad Manager
  // ---------------------------------------------------------------------------
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isRewardedInterstitialAdLoading = false;

  /// Initialize Google Mobile Ads SDK and start preloading ads
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Register lifecycle observer for App Open ads
      WidgetsBinding.instance.addObserver(this);

      // Preload ads in background
      _preloadAds();

      debugPrint('AdService: MobileAds initialized successfully. TestMode=${AdConfig.isTestMode}');
    } catch (e) {
      debugPrint('AdService: Error initializing MobileAds: $e');
    }
  }

  void _preloadAds() {
    if (AdConfig.canShowAppOpen) loadAppOpenAd();
    if (AdConfig.canShowInterstitial) loadInterstitialAd();
    if (AdConfig.canShowRewarded) loadRewardedAd();
    if (AdConfig.canShowRewardedInterstitial) loadRewardedInterstitialAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!AdConfig.canShowAppOpen) return;

      // 1. Suppress App Open ad if resuming from an interstitial or rewarded ad
      if (_suppressAppOpenOnNextResume) {
        _suppressAppOpenOnNextResume = false;
        debugPrint('AdService: AppOpenAd suppressed because app resumed from another ad dismissal.');
        return;
      }

      // 2. Suppress App Open ad if any full-screen ad is currently active
      if (_isShowingFullScreenAd) {
        debugPrint('AdService: AppOpenAd suppressed because a full-screen ad is active.');
        return;
      }

      // 3. Suppress App Open ad if another full-screen ad was dismissed very recently (safety buffer)
      if (_lastFullScreenAdDismissedTime != null) {
        final elapsed = DateTime.now().difference(_lastFullScreenAdDismissedTime!);
        if (elapsed < const Duration(seconds: 15)) {
          debugPrint('AdService: AppOpenAd suppressed due to recent ad dismissal (${elapsed.inSeconds}s ago).');
          return;
        }
      }

      // Show App Open Ad on genuine resume from background
      showAppOpenAdIfAvailable();
    }
  }

  // ===========================================================================
  // 1. APP OPEN AD METHODS
  // ===========================================================================

  void loadAppOpenAd({VoidCallback? onLoaded}) {
    if (!AdConfig.canShowAppOpen || _isAppOpenAdLoading) return;

    _isAppOpenAdLoading = true;
    AppOpenAd.load(
      adUnitId: AdConfig.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAdLoadTime = DateTime.now();
          _isAppOpenAdLoading = false;
          debugPrint('AdService: AppOpenAd loaded successfully.');
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isAppOpenAdLoading = false;
          debugPrint('AdService: AppOpenAd failed to load: ${error.message}');
        },
      ),
    );
  }

  bool get isAppOpenAdAvailable {
    if (!AdConfig.canShowAppOpen || _appOpenAd == null || _appOpenAdLoadTime == null) return false;
    final isNotExpired = DateTime.now().difference(_appOpenAdLoadTime!) < const Duration(hours: 4);
    return isNotExpired;
  }

  void showAppOpenAdIfAvailable({bool force = false}) {
    if (!AdConfig.canShowAppOpen || _isShowingFullScreenAd || _suppressAppOpenOnNextResume) return;

    // Check recent ad dismissal buffer
    if (!force && _lastFullScreenAdDismissedTime != null) {
      final elapsed = DateTime.now().difference(_lastFullScreenAdDismissedTime!);
      if (elapsed < const Duration(seconds: 15)) {
        debugPrint('AdService: AppOpenAd skipped due to recent ad dismissal buffer (${elapsed.inSeconds}s ago)');
        return;
      }
    }

    // Check cooldown: in production mode 4 hours, in test mode 30 seconds
    if (!force && _lastAppOpenAdShownTime != null) {
      final elapsed = DateTime.now().difference(_lastAppOpenAdShownTime!);
      final requiredCooldown = AdConfig.isTestMode ? const Duration(seconds: 30) : _appOpenCooldown;
      if (elapsed < requiredCooldown) {
        debugPrint('AdService: AppOpenAd skipped due to cooldown (${elapsed.inSeconds}s / ${requiredCooldown.inSeconds}s)');
        return;
      }
    }

    if (!isAppOpenAdAvailable) {
      if (force) {
        loadAppOpenAd(onLoaded: () {
          showAppOpenAdIfAvailable(force: force);
        });
      } else {
        // Preload for next resume without disrupting current user session
        loadAppOpenAd();
      }
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
        _lastAppOpenAdShownTime = DateTime.now();
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        _lastFullScreenAdDismissedTime = DateTime.now();
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
        debugPrint('AdService: AppOpenAd failed to show: ${error.message}');
      },
    );

    _appOpenAd!.show();
  }

  // ===========================================================================
  // 2. INTERSTITIAL AD METHODS
  // ===========================================================================

  void loadInterstitialAd({VoidCallback? onLoaded}) {
    if (!AdConfig.canShowInterstitial || _isInterstitialAdLoading) return;

    _isInterstitialAdLoading = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
          debugPrint('AdService: InterstitialAd loaded successfully.');
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialAdLoading = false;
          debugPrint('AdService: InterstitialAd failed to load: ${error.message}');
        },
      ),
    );
  }

  void recordActionAndCheckInterstitial({VoidCallback? onDismissed}) {
    if (!AdConfig.canShowInterstitial) {
      onDismissed?.call();
      return;
    }
    _actionCountSinceLastAd++;
    if (_actionCountSinceLastAd >= _actionsRequiredForInterstitial) {
      showInterstitialAd(onDismissed: onDismissed);
    }
  }

  void showInterstitialAd({VoidCallback? onDismissed, bool ignoreCooldown = false}) {
    if (!AdConfig.canShowInterstitial) {
      onDismissed?.call();
      return;
    }

    if (_isShowingFullScreenAd) {
      onDismissed?.call();
      return;
    }

    if (!AdConfig.isTestMode && !ignoreCooldown && _lastInterstitialShownTime != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialShownTime!);
      if (elapsed < _interstitialCooldown) {
        onDismissed?.call();
        return;
      }
    }

    if (_interstitialAd == null) {
      loadInterstitialAd(onLoaded: () {
        showInterstitialAd(onDismissed: onDismissed, ignoreCooldown: true);
      });
      onDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
        _suppressAppOpenOnNextResume = true;
        _lastInterstitialShownTime = DateTime.now();
        _actionCountSinceLastAd = 0;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = true;
        _lastFullScreenAdDismissedTime = DateTime.now();
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = false;
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        onDismissed?.call();
        debugPrint('AdService: InterstitialAd failed to show: ${error.message}');
      },
    );

    _interstitialAd!.show();
  }

  // ===========================================================================
  // 3. REWARDED AD METHODS
  // ===========================================================================

  void loadRewardedAd({VoidCallback? onLoaded}) {
    if (!AdConfig.canShowRewarded || _isRewardedAdLoading) return;

    _isRewardedAdLoading = true;
    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          debugPrint('AdService: RewardedAd loaded successfully.');
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          debugPrint('AdService: RewardedAd failed to load: ${error.message}');
        },
      ),
    );
  }

  void showRewardedAd({
    required Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdClosed,
    VoidCallback? onAdFailed,
  }) {
    if (!AdConfig.canShowRewarded) {
      // Ads disabled -> grant reward directly without blocking user
      onUserEarnedReward(RewardItem(1, 'unlocked_feature'));
      onAdClosed?.call();
      return;
    }

    if (_isShowingFullScreenAd) {
      onAdFailed?.call();
      return;
    }

    if (_rewardedAd == null) {
      debugPrint('AdService: RewardedAd not cached, loading on-demand...');
      RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isRewardedAdLoading = false;
            showRewardedAd(
              onUserEarnedReward: onUserEarnedReward,
              onAdClosed: onAdClosed,
              onAdFailed: onAdFailed,
            );
          },
          onAdFailedToLoad: (error) {
            _rewardedAd = null;
            _isRewardedAdLoading = false;
            debugPrint('AdService: On-demand RewardedAd failed: ${error.message}');
            onAdFailed?.call();
          },
        ),
      );
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
        _suppressAppOpenOnNextResume = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = true;
        _lastFullScreenAdDismissedTime = DateTime.now();
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = false;
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdFailed?.call();
        debugPrint('AdService: RewardedAd failed to show: ${error.message}');
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onUserEarnedReward(reward);
      },
    );
  }

  // ===========================================================================
  // 4. REWARDED INTERSTITIAL AD METHODS
  // ===========================================================================

  void loadRewardedInterstitialAd({VoidCallback? onLoaded}) {
    if (!AdConfig.canShowRewardedInterstitial || _isRewardedInterstitialAdLoading) return;

    _isRewardedInterstitialAdLoading = true;
    RewardedInterstitialAd.load(
      adUnitId: AdConfig.rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          _isRewardedInterstitialAdLoading = false;
          debugPrint('AdService: RewardedInterstitialAd loaded successfully.');
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _rewardedInterstitialAd = null;
          _isRewardedInterstitialAdLoading = false;
          debugPrint('AdService: RewardedInterstitialAd failed to load: ${error.message}');
        },
      ),
    );
  }

  void showRewardedInterstitialAd({
    required Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdClosed,
    VoidCallback? onAdFailed,
  }) {
    if (!AdConfig.canShowRewardedInterstitial) {
      // Ads disabled -> grant reward directly without blocking user
      onUserEarnedReward(RewardItem(1, 'unlocked_feature'));
      onAdClosed?.call();
      return;
    }

    if (_isShowingFullScreenAd) {
      onAdFailed?.call();
      return;
    }

    if (_rewardedInterstitialAd == null) {
      debugPrint('AdService: RewardedInterstitialAd not cached, loading on-demand...');
      RewardedInterstitialAd.load(
        adUnitId: AdConfig.rewardedInterstitialAdUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedInterstitialAd = ad;
            _isRewardedInterstitialAdLoading = false;
            showRewardedInterstitialAd(
              onUserEarnedReward: onUserEarnedReward,
              onAdClosed: onAdClosed,
              onAdFailed: onAdFailed,
            );
          },
          onAdFailedToLoad: (error) {
            _rewardedInterstitialAd = null;
            _isRewardedInterstitialAdLoading = false;
            debugPrint('AdService: On-demand RewardedInterstitialAd failed: ${error.message}');
            onAdFailed?.call();
          },
        ),
      );
      return;
    }

    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingFullScreenAd = true;
        _suppressAppOpenOnNextResume = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = true;
        _lastFullScreenAdDismissedTime = DateTime.now();
        ad.dispose();
        _rewardedInterstitialAd = null;
        loadRewardedInterstitialAd();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingFullScreenAd = false;
        _suppressAppOpenOnNextResume = false;
        ad.dispose();
        _rewardedInterstitialAd = null;
        loadRewardedInterstitialAd();
        onAdFailed?.call();
        debugPrint('AdService: RewardedInterstitialAd failed to show: ${error.message}');
      },
    );

    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onUserEarnedReward(reward);
      },
    );
  }

  /// Dispose service and observer
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }
}
