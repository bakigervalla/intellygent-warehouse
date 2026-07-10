import 'package:flutter/material.dart';

/// Tiny design system: one accent, warm neutrals, a 4pt spacing scale and
/// generous radii. Amber is reserved exclusively for DRAFT signalling.
abstract final class AppColors {
  static const Color accent = Color(0xFF1E5F4B); // deep pine green
  static const Color accentSoft = Color(0xFFDCEBE4);
  static const Color background = Color(0xFFF7F5F0); // warm paper
  static const Color surface = Colors.white;
  static const Color ink = Color(0xFF1A1F1C);
  static const Color inkMuted = Color(0xFF6B7570);
  static const Color draft = Color(0xFFB45309); // amber ink
  static const Color draftFill = Color(0xFFFEF3C7); // amber wash
  static const Color danger = Color(0xFFB3261E);
  static const Color success = Color(0xFF1E5F4B);
  static const Color outline = Color(0xFFE4E1D8);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class AppRadii {
  static const double card = 20;
  static const double control = 14;
  static const double pill = 999;
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentSoft,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
      ),
    );
  }
}
