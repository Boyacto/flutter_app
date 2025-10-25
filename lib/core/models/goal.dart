/// Saving goal configuration
class Goal {
  final String name;
  final double target;
  final DateTime? eta; // Estimated time of arrival

  const Goal({
    required this.name,
    required this.target,
    this.eta,
  });

  /// Copy with method for immutable updates
  Goal copyWith({
    String? name,
    double? target,
    DateTime? eta,
    bool clearEta = false,
  }) {
    return Goal(
      name: name ?? this.name,
      target: target ?? this.target,
      eta: clearEta ? null : (eta ?? this.eta),
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'target': target,
      'eta': eta?.toIso8601String(),
    };
  }

  /// Create from map
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      name: map['name'] as String,
      target: (map['target'] as num).toDouble(),
      eta: map['eta'] != null ? DateTime.parse(map['eta'] as String) : null,
    );
  }

  /// Create default goal
  factory Goal.createDefault() {
    return Goal(
      name: 'My First Goal',
      target: 200.0,
      eta: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
