import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/jar_v2.dart';
import '../../state/jar_providers.dart';
import '../../theme/tokens.dart';
import 'widgets/streak_header.dart';
import 'widgets/floating_affordability.dart';
import 'widgets/saving_feature_card.dart';
import 'widgets/activity_list.dart';
import 'modals/brand_collaboration_sheet.dart';

class JarDetailScreen extends ConsumerWidget {
  const JarDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jar = ref.watch(selectedJarProvider);

    if (jar == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Jar')),
        body: const Center(child: Text('Jar not found')),
      );
    }

    // Get dynamic background color
    final backgroundColor = _getBackgroundColor(jar);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(jar.name),
        backgroundColor: backgroundColor,
        elevation: 0,
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
          padding: const EdgeInsets.only(bottom: AppTokens.s24),
          children: [
            // Streak Header
            Padding(
              padding: const EdgeInsets.all(AppTokens.s16),
              child: StreakHeader(streakDays: jar.streakDays),
            ),

            const SizedBox(height: AppTokens.s8),

            // Floating Affordability Display
            FloatingAffordability(currentAmount: jar.currentBalance),

            const SizedBox(height: AppTokens.s24),

            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.s16),
              child: Text(
                'Saving Features',
                style: AppTokens.title.copyWith(
                  color: AppTokens.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // Coin Saving Card
            SavingFeatureCard(
              title: 'Coin Saving',
              description: 'Save up to \$1 every day',
              isEnabled: jar.isCoinSavingEnabled,
              onToggle: (value) {
                ref.read(jarsProvider.notifier).updateCoinSaving(jar.id, value);
              },
            ),

            // Auto-Save Card
            SavingFeatureCard(
              title: 'Auto-Save',
              description: 'AI analyzes spending and saves \$1-\$10/week',
              isEnabled: jar.isAutoSaveEnabled,
              onToggle: (value) {
                ref.read(jarsProvider.notifier).updateAutoSave(jar.id, value);
              },
            ),

            // Brand Collaboration Card
            BrandCollaborationCard(
              brandName: jar.brandCollaboration?.brandName ?? 'Brand',
              description: jar.isBrandCollabEnabled
                  ? 'Join ${jar.brandCollaboration?.brandName ?? "Brand"} jar for exclusive rewards'
                  : 'Participate in brand collaboration for rewards',
              isEnabled: jar.isBrandCollabEnabled,
              onToggle: (value) {
                ref.read(jarsProvider.notifier).updateBrandCollab(jar.id, value);
              },
              onInfoTap: () {
                if (jar.brandCollaboration != null) {
                  BrandCollaborationSheet.show(
                    context,
                    jar.brandCollaboration!,
                  );
                }
              },
            ),

            const SizedBox(height: AppTokens.s24),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.s16),
              child: Text(
                'Recent Activity',
                style: AppTokens.title.copyWith(
                  color: AppTokens.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // Activity list
            Card(
              margin: const EdgeInsets.symmetric(horizontal: AppTokens.s16),
              child: jar.activities.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppTokens.s32),
                      child: Column(
                        children: [
                          const Text('📝', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: AppTokens.s12),
                          Text(
                            'No activity yet',
                            style: AppTokens.body.copyWith(
                              color: AppTokens.gray500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        ActivityList(activities: jar.activities.take(5).toList()),
                        if (jar.activities.length > 5)
                          TextButton(
                            onPressed: () {
                              // Show all activities
                            },
                            child: const Text('View all activity'),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(JarV2 jar) {
    // Brand collaboration jars use brand color
    if (jar.isBrandCollabEnabled && jar.brandCollaboration != null) {
      try {
        final hex = jar.brandCollaboration!.brandColor;
        return Color(int.parse(hex.replaceFirst('#', '0xFF')))
            .withOpacity(0.1);
      } catch (e) {
        // Fallback to emoji-based color
      }
    }

    // Emoji-based colors for regular jars
    return _getEmojiColor(jar.emoji);
  }

  Color _getEmojiColor(String emoji) {
    // Map emojis to colors
    final colorMap = {
      '🏖️': Colors.blue.shade50, // Beach - blue
      '🎮': Colors.purple.shade50, // Gaming - purple
      '🚗': Colors.grey.shade100, // Car - grey
      '🏪': Colors.red.shade50, // Store - red
      '🎯': Colors.orange.shade50, // Target - orange
      '💎': Colors.cyan.shade50, // Diamond - cyan
      '🌟': Colors.yellow.shade50, // Star - yellow
      '🎨': Colors.pink.shade50, // Art - pink
      '📚': Colors.brown.shade50, // Books - brown
      '🏆': Colors.amber.shade50, // Trophy - amber
    };

    return colorMap[emoji] ?? Colors.grey.shade50;
  }
}
