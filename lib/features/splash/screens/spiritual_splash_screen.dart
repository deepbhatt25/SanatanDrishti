import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../shell/screens/main_shell_screen.dart';

class SpiritualSplashScreen extends StatefulWidget {
  const SpiritualSplashScreen({super.key});

  @override
  State<SpiritualSplashScreen> createState() => _SpiritualSplashScreenState();
}

class _SpiritualSplashScreenState extends State<SpiritualSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _scaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.7, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Show splash screen for 4.5 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 4500), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    _navigationTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) => const MainShellScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToHome, // Tap to skip splash
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.25,
              colors: [
                Color(0xFF4A0E0E),
                Color(0xFF240606),
                Color(0xFF120303),
              ],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Sacred Invocation
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          '॥ ॐ नमो भगवते वासुदेवाय ॥',
                          style: GoogleFonts.notoSerifDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldLight.withAlpha(230),
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),

                    // Center Animated Sacred SanatanDrishti Logo & Title
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Glowing SanatanDrishti Master Logo
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.saffronPrimary.withAlpha((90 * _glowAnimation.value).toInt()),
                                    blurRadius: 45 * _glowAnimation.value,
                                    spreadRadius: 8 * _glowAnimation.value,
                                  ),
                                  BoxShadow(
                                    color: AppColors.gold.withAlpha((70 * _glowAnimation.value).toInt()),
                                    blurRadius: 28 * _glowAnimation.value,
                                  ),
                                ],
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 220,
                                  maxWidth: 280,
                                ),
                                child: Image.asset(
                                  'assets/images/sanatandrishti_logo.png',
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Main Sacred App Title in Sanskrit
                            Text(
                              '॥ सनातन दृष्टि ॥',
                              style: GoogleFonts.notoSerifDevanagari(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.4,
                                shadows: [
                                  Shadow(
                                    color: AppColors.gold.withAlpha(180),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Feature Badges
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(16),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.gold.withAlpha(70),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'पञ्चाङ्ग  •  गीता  •  कुण्डली  •  राशि',
                                style: GoogleFonts.notoSerifDevanagari(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withAlpha(230),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Sacred Motto (Uncluttered, No Circular Indicator)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36.0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          '॥ यतो धर्मस्ततो जयः ॥',
                          style: GoogleFonts.notoSerifDevanagari(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldLight.withAlpha(200),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
