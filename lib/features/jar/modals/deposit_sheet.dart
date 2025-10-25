import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/jar_providers.dart';
import '../../../theme/tokens.dart';

class DepositSheet extends ConsumerStatefulWidget {
  const DepositSheet({super.key, required this.jarId});

  final String jarId;

  @override
  ConsumerState<DepositSheet> createState() => _DepositSheetState();
}

class _DepositSheetState extends ConsumerState<DepositSheet> {
  double? _selectedAmount;
  final _customController = TextEditingController();

  final List<double> _presetAmounts = [10000, 50000, 100000, 200000];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Deposit Amount',
              style: AppTokens.title.copyWith(color: AppTokens.navy),
            ),
            const SizedBox(height: AppTokens.s24),

            // Preset chips
            Wrap(
              spacing: AppTokens.s8,
              runSpacing: AppTokens.s8,
              children: _presetAmounts
                  .map((amount) => ChoiceChip(
                        label: Text('₩${(amount / 1000).toStringAsFixed(0)}K'),
                        selected: _selectedAmount == amount,
                        onSelected: (selected) {
                          setState(() {
                            _selectedAmount = selected ? amount : null;
                            _customController.clear();
                          });
                        },
                      ))
                  .toList(),
            ),

            const SizedBox(height: AppTokens.s16),
            const Divider(),
            const SizedBox(height: AppTokens.s16),

            // Custom input
            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Custom amount',
                prefixText: '₩',
              ),
              onChanged: (value) {
                setState(() {
                  _selectedAmount = double.tryParse(value);
                });
              },
            ),

            const SizedBox(height: AppTokens.s24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedAmount != null && _selectedAmount! > 0
                        ? _confirmDeposit
                        : null,
                child: const Text('Confirm Deposit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeposit() async {
    if (_selectedAmount == null) return;

    try {
      await ref.read(jarsProvider.notifier).deposit(
            widget.jarId,
            _selectedAmount!,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deposit successful!')),
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
