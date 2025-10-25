import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/jar_v2.dart';
import '../../state/jar_providers.dart';
import '../../theme/tokens.dart';
import 'widgets/streak_header.dart';
import 'widgets/deposit_reveal.dart';
import 'widgets/affordability_strip.dart';
import 'widgets/mode_selector.dart';
import 'widgets/activity_list.dart';
import 'modals/deposit_sheet.dart';

class JarDetailScreen extends ConsumerWidget {
  const JarDetailScreen({super.key, required this.jarId});

  final String jarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jarsAsync = ref.watch(jarsProvider);

    return jarsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Jar')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Jar')),
        body: Center(child: Text('Error: $err')),
      ),
      data: (jars) {
        final jar = jars.firstWhere(
          (j) => j.id == jarId,
          orElse: () => throw Exception('Jar not found'),
        );

        return _buildJarDetail(context, ref, jar);
      },
    );
  }

  Widget _buildJarDetail(BuildContext context, WidgetRef ref, JarV2 jar) {

    return Scaffold(
      appBar: AppBar(
        title: Text(jar.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit options coming soon')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(jarsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.s16),
          children: [
            // Streak display
            StreakHeader(streakDays: jar.streakDays),

            const SizedBox(height: AppTokens.s16),

            // Today's deposit (pull-to-reveal)
            DepositReveal(jar: jar),

            const SizedBox(height: AppTokens.s16),

            // Affordability strip
            AffordabilityStrip(amount: jar.todayDeposit),

            const SizedBox(height: AppTokens.s24),

            // Saving mode selector
            ModeSelector(jar: jar),

            const SizedBox(height: AppTokens.s24),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDepositSheet(context, jar.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Deposit'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTokens.s24),

            // Activity list
            ActivityList(activities: jar.activities),
          ],
        ),
      ),
    );
  }

  void _showDepositSheet(BuildContext context, String jarId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DepositSheet(jarId: jarId),
    );
  }
}
