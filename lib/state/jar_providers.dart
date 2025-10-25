import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/jar_v2.dart';
import '../core/services/mock_jar_service.dart';
import 'app_providers.dart';

// ============================================================================
// JAR SERVICE
// ============================================================================

final jarServiceProvider = Provider<MockJarService>((ref) {
  return MockJarService();
});

// ============================================================================
// JARS STATE
// ============================================================================

final jarsProvider =
    StateNotifierProvider<JarsNotifier, AsyncValue<List<JarV2>>>((ref) {
  return JarsNotifier(ref);
});

class JarsNotifier extends StateNotifier<AsyncValue<List<JarV2>>> {
  JarsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadJars();
  }

  final Ref ref;

  Future<void> _loadJars() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(jarServiceProvider);
      final jars = await service.fetchJars();
      state = AsyncValue.data(jars);
      _saveToStorage(jars);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadJars();
  }

  Future<void> createJar({
    required String emoji,
    required String name,
    required double goalAmount,
  }) async {
    final service = ref.read(jarServiceProvider);
    final newJar = await service.createJar(
      emoji: emoji,
      name: name,
      goalAmount: goalAmount,
    );

    state.whenData((jars) {
      final updated = [...jars, newJar];
      state = AsyncValue.data(updated);
      _saveToStorage(updated);
    });
  }

  Future<void> deposit(String jarId, double amount) async {
    try {
      final service = ref.read(jarServiceProvider);
      final updatedJar = await service.deposit(jarId, amount);

      state.whenData((jars) {
        final index = jars.indexWhere((j) => j.id == jarId);
        if (index != -1) {
          final updated = [...jars];
          updated[index] = updatedJar;
          state = AsyncValue.data(updated);
          _saveToStorage(updated);
        }
      });

      // Deduct from user balance
      ref.read(userBalanceProvider.notifier).deductMoney(amount);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteJar(String jarId) async {
    final service = ref.read(jarServiceProvider);
    await service.deleteJar(jarId);

    state.whenData((jars) {
      final updated = jars.where((j) => j.id != jarId).toList();
      state = AsyncValue.data(updated);
      _saveToStorage(updated);
    });
  }

  Future<void> updateMode(String jarId, SavingMode mode) async {
    final service = ref.read(jarServiceProvider);
    final updatedJar = await service.updateMode(jarId, mode);

    state.whenData((jars) {
      final index = jars.indexWhere((j) => j.id == jarId);
      if (index != -1) {
        final updated = [...jars];
        updated[index] = updatedJar;
        state = AsyncValue.data(updated);
        _saveToStorage(updated);
      }
    });
  }

  Future<void> _saveToStorage(List<JarV2> jars) async {
    try {
      final storage = ref.read(storageServiceProvider);
      await storage.saveJarsV2(jars);
    } catch (e) {
      // Handle error silently
    }
  }
}

// ============================================================================
// SELECTED JAR
// ============================================================================

final selectedJarIdProvider = StateProvider<String?>((ref) => null);

final selectedJarProvider = Provider<JarV2?>((ref) {
  final jarId = ref.watch(selectedJarIdProvider);
  if (jarId == null) return null;

  final jarsAsync = ref.watch(jarsProvider);

  return jarsAsync.whenOrNull(
    data: (list) {
      try {
        return list.firstWhere((j) => j.id == jarId);
      } catch (e) {
        return null;
      }
    },
  );
});
