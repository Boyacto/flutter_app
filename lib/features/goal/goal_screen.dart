import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../core/widgets/goal_card.dart';
import '../../core/utils/date.dart';
import '../../state/providers.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jar = ref.watch(jarProvider);
    final progressPercent = jar.progressPercent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditGoalDialog(context, ref),
            tooltip: 'Edit Goal',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.s16),
        children: [
          // Goal card
          GoalCard(
            goalName: jar.name,
            current: jar.balance,
            target: jar.goalAmount,
            etaText: DateFormatter.formatETA(jar.deadline),
          ),

          const SizedBox(height: AppTokens.s24),

          // Milestones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milestones',
                    style: AppTokens.subtitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s20),

                  _MilestoneBadge(
                    label: '25% Milestone',
                    percent: 25,
                    isUnlocked: progressPercent >= 25,
                    icon: Icons.star,
                  ),
                  const SizedBox(height: AppTokens.s12),

                  _MilestoneBadge(
                    label: 'Halfway There!',
                    percent: 50,
                    isUnlocked: progressPercent >= 50,
                    icon: Icons.favorite,
                  ),
                  const SizedBox(height: AppTokens.s12),

                  _MilestoneBadge(
                    label: 'Almost There!',
                    percent: 75,
                    isUnlocked: progressPercent >= 75,
                    icon: Icons.local_fire_department,
                  ),
                  const SizedBox(height: AppTokens.s12),

                  _MilestoneBadge(
                    label: 'Goal Achieved!',
                    percent: 100,
                    isUnlocked: progressPercent >= 100,
                    icon: Icons.emoji_events,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s24),

          // Actions
          if (progressPercent >= 100) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showWithdrawDialog(context, ref),
                icon: const Icon(Icons.celebration),
                label: const Text('Empty Jar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTokens.s20),
                  backgroundColor: AppTokens.accentRed,
                ),
              ),
            ),
            const SizedBox(height: AppTokens.s12),
          ],

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showNewGoalDialog(context, ref),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create New Goal'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppTokens.s20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, WidgetRef ref) {
    final jar = ref.read(jarProvider);
    final nameController = TextEditingController(text: jar.name);
    final amountController = TextEditingController(
      text: jar.goalAmount.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTokens.s16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final amount = double.tryParse(amountController.text);

              if (name.isNotEmpty && amount != null && amount > 0) {
                ref.read(jarProvider.notifier).updateGoal(
                      name: name,
                      goalAmount: amount,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Empty Jar?'),
        content: const Text(
          'This will reset your jar balance to \$0. Your progress will be saved in history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(jarProvider.notifier).updateBalance(0.0);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jar emptied successfully!')),
              );
            },
            child: const Text('Empty Jar'),
          ),
        ],
      ),
    );
  }

  void _showNewGoalDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., Vacation Fund',
              ),
            ),
            const SizedBox(height: AppTokens.s16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final amount = double.tryParse(amountController.text);

              if (name.isNotEmpty && amount != null && amount > 0) {
                ref.read(jarProvider.notifier).updateGoal(
                      name: name,
                      goalAmount: amount,
                      deadline: DateTime.now().add(const Duration(days: 30)),
                    );
                ref.read(jarProvider.notifier).updateBalance(0.0);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New goal "$name" created!')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  final String label;
  final int percent;
  final bool isUnlocked;
  final IconData icon;

  const _MilestoneBadge({
    required this.label,
    required this.percent,
    required this.isUnlocked,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTokens.s12),
          decoration: BoxDecoration(
            color: isUnlocked
                ? AppTokens.accentRed.withValues(alpha: 0.1)
                : AppTokens.gray200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isUnlocked ? AppTokens.accentRed : AppTokens.gray500,
            size: 24,
          ),
        ),
        const SizedBox(width: AppTokens.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTokens.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                '$percent%',
                style: AppTokens.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        if (isUnlocked)
          const Icon(Icons.check_circle, color: AppTokens.successGreen, size: 20),
      ],
    );
  }
}
