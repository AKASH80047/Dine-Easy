import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) context.go('/table-select');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '🍔',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: 28),

              // App Name
              Text(
                'Pandey Foods',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              )
                  .animate()
                  .slideY(
                    begin: 0.3,
                    duration: 600.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .fade(delay: 400.ms, duration: 500.ms),

              const SizedBox(height: 8),

              Text(
                'Fresh & Delicious, Every Time!',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              )
                  .animate()
                  .fade(delay: 700.ms, duration: 500.ms)
                  .slideY(
                    begin: 0.2,
                    delay: 700.ms,
                    duration: 400.ms,
                  ),

              const SizedBox(height: 80),

              // Loading dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(delay: Duration(milliseconds: 900 + i * 150))
                      .fade(duration: 400.ms)
                      .scale(duration: 400.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
