import 'rule_set.dart';
import 'limit.dart';

/// Represents a saving jar with goal, balance, and configuration
class Jar {
  final String id;
  final String name;
  final double goalAmount;
  final DateTime? deadline;
  final double balance;
  final bool isAutoOn;
  final RuleSet rules;
  final Limit limits;
  final DateTime? pausedUntil;

  const Jar({
    required this.id,
    required this.name,
    required this.goalAmount,
    this.deadline,
    required this.balance,
    required this.isAutoOn,
    required this.rules,
    required this.limits,
    this.pausedUntil,
  });

  /// Progress as a fraction (0.0 to 1.0)
  double get progress => goalAmount > 0 ? (balance / goalAmount).clamp(0.0, 1.0) : 0.0;

  /// Progress as a percentage (0 to 100)
  int get progressPercent => (progress * 100).round();

  /// Whether the jar is currently paused
  bool get isPaused {
    if (pausedUntil == null) return false;
    return DateTime.now().isBefore(pausedUntil!);
  }

  /// Copy with method for immutable updates
  Jar copyWith({
    String? id,
    String? name,
    double? goalAmount,
    DateTime? deadline,
    double? balance,
    bool? isAutoOn,
    RuleSet? rules,
    Limit? limits,
    DateTime? pausedUntil,
    bool clearDeadline = false,
    bool clearPause = false,
  }) {
    return Jar(
      id: id ?? this.id,
      name: name ?? this.name,
      goalAmount: goalAmount ?? this.goalAmount,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      balance: balance ?? this.balance,
      isAutoOn: isAutoOn ?? this.isAutoOn,
      rules: rules ?? this.rules,
      limits: limits ?? this.limits,
      pausedUntil: clearPause ? null : (pausedUntil ?? this.pausedUntil),
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goalAmount': goalAmount,
      'deadline': deadline?.toIso8601String(),
      'balance': balance,
      'isAutoOn': isAutoOn,
      'rules': rules.toMap(),
      'limits': limits.toMap(),
      'pausedUntil': pausedUntil?.toIso8601String(),
    };
  }

  /// Create from map
  factory Jar.fromMap(Map<String, dynamic> map) {
    return Jar(
      id: map['id'] as String,
      name: map['name'] as String,
      goalAmount: (map['goalAmount'] as num).toDouble(),
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
      balance: (map['balance'] as num).toDouble(),
      isAutoOn: map['isAutoOn'] as bool,
      rules: RuleSet.fromMap(map['rules'] as Map<String, dynamic>),
      limits: Limit.fromMap(map['limits'] as Map<String, dynamic>),
      pausedUntil: map['pausedUntil'] != null
          ? DateTime.parse(map['pausedUntil'] as String)
          : null,
    );
  }

  /// Create a default jar
  factory Jar.createDefault() {
    return Jar(
      id: 'default',
      name: 'My Savings Jar',
      goalAmount: 200.0,
      deadline: DateTime.now().add(const Duration(days: 30)),
      balance: 0.0,
      isAutoOn: true,
      rules: RuleSet.createDefault(),
      limits: Limit.createDefault(),
      pausedUntil: null,
    );
  }
}
