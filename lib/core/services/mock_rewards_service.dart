import '../models/mission.dart';
import '../models/coupon.dart';

/// Mock service for rewards (missions, coupons, points operations)
class MockRewardsService {
  // Demo missions
  final List<Mission> _missions = [
    Mission(
      id: '1',
      icon: '🎯',
      title: 'Save 3 days in a row',
      subtitle: 'Build your streak',
      rewardPoints: 50,
      status: MissionStatus.available,
    ),
    Mission(
      id: '2',
      icon: '💪',
      title: 'Deposit ₩100,000 this month',
      subtitle: 'Reach your goal',
      rewardPoints: 200,
      status: MissionStatus.inProgress,
    ),
    Mission(
      id: '3',
      icon: '🎮',
      title: 'Play 5 games',
      subtitle: 'Get gaming rewards',
      rewardPoints: 100,
      status: MissionStatus.available,
    ),
    Mission(
      id: '4',
      icon: '🌟',
      title: 'Create your first jar',
      subtitle: 'Start your savings journey',
      rewardPoints: 30,
      status: MissionStatus.completed,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Mission(
      id: '5',
      icon: '🔥',
      title: 'Maintain 30-day streak',
      subtitle: 'Ultimate dedication',
      rewardPoints: 500,
      status: MissionStatus.locked,
    ),
  ];

  // Demo coupons catalog
  final List<Coupon> _availableCoupons = [
    Coupon(
      id: '1',
      brandName: 'Starbucks',
      productName: 'Americano',
      brandImage: '☕',
      couponCode: 'SAVE5000',
      pointsCost: 100,
    ),
    Coupon(
      id: '2',
      brandName: 'McDonald\'s',
      productName: 'Big Mac Meal',
      brandImage: '🍔',
      couponCode: 'MC2024',
      pointsCost: 150,
    ),
    Coupon(
      id: '3',
      brandName: 'CGV',
      productName: 'Movie Ticket',
      brandImage: '🎬',
      couponCode: 'MOVIE10',
      pointsCost: 200,
    ),
    Coupon(
      id: '4',
      brandName: 'YES24',
      productName: 'Book Voucher',
      brandImage: '📚',
      couponCode: 'BOOK2024',
      pointsCost: 120,
    ),
    Coupon(
      id: '5',
      brandName: 'GS25',
      productName: 'Snack Bundle',
      brandImage: '🍿',
      couponCode: 'GS5000',
      pointsCost: 80,
    ),
    Coupon(
      id: '6',
      brandName: 'Subway',
      productName: 'Sandwich',
      brandImage: '🥪',
      couponCode: 'SUB2024',
      pointsCost: 110,
    ),
  ];

  final List<Coupon> _redeemedCoupons = [];

  Future<List<Mission>> fetchMissions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_missions);
  }

  Future<Mission> completeMission(String missionId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _missions.indexWhere((m) => m.id == missionId);
    if (index == -1) {
      throw Exception('Mission not found');
    }

    final mission = _missions[index];

    if (mission.status == MissionStatus.locked) {
      throw Exception('Mission is locked');
    }

    if (mission.status == MissionStatus.completed) {
      throw Exception('Mission already completed');
    }

    // Update mission to completed
    _missions[index] = mission.copyWith(
      status: MissionStatus.completed,
      completedAt: DateTime.now(),
    );

    return _missions[index];
  }

  Future<List<Coupon>> fetchAvailableCoupons() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_availableCoupons);
  }

  Future<List<Coupon>> fetchRedeemedCoupons() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_redeemedCoupons);
  }

  Future<Coupon> redeemCoupon(String couponId, int userPoints) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final coupon = _availableCoupons.firstWhere(
      (c) => c.id == couponId,
      orElse: () => throw Exception('Coupon not found'),
    );

    if (userPoints < coupon.pointsCost) {
      throw Exception('Not enough points');
    }

    final redeemed = coupon.copyWith(
      isRedeemed: true,
      redeemedAt: DateTime.now(),
    );

    _redeemedCoupons.add(redeemed);
    return redeemed;
  }

  Future<Map<String, dynamic>> withdrawPoints({
    required int points,
    required double feePercentage, // 0.1 for 10%
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final fee = (points * feePercentage).round();
    final netPoints = points - fee;

    return {
      'requested': points,
      'fee': fee,
      'net': netPoints,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> buyGift({
    required String giftId,
    required int pointsCost,
    required int userPoints,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (userPoints < pointsCost) {
      throw Exception('Not enough points');
    }

    return {
      'giftId': giftId,
      'pointsSpent': pointsCost,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
