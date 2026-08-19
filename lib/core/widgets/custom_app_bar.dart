import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/language_provider.dart';
import 'language_toggle_button.dart';

class CustomSpiritualAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showOm;
  final bool showLanguageToggle;
  final PreferredSizeWidget? bottom;

  const CustomSpiritualAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showOm = true,
    this.showLanguageToggle = true,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (subtitle != null ? 18.0 : 0.0) + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.headerGradientDark : AppColors.headerGradientLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  if (leading != null)
                    leading!
                  else if (Navigator.of(context).canPop())
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.goldLight),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  else if (showOm)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold.withAlpha(40),
                          border: Border.all(color: AppColors.goldLight, width: 1),
                        ),
                        child: Text(
                          isGujarati ? 'ૐ' : 'ॐ',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldLight,
                                ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.goldLight.withAlpha(220),
                              letterSpacing: 0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (showLanguageToggle) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: LanguageToggleButton(),
                    ),
                  ],
                  ...?actions,
                  if (!showLanguageToggle && actions == null) const SizedBox(width: 48),
                ],
              ),
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }
}
