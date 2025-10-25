import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../theme/tokens.dart';
import '../../state/game_session_provider.dart';
import '../../core/config/feature_flags.dart';
import '../../core/models/game.dart';
import 'widgets/attempts_counter.dart';
import 'widgets/mock_unity_view.dart';
import 'modals/game_result_modal.dart';
import 'modals/share_retry_modal.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  GameSession? _currentSession;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Load game on init
    Future.microtask(() {
      ref.read(gameProvider.notifier).refresh();
    });
  }

  Future<void> _startGame() async {
    try {
      final session = await ref.read(gameProvider.notifier).startSession();
      setState(() {
        _currentSession = session;
        _isPlaying = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting game: $e')),
        );
      }
    }
  }

  Future<void> _onShoot() async {
    if (_currentSession == null) return;

    // Mock success: 70% success rate
    final isSuccess = math.Random().nextDouble() < 0.7;

    try {
      final result = await ref.read(gameProvider.notifier).submitResult(
            session: _currentSession!,
            isSuccess: isSuccess,
          );

      setState(() {
        _isPlaying = false;
        _currentSession = null;
      });

      if (mounted) {
        // Show result modal
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GameResultModal(
            isSuccess: isSuccess,
            rewardAmount: result['reward'] ?? result['points'] ?? 0,
            isMoneyReward: result['reward'] != null && result['reward'] > 0,
            pointsEarned: result['points'] ?? 0,
          ),
        );

        // If failed and no attempts left, offer share for retry
        if (!isSuccess) {
          final gameAsync = ref.read(gameProvider);
          if (gameAsync.hasValue) {
            final game = gameAsync.value!;
            if (!game.canPlay) {
              _showShareRetryModal();
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        _isPlaying = false;
        _currentSession = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showShareRetryModal() {
    showDialog(
      context: context,
      builder: (context) => ShareRetryModal(
        onShareComplete: () async {
          await ref.read(gameProvider.notifier).addShareRetry();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('+1 bonus attempt added!')),
            );
          }
        },
      ),
    );
  }

  void _manualReset() {
    ref.read(gameProvider.notifier).manualReset();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game attempts reset!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Trick Shot'),
        actions: [
          if (FeatureFlags.showManualResetButton)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _manualReset,
              tooltip: 'Reset attempts (debug)',
            ),
        ],
      ),
      body: gameAsync.when(
        data: (game) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attempts counter
                Center(
                  child: AttemptsCounter(
                    remainingAttempts: game.remainingAttempts,
                    bonusRetries: game.bonusRetries,
                  ),
                ),

                const SizedBox(height: AppTokens.s24),

                // Game view
                MockUnityView(
                  isPlaying: _isPlaying,
                  onShoot: _onShoot,
                ),

                const SizedBox(height: AppTokens.s24),

                // Game info
                Container(
                  padding: const EdgeInsets.all(AppTokens.s16),
                  decoration: BoxDecoration(
                    color: AppTokens.gray50,
                    borderRadius: AppTokens.radius16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reward',
                            style: AppTokens.body.copyWith(
                              color: AppTokens.gray600,
                            ),
                          ),
                          Text(
                            game.isMoneyReward
                                ? '\$${game.rewardAmount.toStringAsFixed(2)}'
                                : '+${game.rewardAmount.toInt()} pts',
                            style: AppTokens.subtitle.copyWith(
                              color: game.isMoneyReward
                                  ? AppTokens.successGreen
                                  : AppTokens.accentRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: AppTokens.s16),
                      Text(
                        game.instructions,
                        style: AppTokens.body.copyWith(
                          color: AppTokens.gray700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTokens.s24),

                // Start game button
                if (!_isPlaying)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: game.canPlay ? _startGame : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTokens.s20,
                        ),
                        backgroundColor: AppTokens.teal,
                      ),
                      child: Text(
                        game.canPlay
                            ? 'Start Game'
                            : 'No attempts left',
                        style: AppTokens.label.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (!game.canPlay) ...[
                  const SizedBox(height: AppTokens.s16),
                  TextButton.icon(
                    onPressed: _showShareRetryModal,
                    icon: Icon(Icons.share, color: AppTokens.teal),
                    label: Text(
                      'Share for +1 attempt',
                      style: TextStyle(color: AppTokens.teal),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppTokens.errorRed),
              const SizedBox(height: AppTokens.s16),
              Text(
                'Error loading game',
                style: AppTokens.subtitle.copyWith(color: AppTokens.errorRed),
              ),
              const SizedBox(height: AppTokens.s8),
              Text(
                error.toString(),
                style: AppTokens.caption.copyWith(color: AppTokens.gray500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
