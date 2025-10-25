import 'package:intl/intl.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _usdFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _krwFormat = NumberFormat.currency(
    symbol: '₩',
    decimalDigits: 0,
  );

  /// Format amount as USD
  static String formatUSD(double amount) {
    return _usdFormat.format(amount);
  }

  /// Format amount as KRW
  static String formatKRW(double amount) {
    return _krwFormat.format(amount);
  }

  /// Format amount based on locale (default USD for demo)
  static String format(double amount, {String locale = 'en_US'}) {
    if (locale.startsWith('ko')) {
      return formatKRW(amount);
    }
    return formatUSD(amount);
  }

  /// Format amount with compact notation (1.2K, 1.5M)
  static String formatCompact(double amount) {
    return NumberFormat.compact().format(amount);
  }

  /// Format as currency without symbol
  static String formatWithoutSymbol(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }
}

/// Helper function for quick currency formatting (KRW)
String formatCurrency(double amount) {
  return CurrencyFormatter.formatKRW(amount);
}
