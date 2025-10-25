import 'package:flutter/material.dart';

/// Design tokens for the Saving Jar app
/// Single source of truth for colors, spacing, radius, motion, and typography
class AppTokens {
  AppTokens._();

  // ============================================================================
  // COLORS
  // ============================================================================

  // Primary palette - Navy
  static const Color navy = Color(0xFF0B1F3B); // Primary
  static const Color navyLight = Color(0xFF1A3A5C);
  static const Color navyDark = Color(0xFF050F1D);

  // Secondary palette - Teal
  static const Color teal = Color(0xFF1FB7A6);
  static const Color tealLight = Color(0xFF4DD4C5);
  static const Color tealDark = Color(0xFF179B8D);

  // Accent palette - Red
  static const Color accentRed = Color(0xFFD22F27);
  static const Color accentRedLight = Color(0xFFE25850);
  static const Color accentRedDark = Color(0xFFB02620);

  // Neutral palette - Gray
  static const Color grayBg = Color(0xFFECEFF3);
  static const Color gray900 = Color(0xFF111827);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);

  // Semantic colors
  static const Color errorRed = Color(0xFFD22F27);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Dark mode colors
  static const Color darkBg = Color(0xFF0E1217);
  static const Color darkSurface = Color(0xFF1A1F28);
  static const Color darkBorder = Color(0xFF2A3340);

  // ============================================================================
  // SPACING
  // ============================================================================

  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;

  // ============================================================================
  // RADIUS
  // ============================================================================

  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;

  static BorderRadius radius8 = BorderRadius.circular(r8);
  static BorderRadius radius12 = BorderRadius.circular(r12);
  static BorderRadius radius16 = BorderRadius.circular(r16);
  static BorderRadius radius24 = BorderRadius.circular(r24);
  static BorderRadius radius32 = BorderRadius.circular(r32);

  // ============================================================================
  // ELEVATION
  // ============================================================================

  static const double e0 = 0.0; // Flat design - no elevation
  static const double e1 = 0.0;
  static const double e2 = 0.0;
  static const double e3 = 0.0;
  static const double e4 = 0.0;

  // ============================================================================
  // MOTION (Durations in milliseconds)
  // ============================================================================

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration celebrate = Duration(milliseconds: 800);

  // Animation durations
  static const Duration coinDrop = Duration(milliseconds: 200);
  static const Duration ringPulse = Duration(milliseconds: 120);
  static const Duration countUp = Duration(milliseconds: 300);
  static const Duration badgeUnlock = Duration(milliseconds: 160);
  static const Duration chipTap = Duration(milliseconds: 80);

  // Animation curves
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve spring = Curves.elasticOut;

  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================

  // Display - Hero numbers, large titles
  static const TextStyle display = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Title - Screen titles, card headers
  static const TextStyle title = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  // Subtitle
  static const TextStyle subtitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body - Regular text
  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Body small
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Label - Buttons, tabs, form labels
  static const TextStyle label = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  // Caption - Hints, metadata
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  // ============================================================================
  // SHADOWS (Flat design - no shadows)
  // ============================================================================

  static List<BoxShadow> shadow1 = [];
  static List<BoxShadow> shadow2 = [];
  static List<BoxShadow> shadow3 = [];
}
