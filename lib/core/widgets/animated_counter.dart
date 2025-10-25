import 'package:flutter/material.dart';

/// Animated counter widget for smooth number transitions
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 600),
    this.formatter,
  });

  final double value;
  final TextStyle style;
  final Duration duration;
  final String Function(double)? formatter;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final displayText = formatter != null
            ? formatter!(animatedValue)
            : animatedValue.toStringAsFixed(0);

        return Text(displayText, style: style);
      },
    );
  }
}
