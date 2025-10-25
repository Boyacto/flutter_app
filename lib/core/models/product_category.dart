/// Product category model for financial products
class ProductCategory {
  final String id;
  final String name;
  final String icon; // Emoji
  final int itemCount; // Number of items in category
  final bool isEnabled; // For placeholder vs real features

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.itemCount = 0,
    this.isEnabled = false,
  });

  ProductCategory copyWith({
    String? id,
    String? name,
    String? icon,
    int? itemCount,
    bool? isEnabled,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      itemCount: itemCount ?? this.itemCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'itemCount': itemCount,
        'isEnabled': isEnabled,
      };

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        itemCount: json['itemCount'] as int? ?? 0,
        isEnabled: json['isEnabled'] as bool? ?? false,
      );
}
