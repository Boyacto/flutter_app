/// Game model for AR Trick Shot and other mini-games
class Game {
  final String id;
  final String title;
  final String thumbnail; // Emoji initially: 🏀
  final String description;
  final int maxAttemptsPerDay;
  final int remainingAttempts;
  final int bonusRetries; // From share action
  final double rewardAmount; // Money or points
  final bool isMoneyReward; // true = money, false = points
  final DateTime lastPlayedAt;
  final DateTime? lastResetAt;

  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.maxAttemptsPerDay,
    required this.remainingAttempts,
    this.bonusRetries = 0,
    required this.rewardAmount,
    this.isMoneyReward = true,
    required this.lastPlayedAt,
    this.lastResetAt,
  });

  bool get canPlay => remainingAttempts > 0 || bonusRetries > 0;

  Game copyWith({
    String? id,
    String? title,
    String? thumbnail,
    String? description,
    int? maxAttemptsPerDay,
    int? remainingAttempts,
    int? bonusRetries,
    double? rewardAmount,
    bool? isMoneyReward,
    DateTime? lastPlayedAt,
    DateTime? lastResetAt,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      maxAttemptsPerDay: maxAttemptsPerDay ?? this.maxAttemptsPerDay,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      bonusRetries: bonusRetries ?? this.bonusRetries,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      isMoneyReward: isMoneyReward ?? this.isMoneyReward,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      lastResetAt: lastResetAt ?? this.lastResetAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'description': description,
        'maxAttemptsPerDay': maxAttemptsPerDay,
        'remainingAttempts': remainingAttempts,
        'bonusRetries': bonusRetries,
        'rewardAmount': rewardAmount,
        'isMoneyReward': isMoneyReward,
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        if (lastResetAt != null) 'lastResetAt': lastResetAt!.toIso8601String(),
      };

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'] as String,
        title: json['title'] as String,
        thumbnail: json['thumbnail'] as String,
        description: json['description'] as String,
        maxAttemptsPerDay: json['maxAttemptsPerDay'] as int,
        remainingAttempts: json['remainingAttempts'] as int,
        bonusRetries: json['bonusRetries'] as int? ?? 0,
        rewardAmount: (json['rewardAmount'] as num).toDouble(),
        isMoneyReward: json['isMoneyReward'] as bool? ?? true,
        lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
        lastResetAt: json['lastResetAt'] != null
            ? DateTime.parse(json['lastResetAt'] as String)
            : null,
      );
}

/// Game session for tracking active gameplay
class GameSession {
  final String sessionId;
  final String gameId;
  final String nonce; // Anti-abuse
  final int attemptsUsed;
  final DateTime startedAt;

  const GameSession({
    required this.sessionId,
    required this.gameId,
    required this.nonce,
    this.attemptsUsed = 0,
    required this.startedAt,
  });

  GameSession copyWith({
    String? sessionId,
    String? gameId,
    String? nonce,
    int? attemptsUsed,
    DateTime? startedAt,
  }) {
    return GameSession(
      sessionId: sessionId ?? this.sessionId,
      gameId: gameId ?? this.gameId,
      nonce: nonce ?? this.nonce,
      attemptsUsed: attemptsUsed ?? this.attemptsUsed,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'gameId': gameId,
        'nonce': nonce,
        'attemptsUsed': attemptsUsed,
        'startedAt': startedAt.toIso8601String(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        sessionId: json['sessionId'] as String,
        gameId: json['gameId'] as String,
        nonce: json['nonce'] as String,
        attemptsUsed: json['attemptsUsed'] as int? ?? 0,
        startedAt: DateTime.parse(json['startedAt'] as String),
      );
}
