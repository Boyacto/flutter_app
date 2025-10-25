import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/tokens.dart';
import '../../state/products_providers.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_grid.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(bannersProvider);
          ref.invalidate(categoriesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.s16),
          children: [
            // Banner carousel
            bannersAsync.when(
              data: (banners) => BannerCarousel(banners: banners),
              loading: () => SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, stack) => SizedBox(
                height: 180,
                child: Center(
                  child: Text('Error loading banners',
                      style: TextStyle(color: AppTokens.errorRed)),
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Categories section
            Text(
              'Categories',
              style: AppTokens.title.copyWith(color: AppTokens.navy),
            ),
            const SizedBox(height: AppTokens.s12),

            // Category grid
            categoriesAsync.when(
              data: (categories) => CategoryGrid(categories: categories),
              loading: () => SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, stack) => SizedBox(
                height: 200,
                child: Center(
                  child: Text('Error loading categories',
                      style: TextStyle(color: AppTokens.errorRed)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
