/// Event types for activity log
enum EventType {
  roundup('roundup'),
  topup('topup'),
  skip('skip'),
  goalAchieved('goal_achieved');

  final String value;
  const EventType(this.value);

  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EventType.roundup,
    );
  }
}

/// An event in the jar's activity history
class Event {
  final String id;
  final EventType type;
  final DateTime timestamp;
  final String? transactionId;
  final double amountDelta; // Positive = added to jar
  final String? reason; // For skips: 'cap', 'paused', 'category', 'integer'
  final double jarBalanceAfter;

  // Additional fields for round-up events
  final String? merchant;
  final String? category;
  final double? transactionAmount;
  final double? roundUpUnit;
  final double? multiplier;

  const Event({
    required this.id,
    required this.type,
    required this.timestamp,
    this.transactionId,
    required this.amountDelta,
    this.reason,
    required this.jarBalanceAfter,
    this.merchant,
    this.category,
    this.transactionAmount,
    this.roundUpUnit,
    this.multiplier,
  });

  /// Copy with method for immutable updates
  Event copyWith({
    String? id,
    EventType? type,
    DateTime? timestamp,
    String? transactionId,
    double? amountDelta,
    String? reason,
    double? jarBalanceAfter,
    String? merchant,
    String? category,
    double? transactionAmount,
    double? roundUpUnit,
    double? multiplier,
  }) {
    return Event(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      transactionId: transactionId ?? this.transactionId,
      amountDelta: amountDelta ?? this.amountDelta,
      reason: reason ?? this.reason,
      jarBalanceAfter: jarBalanceAfter ?? this.jarBalanceAfter,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      roundUpUnit: roundUpUnit ?? this.roundUpUnit,
      multiplier: multiplier ?? this.multiplier,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.value,
      'timestamp': timestamp.toIso8601String(),
      'transactionId': transactionId,
      'amountDelta': amountDelta,
      'reason': reason,
      'jarBalanceAfter': jarBalanceAfter,
      'merchant': merchant,
      'category': category,
      'transactionAmount': transactionAmount,
      'roundUpUnit': roundUpUnit,
      'multiplier': multiplier,
    };
  }

  /// Create from map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      type: EventType.fromString(map['type'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
      transactionId: map['transactionId'] as String?,
      amountDelta: (map['amountDelta'] as num).toDouble(),
      reason: map['reason'] as String?,
      jarBalanceAfter: (map['jarBalanceAfter'] as num).toDouble(),
      merchant: map['merchant'] as String?,
      category: map['category'] as String?,
      transactionAmount: map['transactionAmount'] != null
          ? (map['transactionAmount'] as num).toDouble()
          : null,
      roundUpUnit: map['roundUpUnit'] != null
          ? (map['roundUpUnit'] as num).toDouble()
          : null,
      multiplier: map['multiplier'] != null
          ? (map['multiplier'] as num).toDouble()
          : null,
    );
  }

  /// Create a round-up event
  factory Event.roundUp({
    required String id,
    required DateTime timestamp,
    required String transactionId,
    required double roundUpAmount,
    required double jarBalanceAfter,
    required String merchant,
    required String category,
    required double transactionAmount,
    required double roundUpUnit,
    required double multiplier,
  }) {
    return Event(
      id: id,
      type: EventType.roundup,
      timestamp: timestamp,
      transactionId: transactionId,
      amountDelta: roundUpAmount,
      jarBalanceAfter: jarBalanceAfter,
      merchant: merchant,
      category: category,
      transactionAmount: transactionAmount,
      roundUpUnit: roundUpUnit,
      multiplier: multiplier,
    );
  }

  /// Create a top-up event
  factory Event.topUp({
    required String id,
    required DateTime timestamp,
    required double amount,
    required double jarBalanceAfter,
  }) {
    return Event(
      id: id,
      type: EventType.topup,
      timestamp: timestamp,
      amountDelta: amount,
      jarBalanceAfter: jarBalanceAfter,
    );
  }

  /// Create a skip event
  factory Event.skip({
    required String id,
    required DateTime timestamp,
    required String transactionId,
    required String reason,
    required String merchant,
    required String category,
    required double transactionAmount,
  }) {
    return Event(
      id: id,
      type: EventType.skip,
      timestamp: timestamp,
      transactionId: transactionId,
      amountDelta: 0.0,
      reason: reason,
      jarBalanceAfter: 0.0, // Balance doesn't change for skips
      merchant: merchant,
      category: category,
      transactionAmount: transactionAmount,
    );
  }

  /// Create a goal achieved event
  factory Event.goalAchieved({
    required String id,
    required DateTime timestamp,
    required double jarBalanceAfter,
  }) {
    return Event(
      id: id,
      type: EventType.goalAchieved,
      timestamp: timestamp,
      amountDelta: 0.0,
      jarBalanceAfter: jarBalanceAfter,
    );
  }
}
