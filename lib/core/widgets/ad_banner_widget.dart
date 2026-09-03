import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../constants/app_colors.dart';

/// Reusable and lifecycle-safe Banner Ad Widget.
/// Renders standard banner (320x50) cleanly with zero layout shift
/// and collapses gracefully on load failure.
class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  final EdgeInsetsGeometry margin;

  const AdBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
    this.margin = const EdgeInsets.symmetric(vertical: 6.0),
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    AdConfig.adsVisibilityNotifier.addListener(_onVisibilityChanged);
    _loadAd();
  }

  void _onVisibilityChanged() {
    if (!mounted) return;
    if (!AdConfig.canShowBanner) {
      _bannerAd?.dispose();
      _bannerAd = null;
      setState(() {
        _isLoaded = false;
      });
    } else if (_bannerAd == null && !_hasFailed) {
      _loadAd();
    } else {
      setState(() {});
    }
  }

  void _loadAd() {
    if (!AdConfig.canShowBanner) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
            _hasFailed = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdBannerWidget: Failed to load banner: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _hasFailed = true;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    AdConfig.adsVisibilityNotifier.removeListener(_onVisibilityChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.canShowBanner || _hasFailed || (!_isLoaded && _bannerAd == null)) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded) {
      // Return subtle placeholder while loading
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
