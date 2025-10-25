/// Round-up rules configuration
class RuleSet {
  final double roundUpUnit; // 0.5, 1.0, 5.0, 10.0
  final double weekendMultiplier; // 1.0 or 2.0
  final Set<String> includeCategories;
  final Set<String> excludeCategories;

  const RuleSet({
    required this.roundUpUnit,
    required this.weekendMultiplier,
    required this.includeCategories,
    required this.excludeCategories,
  });

  /// Copy with method for immutable updates
  RuleSet copyWith({
    double? roundUpUnit,
    double? weekendMultiplier,
    Set<String>? includeCategories,
    Set<String>? excludeCategories,
  }) {
    return RuleSet(
      roundUpUnit: roundUpUnit ?? this.roundUpUnit,
      weekendMultiplier: weekendMultiplier ?? this.weekendMultiplier,
      includeCategories: includeCategories ?? this.includeCategories,
      excludeCategories: excludeCategories ?? this.excludeCategories,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'roundUpUnit': roundUpUnit,
      'weekendMultiplier': weekendMultiplier,
      'includeCategories': includeCategories.toList(),
      'excludeCategories': excludeCategories.toList(),
    };
  }

  /// Create from map
  factory RuleSet.fromMap(Map<String, dynamic> map) {
    return RuleSet(
      roundUpUnit: (map['roundUpUnit'] as num).toDouble(),
      weekendMultiplier: (map['weekendMultiplier'] as num).toDouble(),
      includeCategories: Set<String>.from(map['includeCategories'] as List),
      excludeCategories: Set<String>.from(map['excludeCategories'] as List),
    );
  }

  /// Create default rules
  factory RuleSet.createDefault() {
    return const RuleSet(
      roundUpUnit: 1.0,
      weekendMultiplier: 1.0,
      includeCategories: {},
      excludeCategories: {},
    );
  }
}
