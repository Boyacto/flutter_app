/// A transaction from the mock API
class Transaction {
  final String id;
  final DateTime timestamp;
  final String merchant;
  final String category;
  final double amount;
  final String status; // 'posted', 'pending'

  const Transaction({
    required this.id,
    required this.timestamp,
    required this.merchant,
    required this.category,
    required this.amount,
    required this.status,
  });

  /// Copy with method for immutable updates
  Transaction copyWith({
    String? id,
    DateTime? timestamp,
    String? merchant,
    String? category,
    double? amount,
    String? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'merchant': merchant,
      'category': category,
      'amount': amount,
      'status': status,
    };
  }

  /// Create from map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      merchant: map['merchant'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      status: map['status'] as String,
    );
  }
}
