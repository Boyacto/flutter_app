import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/user_balance.dart';
import '../core/services/storage_service.dart';

// ============================================================================
// SERVICE PROVIDERS
// ============================================================================

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden in main.dart with an initialized instance',
  );
});

// ============================================================================
// USER BALANCE STATE
// ============================================================================

final userBalanceProvider =
    StateNotifierProvider<UserBalanceNotifier, UserBalance>((ref) {
  return UserBalanceNotifier(ref);
});

class UserBalanceNotifier extends StateNotifier<UserBalance> {
  UserBalanceNotifier(this.ref) : super(UserBalance.initial()) {
    _loadBalance();
  }

  final Ref ref;

  Future<void> _loadBalance() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final saved = storage.loadUserBalance();
      if (saved != null) {
        state = saved;
      }
    } catch (e) {
      // Keep initial state
    }
  }

  void addMoney(double amount) {
    state = state.copyWith(
      currentBalance: state.currentBalance + amount,
      lastUpdated: DateTime.now(),
    );
    _save();
  }

  void deductMoney(double amount) {
    if (state.currentBalance < amount) {
      throw Exception('Insufficient balance');
    }
    state = state.copyWith(
      currentBalance: state.currentBalance - amount,
      lastUpdated: DateTime.now(),
    );
    _save();
  }

  void addPoints(int points) {
    state = state.copyWith(
      points: state.points + points,
      lastUpdated: DateTime.now(),
    );
    _save();
  }

  void deductPoints(int points) {
    if (state.points < points) {
      throw Exception('Insufficient points');
    }
    state = state.copyWith(
      points: state.points - points,
      lastUpdated: DateTime.now(),
    );
    _save();
  }

  void incrementCoupons() {
    state = state.copyWith(
      couponsCount: state.couponsCount + 1,
      lastUpdated: DateTime.now(),
    );
    _save();
  }

  void _save() {
    // Fire-and-forget: save asynchronously without blocking UI
    Future(() async {
      try {
        final storage = ref.read(storageServiceProvider);
        await storage.saveUserBalance(state);
      } catch (e) {
        // Handle error silently for now
      }
    });
  }
}
