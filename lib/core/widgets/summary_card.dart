import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Today's summary card showing today and week totals
class TodaySummaryCard extends StatelessWidget {
  final double todayRoundUp;
  final double weekRoundUp;

  const TodaySummaryCard({
    super.key,
    required this.todayRoundUp,
    required this.weekRoundUp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s20),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Today',
                value: '\$${todayRoundUp.toStringAsFixed(2)}',
                icon: Icons.today,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
            Expanded(
              child: _StatItem(
                label: 'This Week',
                value: '\$${weekRoundUp.toStringAsFixed(2)}',
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppTokens.s4),
            Text(
              label,
              style: AppTokens.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTokens.s8),
        Text(
          value,
          style: AppTokens.title.copyWith(
            fontSize: 20,
            color: AppTokens.navy,
          ),
        ),
      ],
    );
  }
}
