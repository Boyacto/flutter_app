import 'package:flutter/material.dart';

/// Animation helpers and presets
class Animations {
  Animations._();

  // ============================================================================
  // DURATIONS
  // ============================================================================

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // ============================================================================
  // CURVES
  // ============================================================================

  static const Curve bounceIn = Curves.elasticOut;
  static const Curve smoothIn = Curves.easeInOut;
  static const Curve quickIn = Curves.easeOut;

  // ============================================================================
  // COIN DROP ANIMATION
  // ============================================================================

  /// Creates a coin drop animation
  /// Simulates a coin falling and bouncing
  static AnimationController createCoinDropController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
  }

  static Animation<double> coinDropAnimation(AnimationController controller) {
    return Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  static Animation<double> coinRotationAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 0, end: 6.28).animate(controller);
  }

  // ============================================================================
  // SCALE IN ANIMATION
  // ============================================================================

  /// Creates a scale-in animation (pop effect)
  static AnimationController createScaleInController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
  }

  static Animation<double> scaleInAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  // ============================================================================
  // FADE IN ANIMATION
  // ============================================================================

  static AnimationController createFadeInController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
  }

  static Animation<double> fadeInAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  // ============================================================================
  // SLIDE IN ANIMATION
  // ============================================================================

  static AnimationController createSlideInController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
  }

  static Animation<Offset> slideInFromBottomAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  static Animation<Offset> slideInFromRightAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  // ============================================================================
  // PULSE ANIMATION
  // ============================================================================

  static AnimationController createPulseController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    )..repeat(reverse: true);
  }

  static Animation<double> pulseAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // ============================================================================
  // SHIMMER ANIMATION (for loading states)
  // ============================================================================

  static AnimationController createShimmerController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    )..repeat();
  }

  static Animation<double> shimmerAnimation(AnimationController controller) {
    return Tween<double>(begin: -1.0, end: 2.0).animate(controller);
  }
}

/// Extension to add animation helpers to AnimationController
extension AnimationControllerExtensions on AnimationController {
  /// Forward and then reverse the animation
  Future<void> forwardAndReverse() async {
    await forward();
    await reverse();
  }

  /// Play animation multiple times
  Future<void> playTimes(int times) async {
    for (int i = 0; i < times; i++) {
      await forward();
      await reverse();
    }
  }
}
