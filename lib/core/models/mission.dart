/// Mission status enum
enum MissionStatus {
  available,
  inProgress,
  completed,
  locked,
}

/// Mission model for gamification
class Mission {
  final String id;
  final String icon; // Emoji or icon name
  final String title;
  final String subtitle;
  final int rewardPoints;
  final MissionStatus status;
  final DateTime? completedAt;

  const Mission({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rewardPoints,
    required this.status,
    this.completedAt,
  });

  Mission copyWith({
    String? id,
    String? icon,
    String? title,
    String? subtitle,
    int? rewardPoints,
    MissionStatus? status,
    DateTime? completedAt,
  }) {
    return Mission(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
        'rewardPoints': rewardPoints,
        'status': status.name,
        if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'] as String,
        icon: json['icon'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        rewardPoints: json['rewardPoints'] as int,
        status: MissionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => MissionStatus.available,
        ),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );
}
