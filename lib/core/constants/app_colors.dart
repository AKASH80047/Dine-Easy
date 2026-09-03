import 'package:flutter/material.dart';

class AppColors {
  // Primary - Dark Green
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF0A3D0A);
  static const Color primarySurface = Color(0xFFE8F5E9);

  // Accent - Orange
  static const Color accent = Color(0xFFFF6F00);
  static const Color accentLight = Color(0xFFFF8F00);
  static const Color accentSurface = Color(0xFFFFF3E0);

  // Background & Surface
  static const Color background = Color(0xFFF9FBF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEEEEEE);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF555555);
  static const Color textHint = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);

  // Order Status Colors
  static const Color statusPending = Color(0xFFFFA000);
  static const Color statusPreparing = Color(0xFF1976D2);
  static const Color statusReady = Color(0xFF388E3C);
  static const Color statusServed = Color(0xFF7B1FA2);
  static const Color statusCompleted = Color(0xFF2E7D32);
  static const Color statusCancelled = Color(0xFFE53935);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0A3D0A), Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBannerGradient = LinearGradient(
    colors: [Color(0xFF0A3D0A), Color(0x001B5E20)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F8E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
