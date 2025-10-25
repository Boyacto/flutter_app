import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/mission.dart';
import '../core/models/coupon.dart';
import '../core/services/mock_rewards_service.dart';
import 'app_providers.dart';

// ============================================================================
// REWARDS SERVICE
// ============================================================================

final rewardsServiceProvider = Provider<MockRewardsService>((ref) {
  return MockRewardsService();
});

// ============================================================================
// MISSIONS
// ============================================================================

final missionsProvider = FutureProvider<List<Mission>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.fetchMissions();
});

// ============================================================================
// COUPONS
// ============================================================================

final availableCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.fetchAvailableCoupons();
});

final redeemedCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final service = ref.read(rewardsServiceProvider);
  return service.fetchRedeemedCoupons();
});

// ============================================================================
// REDEEM COUPON ACTION
// ============================================================================

final redeemCouponProvider = Provider((ref) {
  return (String couponId) async {
    final service = ref.read(rewardsServiceProvider);
    final userPoints = ref.read(userBalanceProvider).points;

    final coupon = await service.redeemCoupon(couponId, userPoints);

    // Deduct points
    ref.read(userBalanceProvider.notifier).deductPoints(coupon.pointsCost);

    // Increment coupons count
    ref.read(userBalanceProvider.notifier).incrementCoupons();

    // Invalidate coupons list to refresh
    ref.invalidate(availableCouponsProvider);
    ref.invalidate(redeemedCouponsProvider);

    return coupon;
  };
});

// ============================================================================
// WITHDRAW POINTS ACTION
// ============================================================================

final withdrawPointsProvider = Provider((ref) {
  return ({required int points}) async {
    final service = ref.read(rewardsServiceProvider);

    final result = await service.withdrawPoints(
      points: points,
      feePercentage: 0.1, // 10% fee
    );

    // Deduct points from user balance
    ref.read(userBalanceProvider.notifier).deductPoints(points);

    return result;
  };
});
