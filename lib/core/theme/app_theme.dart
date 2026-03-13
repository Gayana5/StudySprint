import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    // Retro arcade color scheme
    const background = Color(0xFF0A0A0A); // Dark background like old arcade cabinets
    const surface = Color(0xFF1A1A1A); // Dark surface
    const primary = Color(0xFF00FFFF); // Cyan neon
    const secondary = Color(0xFFFF00FF); // Magenta neon
    const tertiary = Color(0xFFFFFF00); // Yellow neon
    const ink = Color(0xFFFFFFFF); // White text

    final colorScheme = const ColorScheme.dark(
      primary: primary,
      onPrimary: Color(0xFF000000),
      secondary: secondary,
      onSecondary: Color(0xFF000000),
      tertiary: tertiary,
      onTertiary: Color(0xFF000000),
      surface: surface,
      onSurface: ink,
      error: Color(0xFFFF4444),
      onError: Color(0xFF000000),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.pressStart2pTextTheme( // Pixelated retro font
        TextTheme(
          bodyMedium: TextStyle(color: ink, fontSize: 12),
          headlineMedium: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: secondary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.pressStart2p(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primary, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: tertiary, width: 3),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        selectedColor: secondary,
        labelStyle: TextStyle(color: ink),
        secondaryLabelStyle: TextStyle(color: ink),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: tertiary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Color(0xFF000000),
          textStyle: GoogleFonts.pressStart2p(fontSize: 10, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: primary.withOpacity(0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: secondary, width: 2),
          textStyle: GoogleFonts.pressStart2p(fontSize: 10, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.pressStart2p(fontSize: 8, fontWeight: FontWeight.w600),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: secondary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiary,
        foregroundColor: Color(0xFF000000),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }
}
