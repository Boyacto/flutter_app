import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../core/widgets/category_chip_group.dart';
import '../../core/widgets/slider_row.dart';
import '../../state/providers.dart';

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jar = ref.watch(jarProvider);
    final rules = jar.rules;
    final limits = jar.limits;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.s16),
        children: [
          // Round-up unit
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Round-up Unit',
                    style: AppTokens.subtitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s16),
                  SegmentedButton<double>(
                    segments: const [
                      ButtonSegment(value: 0.5, label: Text('\$0.50')),
                      ButtonSegment(value: 1.0, label: Text('\$1')),
                      ButtonSegment(value: 5.0, label: Text('\$5')),
                      ButtonSegment(value: 10.0, label: Text('\$10')),
                    ],
                    selected: {rules.roundUpUnit},
                    onSelectionChanged: (Set<double> selection) {
                      final newRules = rules.copyWith(roundUpUnit: selection.first);
                      ref.read(jarProvider.notifier).updateRules(newRules);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Weekend multiplier
          Card(
            child: SwitchListTile(
              value: rules.weekendMultiplier > 1.0,
              onChanged: (value) {
                final newRules = rules.copyWith(
                  weekendMultiplier: value ? 2.0 : 1.0,
                );
                ref.read(jarProvider.notifier).updateRules(newRules);
              },
              title: Text(
                'Weekend 2× Bonus',
                style: AppTokens.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Double your round-ups on weekends',
                style: AppTokens.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Categories
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: AppTokens.subtitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    'Select which categories to include or exclude',
                    style: AppTokens.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppTokens.s16),
                  CategoryChipGroup(
                    options: const [
                      'Food & Drink',
                      'Shopping',
                      'Groceries',
                      'Gas',
                      'Entertainment',
                      'Transportation',
                      'Health',
                      'Bills',
                    ],
                    selected: rules.includeCategories.isNotEmpty
                        ? rules.includeCategories
                        : rules.excludeCategories,
                    includeMode: rules.includeCategories.isNotEmpty,
                    onChanged: (selected) {
                      final newRules = rules.includeCategories.isNotEmpty
                          ? rules.copyWith(includeCategories: selected)
                          : rules.copyWith(excludeCategories: selected);
                      ref.read(jarProvider.notifier).updateRules(newRules);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Limits
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Limits',
                    style: AppTokens.subtitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s16),
                  SliderRow(
                    label: 'Daily Cap',
                    min: 5,
                    max: 50,
                    value: limits.dailyCap ?? 10,
                    suffix: '/day',
                    onChanged: (value) {
                      final newLimits = limits.copyWith(dailyCap: value);
                      ref.read(jarProvider.notifier).updateLimits(newLimits);
                    },
                  ),
                  const SizedBox(height: AppTokens.s16),
                  SliderRow(
                    label: 'Weekly Cap',
                    min: 20,
                    max: 200,
                    value: limits.weeklyCap ?? 50,
                    suffix: '/week',
                    divisions: 18,
                    onChanged: (value) {
                      final newLimits = limits.copyWith(weeklyCap: value);
                      ref.read(jarProvider.notifier).updateLimits(newLimits);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Pause
          Card(
            child: ListTile(
              leading: const Icon(Icons.pause_circle),
              title: Text(
                jar.isPaused ? 'Paused' : 'Pause Round-ups',
                style: AppTokens.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: jar.isPaused
                  ? Text(
                      'Paused until ${jar.pausedUntil?.toString().split(' ').first}',
                      style: AppTokens.caption,
                    )
                  : null,
              trailing: jar.isPaused
                  ? TextButton(
                      onPressed: () {
                        ref.read(jarProvider.notifier).setPause(null);
                      },
                      child: const Text('Resume'),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: jar.isPaused
                  ? null
                  : () => _showPauseDialog(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  void _showPauseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pause Round-ups'),
        content: const Text('How long would you like to pause?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final pauseUntil = DateTime.now().add(const Duration(days: 1));
              ref.read(jarProvider.notifier).setPause(pauseUntil);
              Navigator.pop(context);
            },
            child: const Text('1 Day'),
          ),
          TextButton(
            onPressed: () {
              final pauseUntil = DateTime.now().add(const Duration(days: 7));
              ref.read(jarProvider.notifier).setPause(pauseUntil);
              Navigator.pop(context);
            },
            child: const Text('1 Week'),
          ),
        ],
      ),
    );
  }
}
