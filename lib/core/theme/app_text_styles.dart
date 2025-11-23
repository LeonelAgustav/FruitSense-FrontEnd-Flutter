import 'package:flutter/material.dart';

// Migrasi dari Type.kt
class AppTextStyles {
  // Menggunakan Font Default Flutter (Roboto di Android, SF di iOS)
  
  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    height: 1.5, // 24.sp / 16.sp = 1.5
    letterSpacing: 0.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 22.0,
    height: 1.27, // 28.sp / 22.sp
    letterSpacing: 0.0,
  );

  static const TextStyle labelSmall = TextStyle(
    fontWeight: FontWeight.w500, // Medium
    fontSize: 11.0,
    height: 1.45, // 16.sp / 11.sp
    letterSpacing: 0.5,
  );
  
  // Helper untuk text style umum lainnya (Optional)
  static const TextStyle headlineBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );
}