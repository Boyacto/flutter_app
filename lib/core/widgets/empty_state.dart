import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Reusable empty state widget
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.action,
    this.actionLabel,
  });

  final String emoji;
  final String title;
  final String description;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji
            Text(
              emoji,
              style: TextStyle(fontSize: 80),
            ),

            const SizedBox(height: AppTokens.s24),

            // Title
            Text(
              title,
              style: AppTokens.title.copyWith(
                color: AppTokens.navy,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTokens.s12),

            // Description
            Text(
              description,
              style: AppTokens.body.copyWith(
                color: AppTokens.gray600,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional action button
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppTokens.s24),
              ElevatedButton(
                onPressed: action,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Specific empty state variants for common scenarios

class EmptyJarsState extends StatelessWidget {
  const EmptyJarsState({super.key, this.onCreateJar});

  final VoidCallback? onCreateJar;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      emoji: '🫙',
      title: 'No Jars Yet',
      description: 'Create your first savings jar and start building your goals!',
      action: onCreateJar,
      actionLabel: 'Create Jar',
    );
  }
}

class EmptyMissionsState extends StatelessWidget {
  const EmptyMissionsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      emoji: '✨',
      title: 'No Missions Available',
      description: 'Check back soon for new missions and earn more rewards!',
    );
  }
}

class EmptyTransactionsState extends StatelessWidget {
  const EmptyTransactionsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      emoji: '💳',
      title: 'No Transactions Yet',
      description: 'Your recent transactions will appear here.',
    );
  }
}

class EmptyCouponsState extends StatelessWidget {
  const EmptyCouponsState({super.key, this.onBrowseCoupons});

  final VoidCallback? onBrowseCoupons;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      emoji: '🎟️',
      title: 'No Coupons Yet',
      description: 'Browse the catalog and redeem coupons with your points!',
      action: onBrowseCoupons,
      actionLabel: 'Browse Coupons',
    );
  }
}

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      emoji: '🔍',
      title: 'No Results Found',
      description: 'Try adjusting your search or filters.',
    );
  }
}
