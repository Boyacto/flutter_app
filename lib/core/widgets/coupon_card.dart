import 'package:flutter/material.dart';
import '../models/coupon.dart';
import '../../theme/tokens.dart';

class CouponCardWidget extends StatelessWidget {
  const CouponCardWidget({
    super.key,
    required this.coupon,
    required this.canAfford,
    required this.onTap,
  });

  final Coupon coupon;
  final bool canAfford;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: canAfford ? onTap : null,
        borderRadius: AppTokens.radius24,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand image (emoji placeholder)
              Text(
                coupon.brandImage,
                style: const TextStyle(fontSize: 48),
              ),

              const SizedBox(height: AppTokens.s8),

              Text(
                coupon.brandName,
                style: AppTokens.label.copyWith(color: AppTokens.navy),
                textAlign: TextAlign.center,
              ),

              Text(
                coupon.productName,
                style: AppTokens.caption.copyWith(color: AppTokens.gray500),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.s12,
                  vertical: AppTokens.s4,
                ),
                decoration: BoxDecoration(
                  color: canAfford
                      ? AppTokens.accentRed.withOpacity(0.1)
                      : AppTokens.gray200,
                  borderRadius: AppTokens.radius8,
                ),
                child: Text(
                  '${coupon.pointsCost} pts',
                  style: AppTokens.label.copyWith(
                    color: canAfford ? AppTokens.accentRed : AppTokens.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
