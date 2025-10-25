import 'package:flutter/material.dart';
import '../../../core/models/jar_v2.dart';
import '../../../theme/tokens.dart';

class TipSheet extends StatelessWidget {
  const TipSheet({super.key, required this.mode});

  final SavingMode mode;

  @override
  Widget build(BuildContext context) {
    final tips = _getTipsForMode(mode);

    return Container(
      padding: const EdgeInsets.all(AppTokens.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getModeTitle(mode),
                style: AppTokens.title.copyWith(color: AppTokens.navy),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.s16),

          ...tips
              .map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTokens.s12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  '),
                        Expanded(child: Text(tip, style: AppTokens.body)),
                      ],
                    ),
                  ))
              ,
        ],
      ),
    );
  }

  String _getModeTitle(SavingMode mode) {
    switch (mode) {
      case SavingMode.manual:
        return '💰 Manual Saving';
      case SavingMode.autoSave:
        return '🤖 Auto-Save AI';
      case SavingMode.brandCoupons:
        return '🎟️ Brand Coupons';
    }
  }

  List<String> _getTipsForMode(SavingMode mode) {
    switch (mode) {
      case SavingMode.manual:
        return [
          'Deposit whenever you want',
          'Full control over your savings',
          'Set reminders to stay on track',
        ];
      case SavingMode.autoSave:
        return [
          'AI analyzes your spending patterns',
          'Automatically saves spare change',
          'Optimizes based on your goals',
        ];
      case SavingMode.brandCoupons:
        return [
          'Save by using brand coupons',
          'Earn rewards while saving',
          'Redeem with your points',
        ];
    }
  }
}
