import 'package:flutter/material.dart';

/// Design tokens for the Saving Jar app
/// Single source of truth for colors, spacing, radius, motion, and typography
class AppTokens {
  AppTokens._();

  // ============================================================================
  // COLORS
  // ============================================================================

  // Primary palette - Mint
  static const Color mint600 = Color(0xFF10B981); // Primary
  static const Color mint400 = Color(0xFF34D399);
  static const Color mint50 = Color(0xFFECFDF5);

  // Accent palette - Teal & Amber
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color amber500 = Color(0xFFF59E0B);

  // Neutral palette - Gray
  static const Color gray900 = Color(0xFF111827);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);

  // Semantic colors
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Dark mode colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // ============================================================================
  // SPACING
  // ============================================================================

  static const double s4 = 4.0;
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

  static BorderRadius radius8 = BorderRadius.circular(r8);
  static BorderRadius radius12 = BorderRadius.circular(r12);
  static BorderRadius radius16 = BorderRadius.circular(r16);
  static BorderRadius radius24 = BorderRadius.circular(r24);

  // ============================================================================
  // ELEVATION
  // ============================================================================

  static const double e0 = 0.0;
  static const double e1 = 1.0;
  static const double e2 = 2.0;
  static const double e3 = 3.0;
  static const double e4 = 4.0;

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
  // SHADOWS
  // ============================================================================

  static List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
