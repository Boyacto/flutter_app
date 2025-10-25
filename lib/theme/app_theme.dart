import 'package:flutter/material.dart';
import 'tokens.dart';

/// App theme configuration for light and dark modes
/// Ensures 4.5:1 contrast ratio for accessibility
class AppTheme {
  AppTheme._();

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppTokens.mint600,
        onPrimary: Colors.white,
        secondary: AppTokens.amber500,
        onSecondary: AppTokens.gray900,
        tertiary: AppTokens.teal500,
        error: AppTokens.errorRed,
        surface: Colors.white,
        onSurface: AppTokens.gray900,
        surfaceContainerHighest: AppTokens.gray50,
        outline: AppTokens.gray200,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppTokens.gray50,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTokens.gray900,
        titleTextStyle: AppTokens.title.copyWith(color: AppTokens.gray900),
        centerTitle: false,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppTokens.e1,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius16,
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s8,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.mint600,
          foregroundColor: Colors.white,
          elevation: AppTokens.e1,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius12,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.mint600,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s16,
            vertical: AppTokens.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius8,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.mint600,
          side: const BorderSide(color: AppTokens.mint600, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius12,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.mint600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s16,
        ),
        labelStyle: AppTokens.body.copyWith(color: AppTokens.gray500),
        hintStyle: AppTokens.body.copyWith(color: AppTokens.gray500),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return AppTokens.gray200;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTokens.mint600;
          }
          return AppTokens.gray200;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTokens.mint600,
        inactiveTrackColor: AppTokens.gray200,
        thumbColor: AppTokens.mint600,
        overlayColor: AppTokens.mint600.withValues(alpha: 0.2),
        valueIndicatorColor: AppTokens.mint600,
        valueIndicatorTextStyle: AppTokens.label.copyWith(color: Colors.white),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.gray100,
        selectedColor: AppTokens.mint600,
        disabledColor: AppTokens.gray100,
        labelStyle: AppTokens.label.copyWith(color: AppTokens.gray700),
        secondaryLabelStyle: AppTokens.label.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s12,
          vertical: AppTokens.s8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius8,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTokens.gray900,
        contentTextStyle: AppTokens.body.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius12,
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTokens.r24),
          ),
        ),
        elevation: AppTokens.e4,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTokens.display.copyWith(color: AppTokens.gray900),
        displayMedium: AppTokens.display.copyWith(
          fontSize: 36,
          color: AppTokens.gray900,
        ),
        displaySmall: AppTokens.display.copyWith(
          fontSize: 28,
          color: AppTokens.gray900,
        ),
        headlineLarge: AppTokens.title.copyWith(color: AppTokens.gray900),
        headlineMedium: AppTokens.subtitle.copyWith(color: AppTokens.gray900),
        titleLarge: AppTokens.subtitle.copyWith(color: AppTokens.gray900),
        titleMedium: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTokens.gray900,
        ),
        bodyLarge: AppTokens.body.copyWith(color: AppTokens.gray700),
        bodyMedium: AppTokens.bodySmall.copyWith(color: AppTokens.gray700),
        labelLarge: AppTokens.label.copyWith(color: AppTokens.gray900),
        bodySmall: AppTokens.caption.copyWith(color: AppTokens.gray500),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppTokens.gray200,
        thickness: 1,
        space: AppTokens.s16,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppTokens.gray700,
        size: 24,
      ),
    );
  }

  // ============================================================================
  // DARK THEME
  // ============================================================================

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme - Lower saturation/brightness for dark mode
      colorScheme: ColorScheme.dark(
        primary: AppTokens.mint400, // Lighter mint for dark
        onPrimary: AppTokens.gray900,
        secondary: AppTokens.amber500,
        onSecondary: AppTokens.gray900,
        tertiary: AppTokens.teal500,
        error: AppTokens.errorRed,
        surface: AppTokens.darkSurface,
        onSurface: AppTokens.gray100,
        surfaceContainerHighest: AppTokens.darkBg,
        outline: AppTokens.darkBorder,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppTokens.darkBg,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppTokens.darkSurface,
        foregroundColor: AppTokens.gray100,
        titleTextStyle: AppTokens.title.copyWith(color: AppTokens.gray100),
        centerTitle: false,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppTokens.e1,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius16,
        ),
        color: AppTokens.darkSurface,
        margin: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s8,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.mint400,
          foregroundColor: AppTokens.gray900,
          elevation: AppTokens.e1,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius12,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.mint400,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s16,
            vertical: AppTokens.s12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius8,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.mint400,
          side: const BorderSide(color: AppTokens.mint400, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius12,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.darkSurface,
        border: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.mint400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius12,
          borderSide: const BorderSide(color: AppTokens.errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s16,
        ),
        labelStyle: AppTokens.body.copyWith(color: AppTokens.gray500),
        hintStyle: AppTokens.body.copyWith(color: AppTokens.gray500),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTokens.gray900;
          }
          return AppTokens.gray500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTokens.mint400;
          }
          return AppTokens.darkBorder;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTokens.mint400,
        inactiveTrackColor: AppTokens.darkBorder,
        thumbColor: AppTokens.mint400,
        overlayColor: AppTokens.mint400.withValues(alpha: 0.2),
        valueIndicatorColor: AppTokens.mint400,
        valueIndicatorTextStyle: AppTokens.label.copyWith(
          color: AppTokens.gray900,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.darkSurface,
        selectedColor: AppTokens.mint400,
        disabledColor: AppTokens.darkSurface,
        labelStyle: AppTokens.label.copyWith(color: AppTokens.gray200),
        secondaryLabelStyle: AppTokens.label.copyWith(
          color: AppTokens.gray900,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s12,
          vertical: AppTokens.s8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius8,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTokens.gray100,
        contentTextStyle: AppTokens.body.copyWith(color: AppTokens.gray900),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius12,
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppTokens.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTokens.r24),
          ),
        ),
        elevation: AppTokens.e4,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTokens.display.copyWith(color: AppTokens.gray100),
        displayMedium: AppTokens.display.copyWith(
          fontSize: 36,
          color: AppTokens.gray100,
        ),
        displaySmall: AppTokens.display.copyWith(
          fontSize: 28,
          color: AppTokens.gray100,
        ),
        headlineLarge: AppTokens.title.copyWith(color: AppTokens.gray100),
        headlineMedium: AppTokens.subtitle.copyWith(color: AppTokens.gray100),
        titleLarge: AppTokens.subtitle.copyWith(color: AppTokens.gray100),
        titleMedium: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTokens.gray100,
        ),
        bodyLarge: AppTokens.body.copyWith(color: AppTokens.gray200),
        bodyMedium: AppTokens.bodySmall.copyWith(color: AppTokens.gray200),
        labelLarge: AppTokens.label.copyWith(color: AppTokens.gray100),
        bodySmall: AppTokens.caption.copyWith(color: AppTokens.gray500),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppTokens.darkBorder,
        thickness: 1,
        space: AppTokens.s16,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppTokens.gray200,
        size: 24,
      ),
    );
  }
}
