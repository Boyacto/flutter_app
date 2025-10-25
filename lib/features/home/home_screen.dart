import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../core/widgets/goal_card.dart';
import '../../core/widgets/summary_card.dart';
import '../../core/widgets/quick_topup_row.dart';
import '../../core/widgets/auto_toggle_tile.dart';
import '../../core/widgets/info_banner.dart';
import '../../core/models/event.dart';
import '../../core/utils/date.dart';
import '../../state/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jar = ref.watch(jarProvider);
    final stats = ref.watch(sessionStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saving Jar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.s16),
        children: [
          // Paused banner
          if (jar.isPaused)
            InfoBanner(
              text: 'Round-up paused until ${DateFormatter.formatDate(jar.pausedUntil!)}',
              icon: Icons.pause_circle,
              tint: AppTokens.accentRed,
            ),

          // Auto off banner
          if (!jar.isAutoOn)
            InfoBanner(
              text: 'Auto round-up is off. Turn it on to start saving!',
              icon: Icons.info_outline,
              tint: AppTokens.accentRed,
            ),

          const SizedBox(height: AppTokens.s8),

          // Goal card
          GoalCard(
            goalName: jar.name,
            current: jar.balance,
            target: jar.goalAmount,
            etaText: DateFormatter.formatETA(jar.deadline),
          ),

          const SizedBox(height: AppTokens.s16),

          // Today summary
          TodaySummaryCard(
            todayRoundUp: stats.todayRoundUp,
            weekRoundUp: stats.weekRoundUp,
          ),

          const SizedBox(height: AppTokens.s16),

          // Quick top-up
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Top-up',
                    style: AppTokens.subtitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s16),
                  QuickTopUpRow(
                    onTopUp: (amount) => _handleTopUp(context, ref, amount),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Auto toggle
          AutoRoundUpToggleTile(
            value: jar.isAutoOn,
            onChanged: (_) {
              ref.read(jarProvider.notifier).toggleAuto();
            },
          ),

          const SizedBox(height: AppTokens.s16),

          // Simulate purchase button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/simulate'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Simulate Purchase'),
            ),
          ),

          const SizedBox(height: AppTokens.s8),

          // View activity button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/activity'),
              icon: const Icon(Icons.history),
              label: const Text('View Activity'),
            ),
          ),

          const SizedBox(height: AppTokens.s8),

          // Rules button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/rules'),
              icon: const Icon(Icons.tune),
              label: const Text('Configure Rules'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTopUp(BuildContext context, WidgetRef ref, double amount) {
    // Add to balance
    ref.read(jarProvider.notifier).addToBalance(amount);

    // Create event
    final jar = ref.read(jarProvider);
    final event = Event.topUp(
      id: 'topup_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      amount: amount,
      jarBalanceAfter: jar.balance,
    );
    ref.read(eventsProvider.notifier).addEvent(event);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('+\$$amount added to your jar!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
