import 'package:flutter/material.dart';

/// Responsive breakpoints and helpers
class Responsive {
  Responsive._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if the current device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if the current device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if the current device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get a value based on the current screen size
  /// Returns mobile value by default, tablet value on tablets, desktop value on desktops
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;

    if (width >= desktopBreakpoint && desktop != null) {
      return desktop;
    } else if (width >= mobileBreakpoint && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive padding
  static EdgeInsets padding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  /// Get responsive column count for grids
  static int gridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 2;
    }
  }
}
