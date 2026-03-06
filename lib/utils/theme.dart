import 'package:flutter/material.dart';
import 'package:flutter/src/material/card_theme.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFC8E6C9);
  static const Color earthBrown = Color(0xFF8D6E63);
  static const Color warmBeige = Color(0xFFEFEBE9);
  static const Color textDark = Color(0xFF1B5E20);
  static const Color textLight = Color(0xFFF1F8E9);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryGreen,
      surface: warmBeige,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textDark,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textDark,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textDark,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textDark,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

class AppConstants {
  static const String appName = 'HerbiSense';
  static const String tagline = 'Ethiopian Herbal Wisdom';
  
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'am', 'name': 'አማርኛ'},
    {'code': 'om', 'name': 'Afaan Oromo'},
  ];
}