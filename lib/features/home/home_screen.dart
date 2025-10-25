import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/jar_v2.dart';
import '../../state/app_providers.dart';
import '../../state/jar_providers.dart';
import '../../theme/tokens.dart';
import '../../app_router.dart';

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
            // Balance card
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
                    Center(
                      child: Text(
                        '🏦',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Jars section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Jars',
                  style: AppTokens.title.copyWith(color: AppTokens.navy),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppTokens.teal),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Create jar coming soon')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: AppTokens.s12),

            // Jars grid
            jarsAsync.when(
              data: (jars) {
                if (jars.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTokens.s48),
                      child: Column(
                        children: [
                          Text(
                            '🎯',
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: AppTokens.s16),
                          Text(
                            'No jars yet',
                            style: AppTokens.title.copyWith(
                              color: AppTokens.gray500,
                            ),
                          ),
                          const SizedBox(height: AppTokens.s8),
                          Text(
                            'Create your first jar to start saving!',
                            style: AppTokens.body.copyWith(
                              color: AppTokens.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTokens.s12,
                    mainAxisSpacing: AppTokens.s12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: jars.length,
                  itemBuilder: (context, index) {
                    final jar = jars[index];
                    return _JarCard(jar: jar);
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppTokens.s48),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.s24),
                  child: Text('Error: $err'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JarCard extends StatelessWidget {
  const _JarCard({required this.jar});

  final JarV2 jar;

  @override
  Widget build(BuildContext context) {
    final progressPercent = (jar.progress * 100).clamp(0, 100).toInt();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.jarDetail,
            arguments: jar.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji and streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jar.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  if (jar.streakDays > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.s8,
                        vertical: AppTokens.s4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.accentRed.withOpacity(0.1),
                        borderRadius: AppTokens.radius8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 2),
                          Text(
                            '${jar.streakDays}',
                            style: AppTokens.caption.copyWith(
                              color: AppTokens.accentRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppTokens.s8),

              // Jar name
              Text(
                jar.name,
                style: AppTokens.subtitle.copyWith(color: AppTokens.navy),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppTokens.s4),

              // Balance
              Text(
                '₩${jar.currentBalance.toStringAsFixed(0)}',
                style: AppTokens.title.copyWith(
                  color: AppTokens.teal,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: AppTokens.s4),

              // Goal
              Text(
                'Goal: ₩${jar.goalAmount.toStringAsFixed(0)}',
                style: AppTokens.caption.copyWith(color: AppTokens.gray500),
              ),

              const Spacer(),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$progressPercent%',
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s4),
                  ClipRRect(
                    borderRadius: AppTokens.radius8,
                    child: LinearProgressIndicator(
                      value: jar.progress.clamp(0.0, 1.0),
                      backgroundColor: AppTokens.gray200,
                      valueColor: const AlwaysStoppedAnimation(AppTokens.teal),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
