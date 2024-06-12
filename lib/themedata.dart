import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFF7F7E8);
const Color secondaryColor = Color(0xFFC7CFB7);
const Color secondaryColorOpacity = Color(0xFFe6e9d7);
const Color tertiaryColor = Color(0xFF9DAD7F);
const Color accentColor = Color(0xFF557174);

ThemeData buildCustomTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      onPrimary: accentColor,
      secondary: secondaryColor,
      onSecondary: accentColor,
      surface: primaryColor,
      onSurface: tertiaryColor,
      background: secondaryColorOpacity,
      onBackground: tertiaryColor,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.jockeyOne(),
      displayMedium: GoogleFonts.jockeyOne(),
      displaySmall: GoogleFonts.jockeyOne(),
      headlineLarge: GoogleFonts.jockeyOne(
        fontSize: 42,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.jockeyOne(
          fontSize: 48,
          fontWeight: FontWeight.bold
      ),
      titleMedium: GoogleFonts.jockeyOne(
          fontSize: 24,
          fontWeight: FontWeight.normal
      ),
      bodyLarge: GoogleFonts.dosis(
          fontSize: 24,
          fontWeight: FontWeight.w600
      ),
      bodyMedium: GoogleFonts.dosis(
          fontSize: 20,
          fontWeight: FontWeight.w500
      ),
      bodySmall: GoogleFonts.dosis(
          fontSize: 16,
          fontWeight: FontWeight.w500
      ),
    ),
  );
}
