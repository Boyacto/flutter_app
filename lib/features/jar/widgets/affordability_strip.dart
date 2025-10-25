import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class AffordabilityStrip extends StatelessWidget {
  const AffordabilityStrip({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final items = _getAffordableItems(amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What this can buy',
              style: AppTokens.label.copyWith(color: AppTokens.gray700),
            ),
            const SizedBox(height: AppTokens.s12),

            Wrap(
              spacing: AppTokens.s16,
              runSpacing: AppTokens.s8,
              children: items
                  .map((item) => _AffordabilityItem(
                        emoji: item['emoji'] as String,
                        name: item['name'] as String,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getAffordableItems(double amount) {
    // Simple logic: show items based on amount
    if (amount < 5000) {
      return [
        {'emoji': '☕', 'name': 'Coffee'},
      ];
    } else if (amount < 15000) {
      return [
        {'emoji': '☕', 'name': 'Coffee'},
        {'emoji': '🍔', 'name': 'Burger'},
      ];
    } else if (amount < 30000) {
      return [
        {'emoji': '☕', 'name': 'Coffee'},
        {'emoji': '🍔', 'name': 'Burger'},
        {'emoji': '🎬', 'name': 'Movie'},
      ];
    } else {
      return [
        {'emoji': '☕', 'name': 'Coffee'},
        {'emoji': '🍔', 'name': 'Burger'},
        {'emoji': '🎬', 'name': 'Movie'},
        {'emoji': '📚', 'name': 'Book'},
      ];
    }
  }
}

class _AffordabilityItem extends StatelessWidget {
  const _AffordabilityItem({required this.emoji, required this.name});

  final String emoji;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 4),
        Text(name, style: AppTokens.caption),
      ],
    );
  }
}
