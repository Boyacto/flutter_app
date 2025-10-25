import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/currency.dart'; // formatCurrency
import 'app_providers.dart'; // userBalanceProvider

// === Config (USD) ===
const double kDailyRewardUSD = 0.10; // $0.10/day
const double kWeeklyStreakBonusUSD = 0.50; // +$0.50 on day 7
const double kMonthlyStreakBonusUSD = 2.00; // +$2.00 on day 30 (option)
const double kMonthlyCapUSD = 6.00; // abuse cap
const int kResetHourLocal = 0; // 00:00 local (America/Monterrey)

// === State ===
class DailyRewardState {
  final DateTime? lastClaimedAt; // Local time storage
  final int streak; // Consecutive attendance days
  final double monthTotal; // This month's total payout
  final int month; // Month boundary reset check
  final int year;

  const DailyRewardState({
    required this.lastClaimedAt,
    required this.streak,
    required this.monthTotal,
    required this.month,
    required this.year,
  });

  factory DailyRewardState.initial() => DailyRewardState(
        lastClaimedAt: null,
        streak: 0,
        monthTotal: 0,
        month: DateTime.now().month,
        year: DateTime.now().year,
      );

  DailyRewardState copyWith({
    DateTime? lastClaimedAt,
    int? streak,
    double? monthTotal,
    int? month,
    int? year,
  }) =>
      DailyRewardState(
        lastClaimedAt: lastClaimedAt ?? this.lastClaimedAt,
        streak: streak ?? this.streak,
        monthTotal: monthTotal ?? this.monthTotal,
        month: month ?? this.month,
        year: year ?? this.year,
      );
}

// === Notifier ===
class DailyRewardNotifier extends StateNotifier<DailyRewardState> {
  DailyRewardNotifier(this.ref) : super(DailyRewardState.initial()) {
    _load();
  }
  final Ref ref;

  static const _kKey = 'daily_reward_state_v1';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return;
    try {
      // Simple comma-based serialization; can be replaced with json if needed
      final parts = raw.split('|');
      final last = parts[0].isEmpty ? null : DateTime.parse(parts[0]);
      final streak = int.parse(parts[1]);
      final monthTotal = double.parse(parts[2]);
      final month = int.parse(parts[3]);
      final year = int.parse(parts[4]);

      state = DailyRewardState(
        lastClaimedAt: last,
        streak: streak,
        monthTotal: monthTotal,
        month: month,
        year: year,
      );
      _applyMonthBoundaryIfNeeded();
    } catch (_) {
      // ignore parse error
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final last = state.lastClaimedAt?.toIso8601String() ?? '';
    final raw = [
      last,
      state.streak.toString(),
      state.monthTotal.toStringAsFixed(2),
      state.month.toString(),
      state.year.toString(),
    ].join('|');
    await prefs.setString(_kKey, raw);
  }

  // Midnight boundary/month boundary handling (local)
  DateTime _todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get isTodayClaimed {
    if (state.lastClaimedAt == null) return false;
    final last = state.lastClaimedAt!;
    final today = _todayLocal();
    return last.year == today.year &&
        last.month == today.month &&
        last.day == today.day;
  }

  void _applyMonthBoundaryIfNeeded() {
    final now = DateTime.now();
    if (state.month != now.month || state.year != now.year) {
      state = state.copyWith(
        monthTotal: 0,
        month: now.month,
        year: now.year,
      );
    }
  }

  // If you skip a day, streak resets (no cumulative rewards), cannot claim twice same day
  Future<void> claim() async {
    _applyMonthBoundaryIfNeeded();

    if (isTodayClaimed) {
      throw Exception('Already claimed today');
    }
    if (state.monthTotal >= kMonthlyCapUSD) {
      throw Exception(
          'Monthly cap reached: ${formatCurrency(kMonthlyCapUSD)}');
    }

    // Update streak
    final now = DateTime.now();
    int nextStreak = 1;
    if (state.lastClaimedAt != null) {
      final last = state.lastClaimedAt!;
      final daysGap = _todayLocal()
          .difference(DateTime(last.year, last.month, last.day))
          .inDays;
      nextStreak = (daysGap == 1) ? state.streak + 1 : 1;
    }

    // Basic payout
    double payout = kDailyRewardUSD;

    // Weekly/monthly bonuses
    if (nextStreak % 7 == 0) {
      payout += kWeeklyStreakBonusUSD;
    }
    if (nextStreak == 30) {
      payout += kMonthlyStreakBonusUSD; // option
    }

    // Apply monthly cap
    final remainingCap =
        (kMonthlyCapUSD - state.monthTotal).clamp(0.0, kMonthlyCapUSD);
    if (payout > remainingCap) payout = remainingCap;

    // Apply changes
    ref.read(userBalanceProvider.notifier).addMoney(payout);
    state = state.copyWith(
      lastClaimedAt: now,
      streak: nextStreak,
      monthTotal: (state.monthTotal + payout),
    );
    await _save();
  }
}

// Provider
final dailyRewardProvider =
    StateNotifierProvider<DailyRewardNotifier, DailyRewardState>((ref) {
  return DailyRewardNotifier(ref);
});
