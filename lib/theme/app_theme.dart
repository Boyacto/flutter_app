import 'package:flutter/material.dart';
import 'tokens.dart';

/// App theme configuration for light and dark modes
/// Flat design with Navy/Teal/Red color scheme
class AppTheme {
  AppTheme._();

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTokens.navy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppTokens.navy,
      onPrimary: Colors.white,
      secondary: AppTokens.teal,
      onSecondary: Colors.white,
      tertiary: AppTokens.accentRed,
      error: AppTokens.errorRed,
      surface: Colors.white,
      onSurface: AppTokens.gray900,
      surfaceContainerHighest: AppTokens.grayBg,
      outline: AppTokens.gray200,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,

      // Scaffold
      scaffoldBackgroundColor: Colors.white,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTokens.navy,
        titleTextStyle: AppTokens.title.copyWith(color: AppTokens.navy),
        centerTitle: false,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius24,
        ),
        color: Colors.white,
        surfaceTintColor: scheme.surfaceTint,
        margin: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s8,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s16,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius16,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.navy,
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
          foregroundColor: AppTokens.navy,
          side: const BorderSide(color: AppTokens.navy, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius16,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
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
          return Colors.white; // White thumb when off
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTokens.navy;
          }
          return AppTokens.gray300; // Grey track when off
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTokens.navy,
        inactiveTrackColor: AppTokens.gray200,
        thumbColor: AppTokens.navy,
        overlayColor: AppTokens.navy.withValues(alpha: 0.2),
        valueIndicatorColor: AppTokens.navy,
        valueIndicatorTextStyle: AppTokens.label.copyWith(color: Colors.white),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.gray100,
        selectedColor: AppTokens.navy,
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
        backgroundColor: AppTokens.navy,
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
        elevation: 0,
      ),

      // Text theme
      textTheme: Typography.englishLike2021.apply(
        bodyColor: AppTokens.gray900,
        displayColor: AppTokens.gray900,
      ).copyWith(
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

      // Visual density
      visualDensity: VisualDensity.comfortable,
    );
  }

  // ============================================================================
  // DARK THEME
  // ============================================================================

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppTokens.navy,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppTokens.teal,
      onPrimary: AppTokens.darkBg,
      secondary: AppTokens.tealLight,
      onSecondary: AppTokens.darkBg,
      tertiary: AppTokens.accentRed,
      error: AppTokens.errorRed,
      surface: AppTokens.darkSurface,
      onSurface: AppTokens.gray100,
      surfaceContainerHighest: AppTokens.darkBg,
      outline: AppTokens.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,

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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppTokens.radius24,
        ),
        color: AppTokens.darkSurface,
        surfaceTintColor: scheme.surfaceTint,
        margin: const EdgeInsets.symmetric(
          horizontal: AppTokens.s16,
          vertical: AppTokens.s8,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.teal,
          foregroundColor: AppTokens.darkBg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s16,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius16,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.teal,
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
          foregroundColor: AppTokens.teal,
          side: const BorderSide(color: AppTokens.teal, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.s24,
            vertical: AppTokens.s16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTokens.radius16,
          ),
          textStyle: AppTokens.label,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.darkSurface,
        border: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
          borderSide: const BorderSide(color: AppTokens.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppTokens.radius16,
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
            return AppTokens.darkBg;
          }
          return AppTokens.gray300; // Light grey thumb when off
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTokens.teal;
          }
          return AppTokens.gray600; // Darker track when off
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTokens.teal,
        inactiveTrackColor: AppTokens.darkBorder,
        thumbColor: AppTokens.teal,
        overlayColor: AppTokens.teal.withValues(alpha: 0.2),
        valueIndicatorColor: AppTokens.teal,
        valueIndicatorTextStyle: AppTokens.label.copyWith(
          color: AppTokens.darkBg,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.darkSurface,
        selectedColor: AppTokens.teal,
        disabledColor: AppTokens.darkSurface,
        labelStyle: AppTokens.label.copyWith(color: AppTokens.gray200),
        secondaryLabelStyle: AppTokens.label.copyWith(
          color: AppTokens.darkBg,
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
        contentTextStyle: AppTokens.body.copyWith(color: AppTokens.darkBg),
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
        elevation: 0,
      ),

      // Text theme
      textTheme: Typography.englishLike2021.apply(
        bodyColor: AppTokens.gray100,
        displayColor: AppTokens.gray100,
      ).copyWith(
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

      // Visual density
      visualDensity: VisualDensity.comfortable,
    );
  }
}
