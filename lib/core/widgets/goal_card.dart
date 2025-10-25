import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'progress_ring.dart';

/// Goal card with progress ring
class GoalCard extends StatelessWidget {
  final String goalName;
  final double current;
  final double target;
  final String? etaText;

  const GoalCard({
    super.key,
    required this.goalName,
    required this.current,
    required this.target,
    this.etaText,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final progressPercent = (progress * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s24),
        child: Column(
          children: [
            // Goal name
            Text(
              goalName,
              style: AppTokens.title.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTokens.s24),

            // Progress ring
            ProgressRing(
              progress: progress,
              primaryText: '\$$current',
              secondaryText: 'of \$$target',
            ),

            const SizedBox(height: AppTokens.s24),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTokens.r8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(AppTokens.navy),
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.s12),
                Text(
                  '$progressPercent%',
                  style: AppTokens.label.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            // ETA
            if (etaText != null) ...[
              const SizedBox(height: AppTokens.s12),
              Text(
                etaText!,
                style: AppTokens.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
