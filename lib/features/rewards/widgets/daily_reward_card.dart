import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/daily_reward_provider.dart';
import '../../../core/utils/currency.dart';
import '../../../theme/tokens.dart';

class DailyRewardCard extends ConsumerWidget {
  const DailyRewardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyRewardProvider);
    final isClaimed = ref.read(dailyRewardProvider.notifier).isTodayClaimed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎁 Daily Reward',
                style: AppTokens.subtitle.copyWith(color: AppTokens.navy)),
            const SizedBox(height: 6),
            Text(
              isClaimed
                  ? 'Already claimed today'
                  : 'Check in today and get ${formatCurrency(kDailyRewardUSD)}',
              style: AppTokens.body.copyWith(color: AppTokens.gray700),
            ),
            if (!isClaimed) ...[
              const SizedBox(height: 4),
              Text(
                '7-day streak bonus: +${formatCurrency(kWeeklyStreakBonusUSD)}',
                style: AppTokens.caption.copyWith(color: AppTokens.gray500),
              ),
            ],
            const SizedBox(height: AppTokens.s12),
            Row(
              children: [
                _Badge(label: 'Streak', value: '${state.streak}'),
                const SizedBox(width: 8),
                _Badge(
                    label: 'This month',
                    value: formatCurrency(state.monthTotal)),
                const Spacer(),
                ElevatedButton(
                  onPressed: isClaimed
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(dailyRewardProvider.notifier)
                                .claim();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Claimed ${formatCurrency(kDailyRewardUSD)}!')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$e')),
                              );
                            }
                          }
                        },
                  child: Text(isClaimed
                      ? 'Come back tomorrow'
                      : 'Claim ${formatCurrency(kDailyRewardUSD)} Now'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.gray100,
        borderRadius: AppTokens.radius8,
      ),
      child: Row(
        children: [
          Text(label,
              style: AppTokens.caption.copyWith(color: AppTokens.gray600)),
          const SizedBox(width: 6),
          Text(value,
              style: AppTokens.label.copyWith(color: AppTokens.navy)),
        ],
      ),
    );
  }
}
