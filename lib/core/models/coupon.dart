/// Coupon model for brand rewards
class Coupon {
  final String id;
  final String brandName; // "Starbucks", "McDonald's"
  final String productName; // "Coffee", "Big Mac"
  final String brandImage; // Emoji: ☕, 🍔 (later: URL)
  final String couponCode; // "SAVE20", "MC2024"
  final int pointsCost;
  final bool isRedeemed;
  final DateTime? redeemedAt;

  const Coupon({
    required this.id,
    required this.brandName,
    required this.productName,
    required this.brandImage,
    required this.couponCode,
    required this.pointsCost,
    this.isRedeemed = false,
    this.redeemedAt,
  });

  Coupon copyWith({
    String? id,
    String? brandName,
    String? productName,
    String? brandImage,
    String? couponCode,
    int? pointsCost,
    bool? isRedeemed,
    DateTime? redeemedAt,
  }) {
    return Coupon(
      id: id ?? this.id,
      brandName: brandName ?? this.brandName,
      productName: productName ?? this.productName,
      brandImage: brandImage ?? this.brandImage,
      couponCode: couponCode ?? this.couponCode,
      pointsCost: pointsCost ?? this.pointsCost,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brandName': brandName,
        'productName': productName,
        'brandImage': brandImage,
        'couponCode': couponCode,
        'pointsCost': pointsCost,
        'isRedeemed': isRedeemed,
        if (redeemedAt != null) 'redeemedAt': redeemedAt!.toIso8601String(),
      };

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json['id'] as String,
        brandName: json['brandName'] as String,
        productName: json['productName'] as String,
        brandImage: json['brandImage'] as String,
        couponCode: json['couponCode'] as String,
        pointsCost: json['pointsCost'] as int,
        isRedeemed: json['isRedeemed'] as bool? ?? false,
        redeemedAt: json['redeemedAt'] != null
            ? DateTime.parse(json['redeemedAt'] as String)
            : null,
      );
}
