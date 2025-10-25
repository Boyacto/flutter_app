import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/storage_service.dart';
import 'app_providers.dart' show storageServiceProvider;

// ============================================================================
// SETTINGS PROVIDERS
// ============================================================================

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<String> {
  final StorageService _storage;

  LocaleNotifier(this._storage) : super(_storage.loadLocale());

  void setLocale(String locale) {
    state = locale;
    _storage.saveLocale(locale);
  }
}

/// Theme mode provider ('light', 'dark', 'system')
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ThemeModeNotifier(storage);
});

class ThemeModeNotifier extends StateNotifier<String> {
  final StorageService _storage;

  ThemeModeNotifier(this._storage) : super(_storage.loadThemeMode());

  void setThemeMode(String mode) {
    state = mode;
    _storage.saveThemeMode(mode);
  }
}

/// Reduce motion provider
final reduceMotionProvider = StateNotifierProvider<ReduceMotionNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ReduceMotionNotifier(storage);
});

class ReduceMotionNotifier extends StateNotifier<bool> {
  final StorageService _storage;

  ReduceMotionNotifier(this._storage) : super(_storage.loadReduceMotion());

  void toggle() {
    state = !state;
    _storage.saveReduceMotion(state);
  }

  void setValue(bool value) {
    state = value;
    _storage.saveReduceMotion(value);
  }
}
