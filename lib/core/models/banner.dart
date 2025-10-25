/// Promotional banner model
class PromoBanner {
  final String id;
  final String imageUrl; // Emoji placeholder or real URL
  final String title;
  final String? linkUrl; // Optional deep link

  const PromoBanner({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.linkUrl,
  });

  PromoBanner copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? linkUrl,
  }) {
    return PromoBanner(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      linkUrl: linkUrl ?? this.linkUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'title': title,
        if (linkUrl != null) 'linkUrl': linkUrl,
      };

  factory PromoBanner.fromJson(Map<String, dynamic> json) => PromoBanner(
        id: json['id'] as String,
        imageUrl: json['imageUrl'] as String,
        title: json['title'] as String,
        linkUrl: json['linkUrl'] as String?,
      );
}
