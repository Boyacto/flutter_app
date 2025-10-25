import 'package:flutter/material.dart';
import 'tokens.dart';

/// Theme extension for jar category colors
class JarThemeExtension extends ThemeExtension<JarThemeExtension> {
  final Color categoryVacation;
  final Color categoryEmergency;
  final Color categoryEducation;
  final Color categoryHome;
  final Color categoryElectronics;
  final Color categoryGeneral;

  const JarThemeExtension({
    required this.categoryVacation,
    required this.categoryEmergency,
    required this.categoryEducation,
    required this.categoryHome,
    required this.categoryElectronics,
    required this.categoryGeneral,
  });

  /// Light theme colors
  factory JarThemeExtension.light() {
    return const JarThemeExtension(
      categoryVacation: AppTokens.teal,
      categoryEmergency: AppTokens.accentRed,
      categoryEducation: Color(0xFF9C27B0), // Purple
      categoryHome: AppTokens.warningAmber,
      categoryElectronics: AppTokens.navy,
      categoryGeneral: AppTokens.gray600,
    );
  }

  /// Dark theme colors
  factory JarThemeExtension.dark() {
    return const JarThemeExtension(
      categoryVacation: AppTokens.tealLight,
      categoryEmergency: AppTokens.accentRed,
      categoryEducation: Color(0xFFCE93D8), // Light purple
      categoryHome: AppTokens.warningAmber,
      categoryElectronics: AppTokens.teal,
      categoryGeneral: AppTokens.gray400,
    );
  }

  @override
  ThemeExtension<JarThemeExtension> copyWith({
    Color? categoryVacation,
    Color? categoryEmergency,
    Color? categoryEducation,
    Color? categoryHome,
    Color? categoryElectronics,
    Color? categoryGeneral,
  }) {
    return JarThemeExtension(
      categoryVacation: categoryVacation ?? this.categoryVacation,
      categoryEmergency: categoryEmergency ?? this.categoryEmergency,
      categoryEducation: categoryEducation ?? this.categoryEducation,
      categoryHome: categoryHome ?? this.categoryHome,
      categoryElectronics: categoryElectronics ?? this.categoryElectronics,
      categoryGeneral: categoryGeneral ?? this.categoryGeneral,
    );
  }

  @override
  ThemeExtension<JarThemeExtension> lerp(
    ThemeExtension<JarThemeExtension>? other,
    double t,
  ) {
    if (other is! JarThemeExtension) {
      return this;
    }

    return JarThemeExtension(
      categoryVacation: Color.lerp(categoryVacation, other.categoryVacation, t)!,
      categoryEmergency: Color.lerp(categoryEmergency, other.categoryEmergency, t)!,
      categoryEducation: Color.lerp(categoryEducation, other.categoryEducation, t)!,
      categoryHome: Color.lerp(categoryHome, other.categoryHome, t)!,
      categoryElectronics: Color.lerp(categoryElectronics, other.categoryElectronics, t)!,
      categoryGeneral: Color.lerp(categoryGeneral, other.categoryGeneral, t)!,
    );
  }

  /// Get color for a jar category
  Color getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'vacation':
      case 'travel':
        return categoryVacation;
      case 'emergency':
      case 'savings':
        return categoryEmergency;
      case 'education':
      case 'learning':
        return categoryEducation;
      case 'home':
      case 'housing':
        return categoryHome;
      case 'electronics':
      case 'gadgets':
        return categoryElectronics;
      default:
        return categoryGeneral;
    }
  }
}

/// Extension method to access JarThemeExtension from BuildContext
extension JarThemeExtensionHelper on BuildContext {
  JarThemeExtension get jarTheme =>
      Theme.of(this).extension<JarThemeExtension>() ?? JarThemeExtension.light();
}
