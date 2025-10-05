import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Black & White System
  static const Color primary = Color(0xFF000000); // Pure Black
  static const Color secondary = Color(0xFFFFFFFF); // Pure White

  // Grayscale Palette for depth
  static const Color gray900 = Color(0xFF0A0A0A); // Near Black
  static const Color gray800 = Color(0xFF1A1A1A); // Darkest Gray
  static const Color gray700 = Color(0xFF2A2A2A); // Dark Gray
  static const Color gray600 = Color(0xFF404040); // Medium Dark
  static const Color gray500 = Color(0xFF737373); // Medium Gray
  static const Color gray400 = Color(0xFF9CA3AF); // Light Medium
  static const Color gray300 = Color(0xFFD1D5DB); // Light Gray
  static const Color gray200 = Color(0xFFE5E7EB); // Lighter Gray
  static const Color gray100 = Color(0xFFF3F4F6); // Very Light
  static const Color gray50 = Color(0xFFFAFAFA); // Near White

  // Accent - Subtle tech highlight
  static const Color accent = Color(0xFFFFFFFF); // White as accent on dark
  static const Color accentDark = Color(0xFF000000); // Black as accent on light

  // Functional Colors (minimal, subtle)
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF3B82F6); // Blue

  // Surface Colors
  static const Color surface = Color(0xFF000000);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color background = Color(0xFF000000);
  static const Color backgroundVariant = Color(0xFF0A0A0A);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF737373);
  static const Color textInverse = Color(0xFF000000);

  // Border & Divider
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFF404040);
  static const Color divider = Color(0xFF1A1A1A);

  // Overlay & Shadow
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black
  static const Color shadow = Color(0xFF000000);

  // Interactive States
  static const Color hover = Color(0xFF2A2A2A);
  static const Color pressed = Color(0xFF404040);
  static const Color focus = Color(0xFFFFFFFF);
  static const Color disabled = Color(0xFF404040);
  static const Color disabledText = Color(0xFF737373);
}
