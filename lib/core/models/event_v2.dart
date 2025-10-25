/// Event types for activity logging
enum EventType {
  jarDeposit,
  jarWithdraw,
  missionComplete,
  gameWin,
  gameLose,
  couponRedeemed,
  pointsAwarded,
  pointsSpent,
}

/// Event model for tracking user actions
class EventV2 {
  final String id;
  final EventType type;
  final String title;
  final String subtitle;
  final String icon; // Emoji
  final double? amount; // Optional money amount
  final int? points; // Optional points
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // Extra data (coupon code, etc.)

  const EventV2({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.amount,
    this.points,
    required this.timestamp,
    this.metadata,
  });

  EventV2 copyWith({
    String? id,
    EventType? type,
    String? title,
    String? subtitle,
    String? icon,
    double? amount,
    int? points,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return EventV2(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      amount: amount ?? this.amount,
      points: points ?? this.points,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'subtitle': subtitle,
        'icon': icon,
        if (amount != null) 'amount': amount,
        if (points != null) 'points': points,
        'timestamp': timestamp.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };

  factory EventV2.fromJson(Map<String, dynamic> json) => EventV2(
        id: json['id'] as String,
        type: EventType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => EventType.jarDeposit,
        ),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        icon: json['icon'] as String,
        amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
        points: json['points'] as int?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}
