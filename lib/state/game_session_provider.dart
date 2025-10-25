import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/game.dart';
import '../core/services/mock_game_service.dart';
import 'app_providers.dart';

// ============================================================================
// GAME SERVICE
// ============================================================================

final gameServiceProvider = Provider<MockGameService>((ref) {
  return MockGameService();
});

// ============================================================================
// GAME STATE
// ============================================================================

/// Provider for listing all available games
final gamesProvider = FutureProvider<List<Game>>((ref) async {
  final service = ref.read(gameServiceProvider);
  final game = await service.fetchGame();
  return [game]; // For now, we only have one game
});

final gameProvider =
    StateNotifierProvider<GameNotifier, AsyncValue<Game>>((ref) {
  return GameNotifier(ref);
});

class GameNotifier extends StateNotifier<AsyncValue<Game>> {
  GameNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadGame();
  }

  final Ref ref;

  Future<void> _loadGame() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(gameServiceProvider);
      final game = await service.fetchGame();
      state = AsyncValue.data(game);
      _saveToStorage(game);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadGame();
  }

  Future<GameSession> startSession() async {
    final service = ref.read(gameServiceProvider);
    return await service.startSession('ar-trick-shot');
  }

  Future<Map<String, dynamic>> submitResult({
    required GameSession session,
    required bool isSuccess,
  }) async {
    final service = ref.read(gameServiceProvider);
    final result = await service.submitResult(
      session: session,
      isSuccess: isSuccess,
    );

    // Award money/points
    if (isSuccess) {
      if (result['reward'] > 0) {
        ref.read(userBalanceProvider.notifier).addMoney(
              (result['reward'] as num).toDouble(),
            );
      }
      if (result['points'] > 0) {
        ref.read(userBalanceProvider.notifier).addPoints(
              result['points'] as int,
            );
      }
    }

    // Reload game state
    await _loadGame();

    return result;
  }

  Future<void> addShareRetry() async {
    final service = ref.read(gameServiceProvider);
    await service.addShareRetry();
    await _loadGame();
  }

  void manualReset() {
    final service = ref.read(gameServiceProvider);
    service.manualReset();
    _loadGame();
  }

  void _saveToStorage(Game game) {
    // Fire-and-forget: save asynchronously without blocking UI
    Future(() async {
      try {
        final storage = ref.read(storageServiceProvider);
        await storage.saveGameState(game);
      } catch (e) {
        // Handle error silently
      }
    });
  }
}
