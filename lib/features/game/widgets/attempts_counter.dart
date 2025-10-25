import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class AttemptsCounter extends StatelessWidget {
  const AttemptsCounter({
    super.key,
    required this.remainingAttempts,
    required this.bonusRetries,
  });

  final int remainingAttempts;
  final int bonusRetries;

  @override
  Widget build(BuildContext context) {
    final totalAttempts = remainingAttempts + bonusRetries;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s20,
        vertical: AppTokens.s12,
      ),
      decoration: BoxDecoration(
        color: AppTokens.tealLight.withOpacity(0.1),
        borderRadius: AppTokens.radius16,
        border: Border.all(color: AppTokens.teal.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_basketball,
            color: AppTokens.teal,
            size: 24,
          ),
          const SizedBox(width: AppTokens.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attempts Remaining',
                style: AppTokens.caption.copyWith(color: AppTokens.gray600),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '$totalAttempts',
                    style: AppTokens.title.copyWith(
                      color: AppTokens.teal,
                      fontSize: 24,
                    ),
                  ),
                  if (bonusRetries > 0) ...[
                    const SizedBox(width: AppTokens.s8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.s8,
                        vertical: AppTokens.s2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.accentRed,
                        borderRadius: AppTokens.radius8,
                      ),
                      child: Text(
                        '+$bonusRetries bonus',
                        style: AppTokens.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
