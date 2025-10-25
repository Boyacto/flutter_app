import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/jar_v2.dart';
import '../../../core/utils/currency.dart';
import '../../../theme/tokens.dart';

class DepositReveal extends StatefulWidget {
  const DepositReveal({super.key, required this.jar});

  final JarV2 jar;

  @override
  State<DepositReveal> createState() => _DepositRevealState();
}

class _DepositRevealState extends State<DepositReveal>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  late AnimationController _coinController;

  @override
  void initState() {
    super.initState();
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _coinController.dispose();
    super.dispose();
  }

  void _reveal() {
    HapticFeedback.mediumImpact();
    setState(() => _isRevealed = true);
    _coinController.forward();

    // Auto re-mask after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isRevealed = false);
        _coinController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 100) {
          _reveal();
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Deposit',
                style: AppTokens.body.copyWith(color: AppTokens.gray500),
              ),
              const SizedBox(height: AppTokens.s8),

              Stack(
                children: [
                  // Amount (masked or revealed)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isRevealed
                        ? Text(
                            formatCurrency(widget.jar.todayDeposit),
                            key: const ValueKey('revealed'),
                            style: AppTokens.display.copyWith(
                              color: AppTokens.teal,
                              fontSize: 36,
                            ),
                          )
                        : Text(
                            '₩ •••••',
                            key: const ValueKey('masked'),
                            style: AppTokens.display.copyWith(
                              color: AppTokens.gray200,
                              fontSize: 36,
                            ),
                          ),
                  ),

                  // Coin drop animation
                  if (_isRevealed)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedBuilder(
                        animation: _coinController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _coinController.value * 50 - 50),
                            child: Opacity(
                              opacity: 1 - _coinController.value,
                              child: const Text(
                                '🪙',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppTokens.s8),
              Text(
                _isRevealed ? 'Great job!' : 'Pull down to reveal',
                style: AppTokens.caption.copyWith(color: AppTokens.gray500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
