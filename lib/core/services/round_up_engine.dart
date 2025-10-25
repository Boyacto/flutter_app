import '../models/rule_set.dart';
import '../models/limit.dart';
import '../models/transaction.dart';

/// Result of a round-up calculation
class RoundUpResult {
  final double amount;
  final bool applied;
  final String? skipReason; // 'integer', 'cap', 'paused', 'category'
  final double multiplier;

  const RoundUpResult({
    required this.amount,
    required this.applied,
    this.skipReason,
    this.multiplier = 1.0,
  });

  factory RoundUpResult.skipped(String reason) {
    return RoundUpResult(
      amount: 0.0,
      applied: false,
      skipReason: reason,
    );
  }

  factory RoundUpResult.success(double amount, double multiplier) {
    return RoundUpResult(
      amount: amount,
      applied: true,
      multiplier: multiplier,
    );
  }
}

/// Round-up calculation engine
class RoundUpEngine {
  /// Calculate round-up amount
  /// Formula: ceil(amount / unit) * unit - amount
  double calcRoundUp(double amount, double unit) {
    // Integer amounts return 0
    if (amount % 1.0 == 0.0) {
      return 0.0;
    }

    // Calculate ceiling to nearest unit
    final ceiledAmount = (amount / unit).ceil() * unit;
    final roundUp = ceiledAmount - amount;

    // Round to 2 decimal places to avoid floating point issues
    return (roundUp * 100).round() / 100;
  }

  /// Process a transaction and determine if round-up should be applied
  RoundUpResult processTransaction({
    required Transaction transaction,
    required RuleSet rules,
    required Limit limits,
    required bool isPaused,
  }) {
    // Check if paused
    if (isPaused) {
      return RoundUpResult.skipped('paused');
    }

    // Check category filters
    if (!_shouldIncludeCategory(transaction.category, rules)) {
      return RoundUpResult.skipped('category');
    }

    // Calculate base round-up
    final baseRoundUp = calcRoundUp(transaction.amount, rules.roundUpUnit);

    // Integer amount -> 0
    if (baseRoundUp == 0.0) {
      return RoundUpResult.skipped('integer');
    }

    // Apply weekend multiplier
    final multiplier = _getMultiplier(transaction.timestamp, rules.weekendMultiplier);
    final finalRoundUp = baseRoundUp * multiplier;

    // Check limits
    if (!_checkLimits(finalRoundUp, limits)) {
      return RoundUpResult.skipped('cap');
    }

    return RoundUpResult.success(finalRoundUp, multiplier);
  }

  /// Check if category should be included based on rules
  bool _shouldIncludeCategory(String category, RuleSet rules) {
    // If include list is not empty, only include those categories
    if (rules.includeCategories.isNotEmpty) {
      return rules.includeCategories.contains(category);
    }

    // If exclude list is not empty, exclude those categories
    if (rules.excludeCategories.isNotEmpty) {
      return !rules.excludeCategories.contains(category);
    }

    // No filters, include all
    return true;
  }

  /// Get multiplier based on weekend rule
  double _getMultiplier(DateTime timestamp, double weekendMultiplier) {
    // Saturday = 6, Sunday = 7
    if (timestamp.weekday == DateTime.saturday ||
        timestamp.weekday == DateTime.sunday) {
      return weekendMultiplier;
    }
    return 1.0;
  }

  /// Check if round-up amount is within limits
  bool _checkLimits(double roundUpAmount, Limit limits) {
    // Check daily limit
    if (limits.dailyCap != null) {
      if (limits.dailyUsed + roundUpAmount > limits.dailyCap!) {
        return false;
      }
    }

    // Check weekly limit
    if (limits.weeklyCap != null) {
      if (limits.weeklyUsed + roundUpAmount > limits.weeklyCap!) {
        return false;
      }
    }

    return true;
  }

  /// Get skip reason message (localized)
  String getSkipReasonMessage(String reason, {String locale = 'en_US'}) {
    final isKorean = locale.startsWith('ko');

    switch (reason) {
      case 'integer':
        return isKorean
            ? '정수 금액은 잔돈이 없어요'
            : 'No spare change for whole dollar amounts';
      case 'cap':
        return isKorean
            ? '오늘 한도에 도달했어요. 내일 다시 모을게요.'
            : 'Daily cap reached. We\'ll resume tomorrow.';
      case 'paused':
        return isKorean
            ? '저금이 일시 중지되었어요'
            : 'Round-up is paused';
      case 'category':
        return isKorean
            ? '카테고리 필터로 제외되었어요'
            : 'Excluded by category filter';
      default:
        return isKorean ? '알 수 없는 이유' : 'Unknown reason';
    }
  }

  /// Get skip reason hint (what to change)
  String getSkipReasonHint(String reason, {String locale = 'en_US'}) {
    final isKorean = locale.startsWith('ko');

    switch (reason) {
      case 'integer':
        return isKorean
            ? '잔돈이 생기는 금액이 필요해요'
            : 'Use amounts with cents to generate spare change';
      case 'cap':
        return isKorean ? '규칙에서 한도 변경' : 'Change in Rules';
      case 'paused':
        return isKorean ? '일시 중지 해제' : 'Unpause in Rules';
      case 'category':
        return isKorean ? '규칙에서 카테고리 변경' : 'Change in Rules';
      default:
        return '';
    }
  }
}
