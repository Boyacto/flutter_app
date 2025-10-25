import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/app_providers.dart';
import '../../../state/rewards_providers.dart';
import '../../../core/widgets/coupon_card.dart';
import '../../../theme/tokens.dart';

class CouponCatalogModal extends ConsumerWidget {
  const CouponCatalogModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(availableCouponsProvider);
    final userPoints = ref.watch(userBalanceProvider).points;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(AppTokens.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coupon Catalog',
                style: AppTokens.title.copyWith(color: AppTokens.navy),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          Text(
            'You have $userPoints points',
            style: AppTokens.body.copyWith(color: AppTokens.gray500),
          ),

          const SizedBox(height: AppTokens.s16),

          Expanded(
            child: couponsAsync.when(
              data: (coupons) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: AppTokens.s12,
                  mainAxisSpacing: AppTokens.s12,
                ),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  final canAfford = userPoints >= coupon.pointsCost;

                  return CouponCardWidget(
                    coupon: coupon,
                    canAfford: canAfford,
                    onTap: () async {
                      if (!canAfford) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not enough points')),
                        );
                        return;
                      }

                      try {
                        final redeemAction = ref.read(redeemCouponProvider);
                        await redeemAction(coupon.id);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Redeemed ${coupon.productName}!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
