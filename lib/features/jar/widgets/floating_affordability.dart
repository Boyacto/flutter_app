import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Data class for affordability items
class AffordabilityItem {
  final String emoji;
  final String description;
  final double minAmount;
  final double maxAmount;

  const AffordabilityItem({
    required this.emoji,
    required this.description,
    required this.minAmount,
    required this.maxAmount,
  });

  static const List<AffordabilityItem> items = [
    AffordabilityItem(
      emoji: '🖊️',
      description: 'Pen',
      minAmount: 0,
      maxAmount: 1.0,
    ),
    AffordabilityItem(
      emoji: '☕',
      description: 'Cup of coffee',
      minAmount: 1.0,
      maxAmount: 5.0,
    ),
    AffordabilityItem(
      emoji: '🥪',
      description: 'Sandwich',
      minAmount: 5.0,
      maxAmount: 10.0,
    ),
    AffordabilityItem(
      emoji: '🍱',
      description: 'Lunch box',
      minAmount: 10.0,
      maxAmount: 20.0,
    ),
    AffordabilityItem(
      emoji: '🎬',
      description: '2 movie tickets',
      minAmount: 20.0,
      maxAmount: 30.0,
    ),
    AffordabilityItem(
      emoji: '🕯️',
      description: 'Luxury candle',
      minAmount: 30.0,
      maxAmount: 50.0,
    ),
    AffordabilityItem(
      emoji: '🎧',
      description: 'Wireless headset',
      minAmount: 50.0,
      maxAmount: 70.0,
    ),
    AffordabilityItem(
      emoji: '⛽',
      description: '2-3 gas fill-ups',
      minAmount: 70.0,
      maxAmount: 100.0,
    ),
  ];

  static AffordabilityItem getForAmount(double amount) {
    try {
      return items.firstWhere(
        (item) => amount >= item.minAmount && amount < item.maxAmount,
      );
    } catch (e) {
      // If amount is >= 100, return the last item
      if (amount >= 100.0) {
        return items.last;
      }
      // Otherwise return the first item
      return items.first;
    }
  }
}

/// Floating affordability display that shows what you can afford
/// with your current savings
class FloatingAffordability extends StatelessWidget {
  final double currentAmount;

  const FloatingAffordability({
    super.key,
    required this.currentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = currentAmount == 0.0;

    // For empty jar, show special message
    if (isEmpty) {
      return Container(
        margin: const EdgeInsets.all(AppTokens.s16),
        padding: const EdgeInsets.all(AppTokens.s24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppTokens.radius24,
          boxShadow: [
            BoxShadow(
              color: AppTokens.navy.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Large empty jar emoji
            Container(
              padding: const EdgeInsets.all(AppTokens.s20),
              decoration: BoxDecoration(
                color: AppTokens.gray100,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '🫙',
                style: TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: AppTokens.s16),

            // Encouraging message
            Text(
              'Looking forward to seeing how much this will fill!',
              style: AppTokens.title.copyWith(
                color: AppTokens.navy,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // For non-empty jar, show affordability
    final item = AffordabilityItem.getForAmount(currentAmount);

    return Container(
      margin: const EdgeInsets.all(AppTokens.s16),
      padding: const EdgeInsets.all(AppTokens.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTokens.radius24,
        boxShadow: [
          BoxShadow(
            color: AppTokens.navy.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'You can afford',
            style: AppTokens.body.copyWith(
              color: AppTokens.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppTokens.s16),

          // Large emoji with floating effect
          Container(
            padding: const EdgeInsets.all(AppTokens.s20),
            decoration: BoxDecoration(
              color: AppTokens.gray100,
              shape: BoxShape.circle,
            ),
            child: Text(
              item.emoji,
              style: const TextStyle(fontSize: 80),
            ),
          ),
          const SizedBox(height: AppTokens.s16),

          // Description
          Text(
            item.description,
            style: AppTokens.title.copyWith(
              color: AppTokens.navy,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          // Optional: Show current amount
          const SizedBox(height: AppTokens.s8),
          Text(
            'with \$${currentAmount.toStringAsFixed(2)}',
            style: AppTokens.caption.copyWith(
              color: AppTokens.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
