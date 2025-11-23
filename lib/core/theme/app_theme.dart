import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// Migrasi dari Theme.kt
class AppTheme {
  // --- LIGHT THEME ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.greenDark,       // Warna utama Hijau
      onPrimary: Colors.white,
      secondary: AppColors.greenOlive,
      onSecondary: Colors.white,
      tertiary: AppColors.brownDark,
      surface: Colors.white,
      onSurface: AppColors.black,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
    ),
  );

  // --- DARK THEME ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.greenDark,       // Tetap Hijau di Dark Mode
      onPrimary: Colors.white,
      secondary: AppColors.greenOlive,
      onSecondary: Colors.white,
      tertiary: AppColors.brownDark,      // Hitam standar Material
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: Color(0xFFCF6679),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // Text Theme Global
  static const TextTheme _textTheme = TextTheme(
    bodyLarge: AppTextStyles.bodyLarge,
    titleLarge: AppTextStyles.titleLarge,
    labelSmall: AppTextStyles.labelSmall,
  );
}