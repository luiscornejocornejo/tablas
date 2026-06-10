import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta y tema visual infantil para la app de tablas de multiplicar.
class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFFFFF8E7);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);

  /// Colores distintos para cada tabla (1-12), facilitan reconocimiento visual.
  static const List<Color> tableColors = [
    Color(0xFFFF6B6B),
    Color(0xFFFF9F43),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFF9B59B6),
    Color(0xFFE056FD),
    Color(0xFF00D2D3),
    Color(0xFFFF7979),
    Color(0xFF686DE0),
    Color(0xFF22A6B3),
    Color(0xFFF0932B),
  ];

  static Color colorForTable(int table) {
    return tableColors[(table - 1).clamp(0, tableColors.length - 1)];
  }

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: background,
      ),
      scaffoldBackgroundColor: background,
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFF2D3436),
        displayColor: const Color(0xFF2D3436),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2D3436),
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3436),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.fredoka(fontSize: 18),
        ),
      ),
    );
  }
}
