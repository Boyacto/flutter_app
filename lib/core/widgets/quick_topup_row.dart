import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Quick top-up buttons row
class QuickTopUpRow extends StatelessWidget {
  final void Function(double amount) onTopUp;

  const QuickTopUpRow({
    super.key,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickTopUpButton(
            amount: 1.0,
            onTap: () => onTopUp(1.0),
          ),
        ),
        const SizedBox(width: AppTokens.s12),
        Expanded(
          child: _QuickTopUpButton(
            amount: 3.0,
            onTap: () => onTopUp(3.0),
          ),
        ),
        const SizedBox(width: AppTokens.s12),
        Expanded(
          child: _QuickTopUpButton(
            amount: 5.0,
            onTap: () => onTopUp(5.0),
          ),
        ),
      ],
    );
  }
}

class _QuickTopUpButton extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _QuickTopUpButton({
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppTokens.s16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, size: 16),
          const SizedBox(width: AppTokens.s4),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: AppTokens.label,
          ),
        ],
      ),
    );
  }
}
