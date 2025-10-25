import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/account.dart';
import '../core/services/mock_account_service.dart';
import 'app_providers.dart';

// ============================================================================
// ACCOUNT SERVICE
// ============================================================================

final accountServiceProvider = Provider<MockAccountService>((ref) {
  return MockAccountService();
});

// ============================================================================
// ACCOUNTS STATE
// ============================================================================

final accountsProvider =
    StateNotifierProvider<AccountsNotifier, AsyncValue<List<Account>>>((ref) {
  return AccountsNotifier(ref);
});

class AccountsNotifier extends StateNotifier<AsyncValue<List<Account>>> {
  AccountsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadAccounts();
  }

  final Ref ref;

  Future<void> _loadAccounts() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(accountServiceProvider);
      final accounts = await service.fetchAccounts();
      state = AsyncValue.data(accounts);
      _saveToStorage(accounts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadAccounts();
  }

  Future<void> updateBalance(String accountId, double amount) async {
    try {
      final service = ref.read(accountServiceProvider);
      final updatedAccount =
          await service.updateAccountBalance(accountId, amount);

      state.whenData((accounts) {
        final index = accounts.indexWhere((a) => a.id == accountId);
        if (index != -1) {
          final updated = [...accounts];
          updated[index] = updatedAccount;
          state = AsyncValue.data(updated);
          _saveToStorage(updated);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> linkJar(String accountId, String jarId) async {
    try {
      final service = ref.read(accountServiceProvider);
      final updatedAccount = await service.linkJarToAccount(accountId, jarId);

      state.whenData((accounts) {
        final index = accounts.indexWhere((a) => a.id == accountId);
        if (index != -1) {
          final updated = [...accounts];
          updated[index] = updatedAccount;
          state = AsyncValue.data(updated);
          _saveToStorage(updated);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlinkJar(String accountId) async {
    try {
      final service = ref.read(accountServiceProvider);
      final updatedAccount = await service.unlinkJarFromAccount(accountId);

      state.whenData((accounts) {
        final index = accounts.indexWhere((a) => a.id == accountId);
        if (index != -1) {
          final updated = [...accounts];
          updated[index] = updatedAccount;
          state = AsyncValue.data(updated);
          _saveToStorage(updated);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Account?> findAvailableAccount() async {
    final service = ref.read(accountServiceProvider);
    return await service.findAvailableAccount();
  }

  void _saveToStorage(List<Account> accounts) {
    // Fire-and-forget: save asynchronously without blocking UI
    Future(() async {
      try {
        final storage = ref.read(storageServiceProvider);
        await storage.saveAccounts(accounts);
      } catch (e) {
        // Handle error silently - storage might not have this method yet
      }
    });
  }
}

// ============================================================================
// SELECTED ACCOUNT
// ============================================================================

final selectedAccountIdProvider = StateProvider<String?>((ref) => null);

final selectedAccountProvider = Provider<Account?>((ref) {
  final accountId = ref.watch(selectedAccountIdProvider);
  if (accountId == null) return null;

  final accountsAsync = ref.watch(accountsProvider);

  return accountsAsync.whenOrNull(
    data: (list) {
      try {
        return list.firstWhere((a) => a.id == accountId);
      } catch (e) {
        return null;
      }
    },
  );
});

// ============================================================================
// HELPER: Get account by jar ID
// ============================================================================

final accountByJarIdProvider = Provider.family<Account?, String>((ref, jarId) {
  final accountsAsync = ref.watch(accountsProvider);

  return accountsAsync.whenOrNull(
    data: (accounts) {
      try {
        return accounts.firstWhere((a) => a.linkedJarId == jarId);
      } catch (e) {
        return null;
      }
    },
  );
});
