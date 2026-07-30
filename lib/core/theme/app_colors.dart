import 'package:flutter/material.dart';

class AppColors {
  // Google Stitch Deep Charcoal/Slate Backgrounds
  static const Color stitchBgDark = Color(0xFF0D0E15);
  static const Color stitchSurfaceDark = Color(0xFF161823);
  static const Color stitchCardDark = Color(0xFF1F2232);
  static const Color stitchBorderDark = Color(0xFF2E3248);

  // Backward compatibility alias getters
  static const Color darkSurface = stitchSurfaceDark;
  static const Color darkCard = stitchCardDark;

  // Light Mode Colors
  static const Color lightBg = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFEDF2F9);
  static const Color lightText = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF444746);

  // Dark Mode Text
  static const Color darkText = Color(0xFFF2F5FB);
  static const Color darkTextSecondary = Color(0xFFA0A7B8);

  // Google Stitch Neon AI Accents
  static const Color primary = Color(0xFF8E54E9);
  static const Color primaryLight = Color(0xFFA875F0);
  static const Color secondary = Color(0xFF00D2FF);
  static const Color success = Color(0xFF00F2FE);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF4B4B);

  // Google Stitch AI Gradients
  static const LinearGradient stitchGradient = LinearGradient(
    colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = stitchGradient;
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF4776E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGlowGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF8E54E9), Color(0xFFFF416C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFF76B1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
