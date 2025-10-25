import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Auto round-up toggle tile
class AutoRoundUpToggleTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AutoRoundUpToggleTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          'Auto Round-Up',
          style: AppTokens.body.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          value
              ? 'Automatically saving spare change'
              : 'Paused - tap to resume',
          style: AppTokens.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        secondary: Icon(
          value ? Icons.savings : Icons.pause_circle_outline,
          color: value ? AppTokens.navy : AppTokens.gray500,
        ),
      ),
    );
  }
}
