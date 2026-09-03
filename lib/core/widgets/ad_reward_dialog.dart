import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../config/ad_config.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import '../services/ad_service.dart';

/// Spiritual styled modal dialog for Rewarded Ads.
/// Adheres to Google and Apple guidelines by requiring explicit user opt-in
/// with clear reward explanation and non-punitive dismiss options.
class AdRewardDialog extends StatefulWidget {
  final String title;
  final String description;
  final String rewardDescription;
  final IconData icon;
  final bool isRewardedInterstitial;
  final VoidCallback onRewardGranted;

  const AdRewardDialog({
    super.key,
    required this.title,
    required this.description,
    required this.rewardDescription,
    this.icon = Icons.auto_awesome_rounded,
    this.isRewardedInterstitial = false,
    required this.onRewardGranted,
  });

  /// Helper static method to show the dialog conveniently
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    required String rewardDescription,
    IconData icon = Icons.auto_awesome_rounded,
    bool isRewardedInterstitial = false,
    required VoidCallback onRewardGranted,
  }) {
    // If ads are disabled in Remote Config, grant reward immediately without popup friction
    final canShow = isRewardedInterstitial
        ? AdConfig.canShowRewardedInterstitial
        : AdConfig.canShowRewarded;
    if (!canShow) {
      onRewardGranted();
      return Future.value();
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AdRewardDialog(
        title: title,
        description: description,
        rewardDescription: rewardDescription,
        icon: icon,
        isRewardedInterstitial: isRewardedInterstitial,
        onRewardGranted: onRewardGranted,
      ),
    );
  }

  @override
  State<AdRewardDialog> createState() => _AdRewardDialogState();
}

class _AdRewardDialogState extends State<AdRewardDialog> {
  bool _isLoadingAd = false;

  void _watchAd() {
    setState(() => _isLoadingAd = true);

    if (widget.isRewardedInterstitial) {
      AdService.instance.showRewardedInterstitialAd(
        onUserEarnedReward: (RewardItem reward) {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            widget.onRewardGranted();
          }
        },
        onAdClosed: () {
          if (mounted) {
            setState(() => _isLoadingAd = false);
          }
        },
        onAdFailed: () {
          if (mounted) {
            setState(() => _isLoadingAd = false);
            Navigator.of(context, rootNavigator: true).pop();
            // Fallback: grant reward gracefully if ad failed to load to prevent user frustration
            widget.onRewardGranted();
          }
        },
      );
    } else {
      AdService.instance.showRewardedAd(
        onUserEarnedReward: (RewardItem reward) {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            widget.onRewardGranted();
          }
        },
        onAdClosed: () {
          if (mounted) {
            setState(() => _isLoadingAd = false);
          }
        },
        onAdFailed: () {
          if (mounted) {
            setState(() => _isLoadingAd = false);
            Navigator.of(context, rootNavigator: true).pop();
            // Fallback: grant reward gracefully if ad failed to load to prevent user frustration
            widget.onRewardGranted();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Spiritual Icon with Glow
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.saffronGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffronPrimary.withAlpha(80),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: isGujarati
                  ? GoogleFonts.notoSerifGujarati(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.45,
                    )
                  : GoogleFonts.notoSerifDevanagari(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.45,
                    ),
            ),
            const SizedBox(height: 16),

            // Reward Highlight Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.gold.withAlpha(isDark ? 30 : 25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold.withAlpha(100),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.rewardDescription,
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Dismiss / Not now button
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    onPressed: _isLoadingAd ? null : () => Navigator.of(context, rootNavigator: true).pop(),
                    child: Text(
                      isGujarati ? 'હમણાં નહીં' : 'अभी नहीं',
                      style: isGujarati
                          ? GoogleFonts.notoSerifGujarati(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            )
                          : GoogleFonts.notoSerifDevanagari(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Watch Ad Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.saffronPrimary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoadingAd ? null : _watchAd,
                    child: _isLoadingAd
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_circle_fill_rounded, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                isGujarati ? 'જાહેરાત જુઓ' : 'विज्ञापन देखें',
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      )
                                    : GoogleFonts.notoSerifDevanagari(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
