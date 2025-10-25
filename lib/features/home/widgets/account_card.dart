import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/account.dart';
import '../../../core/models/jar_v2.dart';
import '../../../core/utils/currency.dart';
import '../../../theme/tokens.dart';
import '../../../state/jar_providers.dart';
import '../../../state/account_providers.dart';
import '../../jar/jar_detail_screen.dart';
import '../../jar/widgets/floating_affordability.dart';

/// Account Card widget that displays a savings account
/// with optional linked jar or "Make a Jar" button
class AccountCard extends ConsumerWidget {
  final Account account;

  const AccountCard({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jarsAsync = ref.watch(jarsProvider);
    final backgroundColor = _getAccountColor(account.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.s16,
        vertical: AppTokens.s8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account name (not clickable)
            Text(
              account.name,
              style: AppTokens.subtitle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTokens.navy,
              ),
            ),
            const SizedBox(height: AppTokens.s8),

            // Account balance (not clickable)
            Text(
              CurrencyFormatter.formatUSD(account.balance),
              style: AppTokens.display.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTokens.gray900,
              ),
            ),
            const SizedBox(height: AppTokens.s16),

            // Divider (not clickable)
            const Divider(height: 1),
            const SizedBox(height: AppTokens.s16),

            // Jar status section (clickable)
            if (account.hasLinkedJar)
              jarsAsync.when(
                data: (jars) {
                  try {
                    final jar = jars.firstWhere(
                      (j) => j.id == account.linkedJarId,
                    );
                    return _buildLinkedJarSection(context, ref, jar);
                  } catch (e) {
                    return _buildNoJarSection(context, ref);
                  }
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppTokens.s16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => _buildNoJarSection(context, ref),
              )
            else
              _buildNoJarSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedJarSection(BuildContext context, WidgetRef ref, JarV2 jar) {
    final isEmpty = jar.currentBalance == 0.0;

    // Determine emoji to display
    String displayEmoji;
    if (isEmpty) {
      displayEmoji = '🫙'; // Empty jar
    } else if (jar.isBrandCollabEnabled) {
      displayEmoji = jar.emoji; // Keep brand emoji (🏪 for OXXO)
    } else {
      // Use affordability range emoji for regular jars
      final affordabilityItem = AffordabilityItem.getForAmount(jar.currentBalance);
      displayEmoji = affordabilityItem.emoji;
    }

    return InkWell(
      onTap: () => _navigateToJar(context, ref, jar.id),
      borderRadius: AppTokens.radius12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTokens.s8),
        child: Row(
          children: [
            // Dynamic jar emoji
            Text(
              displayEmoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppTokens.s8),

            // Display message
            Expanded(
              child: Text(
                isEmpty
                    ? 'Your ${jar.name} will be filled soon!'
                    : 'Your ${jar.name} reached ${jar.streakDays} streaks🔥',
                style: AppTokens.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTokens.gray900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoJarSection(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _makeJar(context, ref),
      borderRadius: AppTokens.radius12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTokens.s8),
        child: Row(
          children: [
            // Light bulb emoji for "create jar" prompt
            const Text(
              '💡',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppTokens.s8),

            // Prompt message
            Expanded(
              child: Text(
                'Start saving with a Jar!',
                style: AppTokens.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTokens.gray900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeJar(BuildContext context, WidgetRef ref) async {
    try {
      // Create a new jar with defaults
      final newJar = await ref.read(jarsProvider.notifier).createJar();

      // Link the jar to this account
      await ref.read(accountsProvider.notifier).linkJar(account.id, newJar.id);

      // Navigate to jar detail
      if (context.mounted) {
        ref.read(selectedJarIdProvider.notifier).state = newJar.id;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const JarDetailScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create jar: $e')),
        );
      }
    }
  }

  void _navigateToJar(BuildContext context, WidgetRef ref, String jarId) {
    ref.read(selectedJarIdProvider.notifier).state = jarId;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const JarDetailScreen(),
      ),
    );
  }

  Color _getAccountColor(String accountId) {
    switch (accountId) {
      case '1':
        return Colors.blue.shade50;
      case '2':
        return const Color(0xFFFFF5F5); // Light red tint for OXXO
      case '3':
        return Colors.purple.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTokens.navy;
    }
  }
}
