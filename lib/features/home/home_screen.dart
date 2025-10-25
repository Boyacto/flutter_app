import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../../state/jar_providers.dart';
import '../../theme/tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(userBalanceProvider);
    final jarsAsync = ref.watch(jarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OneUp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
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
            // Balance card placeholder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTokens.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: AppTokens.body.copyWith(color: AppTokens.gray500),
                    ),
                    const SizedBox(height: AppTokens.s8),
                    Text(
                      '₩${balance.currentBalance.toStringAsFixed(0)}',
                      style: AppTokens.display.copyWith(
                        color: AppTokens.navy,
                        fontSize: 36,
                      ),
                    ),
                    const Divider(height: AppTokens.s32),
                    Text(
                      'Jars',
                      style: AppTokens.subtitle.copyWith(color: AppTokens.navy),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Jars section
            jarsAsync.when(
              data: (jars) {
                if (jars.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppTokens.s24),
                      child: Text('No jars yet. Create your first jar!'),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Jars',
                      style: AppTokens.title.copyWith(color: AppTokens.navy),
                    ),
                    const SizedBox(height: AppTokens.s16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: jars.length,
                      itemBuilder: (context, index) {
                        final jar = jars[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppTokens.s8),
                          child: ListTile(
                            leading: Text(
                              jar.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            title: Text(jar.name),
                            subtitle: LinearProgressIndicator(
                              value: jar.progress.clamp(0.0, 1.0),
                              backgroundColor: AppTokens.gray200,
                              valueColor: const AlwaysStoppedAnimation(
                                AppTokens.teal,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // TODO: Navigate to jar detail
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
