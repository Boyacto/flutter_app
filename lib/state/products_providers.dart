import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/banner.dart';
import '../core/models/product_category.dart';
import '../core/services/mock_products_service.dart';

// ============================================================================
// PRODUCTS SERVICE
// ============================================================================

final productsServiceProvider = Provider<MockProductsService>((ref) {
  return MockProductsService();
});

// ============================================================================
// BANNERS
// ============================================================================

final bannersProvider = FutureProvider<List<PromoBanner>>((ref) async {
  final service = ref.read(productsServiceProvider);
  return service.fetchBanners();
});

// ============================================================================
// CATEGORIES
// ============================================================================

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  final service = ref.read(productsServiceProvider);
  return service.fetchCategories();
});
