import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF1565C0);
  static const Color _secondaryColor = Color(0xFFFFC107);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      secondary: _secondaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }
}
