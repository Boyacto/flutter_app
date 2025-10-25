import 'package:flutter/material.dart';
import '../models/game.dart';
import '../utils/currency.dart';
import '../../theme/tokens.dart';

class GameCardWidget extends StatelessWidget {
  const GameCardWidget({
    super.key,
    required this.game,
    required this.onTap,
  });

  final Game game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: game.canPlay ? onTap : null,
        borderRadius: AppTokens.radius24,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s16),
          child: Row(
            children: [
              // Game thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTokens.tealLight.withOpacity(0.2),
                  borderRadius: AppTokens.radius12,
                ),
                child: Center(
                  child: Text(game.thumbnail, style: const TextStyle(fontSize: 32)),
                ),
              ),

              const SizedBox(width: AppTokens.s16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: AppTokens.subtitle.copyWith(color: AppTokens.navy),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${game.remainingAttempts + game.bonusRetries} tries left',
                      style: AppTokens.caption.copyWith(color: AppTokens.gray500),
                    ),
                  ],
                ),
              ),

              // Reward
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    game.isMoneyReward
                        ? formatCurrency(game.rewardAmount)
                        : '+${game.rewardAmount.toInt()} pts',
                    style: AppTokens.label.copyWith(color: AppTokens.accentRed),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: game.canPlay ? AppTokens.navy : AppTokens.gray200,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
