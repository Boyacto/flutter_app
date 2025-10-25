/// Product category model for financial products
class ProductCategory {
  final String id;
  final String name;
  final String icon; // Emoji
  final bool isEnabled; // For placeholder vs real features

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isEnabled = false,
  });

  ProductCategory copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isEnabled,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'isEnabled': isEnabled,
      };

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        isEnabled: json['isEnabled'] as bool? ?? false,
      );
}
