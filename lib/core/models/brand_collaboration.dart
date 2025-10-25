/// Reward associated with a brand collaboration
class BrandReward {
  final String id;
  final String emoji; // Visual representation (e.g., ☕)
  final String title; // e.g., "Café Andatti Gourmet discount coupon"
  final String description; // e.g., "Save just 1 time and get discount"
  final String? imageUrl; // Optional image URL for the reward

  const BrandReward({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  BrandReward copyWith({
    String? id,
    String? emoji,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return BrandReward(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'emoji': emoji,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
      };

  factory BrandReward.fromJson(Map<String, dynamic> json) => BrandReward(
        id: json['id'] as String,
        emoji: json['emoji'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}

/// Brand collaboration details for a jar
class BrandCollaboration {
  final String brandName; // e.g., "OXXO"
  final String brandColor; // Hex color code (e.g., "#E12019")
  final List<BrandReward> rewards;
  final String? logoUrl; // Optional brand logo URL

  const BrandCollaboration({
    required this.brandName,
    required this.brandColor,
    required this.rewards,
    this.logoUrl,
  });

  BrandCollaboration copyWith({
    String? brandName,
    String? brandColor,
    List<BrandReward>? rewards,
    String? logoUrl,
  }) {
    return BrandCollaboration(
      brandName: brandName ?? this.brandName,
      brandColor: brandColor ?? this.brandColor,
      rewards: rewards ?? this.rewards,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'brandName': brandName,
        'brandColor': brandColor,
        'rewards': rewards.map((r) => r.toJson()).toList(),
        'logoUrl': logoUrl,
      };

  factory BrandCollaboration.fromJson(Map<String, dynamic> json) =>
      BrandCollaboration(
        brandName: json['brandName'] as String,
        brandColor: json['brandColor'] as String,
        rewards: (json['rewards'] as List<dynamic>)
            .map((r) => BrandReward.fromJson(r as Map<String, dynamic>))
            .toList(),
        logoUrl: json['logoUrl'] as String?,
      );
}
