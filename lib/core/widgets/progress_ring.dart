import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Circular progress ring with gradient stroke
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String primaryText;
  final String secondaryText;
  final double size;
  final double strokeWidth;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.primaryText,
    required this.secondaryText,
    this.size = 200.0,
    this.strokeWidth = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: 1.0,
              strokeWidth: strokeWidth,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),

          // Progress ring
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: clampedProgress,
              strokeWidth: strokeWidth,
              color: AppTokens.mint600,
              gradient: LinearGradient(
                colors: [AppTokens.mint600, AppTokens.teal500],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Text content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                primaryText,
                style: AppTokens.display.copyWith(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppTokens.s4),
              Text(
                secondaryText,
                style: AppTokens.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (gradient != null && progress > 0) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
