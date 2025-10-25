/// User balance model - tracks money, points, and coupons
class UserBalance {
  final double currentBalance; // Money in main account
  final int points; // Reward points
  final int couponsCount; // Number of coupons owned
  final DateTime lastUpdated;

  const UserBalance({
    required this.currentBalance,
    required this.points,
    required this.couponsCount,
    required this.lastUpdated,
  });

  factory UserBalance.initial() => UserBalance(
        currentBalance: 1500.0, // $1,500 starting balance
        points: 150, // 150 starting points
        couponsCount: 0,
        lastUpdated: DateTime.now(),
      );

  UserBalance copyWith({
    double? currentBalance,
    int? points,
    int? couponsCount,
    DateTime? lastUpdated,
  }) {
    return UserBalance(
      currentBalance: currentBalance ?? this.currentBalance,
      points: points ?? this.points,
      couponsCount: couponsCount ?? this.couponsCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentBalance': currentBalance,
        'points': points,
        'couponsCount': couponsCount,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory UserBalance.fromJson(Map<String, dynamic> json) => UserBalance(
        currentBalance: (json['currentBalance'] as num).toDouble(),
        points: json['points'] as int,
        couponsCount: json['couponsCount'] as int,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}
