import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Base font family - Roboto Mono for tech-forward monospace aesthetic
  static String get fontFamily => GoogleFonts.robotoMono().fontFamily!;

  // Display Styles - Large headings
  static TextStyle display1 = GoogleFonts.robotoMono(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle display2 = GoogleFonts.robotoMono(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.16,
  );

  static TextStyle display3 = GoogleFonts.robotoMono(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.22,
  );

  // Headline Styles
  static TextStyle h1 = GoogleFonts.robotoMono(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  static TextStyle h2 = GoogleFonts.robotoMono(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  static TextStyle h3 = GoogleFonts.robotoMono(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  static TextStyle h4 = GoogleFonts.robotoMono(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static TextStyle h5 = GoogleFonts.robotoMono(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.44,
  );

  static TextStyle h6 = GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  // Body Text Styles
  static TextStyle bodyLarge = GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static TextStyle bodySmall = GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles - For buttons, chips, etc.
  static TextStyle labelLarge = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25, // More spacing for tech feel
    height: 1.43,
  );

  static TextStyle labelMedium = GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    height: 1.33,
  );

  static TextStyle labelSmall = GoogleFonts.robotoMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    height: 1.45,
  );

  // Special Styles
  static TextStyle button = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5, // Wide spacing for buttons
    height: 1.43,
  );

  static TextStyle caption = GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static TextStyle overline = GoogleFonts.robotoMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // Code/Monospace emphasis (already monospace but for emphasis)
  static TextStyle code = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
    backgroundColor: const Color(0xFF1A1A1A),
  );
}
