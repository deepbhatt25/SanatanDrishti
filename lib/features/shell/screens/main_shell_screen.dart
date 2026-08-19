import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/language_provider.dart';
import '../../geeta/screens/chapters_screen.dart';
import '../../kundali/screens/create_kundali_screen.dart';
import '../../panchang/screens/panchang_screen.dart';
import '../../rashi/screens/rashi_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../widgets/spiritual_bottom_nav.dart';

class MainShellScreen extends StatefulWidget {
  final int initialTabIndex;

  const MainShellScreen({super.key, this.initialTabIndex = 1}); // 1 = Geeta Center Tab by default

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final isGujarati = langProvider.isGujarati;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          PanchangScreen(), // Tab 0 (Left)
          ChaptersScreen(), // Tab 1 (Center / Home)
          RashiScreen(),    // Tab 2 (Right)
        ],
      ),
      bottomNavigationBar: SpiritualBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.small(
              heroTag: 'settings_fab',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              tooltip: 'Settings',
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.settings_outlined, size: 20),
            )
          : (_currentIndex == 2
              ? FloatingActionButton.extended(
                  heroTag: 'rashi_kundali_fab',
                  backgroundColor: AppColors.saffronPrimary,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  label: Text(
                    isGujarati ? 'કુંડળી બનાવો' : 'कुंडली बनाएं',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateKundaliScreen()),
                    );
                  },
                )
              : null),
    );
  }
}

