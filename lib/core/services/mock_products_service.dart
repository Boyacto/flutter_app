import '../models/banner.dart';
import '../models/product_category.dart';

/// Mock service for products (banners and categories)
class MockProductsService {
  final List<PromoBanner> _banners = [
    const PromoBanner(
      id: '1',
      imageUrl: '🎁', // Placeholder emoji
      title: 'Special Savings Event',
    ),
    const PromoBanner(
      id: '2',
      imageUrl: '💳',
      title: 'New Credit Card Launch',
    ),
    const PromoBanner(
      id: '3',
      imageUrl: '📈',
      title: 'Investment Guide',
    ),
    const PromoBanner(
      id: '4',
      imageUrl: '💰',
      title: 'High-Interest Savings',
    ),
  ];

  final List<ProductCategory> _categories = [
    const ProductCategory(
      id: '1',
      name: 'Accounts',
      icon: '🏦',
      isEnabled: false,
    ),
    const ProductCategory(
      id: '2',
      name: 'Savings',
      icon: '💰',
      isEnabled: false,
    ),
    const ProductCategory(
      id: '3',
      name: 'Loans',
      icon: '💳',
      isEnabled: false,
    ),
    const ProductCategory(
      id: '4',
      name: 'Invest',
      icon: '📈',
      isEnabled: false,
    ),
    const ProductCategory(
      id: '5',
      name: 'Cards',
      icon: '💳',
      isEnabled: false,
    ),
    const ProductCategory(
      id: '6',
      name: 'Business',
      icon: '🏢',
      isEnabled: false,
    ),
  ];

  Future<List<PromoBanner>> fetchBanners() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_banners);
  }

  Future<List<ProductCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_categories);
  }
}
