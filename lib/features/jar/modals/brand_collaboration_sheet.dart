import 'package:flutter/material.dart';
import '../../../core/models/brand_collaboration.dart';
import '../../../theme/tokens.dart';

/// Bottom sheet to show brand collaboration details and rewards
class BrandCollaborationSheet extends StatelessWidget {
  final BrandCollaboration collaboration;

  const BrandCollaborationSheet({
    super.key,
    required this.collaboration,
  });

  static void show(BuildContext context, BrandCollaboration collaboration) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BrandCollaborationSheet(
        collaboration: collaboration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.r24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppTokens.s12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTokens.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jar with ${collaboration.brandName} starts from now',
                    style: AppTokens.title.copyWith(
                      color: AppTokens.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s12),
                  Text(
                    'Your money stays the same, but your jar becomes a branded jar. You can get rewards each time you complete a mission.',
                    style: AppTokens.body.copyWith(
                      color: AppTokens.gray600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Rewards list
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTokens.s24),
              child: Text(
                'Available Rewards',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.navy,
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // Scrollable rewards
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.s16),
                child: Column(
                  children: collaboration.rewards
                      .map((reward) => _RewardCard(reward: reward))
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s16),

            // Button
            Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTokens.s16),
                ),
                child: const Text('I\'ve reviewed the benefits'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final BrandReward reward;

  const _RewardCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.s8,
        vertical: AppTokens.s6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s16),
        child: Row(
          children: [
            // Emoji or image placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTokens.gray100,
                borderRadius: AppTokens.radius12,
              ),
              child: Center(
                child: Text(
                  reward.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),

            const SizedBox(width: AppTokens.s16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    reward.title,
                    style: AppTokens.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTokens.gray900,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s4),

                  // Description
                  Text(
                    reward.description,
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
