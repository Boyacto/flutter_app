import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../core/models/product_category.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
  });

  final List<ProductCategory> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppTokens.s12,
        mainAxisSpacing: AppTokens.s12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(category: category);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (category.isEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${category.name} - Coming soon!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon!')),
            );
          }
        },
        borderRadius: AppTokens.radius24,
        child: Container(
          padding: const EdgeInsets.all(AppTokens.s16),
          decoration: BoxDecoration(
            gradient: category.isEnabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getCategoryColor().withOpacity(0.1),
                      _getCategoryColor().withOpacity(0.05),
                    ],
                  )
                : null,
            borderRadius: AppTokens.radius24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji icon
              Text(
                category.icon,
                style: TextStyle(
                  fontSize: 48,
                  color: category.isEnabled ? null : AppTokens.gray300,
                ),
              ),
              const SizedBox(height: AppTokens.s12),
              // Category name
              Text(
                category.name,
                style: AppTokens.label.copyWith(
                  color: category.isEnabled
                      ? _getCategoryColor()
                      : AppTokens.gray400,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (category.itemCount != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${category.itemCount} items',
                  style: AppTokens.caption.copyWith(
                    color: category.isEnabled
                        ? AppTokens.gray600
                        : AppTokens.gray400,
                  ),
                ),
              ],
              if (!category.isEnabled) ...[
                const SizedBox(height: 4),
                Text(
                  'Coming Soon',
                  style: AppTokens.caption.copyWith(
                    color: AppTokens.gray400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category.id) {
      case 'electronics':
        return AppTokens.navy;
      case 'fashion':
        return AppTokens.accentRed;
      case 'food':
        return AppTokens.warningAmber;
      case 'travel':
        return AppTokens.teal;
      case 'entertainment':
        return const Color(0xFF9C27B0); // Purple
      case 'health':
        return AppTokens.successGreen;
      default:
        return AppTokens.navy;
    }
  }
}
