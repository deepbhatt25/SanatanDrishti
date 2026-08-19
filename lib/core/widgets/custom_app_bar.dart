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
      Size.fromHeight(kToolbarHeight + (subtitle != null ? 14.0 : 0.0) + (bottom?.preferredSize.height ?? 0.0));

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null)
                    leading!
                  else if (Navigator.of(context).canPop())
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.goldLight),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  else if (showOm)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold.withAlpha(45),
                          border: Border.all(color: AppColors.goldLight, width: 1),
                        ),
                        child: Text(
                          isGujarati ? 'ૐ' : 'ॐ',
                          style: isGujarati
                              ? GoogleFonts.notoSerifGujarati(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldLight,
                                )
                              : GoogleFonts.notoSerifDevanagari(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldLight,
                                ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: isGujarati
                                  ? GoogleFonts.notoSerifGujarati(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    )
                                  : GoogleFonts.notoSerifDevanagari(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                              maxLines: 1,
                            ),
                          ),
                          if (subtitle != null && subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 1),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                subtitle!,
                                style: isGujarati
                                    ? GoogleFonts.notoSerifGujarati(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.goldLight.withAlpha(225),
                                        letterSpacing: 0.2,
                                      )
                                    : (subtitle!.contains(RegExp(r'[\u0900-\u097F]'))
                                        ? GoogleFonts.notoSerifDevanagari(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.goldLight.withAlpha(225),
                                            letterSpacing: 0.2,
                                          )
                                        : GoogleFonts.outfit(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.goldLight.withAlpha(225),
                                            letterSpacing: 0.2,
                                          )),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (showLanguageToggle) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: LanguageToggleButton(isCompact: true),
                    ),
                  ],
                  if (actions != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!
                          .map(
                            (action) => Theme(
                              data: Theme.of(context).copyWith(
                                iconButtonTheme: IconButtonThemeData(
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(34, 34),
                                    padding: const EdgeInsets.all(5),
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                              child: action,
                            ),
                          )
                          .toList(),
                    ),
                  if (!showLanguageToggle && actions == null) const SizedBox(width: 36),
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

