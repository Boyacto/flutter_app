import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/jar.dart';
import '../core/models/rule_set.dart';
import '../core/models/limit.dart';
import '../core/models/event.dart';
import '../core/services/mock_api_service.dart';
import '../core/services/round_up_engine.dart';
import '../core/services/storage_service.dart';

// ============================================================================
// SERVICE PROVIDERS
// ============================================================================

/// Mock API service provider
final mockApiServiceProvider = Provider<MockApiService>((ref) {
  return MockApiService();
});

/// Round-up engine provider
final roundUpEngineProvider = Provider<RoundUpEngine>((ref) {
  return RoundUpEngine();
});

/// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// ============================================================================
// JAR PROVIDER
// ============================================================================

/// Jar state provider
final jarProvider = StateNotifierProvider<JarNotifier, Jar>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return JarNotifier(storage);
});

class JarNotifier extends StateNotifier<Jar> {
  final StorageService _storage;

  JarNotifier(this._storage) : super(_loadOrCreateJar(_storage));

  static Jar _loadOrCreateJar(StorageService storage) {
    final loaded = storage.loadJar();
    if (loaded != null) return loaded;

    // Create and save default jar
    final jar = Jar.createDefault();
    storage.saveJar(jar);
    return jar;
  }

  /// Update jar
  void update(Jar jar) {
    state = jar;
    _storage.saveJar(jar);
  }

  /// Update balance
  void updateBalance(double newBalance) {
    state = state.copyWith(balance: newBalance);
    _storage.saveJar(state);
  }

  /// Add to balance
  void addToBalance(double amount) {
    state = state.copyWith(balance: state.balance + amount);
    _storage.saveJar(state);
  }

  /// Toggle auto round-up
  void toggleAuto() {
    state = state.copyWith(isAutoOn: !state.isAutoOn);
    _storage.saveJar(state);
  }

  /// Update rules
  void updateRules(RuleSet rules) {
    state = state.copyWith(rules: rules);
    _storage.saveJar(state);
  }

  /// Update limits
  void updateLimits(Limit limits) {
    state = state.copyWith(limits: limits);
    _storage.saveJar(state);
  }

  /// Set pause
  void setPause(DateTime? pausedUntil) {
    state = state.copyWith(
      pausedUntil: pausedUntil,
      clearPause: pausedUntil == null,
    );
    _storage.saveJar(state);
  }

  /// Update goal
  void updateGoal({
    String? name,
    double? goalAmount,
    DateTime? deadline,
    bool clearDeadline = false,
  }) {
    state = state.copyWith(
      name: name,
      goalAmount: goalAmount,
      deadline: deadline,
      clearDeadline: clearDeadline,
    );
    _storage.saveJar(state);
  }

  /// Reset jar
  void reset() {
    state = Jar.createDefault();
    _storage.saveJar(state);
  }
}

// ============================================================================
// EVENTS PROVIDER
// ============================================================================

/// Events provider
final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return EventsNotifier(storage);
});

class EventsNotifier extends StateNotifier<List<Event>> {
  final StorageService _storage;

  EventsNotifier(this._storage) : super(_storage.loadEvents());

  /// Add event
  void addEvent(Event event) {
    state = [event, ...state];
    _storage.saveEvents(state);
  }

  /// Clear all events
  void clearAll() {
    state = [];
    _storage.clearEvents();
  }

  /// Get events by type
  List<Event> getByType(EventType type) {
    return state.where((e) => e.type == type).toList();
  }

  /// Get events for today
  List<Event> getToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.where((e) {
      final eventDate = DateTime(
        e.timestamp.year,
        e.timestamp.month,
        e.timestamp.day,
      );
      return eventDate == today;
    }).toList();
  }
}

// ============================================================================
// SESSION STATS PROVIDER
// ============================================================================

/// Session statistics (today and this week)
final sessionStatsProvider = Provider<SessionStats>((ref) {
  final events = ref.watch(eventsProvider);
  final now = DateTime.now();

  // Today's round-ups
  double todayRoundUp = 0.0;
  final today = DateTime(now.year, now.month, now.day);

  for (final event in events) {
    final eventDate = DateTime(
      event.timestamp.year,
      event.timestamp.month,
      event.timestamp.day,
    );

    if (eventDate == today && event.type == EventType.roundup) {
      todayRoundUp += event.amountDelta;
    }
  }

  // This week's round-ups (Monday to Sunday)
  double weekRoundUp = 0.0;
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

  for (final event in events) {
    final eventDate = DateTime(
      event.timestamp.year,
      event.timestamp.month,
      event.timestamp.day,
    );

    if (eventDate.isAfter(weekStartDate.subtract(const Duration(days: 1))) &&
        event.type == EventType.roundup) {
      weekRoundUp += event.amountDelta;
    }
  }

  return SessionStats(
    todayRoundUp: todayRoundUp,
    weekRoundUp: weekRoundUp,
  );
});

class SessionStats {
  final double todayRoundUp;
  final double weekRoundUp;

  const SessionStats({
    required this.todayRoundUp,
    required this.weekRoundUp,
  });
}

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
