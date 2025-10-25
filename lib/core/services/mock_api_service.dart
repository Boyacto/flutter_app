import 'dart:math';
import '../models/transaction.dart';

/// Mock Capital One API service for demo purposes
class MockApiService {
  final Random _random = Random();

  // Demo merchants
  static const List<String> _merchants = [
    'Starbucks',
    'Target',
    'Whole Foods',
    'Shell Gas',
    'Amazon',
    'Netflix',
    'Chipotle',
    'McDonald\'s',
    'Uber',
    'Spotify',
    'Apple Store',
    'Best Buy',
    'CVS Pharmacy',
    'Walgreens',
    'Trader Joe\'s',
  ];

  // Demo categories
  static const List<String> _categories = [
    'Food & Drink',
    'Shopping',
    'Groceries',
    'Gas',
    'Entertainment',
    'Transportation',
    'Health',
    'Bills',
  ];

  // Category mappings
  static const Map<String, String> _merchantCategories = {
    'Starbucks': 'Food & Drink',
    'Target': 'Shopping',
    'Whole Foods': 'Groceries',
    'Shell Gas': 'Gas',
    'Amazon': 'Shopping',
    'Netflix': 'Entertainment',
    'Chipotle': 'Food & Drink',
    'McDonald\'s': 'Food & Drink',
    'Uber': 'Transportation',
    'Spotify': 'Entertainment',
    'Apple Store': 'Shopping',
    'Best Buy': 'Shopping',
    'CVS Pharmacy': 'Health',
    'Walgreens': 'Health',
    'Trader Joe\'s': 'Groceries',
  };

  int _transactionCounter = 1000;

  /// Fetch recent transactions
  Future<List<Transaction>> fetchRecentTransactions({DateTime? since}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate 5-10 demo transactions
    final count = 5 + _random.nextInt(6);
    final transactions = <Transaction>[];

    for (int i = 0; i < count; i++) {
      transactions.add(_generateRandomTransaction(
        timestamp: DateTime.now().subtract(Duration(hours: i * 2)),
      ));
    }

    return transactions;
  }

  /// Simulate a purchase transaction
  Transaction simulatePurchase({
    double? amount,
    String? category,
    String? merchant,
  }) {
    return _generateRandomTransaction(
      amount: amount,
      category: category,
      merchant: merchant,
      timestamp: DateTime.now(),
    );
  }

  /// Generate a random transaction
  Transaction _generateRandomTransaction({
    double? amount,
    String? category,
    String? merchant,
    required DateTime timestamp,
  }) {
    // Pick random merchant or use provided
    final selectedMerchant = merchant ?? _merchants[_random.nextInt(_merchants.length)];

    // Get category from merchant or use provided
    final selectedCategory = category ??
        _merchantCategories[selectedMerchant] ??
        _categories[_random.nextInt(_categories.length)];

    // Generate amount if not provided
    final selectedAmount = amount ?? _generateRandomAmount(selectedCategory);

    _transactionCounter++;

    return Transaction(
      id: 'txn_$_transactionCounter',
      timestamp: timestamp,
      merchant: selectedMerchant,
      category: selectedCategory,
      amount: selectedAmount,
      status: 'posted',
    );
  }

  /// Generate a realistic amount based on category
  double _generateRandomAmount(String category) {
    switch (category) {
      case 'Food & Drink':
        return 5.0 + _random.nextDouble() * 25.0; // $5-$30
      case 'Shopping':
        return 15.0 + _random.nextDouble() * 85.0; // $15-$100
      case 'Groceries':
        return 20.0 + _random.nextDouble() * 80.0; // $20-$100
      case 'Gas':
        return 30.0 + _random.nextDouble() * 50.0; // $30-$80
      case 'Entertainment':
        return 10.0 + _random.nextDouble() * 40.0; // $10-$50
      case 'Transportation':
        return 8.0 + _random.nextDouble() * 32.0; // $8-$40
      case 'Health':
        return 10.0 + _random.nextDouble() * 90.0; // $10-$100
      case 'Bills':
        return 50.0 + _random.nextDouble() * 150.0; // $50-$200
      default:
        return 10.0 + _random.nextDouble() * 40.0; // $10-$50
    }
  }

  /// Get all available categories
  List<String> getCategories() {
    return List.from(_categories);
  }

  /// Get all available merchants
  List<String> getMerchants() {
    return List.from(_merchants);
  }

  /// Get a random merchant
  String getRandomMerchant() {
    return _merchants[_random.nextInt(_merchants.length)];
  }

  /// Get a random category
  String getRandomCategory() {
    return _categories[_random.nextInt(_categories.length)];
  }
}
