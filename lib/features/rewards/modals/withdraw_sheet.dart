import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/app_providers.dart';
import '../../../state/rewards_providers.dart';
import '../../../theme/tokens.dart';

class WithdrawSheet extends ConsumerStatefulWidget {
  const WithdrawSheet({super.key});

  @override
  ConsumerState<WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends ConsumerState<WithdrawSheet> {
  final _controller = TextEditingController();
  int _requestedPoints = 0;
  static const double _feePercentage = 0.1; // 10%

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _fee => (_requestedPoints * _feePercentage).round();
  int get _netPoints => _requestedPoints - _fee;

  @override
  Widget build(BuildContext context) {
    final userPoints = ref.watch(userBalanceProvider).points;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTokens.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Withdraw Points',
              style: AppTokens.title.copyWith(color: AppTokens.navy),
            ),
            const SizedBox(height: AppTokens.s8),
            Text(
              'Available: $userPoints points',
              style: AppTokens.body.copyWith(color: AppTokens.gray500),
            ),

            const SizedBox(height: AppTokens.s24),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Points to withdraw',
                suffixText: 'pts',
              ),
              onChanged: (value) {
                setState(() {
                  _requestedPoints = int.tryParse(value) ?? 0;
                });
              },
            ),

            if (_requestedPoints > 0) ...[
              const SizedBox(height: AppTokens.s16),
              Container(
                padding: const EdgeInsets.all(AppTokens.s16),
                decoration: BoxDecoration(
                  color: AppTokens.gray50,
                  borderRadius: AppTokens.radius12,
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Requested',
                      value: '$_requestedPoints pts',
                    ),
                    const SizedBox(height: AppTokens.s8),
                    _InfoRow(
                      label: 'Fee (10%)',
                      value: '-$_fee pts',
                      valueColor: AppTokens.accentRed,
                    ),
                    const Divider(height: AppTokens.s16),
                    _InfoRow(
                      label: 'You receive',
                      value: '$_netPoints pts',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppTokens.s24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _requestedPoints > 0 && _requestedPoints <= userPoints
                    ? _confirmWithdraw
                    : null,
                child: const Text('Confirm Withdrawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmWithdraw() async {
    try {
      final withdrawAction = ref.read(withdrawPointsProvider);
      await withdrawAction(points: _requestedPoints);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrew $_netPoints points (after fee)'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTokens.label
              : AppTokens.body.copyWith(color: AppTokens.gray700),
        ),
        Text(
          value,
          style: isBold
              ? AppTokens.label.copyWith(color: valueColor ?? AppTokens.navy)
              : AppTokens.body.copyWith(color: valueColor ?? AppTokens.navy),
        ),
      ],
    );
  }
}
