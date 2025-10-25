import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../core/models/event.dart';
import '../../state/providers.dart';

class SimulateScreen extends ConsumerStatefulWidget {
  const SimulateScreen({super.key});

  @override
  ConsumerState<SimulateScreen> createState() => _SimulateScreenState();
}

class _SimulateScreenState extends ConsumerState<SimulateScreen> {
  double _amount = 25.0;
  String _category = 'Food & Drink';
  String? _merchant;

  final List<String> _categories = [
    'Food & Drink',
    'Shopping',
    'Groceries',
    'Gas',
    'Entertainment',
    'Transportation',
    'Health',
    'Bills',
  ];

  @override
  Widget build(BuildContext context) {
    final mockApi = ref.read(mockApiServiceProvider);
    final jar = ref.watch(jarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulate Purchase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.s16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Details',
                    style: AppTokens.title.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s24),

                  // Amount slider
                  Text(
                    'Amount',
                    style: AppTokens.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    '\$${_amount.toStringAsFixed(2)}',
                    style: AppTokens.display.copyWith(
                      fontSize: 36,
                      color: AppTokens.mint600,
                    ),
                  ),
                  Slider(
                    value: _amount,
                    min: 1.0,
                    max: 100.0,
                    divisions: 99,
                    label: '\$${_amount.toStringAsFixed(2)}',
                    onChanged: (value) {
                      setState(() => _amount = value);
                    },
                  ),

                  const SizedBox(height: AppTokens.s24),

                  // Category picker
                  Text(
                    'Category',
                    style: AppTokens.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s12),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
                  ),

                  const SizedBox(height: AppTokens.s24),

                  // Merchant
                  Text(
                    'Merchant',
                    style: AppTokens.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _merchant ?? 'Random',
                          style: AppTokens.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _merchant = mockApi.getRandomMerchant();
                          });
                        },
                        child: const Text('Random'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s24),

          // Generate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _simulatePurchase(context),
              icon: const Icon(Icons.receipt_long),
              label: const Text('Generate Purchase'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppTokens.s20),
              ),
            ),
          ),

          const SizedBox(height: AppTokens.s16),

          // Info card
          Card(
            color: AppTokens.mint50,
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTokens.mint600),
                  const SizedBox(width: AppTokens.s12),
                  Expanded(
                    child: Text(
                      'Current rules: Round-up to \$${jar.rules.roundUpUnit}, '
                      '${jar.rules.weekendMultiplier > 1 ? 'Weekend 2×' : 'No weekend bonus'}',
                      style: AppTokens.bodySmall.copyWith(
                        color: AppTokens.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePurchase(BuildContext context) {
    final mockApi = ref.read(mockApiServiceProvider);
    final engine = ref.read(roundUpEngineProvider);
    final jar = ref.read(jarProvider);

    // Generate transaction
    final transaction = mockApi.simulatePurchase(
      amount: _amount,
      category: _category,
      merchant: _merchant,
    );

    // Process round-up
    final result = engine.processTransaction(
      transaction: transaction,
      rules: jar.rules,
      limits: jar.limits,
      isPaused: jar.isPaused,
    );

    if (result.applied) {
      // Add to balance
      ref.read(jarProvider.notifier).addToBalance(result.amount);

      // Update limits
      var updatedLimits = jar.limits.resetIfNeeded();
      updatedLimits = updatedLimits.copyWith(
        dailyUsed: updatedLimits.dailyUsed + result.amount,
        weeklyUsed: updatedLimits.weeklyUsed + result.amount,
      );
      ref.read(jarProvider.notifier).updateLimits(updatedLimits);

      // Create event
      final updatedJar = ref.read(jarProvider);
      final event = Event.roundUp(
        id: 'roundup_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: transaction.timestamp,
        transactionId: transaction.id,
        roundUpAmount: result.amount,
        jarBalanceAfter: updatedJar.balance,
        merchant: transaction.merchant,
        category: transaction.category,
        transactionAmount: transaction.amount,
        roundUpUnit: jar.rules.roundUpUnit,
        multiplier: result.multiplier,
      );
      ref.read(eventsProvider.notifier).addEvent(event);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${transaction.merchant} \$${transaction.amount.toStringAsFixed(2)} — '
            '+\$${result.amount.toStringAsFixed(2)} saved!',
          ),
          backgroundColor: AppTokens.mint600,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context);
    } else {
      // Show skip reason
      final reason = engine.getSkipReasonMessage(result.skipReason ?? 'unknown');
      final hint = engine.getSkipReasonHint(result.skipReason ?? 'unknown');

      // Create skip event
      final event = Event.skip(
        id: 'skip_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: transaction.timestamp,
        transactionId: transaction.id,
        reason: result.skipReason ?? 'unknown',
        merchant: transaction.merchant,
        category: transaction.category,
        transactionAmount: transaction.amount,
      );
      ref.read(eventsProvider.notifier).addEvent(event);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Round-up Skipped'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reason),
              if (hint.isNotEmpty) ...[
                const SizedBox(height: AppTokens.s12),
                Text(
                  'Hint: $hint',
                  style: AppTokens.caption.copyWith(
                    color: AppTokens.gray500,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
