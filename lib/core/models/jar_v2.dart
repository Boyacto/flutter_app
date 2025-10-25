import 'brand_collaboration.dart';

/// Jar activity entry
class JarActivity {
  final String id;
  final String emoji; // Summary icon
  final String description;
  final double amount;
  final DateTime timestamp;

  const JarActivity({
    required this.id,
    required this.emoji,
    required this.description,
    required this.amount,
    required this.timestamp,
  });

  JarActivity copyWith({
    String? id,
    String? emoji,
    String? description,
    double? amount,
    DateTime? timestamp,
  }) {
    return JarActivity(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'description': description,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory JarActivity.fromJson(Map<String, dynamic> json) => JarActivity(
        id: json['id'] as String,
        emoji: json['emoji'] as String,
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Jar V2 model for savings goals
class JarV2 {
  final String id;
  final String emoji; // 🏖️, 🎮, 🚗, etc.
  final String name; // "Beach Vacation", "Gaming Setup"
  final double currentBalance;
  final double goalAmount;
  final int streakDays;
  final double todayDeposit;
  final DateTime lastDepositDate;

  // Saving feature toggles (replacing SavingMode enum)
  final bool isCoinSavingEnabled; // Save up to $1 every day
  final bool isAutoSaveEnabled; // AI analyzes spending and saves $1-$10/week
  final bool isBrandCollabEnabled; // Participate in brand collaboration

  final BrandCollaboration? brandCollaboration; // Brand details if enabled
  final List<JarActivity> activities;
  final DateTime createdAt;

  const JarV2({
    required this.id,
    required this.emoji,
    required this.name,
    required this.currentBalance,
    required this.goalAmount,
    this.streakDays = 0,
    this.todayDeposit = 0,
    required this.lastDepositDate,
    this.isCoinSavingEnabled = false,
    this.isAutoSaveEnabled = false,
    this.isBrandCollabEnabled = false,
    this.brandCollaboration,
    this.activities = const [],
    required this.createdAt,
  });

  double get progress => goalAmount > 0 ? currentBalance / goalAmount : 0;
  bool get goalReached => currentBalance >= goalAmount;

  JarV2 copyWith({
    String? id,
    String? emoji,
    String? name,
    double? currentBalance,
    double? goalAmount,
    int? streakDays,
    double? todayDeposit,
    DateTime? lastDepositDate,
    bool? isCoinSavingEnabled,
    bool? isAutoSaveEnabled,
    bool? isBrandCollabEnabled,
    BrandCollaboration? brandCollaboration,
    List<JarActivity>? activities,
    DateTime? createdAt,
  }) {
    return JarV2(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
      goalAmount: goalAmount ?? this.goalAmount,
      streakDays: streakDays ?? this.streakDays,
      todayDeposit: todayDeposit ?? this.todayDeposit,
      lastDepositDate: lastDepositDate ?? this.lastDepositDate,
      isCoinSavingEnabled: isCoinSavingEnabled ?? this.isCoinSavingEnabled,
      isAutoSaveEnabled: isAutoSaveEnabled ?? this.isAutoSaveEnabled,
      isBrandCollabEnabled: isBrandCollabEnabled ?? this.isBrandCollabEnabled,
      brandCollaboration: brandCollaboration ?? this.brandCollaboration,
      activities: activities ?? this.activities,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'name': name,
        'currentBalance': currentBalance,
        'goalAmount': goalAmount,
        'streakDays': streakDays,
        'todayDeposit': todayDeposit,
        'lastDepositDate': lastDepositDate.toIso8601String(),
        'isCoinSavingEnabled': isCoinSavingEnabled,
        'isAutoSaveEnabled': isAutoSaveEnabled,
        'isBrandCollabEnabled': isBrandCollabEnabled,
        'brandCollaboration': brandCollaboration?.toJson(),
        'activities': activities.map((a) => a.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory JarV2.fromJson(Map<String, dynamic> json) => JarV2(
        id: json['id'] as String,
        emoji: json['emoji'] as String,
        name: json['name'] as String,
        currentBalance: (json['currentBalance'] as num).toDouble(),
        goalAmount: (json['goalAmount'] as num).toDouble(),
        streakDays: json['streakDays'] as int? ?? 0,
        todayDeposit: (json['todayDeposit'] as num?)?.toDouble() ?? 0,
        lastDepositDate: DateTime.parse(json['lastDepositDate'] as String),
        isCoinSavingEnabled: json['isCoinSavingEnabled'] as bool? ?? false,
        isAutoSaveEnabled: json['isAutoSaveEnabled'] as bool? ?? false,
        isBrandCollabEnabled: json['isBrandCollabEnabled'] as bool? ?? false,
        brandCollaboration: json['brandCollaboration'] != null
            ? BrandCollaboration.fromJson(
                json['brandCollaboration'] as Map<String, dynamic>)
            : null,
        activities: (json['activities'] as List<dynamic>?)
                ?.map((a) => JarActivity.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
