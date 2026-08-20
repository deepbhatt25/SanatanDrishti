import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../constants/app_colors.dart';

/// Reusable Native Advanced Ad Card styled to seamlessly blend with
/// the SanatanDrishti spiritual aesthetic while clearly displaying
/// the mandatory Google/Apple "Ad" attribution badge.
class AdNativeCard extends StatefulWidget {
  final TemplateType templateType;
  final EdgeInsetsGeometry margin;

  const AdNativeCard({
    super.key,
    this.templateType = TemplateType.small,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  State<AdNativeCard> createState() => _AdNativeCardState();
}

class _AdNativeCardState extends State<AdNativeCard> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nativeAd == null && !_hasFailed) {
      _loadAd();
    }
  }

  void _loadAd() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _nativeAd = NativeAd(
      adUnitId: AdConfig.nativeAdUnitId,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.landscape,
      ),
      listener: NativeAdListener(
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
          debugPrint('AdNativeCard: Failed to load native ad: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _hasFailed = true;
            });
          }
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
        mainBackgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        cornerRadius: 14.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.saffronPrimary,
          style: NativeTemplateFontStyle.bold,
          size: 13.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          size: 12.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: isDark ? AppColors.goldLight : AppColors.goldDark,
          size: 11.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasFailed || (!_isLoaded && _nativeAd == null)) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double cardHeight = widget.templateType == TemplateType.small ? 110.0 : 340.0;

    return Container(
      margin: widget.margin,
      height: cardHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: AdWidget(ad: _nativeAd!),
      ),
    );
  }
}
