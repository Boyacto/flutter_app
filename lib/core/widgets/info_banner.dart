import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Information banner for alerts and notifications
class InfoBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? tint;

  const InfoBanner({
    super.key,
    required this.text,
    required this.icon,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final bannerColor = tint ?? AppTokens.accentRed;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.s16,
        vertical: AppTokens.s8,
      ),
      padding: const EdgeInsets.all(AppTokens.s16),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: AppTokens.radius12,
        border: Border.all(
          color: bannerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: bannerColor,
            size: 20,
          ),
          const SizedBox(width: AppTokens.s12),
          Expanded(
            child: Text(
              text,
              style: AppTokens.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
