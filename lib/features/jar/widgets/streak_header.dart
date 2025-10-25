import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class StreakHeader extends StatelessWidget {
  const StreakHeader({super.key, required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s20),
        child: Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 32)),
            const SizedBox(width: AppTokens.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streakDays days streak',
                  style: AppTokens.title.copyWith(color: AppTokens.navy),
                ),
                Text(
                  'Keep it going!',
                  style: AppTokens.caption.copyWith(color: AppTokens.gray500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
