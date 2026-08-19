import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/verse_model.dart';

class CommentatorSelector extends StatelessWidget {
  final Map<String, CommentatorItem> commentators;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  const CommentatorSelector({
    super.key,
    required this.commentators,
    required this.selectedKey,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (commentators.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: commentators.containsKey(selectedKey) ? selectedKey : commentators.keys.first,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? AppColors.goldLight : AppColors.maroonPrimary,
          ),
          dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          items: commentators.entries.map((entry) {
            final item = entry.value;
            String label = item.author;
            String langIndicator = '';
            if (item.hasHindi && item.hasEnglish) {
              langIndicator = ' [HI/EN]';
            } else if (item.hasHindi) {
              langIndicator = ' [HI]';
            } else if (item.hasEnglish) {
              langIndicator = ' [EN]';
            }

            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Icon(
                    Icons.person_pin_outlined,
                    size: 16,
                    color: isDark ? AppColors.goldLight : AppColors.saffronPrimary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$label$langIndicator',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onSelected(val);
          },
        ),
      ),
    );
  }
}
