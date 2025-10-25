/// Daily and weekly round-up limits
class Limit {
  final double? dailyCap;
  final double? weeklyCap;
  final double dailyUsed;
  final double weeklyUsed;
  final DateTime lastDailyReset;
  final DateTime lastWeeklyReset;

  const Limit({
    this.dailyCap,
    this.weeklyCap,
    required this.dailyUsed,
    required this.weeklyUsed,
    required this.lastDailyReset,
    required this.lastWeeklyReset,
  });

  /// Check if daily limit is reached
  bool get isDailyLimitReached {
    if (dailyCap == null) return false;
    return dailyUsed >= dailyCap!;
  }

  /// Check if weekly limit is reached
  bool get isWeeklyLimitReached {
    if (weeklyCap == null) return false;
    return weeklyUsed >= weeklyCap!;
  }

  /// Check if any limit is reached
  bool get isLimitReached => isDailyLimitReached || isWeeklyLimitReached;

  /// Copy with method for immutable updates
  Limit copyWith({
    double? dailyCap,
    double? weeklyCap,
    double? dailyUsed,
    double? weeklyUsed,
    DateTime? lastDailyReset,
    DateTime? lastWeeklyReset,
    bool clearDailyCap = false,
    bool clearWeeklyCap = false,
  }) {
    return Limit(
      dailyCap: clearDailyCap ? null : (dailyCap ?? this.dailyCap),
      weeklyCap: clearWeeklyCap ? null : (weeklyCap ?? this.weeklyCap),
      dailyUsed: dailyUsed ?? this.dailyUsed,
      weeklyUsed: weeklyUsed ?? this.weeklyUsed,
      lastDailyReset: lastDailyReset ?? this.lastDailyReset,
      lastWeeklyReset: lastWeeklyReset ?? this.lastWeeklyReset,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'dailyCap': dailyCap,
      'weeklyCap': weeklyCap,
      'dailyUsed': dailyUsed,
      'weeklyUsed': weeklyUsed,
      'lastDailyReset': lastDailyReset.toIso8601String(),
      'lastWeeklyReset': lastWeeklyReset.toIso8601String(),
    };
  }

  /// Create from map
  factory Limit.fromMap(Map<String, dynamic> map) {
    return Limit(
      dailyCap: map['dailyCap'] as double?,
      weeklyCap: map['weeklyCap'] as double?,
      dailyUsed: (map['dailyUsed'] as num).toDouble(),
      weeklyUsed: (map['weeklyUsed'] as num).toDouble(),
      lastDailyReset: DateTime.parse(map['lastDailyReset'] as String),
      lastWeeklyReset: DateTime.parse(map['lastWeeklyReset'] as String),
    );
  }

  /// Create default limits
  factory Limit.createDefault() {
    final now = DateTime.now();
    return Limit(
      dailyCap: 10.0,
      weeklyCap: 50.0,
      dailyUsed: 0.0,
      weeklyUsed: 0.0,
      lastDailyReset: now,
      lastWeeklyReset: now,
    );
  }

  /// Reset limits if needed
  Limit resetIfNeeded() {
    final now = DateTime.now();
    bool needsDailyReset = false;
    bool needsWeeklyReset = false;

    // Check if we need to reset daily (new day)
    if (now.day != lastDailyReset.day ||
        now.month != lastDailyReset.month ||
        now.year != lastDailyReset.year) {
      needsDailyReset = true;
    }

    // Check if we need to reset weekly (new week - Monday)
    final lastWeekStart = lastWeeklyReset.subtract(
      Duration(days: lastWeeklyReset.weekday - 1),
    );
    final currentWeekStart = now.subtract(
      Duration(days: now.weekday - 1),
    );
    if (currentWeekStart.isAfter(lastWeekStart)) {
      needsWeeklyReset = true;
    }

    if (!needsDailyReset && !needsWeeklyReset) {
      return this;
    }

    return copyWith(
      dailyUsed: needsDailyReset ? 0.0 : null,
      weeklyUsed: needsWeeklyReset ? 0.0 : null,
      lastDailyReset: needsDailyReset ? now : null,
      lastWeeklyReset: needsWeeklyReset ? now : null,
    );
  }
}
