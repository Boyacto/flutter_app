import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class PointsCounter extends StatelessWidget {
  const PointsCounter({
    super.key,
    required this.points,
    required this.coupons,
  });

  final int points;
  final int coupons;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Pill(
          icon: Icons.star,
          label: '$points pts',
          color: AppTokens.accentRed,
        ),
        const SizedBox(width: AppTokens.s8),
        _Pill(
          icon: Icons.local_offer,
          label: '$coupons',
          color: AppTokens.teal,
        ),
        const SizedBox(width: AppTokens.s8),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s12,
        vertical: AppTokens.s4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppTokens.radius8,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTokens.label.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
