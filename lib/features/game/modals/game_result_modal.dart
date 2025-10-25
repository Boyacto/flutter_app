import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../theme/tokens.dart';
import '../../../core/utils/currency.dart';

class GameResultModal extends StatefulWidget {
  const GameResultModal({
    super.key,
    required this.isSuccess,
    required this.rewardAmount,
    required this.isMoneyReward,
    required this.pointsEarned,
  });

  final bool isSuccess;
  final double rewardAmount;
  final bool isMoneyReward;
  final int pointsEarned;

  @override
  State<GameResultModal> createState() => _GameResultModalState();
}

class _GameResultModalState extends State<GameResultModal> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    if (widget.isSuccess) {
      // Start confetti after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _confettiController.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppTokens.radius24,
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTokens.s32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon/Emoji
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: widget.isSuccess
                        ? AppTokens.successGreen.withOpacity(0.1)
                        : AppTokens.errorRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.isSuccess ? '🎉' : '😔',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),

                const SizedBox(height: AppTokens.s24),

                // Title
                Text(
                  widget.isSuccess ? 'Success!' : 'Missed!',
                  style: AppTokens.title.copyWith(
                    fontSize: 28,
                    color: widget.isSuccess
                        ? AppTokens.successGreen
                        : AppTokens.errorRed,
                  ),
                ),

                const SizedBox(height: AppTokens.s12),

                // Reward/Message
                if (widget.isSuccess) ...[
                  Text(
                    'You earned',
                    style: AppTokens.body.copyWith(color: AppTokens.gray600),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  if (widget.isMoneyReward)
                    Text(
                      formatCurrency(widget.rewardAmount),
                      style: AppTokens.display.copyWith(
                        color: AppTokens.successGreen,
                        fontSize: 36,
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.rewardAmount.toInt()}',
                          style: AppTokens.display.copyWith(
                            color: AppTokens.accentRed,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(width: AppTokens.s8),
                        Text(
                          'points',
                          style: AppTokens.subtitle.copyWith(
                            color: AppTokens.gray600,
                          ),
                        ),
                      ],
                    ),
                ] else ...[
                  Text(
                    'Better luck next time!',
                    style: AppTokens.body.copyWith(color: AppTokens.gray600),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: AppTokens.s32),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isSuccess
                          ? AppTokens.successGreen
                          : AppTokens.navy,
                    ),
                    child: Text(widget.isSuccess ? 'Collect!' : 'Close'),
                  ),
                ),
              ],
            ),
          ),

          // Confetti
          if (widget.isSuccess)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: 3.14 / 2, // Down
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.3,
                  colors: const [
                    AppTokens.teal,
                    AppTokens.accentRed,
                    AppTokens.warningAmber,
                    AppTokens.successGreen,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
