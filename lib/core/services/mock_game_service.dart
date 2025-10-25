import '../models/game.dart';

/// Mock service for game operations
class MockGameService {
  Game _arGame = Game(
    id: 'ar-trick-shot',
    title: 'AR Trick Shot Simulator',
    thumbnail: '🏀',
    description: 'Shoot hoops to win rewards!',
    maxAttemptsPerDay: 3,
    remainingAttempts: 3,
    bonusRetries: 0,
    rewardAmount: 5000,
    isMoneyReward: true,
    lastPlayedAt: DateTime.now(),
    lastResetAt: DateTime.now(),
  );

  Future<Game> fetchGame() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _checkDailyReset(); // Auto-reset at midnight
    return _arGame;
  }

  Future<GameSession> startSession(String gameId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_arGame.remainingAttempts <= 0 && _arGame.bonusRetries <= 0) {
      throw Exception('No attempts remaining');
    }

    return GameSession(
      sessionId: _generateSessionId(),
      gameId: gameId,
      nonce: _generateNonce(),
      attemptsUsed: 0,
      startedAt: DateTime.now(),
    );
  }

  Future<Map<String, dynamic>> submitResult({
    required GameSession session,
    required bool isSuccess,
  }) async {
    // Simulate result validation
    await Future.delayed(const Duration(milliseconds: 500));

    // Deduct attempt
    if (_arGame.bonusRetries > 0) {
      _arGame = _arGame.copyWith(bonusRetries: _arGame.bonusRetries - 1);
    } else {
      _arGame = _arGame.copyWith(
        remainingAttempts: _arGame.remainingAttempts - 1,
      );
    }

    _arGame = _arGame.copyWith(lastPlayedAt: DateTime.now());

    double reward = 0;
    int points = 0;

    if (isSuccess) {
      if (_arGame.isMoneyReward) {
        reward = _arGame.rewardAmount;
      } else {
        points = _arGame.rewardAmount.toInt();
      }
    }

    return {
      'success': isSuccess,
      'reward': reward,
      'points': points,
      'remainingAttempts': _arGame.remainingAttempts,
      'bonusRetries': _arGame.bonusRetries,
    };
  }

  Future<void> addShareRetry() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_arGame.bonusRetries < 1) {
      // Max 1 bonus per day
      _arGame = _arGame.copyWith(bonusRetries: 1);
    }
  }

  void manualReset() {
    _arGame = _arGame.copyWith(
      remainingAttempts: _arGame.maxAttemptsPerDay,
      bonusRetries: 0,
      lastResetAt: DateTime.now(),
    );
  }

  void _checkDailyReset() {
    final now = DateTime.now();
    final lastReset = _arGame.lastResetAt;

    if (lastReset == null ||
        (now.day != lastReset.day ||
            now.month != lastReset.month ||
            now.year != lastReset.year)) {
      manualReset();
    }
  }

  String _generateSessionId() =>
      'session_${DateTime.now().millisecondsSinceEpoch}';

  String _generateNonce() =>
      DateTime.now().millisecondsSinceEpoch.toRadixString(36);
}
