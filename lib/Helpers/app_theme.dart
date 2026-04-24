import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color scaffoldBackground = Color(0xFF0A0E21);
  static const Color primary = Color(0xFF6200EE);
  static const Color accentAmber = Color(0xFFFFD700);

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accentAmber,
        surface: scaffoldBackground,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF0A0E21),
        onSurface: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
