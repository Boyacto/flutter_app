import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../../state/rewards_providers.dart';
import '../../state/game_session_provider.dart';
import '../../theme/tokens.dart';
import '../../app_router.dart';
import 'widgets/points_counter.dart';
import '../../core/widgets/mission_card.dart';
import '../../core/widgets/game_card.dart';
import 'modals/coupon_catalog_modal.dart';
import 'modals/withdraw_sheet.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(userBalanceProvider);
    final missionsAsync = ref.watch(missionsProvider);
    final gamesAsync = ref.watch(gamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTokens.s16),
            child: PointsCounter(
              points: balance.points,
              coupons: balance.couponsCount,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(missionsProvider);
          ref.invalidate(gamesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.s16),
          children: [
            // Games Section
            Text(
              'Games',
              style: AppTokens.title.copyWith(color: AppTokens.navy),
            ),
            const SizedBox(height: AppTokens.s12),
            gamesAsync.when(
              data: (games) {
                if (games.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppTokens.s24),
                      child: Center(child: Text('No games available')),
                    ),
                  );
                }

                return Column(
                  children: games.map((game) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTokens.s8),
                      child: GameCardWidget(
                        game: game,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.game,
                            arguments: game.id,
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: AppTokens.s24),

            // Missions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Missions',
                  style: AppTokens.title.copyWith(color: AppTokens.navy),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.s12),
            missionsAsync.when(
              data: (missions) {
                if (missions.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppTokens.s24),
                      child: Center(child: Text('No missions available')),
                    ),
                  );
                }

                return Column(
                  children: missions.map((mission) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTokens.s8),
                      child: MissionCardWidget(
                        mission: mission,
                        onTap: () async {
                          // Complete the mission
                          try {
                            final completeMissionAction =
                                ref.read(completeMissionProvider);
                            await completeMissionAction(mission.id);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Earned ${mission.rewardPoints} points!',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),

            const SizedBox(height: AppTokens.s24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTokens.title.copyWith(color: AppTokens.navy),
            ),
            const SizedBox(height: AppTokens.s12),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.local_offer,
                    label: 'Browse Coupons',
                    color: AppTokens.teal,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const CouponCatalogModal(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppTokens.s12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.account_balance_wallet,
                    label: 'Withdraw Points',
                    color: AppTokens.accentRed,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const WithdrawSheet(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTokens.radius12,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTokens.s12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: AppTokens.s12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTokens.label.copyWith(color: AppTokens.navy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
